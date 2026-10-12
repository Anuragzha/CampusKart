# CampusKart — Setup Guide

---

## Prerequisites

| Tool            | Version | Install                                      |
| --------------- | ------- | -------------------------------------------- |
| Flutter SDK     | 3.48+   | https://flutter.dev/docs/get-started/install |
| Dart SDK        | 3.5+    | Bundled with Flutter                         |
| Python          | 3.11+   | https://python.org                           |
| Node.js         | 18+     | https://nodejs.org (for Firebase CLI)        |
| Firebase CLI    | Latest  | `npm install -g firebase-tools`              |
| FlutterFire CLI | Latest  | `dart pub global activate flutterfire_cli`   |

---

## Step 1: Firebase Project Setup

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create a new project → Name: `CampusKart`
3. **Enable Authentication**:
   - Go to Authentication → Sign-in method
   - Enable **Email/Password**
   - Enable **Google**
4. **Create Firestore Database**:
   - Go to Firestore Database → Create database
   - Start in **Test mode** (for development)
   - Choose region: `asia-south1` (Mumbai)
5. **Create Storage Bucket**:
   - Go to Storage → Get started
   - Start in test mode
6. **Register apps**:
   - Add Android app: package name = `com.example.campus_kart`
   - Add Web app: name = `CampusKart Web`

---

## Step 2: FlutterFire Configuration

```bash
# In project root (c:\Users\acer\Desktop\CampusCart)
flutterfire configure
```

This will:

- Ask you to select your Firebase project
- Generate `lib/firebase_options.dart` automatically

---

## Step 3: Flutter Setup

```bash
cd c:\Users\acer\Desktop\CampusCart

# Install dependencies
flutter pub get

# Verify setup
flutter doctor

# Run on Android (connect device or start emulator first)
flutter run

# Run on web
flutter run -d chrome
```

---

## Step 4: Backend Setup

```bash
cd c:\Users\acer\Desktop\CampusCart\backend

# Create virtual environment
python -m venv venv

# Activate (Windows)
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
```

Create `backend/.env`:

```env
GROQ_API_KEY=your_groq_api_key_here
CORS_ORIGINS=http://localhost:3000,http://localhost:8080,https://your-app.web.app
GROQ_MODEL=llama-3.1-8b-instant
```

Get your Groq API key at: [console.groq.com](https://console.groq.com)

```bash
# Run FastAPI dev server
uvicorn app.main:app --reload --port 8000

# Test health endpoint
curl http://localhost:8000/health
```

---

## Step 5: Update Flutter API URL

In `lib/src/features/listings/data/listing_repository.dart` (or a constants file), update:

```dart
const String kAiBaseUrl = 'http://localhost:8000'; // dev
// const String kAiBaseUrl = 'https://your-app.render.com'; // prod
```

---

## Step 6: Firebase Local Emulator (for Integration Testing)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize emulators
firebase init emulators
# Select: Firestore, Authentication, Storage

# Start emulators
firebase emulators:start
```

---

## Step 7: Run Tests

```bash
# Flutter unit tests
flutter test

# Python backend tests
cd backend
pytest tests/ -v
```

---

## Step 8: Build for Release

```bash
# Android APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Web
flutter build web
firebase deploy --only hosting
```

---

## Environment Variables Reference

| Variable       | Description                       | Example                 |
| -------------- | --------------------------------- | ----------------------- |
| `GROQ_API_KEY` | Groq LPU API key                  | `gsk_...`               |
| `CORS_ORIGINS` | Allowed origins (comma-separated) | `http://localhost:3000` |
| `GROQ_MODEL`   | Groq model ID                     | `llama-3.1-8b-instant`  |

---

## Troubleshooting

**`firebase_options.dart` not found?**
→ Run `flutterfire configure`

**Groq API 503 error?**
→ Check `GROQ_API_KEY` in `.env`, verify at console.groq.com

**Firestore permission denied?**
→ Check that user is logged in, and Firestore rules allow the operation

**Image upload fails?**
→ Check Firebase Storage rules are in test mode, and `firebase_storage` is initialized
