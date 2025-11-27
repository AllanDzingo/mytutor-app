# 🎓 MyTutor - AI-Powered Education Platform

An intelligent tutoring system built with FastAPI, React, and PostgreSQL, featuring AI-powered quiz generation and personalized tutor assignment.

## ✨ Features

- 🔐 **User Authentication** - Secure registration and login with password hashing
- 👨‍🏫 **Tutor Assignment** - Automatic assignment of qualified tutors
- 📚 **Subject Selection** - Support for multiple subjects and grade levels
- 🤖 **AI Quiz Generation** - Powered by Transformers for personalized quizzes
- 💾 **Database Persistence** - PostgreSQL for reliable data storage
- 🎨 **Premium UI** - Glassmorphism design with dark mode
- 🔄 **n8n Integration** - Workflow automation capabilities

## 🚀 Quick Start

### Prerequisites
- Docker Desktop
- Node.js (for local development)
- Git

### Run with Docker Compose

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/mytutor.git
cd mytutor

# Start all services
docker-compose up --build

# Access the application
# Frontend: http://localhost:5173
# Backend API: http://localhost:8080
# API Docs: http://localhost:8080/docs
# n8n: http://localhost:5678
```

## 📖 Documentation

- [Setup Guide](SETUP_GUIDE.md) - Complete setup and testing instructions
- [Git Setup](GIT_SETUP.md) - Version control and GitHub integration

## 🏗️ Architecture

### Backend (FastAPI)
- **Framework**: FastAPI 0.109.0
- **Database**: PostgreSQL with SQLAlchemy ORM
- **AI/ML**: Transformers (DistilGPT2, DistilBART)
- **Security**: Bcrypt password hashing, CORS middleware

### Frontend (React)
- **Framework**: Vite + React 18
- **Styling**: Vanilla CSS with Glassmorphism
- **Design**: Dark mode, gradient effects, smooth animations

### Infrastructure
- **Containerization**: Docker & Docker Compose
- **Database**: PostgreSQL 15
- **Automation**: n8n workflow engine

## 📁 Project Structure

```
mytutor/
├── ai-service/              # FastAPI backend
│   ├── main.py             # API endpoints
│   ├── database.py         # Database connection
│   ├── models.py           # SQLAlchemy models
│   ├── requirements.txt    # Python dependencies
│   └── Dockerfile
├── frontend/               # React frontend
│   ├── src/
│   │   ├── App.jsx        # Main component
│   │   └── index.css      # Glassmorphism styles
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml      # Service orchestration
├── SETUP_GUIDE.md         # Setup instructions
└── README.md              # This file
```

## 🎯 User Flow

1. **Register** - Create a new account
2. **Login** - Authenticate with credentials
3. **Select Grade & Subject** - Choose from grades 8-12 and various subjects
4. **Get Tutor** - Automatically assigned a qualified tutor
5. **Generate Quiz** - AI creates personalized quizzes
6. **Learn** - Complete quizzes and track progress

## 🔌 API Endpoints

### Authentication
- `POST /register` - Register new user
- `POST /login` - User login

### User Management
- `POST /select-subject` - Select grade and subject
- `GET /tutor-response/{username}` - Get assigned tutor

### AI Features
- `POST /generate-quiz` - Generate AI quiz
- `POST /summarize` - Summarize text content
- `POST /answer-question` - Get AI answers

## 🗄️ Database Schema

**Users Table:**
- `id` - Primary key
- `username` - Unique username
- `password_hash` - Bcrypt hashed password
- `grade` - Student grade level
- `subject` - Selected subject
- `tutor_name` - Assigned tutor

## 🎨 Design Features

- **Glassmorphism** - Modern frosted glass effect
- **Dark Mode** - Easy on the eyes
- **Gradient Text** - Purple/blue color scheme
- **Smooth Animations** - Fade-in, slide-up effects
- **Responsive** - Works on all devices

## 🛠️ Development

### Local Backend Development
```bash
cd ai-service
pip install --only-binary :all: -r requirements.txt
python main.py
```

### Local Frontend Development
```bash
cd frontend
npm install
npm run dev
```

## 🧪 Testing

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete testing instructions.

### Quick Test Flow
1. Start services: `docker-compose up --build`
2. Open http://localhost:5173
3. Register a new user
4. Login and select grade/subject
5. View assigned tutor
6. Generate and view quiz

## 🚀 Deployment

### Environment Variables
```env
DATABASE_URL=postgresql://user:password@db:5432/mytutor
```

### Production Considerations
- Use strong passwords for database
- Enable HTTPS
- Implement JWT authentication
- Add rate limiting
- Set up monitoring and logging
- Use managed database service

## 📝 License

MIT License - feel free to use this project for learning and development.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- FastAPI for the amazing web framework
- React team for the frontend library
- Hugging Face for Transformers
- n8n for workflow automation

## 📧 Contact

Your Name - [@AllanDzingo](https://twitter.com/allandzingo)

Project Link: [https://github.com/AllanDzingo/mytutor](https://github.com/AllanDzingo/mytutor)

---

**Built with ❤️ for education**
