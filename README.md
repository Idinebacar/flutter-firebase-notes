# 📝 Flutter Notes App

A modern, secure, and feature-rich Notes application built with **Flutter** and **Firebase**. This app allows users to manage their personal notes with real-time cloud synchronization, sleek UI, and customizable themes.

---

## ✨ Features

*   **🔒 Secure Authentication**: Register and Login using Firebase Auth. User sessions persist automatically.
*   **📂 Cloud CRUD**: Create, Read, Update, and Delete notes synchronized across all devices via Cloud Firestore.
*   **🎨 Custom Note Colors**: Personalize each note with a vibrant color palette.
*   **🔍 Real-time Search**: Find notes instantly by title or content using a dedicated search interface.
*   **🌗 Dark Mode**: Full support for system-wide light and dark themes.
*   **📱 Modern UI**: Material 3 design with a staggered grid layout and smooth transitions.
*   **👤 User Specific**: Data isolation ensured; users only see and edit their own notes.

---

## 🛠️ Tech Stack

*   **Frontend**: Flutter (Dart)
*   **Backend**: Firebase Authentication, Cloud Firestore
*   **State Management**: Provider

---

## 📂 Project Structure

```text
lib/
├── core/               # App-wide configurations
│   ├── theme/          # Theme & Color definitions
│   │   ├── app_colors.dart # Primary & Note palette colors
│   │   └── app_theme.dart  # Light & Dark theme logic
│   └── constants/      # Static strings and UI constants
├── models/             # Data models
│   └── note.dart       # NoteModel with Firestore serialization
├── providers/          # State Management
│   ├── auth_provider.dart  # User authentication logic
│   ├── theme_provider.dart # Dark/Light mode logic
├── screens/            # UI Screens
│   ├── auth/           # Login & Register screens
│   ├── home/           # Main notes dashboard (Grid view)
│   └── notes/          # Create & Edit note screens
├── services/           # Backend Logic (API/Firebase)
│   ├── auth_service.dart     # Firebase Auth interaction
│   └── firestore_service.dart # Firestore CRUD operations
├── widgets/            # Reusable UI Components
│   ├── custom_button.dart
│   ├── custom_textfield.dart
│   └── note_card.dart  # Personalized note grid tile
├── main.dart           # App entry point & Router
└── firebase_options.dart # Firebase configuration
```

---

## 🚀 Getting Started

### Setup Instructions

1.  **Clone the Repository**
2.  **Firebase Configuration**: Run `flutterfire configure` to update `firebase_options.dart`.
3.  **Install Dependencies**: `flutter pub get`
4.  **Database Rules**:
    ```javascript
    match /notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
    ```
5.  **Run the App**: `flutter run`

---

## 🔮 Future Enhancements

*   [ ] Image attachments & Voice notes.
*   [ ] Categorization using Tags/Labels.
*   [ ] Pin important notes to the top.
*   [ ] Offline local caching with SQLite or Hive.
*   [ ] Biometric lock (Fingerprint/FaceID).

---

**Developed with ❤️ by Chamsidine Bacar**
