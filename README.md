# 📆 Timora

**Timora** est une application de calendrier-agenda développée avec Flutter.  
Elle propose une interface épurée, fluide et responsive, pensée pour organiser ses journées avec sérénité.

---

## ✨ Fonctionnalités prévues

- 🔄 Synchronisation d'événements (Google Calendar, etc.)
- 📅 Vue par jour, semaine, mois, année
- 👥 Espaces partagés (famille, amis, travail)
- 📝 To-do list, bloc-notes, liste de courses
- 🎨 Thèmes personnalisables (clair, sombre, mint, etc.)
- 💬 Petites animations fluides pour une expérience agréable

---

## 📦 Stack technique

- **Flutter** (UI multiplateforme)
- **Dart** (logique métier)
- **Firebase** (auth, stockage, base de données – à venir)
- **Android Studio** (environnement de développement)

---

## 🚀 Lancer l'application en local

```bash
git clone https://github.com/<ton-username>/timora.git
cd timora
flutter pub get
flutter run
```
---

## 🛠️ Organisation du code

```bash
lib/
├── theme/          # Thèmes (dark, light, mint, etc.)
├── components/     # Composants atomiques & moléculaires
├── screens/        # Pages principales
├── providers/      # Gestion de l’état (ThemeSwitcher, etc.)
└── main.dart       # Point d’entrée
```

## Environments cmd

- flutter run --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev
