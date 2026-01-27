# Shopping List App

## Goal of the application

The goal of this application is to provide a simple, mobile-friendly shopping list that helps users keep track of items they need to buy. Users can add items, mark them as collected, delete them, and share the same list state across multiple devices via a cloud backend.

This project is implemented as part of a technical assignment for Mobi Lab.

---

## Supported platform

* Flutter application
* Tested on **Android Emulator Android 16.0 (API 36)**
* The architecture is platform-agnostic and can be extended to iOS without code changes (iOS testing requires macOS)

---

## How to compile and run the application

### Prerequisites

* Flutter SDK (stable channel)
* Android Studio with Android SDK and emulator
* Git

### Steps

1. Clone the repository:

```bash
git clone https://github.com/vpaabo/mobilab-test-task
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application on an emulator or connected device:

```bash
flutter run
```

---

## How to run tests

Unit tests are provided for the business logic layer.

Run all tests with:

```bash
flutter test
```

---

## Architecture overview

The application follows a simple and clean architecture:

* **UI layer**: Flutter widgets responsible only for rendering and user interaction
* **State management**: Riverpod (`StateNotifier`) is used to manage application state
* **Domain model**: Immutable `ShoppingItem` model
* **Repository layer**: Handles cloud communication (Firebase Realtime Database via REST API)

---

## Data storage and syncing

* The shopping list is stored in **Firebase Realtime Database**.
* Items include a `createdAt` timestamp, allowing consistent **newest-first ordering**.
* The app auto-polls Firebase for near real-time updates every 5 seconds.
* Multiple devices accessing the same database see a synchronized list when refreshed or polled.

---

## Testing

* Unit tests cover the core shopping list logic:

  * Initial state
  * Adding items
  * Toggling items
  * Removing items
  * Ensuring newest-first order is maintained

---

## Tooling

* Flutter
* Riverpod
* Git (version control from project start)
* Android Emulator
* Firebase Realtime Database (REST API)

---

## Notes

* No user authentication is implemented; the same data model is shared across instances.