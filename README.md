# 🎯 SamPick (삼픽)

> **하루 3가지 문제로 성장하는 플랫폼**  
> **"Simplify Your Daily Learning, Three at a Time."**

[![Flutter](https://img.shields.io/badge/Flutter-3.38.5-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.0.1-6DB33F?logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)

---

## 📖 Intro
**SamPick(삼픽)**은 바쁜 일상 속에서도 핵심적인 지식을 놓치지 않도록 돕는 **데일리 퀴즈 앱**입니다. 매일 엄선된 3개의 문제를 풀며 꾸준한 학습 습관을 형성하고, 자신의 성장을 시각적으로 확인할 수 있습니다.

## ✨ Key Features
- 📝 **오늘의 3문제 (Daily 3 Quiz)**: 매일 새롭게 제공되는 3개의 핵심 퀴즈.
- 🏆 **랭킹 시스템 (Ranking)**: 다른 사용자들과 선의의 경쟁을 통한 동기 부여.
- 📊 **대시보드 (Dashboard)**: 나의 학습 통계와 성장 그래프 확인.
- 🥇 **배지 시스템 (Badges)**: 특정 목표 달성 시 획득하는 성취 지표.
- 👤 **프로필 관리 (Profile)**: 직관적인 개인화 화면 및 커스터마이징.

## 🛠 Tech Stack
### Frontend
- **Framework**: Flutter 3.38.5
- **Language**: Dart 3.10.4
- **State/Auth**: `flutter_secure_storage`, `http`
- **UI**: Material 3 / Pretendard Font

### Backend
- **Framework**: Spring Boot 4.0.1
- **Architecture**: REST API

## 📂 Project Structure
```text
SamPick/
├── sampick_front/          # Flutter Frontend
│   ├── lib/
│   │   ├── main.dart       # App Entry Point
│   │   └── screens/        # UI Screens (Quiz, Badge, Ranking, etc.)
│   └── pubspec.yaml        # Dependencies & Config
├── requirements.txt        # System Requirements
└── README.md               # Home
```

## 🚀 Getting Started
### Prerequisites
- Flutter SDK (Recommended: 3.38.x)
- Java 17+ (for Spring Boot Backend)

### Running Frontend
```bash
cd sampick_front
flutter pub get
flutter run
```

---

## 🤝 Contact & Contribution
- **Project Owner**: [Your Name/Github ID]
- **Issue Reporting**: [Issues Page Link]

---
© 2026 SamPick Team. All Rights Reserved.
