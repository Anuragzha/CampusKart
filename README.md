# CampusKart

CampusKart is a cross-platform campus marketplace based on the supplied BUEST SRS/TDD. The repository is split into a Flutter client and a stateless FastAPI AI proxy.

## Architecture

```text
Flutter Android/Web client
  |-- Firebase Auth: campus identity and profile
  |-- Cloud Firestore: products, chats, real-time messages
  |-- Firebase Storage: compressed listing images
  |-- HTTPS JSON: AI listing and reply requests
                              |
                        FastAPI backend
                              |
                       Groq Llama inference
```

The client never contains `GROQ_API_KEY`. Firebase credentials are supplied through the normal FlutterFire-generated `firebase_options.dart` file and should not be hand-written into source control.

## Repository layout

- `lib/src/app.dart`: Material 3 application, routes, marketplace, listing, detail, and chat surfaces.
- `lib/src/models/`: product domain models and status/condition values.
- `lib/src/providers.dart`: Riverpod state and demo feed provider; replace the feed provider with the Firestore repository when Firebase is configured.
- `backend/app/`: FastAPI endpoints and Pydantic request/response schemas.
- `firestore.rules`: user, product, chat, and message access isolation.
- `firestore.indexes.json`: marketplace and inbox query indexes.
- `firebase.json`: Firebase Emulator/Hosting deployment configuration.

## Run the Flutter client

```powershell
flutter pub get
flutter run -d chrome
# or
flutter run -d <android-device>
```

To connect Firebase, install FlutterFire CLI and run `flutterfire configure` from the project root. Enable Email/Password Authentication, Firestore, and Storage in the Firebase project, then deploy rules and indexes:

```powershell
firebase deploy --only firestore:rules,firestore:indexes,hosting
```

The current UI includes a local demo feed so the navigation and core flows can be reviewed before Firebase project credentials are available.

## Run the AI backend

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
$env:GROQ_API_KEY = 'your-server-only-key'
uvicorn app.main:app --reload --port 8000
```

Endpoints:

- `GET /health`
- `POST /api/v1/ai/generate-description`
- `POST /api/v1/ai/smart-replies`

For production, put the service behind HTTPS and add Firebase ID-token verification middleware before exposing AI endpoints publicly. The API currently keeps the key server-side and returns a generic provider error instead of leaking exception details.

## Tests

```powershell
flutter analyze
flutter test
cd backend
pytest
```

The local environment may block Flutter's `flutter_tester.exe` through Windows Application Control. In that case, `flutter analyze` remains a valid static check and `flutter test` should be run on an approved development machine or CI runner.
