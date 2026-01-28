
# Shopping List App

## Goal of the Application

This application provides a simple  shopping list that helps users track items they need to buy. Users can:

* Add items
* Check/uncheck items
* Delete items
* Share the same list state across multiple devices

The shopping list is synchronized via **Firebase Realtime Database**, allowing multiple users to view and update the list collaboratively.

This project was implemented as part of a technical assignment for **Mobi Lab**.

<br>

---
<br>

## Compile and Run the Application

### Prerequisites

* Flutter SDK 
* Android Studio with Android SDK and emulator (or a physical device)
* Git

### 1. Clone the repository:

```bash
git clone https://github.com/vpaabo/mobilab-test-task
cd shopping_list_app
```

### 2. Install dependencies:

```bash
flutter pub get
```
### 3. Create a .env file in the project root, based on .env.example:

```bash
cp .env.example .env
```

### 4. Fill in the database URL.

### 5. Run the app on a connected device or emulator:

```bash
flutter run -d <device-name>
```

## Using APK
To build the app into an .apk:

```bash
flutter build apk
```
The generated APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`



A release APK is available in the Releases
section. You can install it directly on an Android device.

<br>


## Running Tests

To run the automated tests:
```bash
flutter test
```

This will execute all unit and widget tests defined in the test/ directory.

## Application Architecture

Project file structure:

lib/             <br>
 ├── models/     <br>
 ├── providers/  <br>
 ├── repository/ <br>
 └── screens/    <br>


The application follows a state-driven architecture using Riverpod for state management and Firebase Realtime Database for persistence. Key components include:

- Models: Defines the ShoppingItem entity.

- Providers: Contains Riverpod providers for managing state.

- Repository: Handles communication with Firebase, including CRUD operations for shopping items.

- Screens   : UI layers of the application, such as the main shopping list screen.

<br>

## Notes

* No user authentication is implemented, the same data model is shared across instances.

* The Firebase database connection is loaded frome the `.env` file. My pre-setup database URL is provided in the email.

* The app has a refresh button to synchronize with the database. I found it more comfortable to have to refresh manually as an user than ex. a 5-second auto-update which would mess with trying to add/change/remove items if the update happens as the user does something.

* Extra to the required functionality, I added
  * `createdAt` field to `ShoppingItem` so the entries could be ordered. 
  * `snackBar` error message handling, which is not rigorously tested as I couldn't simulate the errors reliably.
  * `"Add Item"` text box does not clear when refreshing the app. 
* The UI is rather simple, so I did not see a need for separate UI tests. 
* I have not used Flutter/Dart before nor coded Android apps, so this project is mostly made using the help of AI (I also mentioned this in the interview). This project took ~13 hours (2h setup, 6h vibecoding, 3h testing, 2h touching up).