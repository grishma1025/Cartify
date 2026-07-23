# 🛒 Cartify

> **A smart grocery shopping application that automatically predicts recurring purchases and prepares a ready-to-review shopping cart.**

## ✨ Features

- 🔐 Firebase Authentication
- 👤 Guest User Flow
- 🛍 Product Browsing & Search
- ❤️ Wishlist
- 🛒 Smart Cart Management
- 🤖 Rule-Based Auto Cart Prediction
- 📦 Order Management
- 💳 Razorpay Payment Integration
- 🔔 Push Notifications (FCM)
- ☁️ Firebase Firestore & Storage
- 🖥️ Django Admin Panel

---

## 🛠️ Tech Stack

**Frontend:** Flutter, Dart

**Backend:** Firebase Authentication, Cloud Firestore, Firebase Storage, Firebase Cloud Messaging

**Admin Panel:** Django, Python

**Payment:** Razorpay

**Design:** Figma

---

## 🚀 Getting Started

### Clone the repository

```bash
git clone <YOUR_REPOSITORY_LINK>
cd Cartify
```

### Install dependencies

```bash
flutter pub get
```

### Configure Firebase

- Create a Firebase project.
- Add `google-services.json` to `android/app/`.
- Enable:
  - Authentication
  - Cloud Firestore
  - Firebase Storage
  - Firebase Cloud Messaging

### Run the application

```bash
flutter run
```

---

## 📂 Project Structure

```
Cartify/
├── android/
├── ios/
├── lib/
├── assets/
├── test/
├── web/
├── windows/
└── pubspec.yaml
```

---

## 🤖 Auto Cart Prediction

The application automatically generates a shopping cart based on recurring purchase patterns.

**Algorithm:**

- Starts after **5 purchases** of the same product (same brand & variant)
- Calculates the **average purchase interval**
- Predicts the **next purchase date**
- Generates a smart cart when the user opens the app on or after that date
- Sends a notification for user review before checkout

---

## 👨‍💻 Team

- Grishma Bhuva
- Mitesh Nanera
- Kashish Rabara
- Krishna Ramani

**Guide:** Dr. Arpit Jain

GLS University

---

## 📄 License

Developed as an MCA Major Project for academic purposes.
