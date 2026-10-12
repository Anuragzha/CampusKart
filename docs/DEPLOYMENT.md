# CampusKart — FastAPI Backend Live Deployment Guide (Render)

> Deploy FastAPI + Groq AI microservice for free with automatic HTTPS.

---

## Why Render?

- 100% Free (no credit card needed).
- Direct GitHub automatic deployment.
- Free SSL/HTTPS URL (e.g. `https://campuskart-ai.onrender.com`).
- Matches the official BUEST SRS/TDD document specification.

---

## Step 1: Push Code to GitHub

1. Open your terminal in the project directory:

   ```bash
   cd c:\Users\acer\Desktop\CampusCart
   git init
   git add .
   git commit -m "feat: complete CampusKart flutter client and fastapi groq backend"
   ```

2. Create a new repository on [github.com](https://github.com/new) named `CampusCart` (can be **Private** or **Public**).

3. Link and push your repository:
   ```bash
   git remote add origin https://github.com/<your-username>/CampusCart.git
   git branch -M main
   git push -u origin main
   ```
   _(Note: `.env` is already added to `.gitignore`, so your API keys are 100% secure!)_

---

## Step 2: Create Free Web Service on Render

1. Go to [dashboard.render.com](https://dashboard.render.com/) and click **Sign Up with GitHub**.
2. Click the **+ New** button (top right) → Select **Web Service**.
3. Choose **Build and deploy from a Git repository** → Select your `CampusCart` repo.

---

## Step 3: Configure Deployment Settings

Fill in these exact values:

| Field              | Value                                              |
| ------------------ | -------------------------------------------------- |
| **Name**           | `campuskart-ai`                                    |
| **Region**         | `Singapore` or `Frankfurt` (closest to India)      |
| **Branch**         | `main`                                             |
| **Root Directory** | `backend`                                          |
| **Runtime**        | `Python 3`                                         |
| **Build Command**  | `pip install -r requirements.txt`                  |
| **Start Command**  | `uvicorn app.main:app --host 0.0.0.0 --port $PORT` |
| **Instance Type**  | **Free** ($0/month)                                |

---

## Step 4: Add Environment Variables

Scroll down to the **Environment Variables** section and add:

| Key            | Value                                              |
| -------------- | -------------------------------------------------- |
| `GROQ_API_KEY` | `<your_groq_api_key>` (Paste your secret key here) |
| `GROQ_MODEL`   | `qwen/qwen3.8-27b`                                 |
| `CORS_ORIGINS` | `*`                                                |

Click **Create Web Service**.

---

## Step 5: Test Live API

Render will build and deploy the container in ~2 minutes. You will get a live URL like:
`https://campuskart-ai.onrender.com`

Test it in your browser:

- `https://campuskart-ai.onrender.com/health` → returns `{"status":"ok","service":"campuskart-ai"}`
- `https://campuskart-ai.onrender.com/docs` → interactive Swagger API testing UI

---

## Step 6: Connect Live URL in Flutter

In [`lib/src/features/listings/data/ai_service.dart`](file:///c:/Users/acer/Desktop/CampusCart/lib/src/features/listings/data/ai_service.dart):

```dart
static const String liveBackendUrl = 'https://campuskart-ai.onrender.com';
```

Now any student testing the APK on campus will hit the live cloud AI! 🚀
