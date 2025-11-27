# Git Repository Setup Guide

## Step 1: Create .gitignore File

First, make sure you have a `.gitignore` file to exclude unnecessary files.

## Step 2: Initialize Git Repository

```bash
# Navigate to your project directory
cd "C:\Users\Hanco Sipsma\Desktop\Allan 2025\mytutor"

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: MyTutor AI-powered education platform"
```

## Step 3: Create GitHub Repository

1. Go to [GitHub](https://github.com)
2. Click the **+** icon in the top right
3. Select **New repository**
4. Name it: `mytutor` (or your preferred name)
5. **Do NOT** initialize with README (we already have one)
6. Click **Create repository**

## Step 4: Connect Local Repository to GitHub

```bash
# Add remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/mytutor.git

# Verify remote was added
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 5: Future Updates

After making changes:

```bash
# Check what changed
git status

# Add specific files
git add filename.py

# Or add all changes
git add .

# Commit with a message
git commit -m "Description of changes"

# Push to GitHub
git push
```

## Common Git Commands

```bash
# View commit history
git log --oneline

# Create a new branch
git checkout -b feature-name

# Switch branches
git checkout main

# Merge branch into main
git checkout main
git merge feature-name

# Pull latest changes
git pull origin main

# Discard local changes
git checkout -- filename

# View differences
git diff
```

## Best Practices

### Commit Messages
- Use present tense: "Add feature" not "Added feature"
- Be descriptive but concise
- Examples:
  - `feat: Add user authentication`
  - `fix: Resolve database connection issue`
  - `docs: Update setup guide`
  - `style: Improve frontend design`

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development branch
- `feature/feature-name` - New features
- `fix/bug-name` - Bug fixes

### What to Commit
✅ **DO commit:**
- Source code
- Configuration files
- Documentation
- Dockerfiles
- Requirements files

❌ **DON'T commit:**
- `node_modules/`
- `__pycache__/`
- `.env` files with secrets
- Database files
- Build artifacts
- IDE-specific files

## Troubleshooting

### Authentication Issues
If you get authentication errors:

1. **Use Personal Access Token (PAT)**
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate new token (classic)
   - Use token as password when pushing

2. **Or use SSH**
   ```bash
   # Generate SSH key
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # Add to GitHub: Settings → SSH and GPG keys
   # Change remote to SSH
   git remote set-url origin git@github.com:YOUR_USERNAME/mytutor.git
   ```

### Large Files
If you have large model files:

```bash
# Use Git LFS (Large File Storage)
git lfs install
git lfs track "*.bin"
git lfs track "*.pt"
git add .gitattributes
git commit -m "Add Git LFS tracking"
```

## GitHub Repository Setup

### Add Repository Description
On GitHub, add a description:
> AI-powered education platform with FastAPI backend, React frontend, and PostgreSQL database. Features user authentication, tutor assignment, and AI quiz generation.

### Add Topics/Tags
- `python`
- `react`
- `fastapi`
- `postgresql`
- `docker`
- `ai`
- `education`
- `machine-learning`

### Create README Badge (Optional)
Add to top of README.md:
```markdown
![Python](https://img.shields.io/badge/python-3.11-blue)
![React](https://img.shields.io/badge/react-18.2-blue)
![FastAPI](https://img.shields.io/badge/fastapi-0.109-green)
![Docker](https://img.shields.io/badge/docker-compose-blue)
```

## Next Steps

1. **Add CI/CD** - Set up GitHub Actions for automated testing
2. **Add License** - Choose MIT, Apache, or GPL
3. **Add Contributing Guide** - Help others contribute
4. **Add Issue Templates** - Standardize bug reports
5. **Enable GitHub Pages** - Host documentation

---

**Your project is now version controlled and backed up on GitHub! 🎉**
