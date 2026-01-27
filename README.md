# Shopping List App

## Goal of the application

This application provides a simple  shopping list that helps users track items they need to buy. Users can:

* Add items
* Check/uncheck items as collected
* Delete items
* Share the same list state across multiple devices via a cloud backend

The shopping list is synchronized via **Firebase Realtime Database**, allowing multiple users to view and update the list collaboratively.

This project was implemented as part of a technical assignment for **Mobi Lab**.

---

## How to compile and run the application

### Prerequisites

* Flutter SDK (stable channel)
* Android Studio with Android SDK and emulator (or a physical device)
* Git

### Steps

1. Clone the repository:

```bash
git clone https://github.com/vpaabo/mobilab-test-task

```

2. Navigate to the project directory:

```bash
cd mobilab-test-task

```

3. Install dependencies:

```bash
flutter pub get

```

4. Run the application on an emulator or connected device:

```bash
flutter run

```

---

## How to run tests for the application

Unit tests are provided for the business logic and repository layers.

### Run all tests

From the project root, execute:

```bash
flutter test
```

---

## Overall Architecture

The application follows a clean and modular architecture:

* **UI Layer**: Flutter widgets handle rendering and user interactions.
* **State Management**: Riverpod's `StateNotifier` is used for managing the shopping list state.
* **Domain Model**: Immutable `ShoppingItem` class represents individual list items.
* **Repository Layer**: Handles cloud communication via Firebase Realtime Database REST API.
* **Testing**: Business logic and repository operations are covered with unit tests using fake repositories where appropriate.

This separation ensures maintainability, testability, and platform independence for both Android and iOS.

---

## Notes

* No user authentication is implemented,s the same data model is shared across instances.
* Extra to the required functionality, I added
  * `createdAt` field to `ShoppingItem` so the entries could be ordered. 
  * `snackBar` error message handling, which is sadly untested as I couldn't simulate the errors well enough
* The UI is rather simple, so I did not see a need for separate UI tests. 
* I have not used Flutter/Dart before nor coded Android apps, so this project is mostly made using help of AI (I also mentioned this in the interview)