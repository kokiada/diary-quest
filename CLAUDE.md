# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DiaryQuest (ダイクエ) is a **Flutter-based gamified journaling app** that transforms daily diary entries into RPG-style quests. Users speak their daily experiences, AI analyzes them, and the system converts experiences into experience points across 15 growth parameters.

**Language Note**: Requirements and UI strings are in Japanese, but code is in English.

## Build and Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (requires connected device/simulator)
flutter run

# Build for iOS
flutter build ios

# Run tests
flutter test

# Static analysis
flutter analyze

# Code generation (for Freezed/JSON serialization/riverpod_generator)
flutter pub run build_runner build
```

## Architecture

### Technology Stack
- **Framework**: Flutter (Dart 3.10.7+)
- **State Management**: Riverpod (flutter_riverpod v2.4.9)
- **Backend**: Firebase (Auth + Cloud Firestore)
- **AI**: OpenAI API (GPT-4o) for quest analysis and reframing
- **Voice Input**: speech_to_text package
- **UI**: Custom pixel-art retro game style (Press Start 2P, VT323 fonts)

### Project Structure
```
lib/
├── core/
│   ├── constants/        # App colors, theme, 15 growth parameters
│   ├── config/          # App configuration
│   ├── services/        # OpenAI, Speech, Auth, Follow-up services
│   └── utils/           # Encryption, anonymization utilities
├── models/              # User, QuestEntry, Job, Skill (Freezed models)
├── repositories/        # Data layer (Firestore access)
├── providers/           # Riverpod state management
├── features/            # Feature-based organization
│   ├── auth/           # Login, Navigator selection
│   ├── home/           # Home screen with player stats
│   ├── quest/          # Quest report screen
│   ├── job_skill/      # Job/Skill display
│   ├── status/         # Status/graph screen
│   ├── weekly_report/  # Weekly report
│   └── settings/       # Settings
└── widgets/            # Shared widgets
```

### Clean Architecture Pattern
- **Presentation Layer**: Features (screens, widgets) + Providers (Riverpod)
- **Domain Layer**: Models + Core constants
- **Data Layer**: Repositories (Firestore) + Services (OpenAI, Speech)

## Key Systems

### 15 Growth Parameters (MECE Framework)
Defined in `lib/core/constants/parameters.dart`:
- **5 Categories**: Tactics, Execution, Social, Mastery, Frontier
- **15 Parameters**: 3 per category (e.g., analysis, speed, empathy, resilience, riskTaking)
- Each has: icon, description, growth message, color (by category)

### Quest Analysis Flow
1. User speaks diary entry → speech_to_text transcribes
2. OpenAI Service (`lib/core/services/openai_service.dart`) analyzes:
   - `summary`: Daily report format
   - `reframedContent`: Positive reframing
   - `earnedExp`: Map of GrowthParameter → XP (0-20 each)
   - `navigatorComment`: Personality-based feedback
3. Result saved to Firestore as `QuestEntry`
4. User's parameter XP updated via `UserNotifier`

### State Management (Riverpod)
- **Providers**: Located in `lib/providers/`
- **Key Providers**:
  - `authProvider`: Firebase Auth state
  - `userProvider`: User data, XP calculation, unlock checks
  - `questAnalysisProvider`: Quest analysis state (recording, analyzing, result)
  - `todayQuestsProvider`, `weeklyQuestsProvider`: Quest lists

### Navigator System
5 companion personalities (軍師/aniki/spirit/knight/cat):
- Selected in `NavigatorSelectionScreen` (first time only)
- Stored in `UserModel.selectedNavigator`
- Affects OpenAI prompt personality parameter

## Code Generation

This project uses **Freezed** for immutable models and **json_serializable** for JSON serialization. After modifying model files:

```bash
flutter pub run build_runner build
```

Models requiring regeneration:
- `lib/models/user.dart`
- `lib/models/quest_entry.dart`
- `lib/models/job.dart`
- `lib/models/skill.dart`

## Firebase Configuration

- Firebase project initialized in `lib/main.dart`
- iOS config: `ios/GoogleService-Info.plist`
- Firestore collections:
  - `users`: User documents
  - `quests`: QuestEntry documents (subcollection by user)

## API Keys

OpenAI API key is configured via `AppConfig` (loaded from `secrets/api-key.txt` or environment variable). Never commit API keys directly.

## UI Design System

Pixel-art retro game style (light theme):
- **Fonts**: Press Start 2P (headers), VT323 (body)
- **Colors**: `#F0F9FF` background, category-specific colors for parameters
- **Borders**: Thick 2-4px borders with pixel shadows
- **Components**: Card-based layout with rounded corners

Define in `lib/core/constants/app_colors.dart` and `app_theme.dart`.

## Testing

Currently minimal test coverage. Tests are in `test/` directory using `flutter_test`.

## Common Patterns

### Adding a New Feature Screen
1. Create screen in `lib/features/[feature]/[feature]_screen.dart`
2. Add widgets in `lib/features/[feature]/widgets/`
3. Create provider in `lib/providers/[feature]_provider.dart` if state needed
4. Wire up navigation in `HomeScreen` or via `Navigator.push`

### Modifying Growth Parameters
Edit `lib/core/constants/parameters.dart` - all parameter definitions centralized here.

### Adding New Navigator Personalities
1. Add enum value to `NavigatorType` in models
2. Add personality-specific prompt logic to OpenAI service
3. Update navigator selection UI
