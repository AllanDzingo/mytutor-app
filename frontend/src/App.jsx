import { useState } from 'react'
import './index.css'

const API_URL = 'http://localhost:8080'

function App() {
  const [view, setView] = useState('login') // login, register, dashboard, quiz
  const [isLogin, setIsLogin] = useState(true)
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [grade, setGrade] = useState('')
  const [subject, setSubject] = useState('')
  const [userData, setUserData] = useState(null)
  const [tutorName, setTutorName] = useState('')
  const [quizContent, setQuizContent] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleAuth = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const endpoint = isLogin ? '/login' : '/register'
      const response = await fetch(`${API_URL}${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.detail || 'Authentication failed')
      }

      if (isLogin) {
        setUserData(data)
        if (data.tutor_name) {
          setTutorName(data.tutor_name)
          setGrade(data.grade)
          setSubject(data.subject)
          setView('dashboard')
        } else {
          setView('dashboard')
        }
      } else {
        setIsLogin(true)
        setError('Registration successful! Please login.')
      }
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const handleSelectSubject = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const response = await fetch(`${API_URL}/select-subject`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, grade, subject })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.detail || 'Failed to select subject')
      }

      setTutorName(data.tutor_name)
      setUserData({ ...userData, grade, subject, tutor_name: data.tutor_name })
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  const handleGenerateQuiz = async () => {
    setError('')
    setLoading(true)

    try {
      const response = await fetch(`${API_URL}/generate-quiz`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ topic: subject, difficulty: 'medium' })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.detail || 'Failed to generate quiz')
      }

      setQuizContent(data.quiz_content)
      setView('quiz')
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  // Auth View (Login/Register)
  if (view === 'login') {
    return (
      <div className="glass-card">
        <h1>MyTutor</h1>
        <p>Your AI-Powered Learning Companion</p>

        {error && <div className={error.includes('successful') ? 'success' : 'error'}>{error}</div>}

        <form onSubmit={handleAuth}>
          <div className="form-group">
            <label>Username</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Enter your username"
              required
            />
          </div>

          <div className="form-group">
            <label>Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter your password"
              required
            />
          </div>

          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? 'Processing...' : (isLogin ? 'Login' : 'Register')}
          </button>
        </form>

        <div className="toggle-link">
          {isLogin ? "Don't have an account? " : "Already have an account? "}
          <button onClick={() => { setIsLogin(!isLogin); setError(''); }}>
            {isLogin ? 'Register' : 'Login'}
          </button>
        </div>
      </div>
    )
  }

  // Dashboard View
  if (view === 'dashboard') {
    return (
      <div className="glass-card">
        <h1>Welcome, {username}!</h1>
        <p>Select your grade and subject to get started</p>

        {error && <div className="error">{error}</div>}

        {!tutorName ? (
          <form onSubmit={handleSelectSubject}>
            <div className="form-group">
              <label>Grade</label>
              <select value={grade} onChange={(e) => setGrade(e.target.value)} required>
                <option value="">Select Grade</option>
                <option value="Grade 8">Grade 8</option>
                <option value="Grade 9">Grade 9</option>
                <option value="Grade 10">Grade 10</option>
                <option value="Grade 11">Grade 11</option>
                <option value="Grade 12">Grade 12</option>
              </select>
            </div>

            <div className="form-group">
              <label>Subject</label>
              <select value={subject} onChange={(e) => setSubject(e.target.value)} required>
                <option value="">Select Subject</option>
                <option value="Mathematics">Mathematics</option>
                <option value="Science">Science</option>
                <option value="English">English</option>
                <option value="History">History</option>
                <option value="Geography">Geography</option>
              </select>
            </div>

            <button type="submit" className="btn btn-primary" disabled={loading}>
              {loading ? 'Assigning Tutor...' : 'Get My Tutor'}
            </button>
          </form>
        ) : (
          <>
            <div className="tutor-response">
              <h2>Your Tutor is</h2>
              <div className="tutor-name">{tutorName}</div>
            </div>

            <div className="dashboard-grid">
              <div className="info-card">
                <h3>Grade</h3>
                <p>{grade}</p>
              </div>
              <div className="info-card">
                <h3>Subject</h3>
                <p>{subject}</p>
              </div>
            </div>

            <button onClick={handleGenerateQuiz} className="btn btn-primary" style={{ marginTop: '2rem' }} disabled={loading}>
              {loading ? 'Generating Quiz...' : 'Generate Quiz'}
            </button>

            <button onClick={() => { setView('login'); setUserData(null); setTutorName(''); }} className="btn btn-secondary">
              Logout
            </button>
          </>
        )}
      </div>
    )
  }

  // Quiz View
  if (view === 'quiz') {
    return (
      <div className="glass-card">
        <h1>Your Quiz</h1>
        <p>Subject: {subject}</p>

        <div className="quiz-content">
          {quizContent}
        </div>

        <button onClick={() => setView('dashboard')} className="btn btn-primary" style={{ marginTop: '2rem' }}>
          Back to Dashboard
        </button>
      </div>
    )
  }

  return null
}

export default App
