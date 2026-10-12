# CampusKart — Complete TODO & Roadmap

> Tracked against SRS/TDD Document · BUEST Minor Project
> Last Updated: October 2026

---

## 🏗️ PHASE 1 — Architecture & Scaffolding ✅ COMPLETED (Weeks 1–2)

- [x] SRS & TDD document baseline
- [x] Flutter project initialized
- [x] Riverpod added to pubspec.yaml
- [x] go_router added
- [x] Firebase dependencies added (firebase_core, firebase_auth, cloud_firestore, firebase_storage)
- [x] FastAPI backend created (main.py + schemas.py)
- [x] Docker + requirements.txt for backend
- [x] Backend tests scaffolded (test_api.py)
- [x] **Clean Architecture folder structure created** ✅
- [x] **Feature-based folder organization** ✅
- [x] **Proper Dart models with Firestore serialization** ✅
- [x] **Riverpod providers properly separated by feature** ✅
- [x] **go_router centralized in app_router.dart** ✅
- [x] **Old god-file `providers.dart` + `models/product.dart` deleted** ✅
- [x] **`main.dart` updated with Firebase.initializeApp()** ✅
- [x] **`app.dart` stripped to CampusKartApp widget only** ✅
- [x] **`docs/` folder created** (ARCHITECTURE.md, TODO.md, DATA_MODELS.md, SETUP.md) ✅

---

## 🔄 PHASE 2 — Feed & Chat Sync (Weeks 3–4) ← CURRENT PHASE

### 🎨 Design & UI Mockup Implementation (All 9 Screens) ✅ COMPLETED

- [x] **Screen 1: Welcome / Login Screen** (`login_screen.dart`) — CampusKart branding, campus graphic, Google Sign-in, instant bypass login
- [x] **Screen 2: Home Dashboard** (`home_screen.dart`) — Search bar with live filtering, promo banner, category chips, responsive grid (2-5 cols)
- [x] **Screen 3: All Listings Grid** (`listing_card.dart`) — Grid cards with Featured, Used/New condition badges, live state updates
- [x] **Screen 4: Product Detail** (`listing_detail_screen.dart`) — Image gallery with dots, Description & Details accordions, Chat & Buy Now Deal modal
- [x] **Screen 5: Direct Messaging & Chat** (`chat_screen.dart`) — Realtime bubble layout, text input, Groq AI smart reply chips
- [x] **Screen 6: Post Listing** (`create_listing_screen.dart`) — Live Groq AI auto-enhancer, photo upload, category/condition picker, instant feed sync
- [x] **Screen 7: Categories Grid** (`categories_screen.dart`) — 8 styled category cards with dynamic category filtering
- [x] **Screen 8: My List Screen** (`my_listings_screen.dart`) — Active vs Sold tabs, Mark as Sold, Delete listing, Add listing button
- [x] **Screen 9: User Profile** (`profile_screen.dart`) — Verified Student badge, stats row, safety tips dialog, working Sign Out
- [x] **Responsive Navigation Dock** (`main_shell.dart`) — Mobile elevated Dark Navy circular `+` (Sell) button, Desktop TopBar (≥900px), 5 tabs (`Home`, `Chats`, `Sell`, `My List`, `Account`)
- [x] **Declarative Router with StatefulShellRoute** (`app_router.dart`) — Tab persistence, deep linking & zero overflow layout

### 🔐 Authentication Backend Setup

- [ ] Run `flutterfire configure` to generate `firebase_options.dart`
- [ ] Set up Firebase project on console.firebase.google.com
  - [ ] Enable Email/Password auth
  - [ ] Enable Google Sign-In
  - [ ] Create Firestore database (test mode first)
  - [ ] Create Firebase Storage bucket
- [ ] Connect `FirebaseAuthRepository` in `auth_repository.dart` to live Firebase Auth

### 📋 Listings Firestore Integration

- [ ] Connect `FirestoreListingRepository.getListings()` to real Firestore snapshot stream
- [ ] Connect `CreateListingScreen` to Firebase Storage photo upload + Firestore document write
- [ ] Mark item as SOLD in Firestore from `MyListingsScreen` or detail screen

### 💬 Real-time Chat Firestore Integration

- [ ] Connect `FirestoreChatRepository.getMessages()` to Firestore subcollection stream
- [ ] Connect chat composer send button to Firestore batch message write
- [ ] Add edit/delete listing for seller

### 💬 Real-time Chat

- [ ] Implement `FirestoreChatRepository.getChats()` — real Firestore stream
- [ ] Implement `FirestoreChatRepository.getMessages()` — subcollection stream
- [ ] Implement `FirestoreChatRepository.sendMessage()`
- [ ] Build `InboxScreen` — list of chat threads with unread badge
- [ ] Build `ChatScreen` — message bubbles, text input, send button
- [ ] Add unread message counter logic
- [ ] Enable Firestore offline persistence for message queuing

### 👤 User Profile

- [ ] Auto-create user document in Firestore on first login
- [ ] Implement `UserRepository.getUser()`
- [ ] Build `ProfileScreen` — display name, email, campus location, listings count

---

## 🤖 PHASE 3 — FastAPI & AI Integration ✅ WORKING LIVE

### FastAPI Backend Setup & Groq LPU Integration

- [x] Set up `backend/.env` with live Groq API key ✅
- [x] Select optimal ultra-fast & high-limit model (`qwen/qwen3.8-27b`) ✅
- [x] Test `/health` endpoint locally (status 200) ✅
- [x] Test `/api/v1/ai/generate-description` with Groq (1.35s response) ✅
- [x] Test `/api/v1/ai/smart-replies` with Groq (0.67s response) ✅
- [ ] Add keyword sanitization for inappropriate listings
- [x] Deploy FastAPI to Render: `https://campuskart-yf8h.onrender.com` ✅

### AI in Flutter (Listing Enhancer)

- [x] Create `AiService` in Flutter (`ai_service.dart`) ✅
- [x] Wire "Enhance with AI" button in `CreateListingScreen` ✅
- [x] Show loading spinner while AI generates ✅
- [x] Auto-fill enhanced title and structured description ✅
- [x] Floating confirmation SnackBar on completion ✅

### AI Smart Reply Chips

- [x] Wire dynamic `SmartReplyChips` widget in `ChatScreen` ✅
- [x] One-tap reply selection inserted into chat composer ✅
- [x] Interactive live message sending with auto-scroll ✅

---

## 🧪 PHASE 4 — Integration, QA & Defense (Weeks 7–8)

### Testing

- [ ] **Unit Tests (Flutter)**:
  - [ ] `ListingModel.fromMap()` and `toMap()`
  - [ ] `UserModel.fromMap()` and `toMap()`
  - [ ] `ChatModel.fromMap()` and `toMap()`
  - [ ] `visibleListingsProvider` filter logic
- [ ] **Unit Tests (Python/Pytest)**:
  - [ ] Pydantic schema validation (valid + invalid inputs)
  - [ ] Phone number regex stripping
  - [ ] Groq timeout simulation (mock)
  - [ ] Malformed input handling
- [ ] **Integration Tests**:
  - [ ] Firebase Local Emulator Suite setup
  - [ ] Dual-client chat sync test (latency < 500ms)
  - [ ] Message ordering test
  - [ ] Unread badge counter logic test
- [ ] **UI Tests**:
  - [ ] Layout on 360dp, 480dp (mobile)
  - [ ] Layout on desktop (Chrome DevTools)
  - [ ] Zero visual overflow errors

### Firestore Security Rules

- [ ] Write Firestore security rules:
  - [ ] Users can only read/write their own profile
  - [ ] Listings: anyone authenticated can read, only seller can update/delete
  - [ ] Chats: only buyerId or sellerId can read/write
  - [ ] Messages: only chat participants can read/write
- [ ] Deploy rules to Firebase

### Deployment

- [ ] Android: `flutter build apk --release` → distribute APK to testers
- [ ] Web: `flutter build web` → `firebase deploy --only hosting`
- [ ] Backend: `docker build` → deploy to Render/Railway

### Defense Preparation

- [ ] Demo script walkthrough (buyer + seller journey)
- [ ] Prepare project report
- [ ] Prepare PPT slides

---

## ⚠️ Known Architecture Issues Fixed

| Issue                                | Status     | Fix Applied                                   |
| ------------------------------------ | ---------- | --------------------------------------------- |
| Everything in `app.dart` (God File)  | ✅ Fixed   | Split into feature-based screens              |
| Hardcoded mock data in providers     | 🔄 Pending | Firestore repos created (need Firebase setup) |
| No Firestore model serialization     | ✅ Fixed   | `fromMap/toMap` added to all models           |
| No auth flow / auth guard            | ✅ Fixed   | Auth providers + router redirect              |
| No centralized router                | ✅ Fixed   | `app_router.dart` created                     |
| No feature separation                | ✅ Fixed   | Clean architecture folders                    |
| `ProductCondition` missing `likeNew` | ✅ Fixed   | Added to `ListingModel`                       |
| Chat was modal bottom sheet          | 🔄 Pending | Full `ChatScreen` page needed                 |
| No real-time Firestore streams       | 🔄 Pending | Repos stubbed, need Firebase setup            |

---

## 🔑 Setup Checklist (Do This First!)

```bash
# 1. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Configure Firebase (run from project root)
flutterfire configure

# 3. Create backend .env file
# backend/.env
GROQ_API_KEY=your_groq_key_here
CORS_ORIGINS=http://localhost:3000,https://your-firebase-app.web.app
GROQ_MODEL=llama-3.1-8b-instant

# 4. Run Flutter
flutter pub get
flutter run

# 5. Run FastAPI locally
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload
```
