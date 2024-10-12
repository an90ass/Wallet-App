# Walletly App

A mobile application built using Flutter, Firebase, and Provider to manage cards, transactions, payments, notifications, and incomes efficiently.

### Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/b2ed3565-dfcb-479a-bb14-164844775f7d" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/b0fad0b4-5f97-4459-a8a5-6a19ffd50402" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/8a602215-a6d9-49ff-898f-fe18d6b3cff1" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/0ab7e159-cdc2-4067-82f6-fe7a25a34802" width="200" style="border-radius: 15px; margin: 10px;" />
</p>
<br>
<br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/8b7fef74-a2d2-48ec-9230-ffc7a731fe47" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/33e7e9a0-54d1-4f60-aa0b-651a2ca96ae8" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/90ca25fa-1d0b-4b7e-a99e-2981bb136196" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/c3332125-beda-4260-abb2-feb2e6fc1ff6" width="200" style="border-radius: 15px; margin: 10px;" />
</p>
<br>
<br>
<p align="center">
  <img src="https://github.com/user-attachments/assets/8cb92d86-e73a-4838-87a8-0893bd237d74" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/65c886a0-f8fe-4eeb-aee4-c856d585c8f5" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/a81d1eba-6b24-42f2-ba3c-a25b21c888c8" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/d53e65d7-7831-4d29-b5f9-02118ba29677" width="200" style="border-radius: 15px; margin: 10px;" />
</p>
<br>
<br>
<p align="center">
  <img src="https://github.com/user-attachments/assets/205c9974-2b62-4abd-ab9e-dc88858aac36" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/35c3d1a3-cc91-421a-83a3-9931d9a81fce" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/8dd4aa98-4f63-4953-a9ac-d0c6a3d239de" width="200" style="border-radius: 15px; margin: 10px;" />
  <img src="https://github.com/user-attachments/assets/ba991a31-b172-476a-bccd-ed97c721aff4" width="200" style="border-radius: 15px; margin: 10px;" />
</p>
<br>
<br>
<p align="center">
  <img src="https://github.com/user-attachments/assets/19aab37e-b4ad-48f3-9b9d-1d7ce45b1608" width="200" style="border-radius: 15px; margin: 10px;" />
</p>

## Features

- **Card Management**: Add, edit, and remove payment cards securely.
- **Transactions**: Track your spending and income across various cards.
- **Payments**: Easily manage payments for different services using the saved cards.
- **Notifications**: Get real-time notifications for payments, incoming transactions, and other relevant financial updates. Local notifications are used to alert users about important events.
- **Incomes**: Manage and track income sources with detailed reporting.
- **Secure Data Storage**: All user data, including card details, transactions, and notifications, are stored securely using Firebase Firestore and Firebase Cloud Storage.

## Technologies Used

- **Flutter**: For cross-platform mobile app development.
- **Dart**: Programming language for building the app logic.
- **Provider**: State management for handling app-wide data and ensuring efficient performance.
- **Firebase Firestore**: A cloud NoSQL database for storing and managing card data, transactions, and notifications.
- **Firebase Cloud Functions**: For handling secure payments and managing notifications in real-time.
- **Firebase Cloud Storage**: For securely storing payment receipts, card images, and related documents.
- **Local Notifications**: Manage in-app notifications for reminders and alerts.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
- Firebase account and project set up.
- A code editor such as [Visual Studio Code](https://code.visualstudio.com/) with the Flutter and Dart plugins.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/an90ass/Wallet-App.git
2. Navigate to the project directory:
   ```bash
   cd Wallet-app
3. Install dependencies:
   ```bash
   flutter pub get
4. Set up Firebase:
  - Follow the official Firebase setup guide to configure Firebase for your Flutter project.
  - Add google-services.json (for Android) and GoogleService-Info.plist (for iOS) to the project.
5. Run the application:
   ```bash
   flutter run

## How to Use

1. **Add a Card**  
   Navigate to the **Card Management** section to easily add new payment cards by filling out the necessary details. You can also edit or remove existing cards.

2. **Make a Payment**  
   Select one of the saved cards and initiate a payment for services or bills directly from the app, making the payment process quick and secure.

3. **Track Transactions**  
   Access the **Transactions** tab to view a detailed history of all your spending and income. Each transaction is categorized and can be filtered by date for better financial oversight.

4. **Receive Notifications**  
   Stay informed with **Local Notifications** for every payment success, incoming transactions, or reminders for upcoming bills. Notifications are sent directly to your device.

5. **Manage Income**  
   Head over to the **Income Management** section to add new income sources, track your earnings, and review reports to maintain your financial health with real-time updates.






