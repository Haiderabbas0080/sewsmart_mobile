# SewSmart

SewSmart is an AI-powered tailoring marketplace that connects customers, tailors and delivery riders. Customers browse tailors, place and track orders, get AI design recommendations and preview garments with a virtual try-on. It is a university Final Year Project.

## Repository layout

| Path | What it is | Status |
| --- | --- | --- |
| `lib/` | Flutter mobile app for customers, tailors and riders | UI built, running on mock data |
| `sewsmart_admin/` | Flutter web admin panel | UI built, running on mock data |
| `backend/` | Node.js + Express REST API | Planned |
| `tryon-service/` | Flask service for the virtual try-on | Planned |
| `docs/API.md` | API contract between the apps and the backend | Admin panel and new mobile endpoints designed |

## Run the mobile app

```bash
flutter pub get
flutter run
```

## Run the admin panel

```bash
cd sewsmart_admin
flutter pub get
flutter run -d chrome
```

## Working on this project

All work goes through issues, short-lived branches and pull requests into `develop`. Read [CONTRIBUTING.md](CONTRIBUTING.md) before your first commit.

| Branch | Purpose |
| --- | --- |
| `main` | Stable, demo-ready |
| `develop` | Integration branch and repository default |
| `feature/*` | One branch per issue |
