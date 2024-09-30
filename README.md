# Furniture AR Shopping App

**Furniture AR Shopping App** is a demo online shopping app focused on furniture. This app allows users to browse, try, and shop for furniture in augmented reality (AR). It's built using Flutter and Firebase to provide seamless integration between the app and backend services.

## Features

- **Browse Furniture:** Users can explore a wide range of furniture options.
- **AR Integration:** View and place furniture items in your room using augmented reality.
- **Shopping Cart:** Add selected items to the cart for easy checkout.
- **Firebase Authentication:** Secure login and registration using Firebase.
- **Real-time Database:** Sync and fetch furniture details and orders in real-time with Firebase Firestore.
- **Responsive Design:** Works across iOS and Android platforms.

## Technology Stack

- **Flutter:** UI toolkit for building natively compiled applications.
- **Firebase Authentication:** User authentication with email and password.
- **Firebase Firestore:** Realtime NoSQL database for storing furniture catalog and orders.
- **Firebase Storage:** Store and retrieve images of the furniture.
- **ARCore (for Android) / ARKit (for iOS):** Augmented reality integration for placing furniture.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK installed.
- A Firebase project set up (for authentication and Firestore).
- Xcode (for iOS development) or Android Studio (for Android development).
- Basic knowledge of Dart and Flutter.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/FelixA8/Furiniture.git
   cd Furiniture

2. Clone the repository:
   ```bash
   flutter pub get

3. Set up Firebase:
   - Go to the Firebase Console, create a project, and configure your app for Android and iOS.
   - Download the **google-services.json** file for Android and **GoogleService-Info.plist** for iOS and place them in the respective directories.

4. Run the app:
   ```bash
   flutter run

### ARCore / ARKit Setup
**For Android:** Ensure your device supports ARCore. You'll need to install the ARCore library on your device.
**For iOS:** ARKit is supported on devices running iOS 11 or later. Ensure you are testing on a compatible device (ARKit is not available on the simulator).

### Folder Structure

    ```bash
    lib/
    ├── view_models/           # Data models for Furniture and User
    ├── provider_models/       # Provider for managing state
    ├── global/                # Store temporary data to global variable. Resets everytime application is destroyed
    ├── services/              # Firebase and AR services
    ├── screens/               # UI screens (login, home, product details, AR viewer)
    ├── widgets/               # Custom widgets
    ├── firebase_options.dart  # Firebase Options
    └── main.dart              # Main app file

<p align="center">Built with 💙 using Flutter and Firebase</p>
