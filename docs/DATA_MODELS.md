# CampusKart — Firestore Data Models

---

## Collection: `listings`

Document ID: auto-generated Firestore ID

```
listings/
  {listingId}/
    id:          String   — same as document ID
    sellerId:    String   — Firebase Auth UID
    title:       String   — max 80 chars
    description: String   — AI-enhanced or manual
    price:       Number   — INR, > 0
    condition:   String   — "newItem" | "likeNew" | "good" | "fair"
    category:    String   — "Books" | "Electronics" | "Stationery" | "Lab Equipment" | "Hostel Goods"
    photoUrls:   Array    — 1 to 4 Firebase Storage URLs
    status:      String   — "active" | "sold"
    location:    String   — campus location (e.g., "Block B Hostel")
    createdAt:   Timestamp
```

**Queries used**:

- `where('status', '==', 'active').orderBy('createdAt', descending: true).limit(20)` — home feed
- `where('sellerId', '==', uid)` — seller's listings

---

## Collection: `users`

Document ID: Firebase Auth UID

```
users/
  {uid}/
    uid:            String
    displayName:    String
    email:          String
    photoUrl:       String?   — nullable
    campusLocation: String
    listingsCount:  Number    — incremented on listing creation
    joinedAt:       Timestamp
```

---

## Collection: `chats`

Document ID: auto-generated

```
chats/
  {chatId}/
    chatId:        String
    buyerId:       String   — Firebase Auth UID
    sellerId:      String   — Firebase Auth UID
    listingId:     String
    lastMessage:   String
    lastTimestamp: Timestamp
    unreadCounts:  Map {
      {buyerId}:  Number,
      {sellerId}: Number
    }
```

**Queries used**:

- `where('buyerId', '==', uid).orderBy('lastTimestamp', descending: true)` — inbox for buyer
- `where('sellerId', '==', uid).orderBy('lastTimestamp', descending: true)` — inbox for seller

---

## Subcollection: `chats/{chatId}/messages`

Document ID: auto-generated

```
chats/
  {chatId}/
    messages/
      {messageId}/
        messageId:     String
        senderId:      String   — Firebase Auth UID
        text:          String
        timestamp:     Timestamp
        isAiSuggested: Boolean  — true if sent via smart reply chip
```

**Query used**:

- `.orderBy('timestamp', ascending: true)` — real-time stream

---

## Firestore Security Rules (to be deployed)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users: read own profile, write own profile
    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == uid;
    }

    // Listings: anyone authenticated can read
    // Only seller can update/delete
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.sellerId;
    }

    // Chats: only buyer or seller
    match /chats/{chatId} {
      allow read, write: if request.auth.uid == resource.data.buyerId
                         || request.auth.uid == resource.data.sellerId;

      match /messages/{messageId} {
        allow read, write: if request.auth.uid == get(/databases/$(database)/documents/chats/$(chatId)).data.buyerId
                           || request.auth.uid == get(/databases/$(database)/documents/chats/$(chatId)).data.sellerId;
      }
    }
  }
}
```

---

## Image Storage Structure (Firebase Storage)

```
listings/{sellerId}/{listingId}/
  photo_0.jpg   — compressed, max 300KB
  photo_1.jpg
  photo_2.jpg
  photo_3.jpg

users/{uid}/
  avatar.jpg
```
