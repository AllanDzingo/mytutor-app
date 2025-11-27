# MyTutor - AI-Powered Education Platform

## 🚀 Quick Start Guide

### Prerequisites
- Docker Desktop installed and running
- Node.js (for local frontend development)
- Git

### 🏗️ Build and Run the Full System

#### Step 1: Start All Services with Docker Compose
```bash
# Navigate to project directory
cd mytutor

# Build and start all services (backend, frontend, database, n8n)
docker-compose up --build
```

This will start:
- **AI Service** (Backend API): http://localhost:8080
- **Frontend** (React App): http://localhost:5173
- **PostgreSQL Database**: localhost:5432
- **n8n** (Automation): http://localhost:5678

#### Step 2: Access the Application
Open your browser and go to:
```
http://localhost:5173
```

### 🧪 Testing the Full Flow

#### 1. **Register a New User**
- Click "Register" on the login page
- Enter a username and password
- Click "Register"
- You'll be redirected to login

#### 2. **Login**
- Enter your credentials
- Click "Login"

#### 3. **Select Grade and Subject**
- Choose your grade (8-12)
- Choose your subject (Math, Science, English, etc.)
- Click "Get My Tutor"
- You'll be assigned a random tutor

#### 4. **Generate a Quiz**
- After tutor assignment, click "Generate Quiz"
- The AI will create a quiz based on your subject
- View your personalized quiz content

### 🔧 Local Development (Without Docker)

#### Backend (AI Service)
```bash
cd ai-service

# Install dependencies
pip install --only-binary :all: -r requirements.txt

# Set database URL
$env:DATABASE_URL="postgresql://user:password@localhost:5432/mytutor"

# Run the service
python main.py
```

#### Frontend
```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

#### Database (PostgreSQL)
```bash
# Start only the database
docker-compose up db
```

### 📡 API Endpoints

#### Authentication
- `POST /register` - Register new user
  ```json
  {
    "username": "john",
    "password": "password123"
  }
  ```

- `POST /login` - Login user
  ```json
  {
    "username": "john",
    "password": "password123"
  }
  ```

#### User Management
- `POST /select-subject` - Select grade and subject
  ```json
  {
    "username": "john",
    "grade": "Grade 10",
    "subject": "Mathematics"
  }
  ```

- `GET /tutor-response/{username}` - Get assigned tutor

#### AI Features
- `POST /generate-quiz` - Generate quiz
  ```json
  {
    "topic": "Mathematics",
    "difficulty": "medium"
  }
  ```

- `POST /summarize` - Summarize text
- `POST /answer-question` - Answer questions

### 🗄️ Database Schema

**Users Table:**
- `id` (Primary Key)
- `username` (Unique)
- `password_hash`
- `grade`
- `subject`
- `tutor_name`

### 🎨 Frontend Features

- **Premium Glassmorphism Design** - Modern, sleek UI
- **Dark Mode** - Easy on the eyes
- **Smooth Animations** - Engaging user experience
- **Responsive Layout** - Works on all devices

### 🔍 Troubleshooting

#### Port Already in Use
```bash
# Stop all containers
docker-compose down

# Start again
docker-compose up --build
```

#### Database Connection Issues
```bash
# Reset database
docker-compose down -v
docker-compose up --build
```

#### Frontend Not Loading
```bash
# Rebuild frontend
cd frontend
npm install
npm run dev
```

### 📦 Project Structure
```
mytutor/
├── ai-service/          # FastAPI backend
│   ├── main.py          # API endpoints
│   ├── database.py      # Database connection
│   ├── models.py        # SQLAlchemy models
│   ├── requirements.txt # Python dependencies
│   └── Dockerfile
├── frontend/            # React frontend
│   ├── src/
│   │   ├── App.jsx      # Main component
│   │   └── index.css    # Glassmorphism styles
│   ├── package.json
│   └── Dockerfile
└── docker-compose.yml   # Orchestration
```

### 🎯 Next Steps

1. **Customize Tutor Names** - Edit `TUTOR_NAMES` in `ai-service/main.py`
2. **Add More Subjects** - Update the subject dropdown in `frontend/src/App.jsx`
3. **Enhance Quiz Generation** - Improve prompts in the `/generate-quiz` endpoint
4. **Add Authentication Tokens** - Implement JWT for secure sessions
5. **Deploy to Cloud** - Use GCP, AWS, or Azure for production

### 🤝 Contributing

This is a learning project demonstrating:
- Full-stack development (React + FastAPI)
- Database integration (PostgreSQL)
- AI/ML integration (Transformers)
- Docker containerization
- Modern UI/UX design

---

**Built with ❤️ for education**
