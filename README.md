# Shopping List App

## Goal of the application

The goal of this application is to provide a simple, mobile-friendly shopping list that helps users keep track of items they need to buy. Users can add items, mark them as collected, delete them, and share the same list state across multiple devices in the future via a cloud backend.

This project is implemented as part of a technical assignment for Mobi Lab.

---

## Supported platform

* Flutter application
* Tested on **Android Emulator Android 16 (API 36)**
* The application is built with Flutter using platform-agnostic architecture.
While development and testing were performed on Android, no Android-specific APIs are used, and the app is expected to work on iOS without code changes.

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
cd shopping_list_app
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

Business logic is isolated from the UI, making it easy to test and later extend with a cloud data source.

---

## Data storage

Currently, the application uses in-memory state for simplicity.

The codebase is structured so that a cloud-backed data source (e.g. Firebase Realtime Database via REST API) can be added later without changing the UI layer.

---

## Testing

* Unit tests cover the core shopping list logic:

  * Initial state
  * Adding items
  * Toggling items
  * Removing items

---

## Tooling

* Flutter
* Riverpod
* Git (version control from project start)
* Android Emulator

---

## Notes

* No user authentication is implemented; the same data model is intended to be shared across instances once cloud sync is added
