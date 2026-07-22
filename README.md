
<div align="center">

# 📈 Trading Blitz

### Learn Technical Analysis. Trade Under Pressure. Become a Better Trader.

Trading Blitz is a **stock trading simulator game** that lets you practice technical analysis on real, anonymized historical stock charts — solo or head-to-head against other traders in fast-paced 90-second battles.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Backend-Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![GetX](https://img.shields.io/badge/State%20Management-GetX-8A2BE2?style=for-the-badge)](https://pub.dev/packages/get)
[![Google Play](https://img.shields.io/badge/Google_Play-Download-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.tradingblitz.mobile&hl=en_IN)

</div>

---

## 🎮 About the App

**Trading Blitz** helps students and aspiring traders learn to read price charts and recognize technical patterns — without risking real money. Practice on millions of randomly selected, anonymous historical charts (you won't know the stock or the time period), then test your skills under pressure.

- 🧠 **Solo Mode** — Start with a $100K virtual account. Can you grow it to $1M?
- ⚔️ **Two Player Mode** — Face off against another trader. Both of you see the same anonymous chart and get 90 seconds to trade the next 200 bars. Best trade wins.
- 📊 **Charts powered by TradingView** — the same charting engine used by real traders.
- 🏆 **Gamified learning** — leaderboards, daily challenges, and achievements keep practice fun and addictive.

> Practicing under pressure helps you create diamonds, not disasters.

---

## 📲 Download

<div align="center">

[![Get it on Google Play](https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png)](https://play.google.com/store/apps/details?id=com.tradingblitz.mobile&hl=en_IN)

</div>

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Dart) |
| **Backend** | Python |
| **State Management** | [GetX](https://pub.dev/packages/get) |
| **Local Storage** | SharedPreferences |
| **Real-time Communication** | WebSockets |
| **Notifications** | Push Notifications (FCM) |
| **In-App Web Content** | WebView |
| **API Layer** | REST APIs |
| **Charts** | TradingView |

---

## ✨ Key Features

- 🔐 Secure user authentication & session handling
- 📈 Real-time price data over WebSockets for live two-player matches
- 🔔 Push notifications for match invites, results, and daily challenges
- 💾 Local caching with SharedPreferences for fast app resume
- 🌐 In-app WebView for embedded web content (e.g. policies, support, promos)
- 🔌 REST API integration for account, leaderboard, and trade history data
- 🎯 Clean, reactive UI architecture powered by GetX (state, routing, dependency injection)

---

## 🏗️ Architecture Overview

```
lib/
├── main.dart
├── app/
│   ├── bindings/          # GetX dependency injection
│   ├── controllers/       # GetX controllers (business logic & state)
│   ├── routes/            # App navigation / route management
│   └── data/
│       ├── models/        # Data models
│       ├── providers/     # REST API & WebSocket providers
│       └── repositories/  # Data repositories
├── ui/
│   ├── screens/           # App screens/pages
│   └── widgets/           # Reusable UI components
├── services/
│   ├── notification_service.dart
│   ├── socket_service.dart
│   └── storage_service.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

*(Adjust this tree to match your actual project structure.)*

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio / VS Code with Flutter & Dart plugins
- A configured backend API endpoint (Python backend)
- Firebase project set up for Push Notifications

### Installation

```bash
# Clone the repository
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Environment Setup

Create a `.env` file (or use `--dart-define`) for sensitive config such as API base URLs, socket endpoints, and third-party keys — **never commit secrets directly into source files.**

```bash
flutter run --dart-define=API_BASE_URL=https://your-api.com --dart-define=SOCKET_URL=wss://your-socket.com
```

---

## 📸 Screenshots

| | | |
|---|---|---|
| ![Screenshot 1](https://play-lh.googleusercontent.com/a23BaCQ-mTRZG-7cYNwwDDLyKSqKS-WiL5vI77S7LkR67Bohq7UYTMNY5YM39aafCvhi9pEp0W11iH7GVASa=w526-h296) | ![Screenshot 2](https://play-lh.googleusercontent.com/D0v-CPXs6UXullvINOebHGe-p_fel-qh0srmvbO3aIgt4qJoGMH5FrY4a7hMzLlYdHQ2Pfp85vyIVzZPzmtgtD0=w526-h296) | ![Screenshot 3](https://play-lh.googleusercontent.com/4-lzrPJGW2PiBpTu0i790sWoBz194myQ6no8ki-5GSgHRYlqiWuNyNmxn1eiI17HwNBc_UU0gYSix6QSVZSfyw=w526-h296) |

*(Replace with your own local screenshot paths, e.g. `assets/screenshots/home.png`, once added to the repo.)*

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

Specify your license here (e.g. MIT, Apache 2.0, or "Proprietary — All Rights Reserved").

---

## 📬 Contact & Support

- 🌐 Website: [tradingblitz.com](https://tradingblitz.com)
- ✉️ Support: [support@tradingblitz.com](mailto:support@tradingblitz.com)
- 🔒 Privacy Policy: [tradingblitz.com/privacy](https://tradingblitz.com/privacy)

<div align="center">

Made with ❤️ using Flutter

</div>
