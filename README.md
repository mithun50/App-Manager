# App Manager

A Flutter-based Android app that tracks daily app usage, lets you set category-based time limits, and sends local notifications when limits are approached or reached.

## Features

- **Usage Tracking** — View real-time app usage data via Android's UsageStatsManager
- **Category Organization** — Apps are automatically grouped into 8 categories (Social Media, Games, Productivity, Entertainment, Communication, News & Reading, Education, Other)
- **Time Limits** — Set daily time limits per category with a simple slider interface
- **Smart Notifications** — Get warned at 80% usage and notified when limits are reached (deduplicated per day)
- **Background Monitoring** — WorkManager checks usage every 15 minutes even when the app is closed
- **Usage Charts** — Pie chart breakdown of daily usage by category
- **Dark Mode** — Full light and dark theme support with Material 3

## Screenshots

*Coming soon*

## Architecture

| Layer | Technology |
|-------|-----------|
| State Management | Provider |
| Local Storage | sqflite |
| Notifications | flutter_local_notifications |
| Background Tasks | workmanager |
| Native Bridge | Platform Channel → UsageStatsManager |
| Charts | fl_chart |

## Building

This project uses GitHub Actions for CI/CD since Flutter isn't required locally.

### CI (Automatic)
Every push to `main` triggers a build. Download the APK from the Actions artifacts.

### Release
```bash
git tag v1.0.0
git push --tags
```
This creates a GitHub Release with the APK attached.

### Local Build (if Flutter is installed)
```bash
flutter pub get
flutter build apk --release
```

## Permissions

| Permission | Purpose |
|-----------|---------|
| `PACKAGE_USAGE_STATS` | Read app usage data (requires manual grant in Settings) |
| `POST_NOTIFICATIONS` | Send limit warning and reached notifications |
| `RECEIVE_BOOT_COMPLETED` | Restart background monitoring after device reboot |

## Project Structure

```
lib/
├── main.dart                 # Entry point + MultiProvider setup
├── models/                   # Data classes (AppInfo, AppUsage, Category, DailySummary)
├── services/                 # Database, usage stats bridge, notifications, background worker
├── providers/                # State management (usage, categories, settings)
├── screens/                  # UI screens (dashboard, categories, limits, settings)
├── utils/                    # Constants, formatters, theme, default categories
└── widgets/                  # Shared widgets (progress bar, empty state, loading)

android/.../kotlin/
├── MainActivity.kt           # Platform channel registration
├── UsageStatsHelper.kt       # UsageStatsManager wrapper
└── AppCategoryMapper.kt      # Package → category mapping
```

## License

This project is open source.
