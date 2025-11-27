# MyTutor - AI Educational Assistant

A lightweight AI agent service designed to generate quizzes, summarize content, and answer homework questions. This project demonstrates a modern MLOps workflow using FastAPI, Docker, n8n, and Google Cloud Platform.

## 📂 Project Structure

```
mytutor/
├── ai-service/          # Python FastAPI Microservice
│   ├── main.py         # Application logic
│   ├── requirements.txt # Python dependencies
│   └── Dockerfile      # Container definition
└── README.md           # This file
```

## 🚀 Getting Started

### 1. Local AI Service Setup

**Prerequisites:**
- Docker installed
- Python 3.11+ (optional, for local non-docker run)

**Run with Docker:**

```bash
cd ai-service
docker build -t ai-service:local .
docker run -p 8080:8080 ai-service:local
```

**Run Locally (Python):**

```bash
cd ai-service
pip install -r requirements.txt
python main.py
```

The API will be available at `http://localhost:8080`.
Documentation (Swagger UI): `http://localhost:8080/docs`

### 2. n8n Automation Setup

Run n8n locally using Docker:

```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e GENERIC_TIMEZONE="Europe/Berlin" \
  -e TZ="Europe/Berlin" \
  n8nio/n8n
```

Access n8n at `http://localhost:5678`.

**Workflow Idea:**
1. **Webhook Trigger**: Listen for POST requests.
2. **HTTP Request**: Call `http://host.docker.internal:8080/generate-quiz` (Note: use `host.docker.internal` to access host localhost from n8n container).
3. **Email/Response**: Send the result back to the user.

## ☁️ GCP Deployment (MLOps)

### 1. Build & Push
```bash
gcloud auth configure-docker
docker build -t us-central1-docker.pkg.dev/<PROJECT_ID>/ai/ai-service:v1 ./ai-service
docker push us-central1-docker.pkg.dev/<PROJECT_ID>/ai/ai-service:v1
```

### 2. Deploy to Cloud Run
```bash
gcloud run deploy ai-service \
  --image us-central1-docker.pkg.dev/<PROJECT_ID>/ai/ai-service:v1 \
  --region us-central1 \
  --allow-unauthenticated
```
