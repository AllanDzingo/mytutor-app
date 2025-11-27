from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from transformers import pipeline
from sqlalchemy.orm import Session
from passlib.context import CryptContext
import logging
import random

from database import engine, get_db, Base
from models import User

# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="MyTutor AI Service", version="1.0.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# --- Models ---
class QuizRequest(BaseModel):
    topic: str
    difficulty: str = "medium"

class SummarizeRequest(BaseModel):
    text: str

class QuestionRequest(BaseModel):
    question: str
    context: str = ""

class RegisterRequest(BaseModel):
    username: str
    password: str

class LoginRequest(BaseModel):
    username: str
    password: str

class SelectSubjectRequest(BaseModel):
    username: str
    grade: str
    subject: str

# --- ML Models (Lazy Loading to save resources on startup if needed) ---
# Using distilgpt2 for text generation (lightweight) and a summarization model
# In a real production app, you might want to load these once at startup.
try:
    logger.info("Loading models... this might take a moment.")
    # Text generation model for quizzes and answers
    generator = pipeline("text-generation", model="distilgpt2") 
    # Summarization model
    summarizer = pipeline("summarization", model="sshleifer/distilbart-cnn-12-6")
    logger.info("Models loaded successfully.")
except Exception as e:
    logger.error(f"Error loading models: {e}")
    generator = None
    summarizer = None

# Tutor names pool
TUTOR_NAMES = [
    "Dr. Sarah Johnson", "Prof. Michael Chen", "Ms. Emily Rodriguez",
    "Mr. David Thompson", "Dr. Aisha Patel", "Prof. James Wilson"
]

@app.get("/")
def health_check():
    return {"status": "ok", "service": "ai-service"}

@app.post("/register")
def register(req: RegisterRequest, db: Session = Depends(get_db)):
    # Check if user exists
    existing_user = db.query(User).filter(User.username == req.username).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Username already exists")
    
    # Hash password
    hashed_password = pwd_context.hash(req.password)
    
    # Create user
    new_user = User(username=req.username, password_hash=hashed_password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    return {"message": "User registered successfully", "username": req.username}

@app.post("/login")
def login(req: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == req.username).first()
    if not user or not pwd_context.verify(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    return {
        "message": "Login successful",
        "username": user.username,
        "grade": user.grade,
        "subject": user.subject,
        "tutor_name": user.tutor_name
    }

@app.post("/select-subject")
def select_subject(req: SelectSubjectRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == req.username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Update user's grade and subject
    user.grade = req.grade
    user.subject = req.subject
    
    # Assign a random tutor
    user.tutor_name = random.choice(TUTOR_NAMES)
    
    db.commit()
    db.refresh(user)
    
    return {
        "message": "Subject and grade updated successfully",
        "tutor_name": user.tutor_name
    }

@app.get("/tutor-response/{username}")
def get_tutor_response(username: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if not user.tutor_name:
        raise HTTPException(status_code=400, detail="No tutor assigned yet")
    
    return {
        "message": f"Your tutor is {user.tutor_name}",
        "tutor_name": user.tutor_name,
        "grade": user.grade,
        "subject": user.subject
    }

@app.post("/generate-quiz")
def generate_quiz(req: QuizRequest):
    if not generator:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    prompt = f"Create a 5-question {req.difficulty} quiz about {req.topic}:\n"
    
    try:
        # Generate text
        result = generator(prompt, max_length=200, num_return_sequences=1)
        generated_text = result[0]['generated_text']
        
        # Simple parsing (in a real app, you'd want structured output or better parsing)
        return {
            "topic": req.topic,
            "difficulty": req.difficulty,
            "quiz_content": generated_text
        }
    except Exception as e:
        logger.error(f"Generation error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/summarize")
def summarize_content(req: SummarizeRequest):
    if not summarizer:
        raise HTTPException(status_code=503, detail="Model not loaded")
        
    try:
        # Truncate if too long for this specific small model
        input_text = req.text[:1024] 
        summary = summarizer(input_text, max_length=130, min_length=30, do_sample=False)
        return {"summary": summary[0]['summary_text']}
    except Exception as e:
        logger.error(f"Summarization error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/answer-question")
def answer_question(req: QuestionRequest):
    if not generator:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    prompt = f"Question: {req.question}\nContext: {req.context}\nAnswer:"
    
    try:
        result = generator(prompt, max_length=100, num_return_sequences=1)
        return {"answer": result[0]['generated_text']}
    except Exception as e:
        logger.error(f"Answering error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
