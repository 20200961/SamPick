Sampick - 학습 퀴즈 애플리케이션
Flutter 기반의 모바일 학습 퀴즈 애플리케이션입니다.
기술 스택
Frontend

Flutter - 크로스 플랫폼 모바일 앱 개발
Dart - 프로그래밍 언어
Material Design 3 - UI/UX 디자인

Backend

Spring Boot - RESTful API 서버
JWT - 인증/인가
Spring Security - 보안

주요 기능

🔐 JWT 기반 로그인/회원가입
📝 일일 퀴즈 (3문제)
📊 학습 통계 및 대시보드
🏆 랭킹 시스템
🎖️ 배지 시스템
📅 학습 캘린더

프로젝트 구조
sampick/
├── sampick_front/          # Flutter 앱
│   └── lib/
│       ├── main.dart
│       └── screens/
└── sampick_back/           # Spring Boot API
    └── src/main/java/
API 엔드포인트
POST /api/auth/login          # 로그인
POST /api/auth/signup         # 회원가입
POST /api/auth/forgot-password # 비밀번호 찾기
개발 환경 설정
Frontend
bashcd sampick_front
flutter pub get
flutter run

Backend

bashcd sampick_back
./gradlew bootRun
테스트 계정

이메일: 1@1
비밀번호: 111111