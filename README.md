# CampusKart

CampusKart is a high-performance, cross-platform campus marketplace application tailored for BUEST university students and faculty. The repository pairs a responsive Flutter client (Mobile, Tablet, and Desktop Web) with a FastAPI microservice powered by Groq LPU AI inference.

---

## 🏛️ System Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                 FLUTTER CLIENT (Web & Mobile)               │
│                                                             │
│   • Core Theme: Royal Blue (#2563EB) & Navy (#192238)       │
│   • Responsive Grid & Dynamic Breakpoints (<600, <900, 1200)│
│   • Riverpod State Layer (Reactive Streams & Filter States) │
│   • go_router Declarative Shell Navigation                 │
│                                                             │
│   Bottom Dock (Mobile) / Top Bar (Desktop):                 │
│   [Home] [Chats]  ★ [ + Sell ] ★  [My List] [Account]       │
└──────────────┬──────────────────────────────┬───────────────┘
               │                              │
               ▼                              ▼
    ┌──────────────────────┐      ┌─────────────────────────┐
    │  Firebase Ecosystem  │      │ Live FastAPI Microservice│
    │  (Identity & Data)   │      │ (Render Cloud Deployed) │
    │                      │      │                         │
    │ • Firebase Auth      │      │ • Base URL: onrender.com│
    │ • Cloud Firestore    │      │ • Groq LPU High-Speed   │
    │ • Firebase Storage   │      │ • Model: qwen3.8-27b    │
    └──────────────────────┘      └─────────────────────────┘
```

---

## 🚀 Live Backend & Endpoints

The AI microservice is deployed and operating live:

- **Live Base URL:** `https://campuskart-yf8h.onrender.com`
- **Health Check:** `GET https://campuskart-yf8h.onrender.com/health` (Returns `{"status": "ok", "service": "campuskart-ai"}`)
- **Listing Auto-Enhancer:** `POST /api/v1/ai/generate-description`
- **Deal Negotiation Smart Replies:** `POST /api/v1/ai/smart-replies`

---

## 📂 Repository Layout (Clean Architecture)

```text
lib/
├── main.dart                                # Flutter bootstrap & ProviderScope
├── firebase_options.dart                    # FlutterFire configuration
└── src/
    ├── app.dart                             # MaterialApp.router configuration
    ├── core/
    │   ├── constants/
    │   │   ├── app_colors.dart              # Royal Blue, Navy, and status badge palette
    │   │   └── app_strings.dart             # UI string constants
    │   ├── router/
    │   │   └── app_router.dart              # go_router StatefulShellRoute setup
    │   ├── theme/
    │   │   └── app_theme.dart               # Material 3 light/dark ThemeData
    │   └── utils/
    │       └── responsive.dart              # Breakpoint helpers & ResponsiveContainer
    └── features/
        ├── auth/                            # Login & Registration screens
        ├── listings/
        │   ├── data/
        │   │   ├── ai_service.dart          # HTTP client for live Render AI
        │   │   ├── listing_model.dart       # Model with condition, specs, & badges
        │   │   └── listing_repository.dart  # Reactive stream & CRUD interface
        │   └── presentation/
        │       ├── providers/               # Reactive Riverpod listing providers
        │       ├── screens/
        │       │   ├── home_screen.dart     # Responsive grid feed with real-time search
        │       │   ├── listing_detail_screen.dart # Image carousel, accordions, Deal modal
        │       │   ├── create_listing_screen.dart  # AI-enhanced listing creation
        │       │   ├── categories_screen.dart      # Category browser grid
        │       │   └── my_listings_screen.dart     # Active vs Sold "My List" manager
        │       └── widgets/
        │           ├── listing_card.dart    # Grid card with Featured, Used/New badges
        │           └── category_filter_bar.dart
        ├── chat/
        │   ├── presentation/
        │   │   ├── screens/
        │   │   │   ├── inbox_screen.dart    # All, Buying, Selling tabs with unread counts
        │   │   │   └── chat_screen.dart     # Real-time chat bubbles & smart replies
        │   │   └── widgets/
        │   │       └── smart_reply_chips.dart # Groq AI suggested quick replies
        ├── profile/                         # Verified student profile & settings
        └── main_shell/
            └── main_shell.dart              # Mobile elevated Navy Sell dock & Desktop TopBar
```

---

## 📱 Interactive Features & Design Highlights

1. **Center Elevated Sell Button:**
   - Bottom dock features a center **Dark Navy circular button (`#192238`)** with an elevated white `+` icon and **"Sell"** label.
   - Tapping directly launches the AI listing creator.
2. **5-Tab Navigation:**
   - **Home** — Product grid feed with live search and category chips.
   - **Chats** — Messaging hub with `All`, `Buying`, and `Selling` filter tabs.
   - **Sell** (`+`) — Fast listing post with one-tap AI description enhancement.
   - **My List** — Manage active listings, mark items as sold, or delete listings.
   - **Account** — Verified student ID profile, transaction stats, and campus safety tips.
3. **Responsive Grid & Desktop Optimization:**
   - Mobile (`< 600px`): 2-column card grid with bottom navigation dock.
   - Tablet (`600px - 899px`): 3-4 column grid with centered container.
   - Desktop (`≥ 900px`): Top navigation header with inline search and centered content max-width (`1200px`). Zero horizontal or vertical layout overflow errors.
4. **Campus Deal Integration:**
   - Interactive "Buy Now" bottom sheet allows buyers to propose physical on-campus meetup spots (_BUEST Central Library, Cafeteria, Hostel Gate_) with Cash or UPI payment on spot.

---

## 💻 Running the Project

### 1. Run Flutter Client (Web or Mobile)

```powershell
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on Android Emulator or physical device
flutter run -d <device-id>
```

### 2. Verify Code Quality & Tests

```powershell
# Analyze codebase (0 issues)
flutter analyze

# Run automated widget & navigation tests (100% passing)
flutter test
```

### 3. Run FastAPI Backend Locally (Optional)

The Flutter app connects directly to the live Render backend by default. To run locally:

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
$env:GROQ_API_KEY="your-groq-api-key"
uvicorn app.main:app --reload --port 8000
```
