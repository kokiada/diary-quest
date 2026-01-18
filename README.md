# DiaryQuest (ダイクエ) - Gamified Journaling App

**人生を冒険に、成長を経験値に**

DiaryQuest is a Flutter-based gamified journaling application that transforms daily diary entries into RPG-style quests. Users speak their daily experiences, AI analyzes them, and the system converts experiences into experience points across 15 growth parameters.

## Features

- 🎤 **Voice Input**: Record diary entries using speech-to-text
- 🤖 **AI Analysis**: OpenAI GPT-4 analyzes experiences and provides positive reframing
- 📊 **15 Growth Parameters**: Track progress across Tactics, Execution, Social, Mastery, and Frontier
- 🎮 **RPG Gamification**: Level up, unlock skills, unlock jobs, earn achievements
- 👥 **Navigator Companions**: Choose from 5 unique AI personality guides
- 📈 **Progress Tracking**: Weekly reports, statistics, and visualizations
- ⚙️ **Settings**: Profile editing, notification preferences, language selection

## Tech Stack

- **Framework**: Flutter (Dart 3.10.7+)
- **State Management**: Riverpod (flutter_riverpod v2.4.9)
- **Backend**: Firebase (Auth + Cloud Firestore)
- **AI**: OpenAI API (GPT-4o)
- **Voice Input**: speech_to_text package
- **Charts**: fl_chart for weekly EXP visualization
- **Animation**: lottie for unlock celebrations

## Prerequisites

Before setting up the project, ensure you have:

1. **Flutter SDK** (3.10.7 or higher)
   ```bash
   flutter --version
   ```

2. **Firebase Account**
   - Create a project at https://console.firebase.google.com
   - Enable Authentication (Email/Password)
   - Create Cloud Firestore database

3. **OpenAI API Key**
   - Get your API key from https://platform.openai.com/api-keys

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/diary-quest.git
cd diary-quest
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

#### iOS Setup

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/`
3. **⚠️ CRITICAL**: The file is currently missing - see [Stage 2 Blockers](#stage-2-blockers) below

#### Android Setup (if needed)

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`

### 4. OpenAI API Key Setup

#### Development Mode

Create a `secrets/api-key.txt` file:

```bash
mkdir secrets
echo "your-openai-api-key-here" > secrets/api-key.txt
```

**Note**: The `secrets/` directory is gitignored and will not be committed.

#### Production Mode

Use environment variables:

```bash
flutter run --dart-define=OPENAI_API_KEY=your_key_here
```

### 5. Run the App

```bash
# iOS Simulator
flutter run

# Android Emulator
flutter run

# Specific device
flutter devices
flutter run -d <device-id>
```

## Project Structure

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
│   ├── quest_history/  # Quest history list
│   ├── job_skill/      # Job/Skill display
│   ├── status/         # Status/graph screen
│   ├── weekly_report/  # Weekly report
│   └── settings/       # Settings
└── widgets/            # Shared widgets (dialogs, etc.)
```

## Architecture

The app follows **Clean Architecture** principles:

- **Presentation Layer**: Features (screens, widgets) + Providers (Riverpod)
- **Domain Layer**: Models + Core constants
- **Data Layer**: Repositories (Firestore) + Services (OpenAI, Speech)

## Development Workflow

### Branch Naming

Follow the convention: `<type>/<issue-id>-<short-description>`

Examples:
- `feature/add-user-authentication`
- `bugfix/fix-login-crash`
- `docs/readme-update`

See [CLAUDE.md](CLAUDE.md) for complete branching guidelines.

### Code Generation

This project uses Freezed for immutable models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Run after modifying:
- `lib/models/user.dart`
- `lib/models/quest_entry.dart`
- `lib/models/job.dart`
- `lib/models/skill.dart`

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Static Analysis

```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

## Key Features Implementation

### 15 Growth Parameters (MECE Framework)

Defined in `lib/core/constants/parameters.dart`:

| Category | Parameters |
|----------|------------|
| **Tactics** | analysis, insight, strategy |
| **Execution** | speed, consistency, resilience |
| **Social** | empathy, communication, leadership |
| **Mastery** | knowledge, creativity, expertise |
| **Frontier** | riskTaking, curiosity, innovation |

### Quest Analysis Flow

1. User speaks diary entry → `speech_to_text` transcribes
2. `OpenAIService` analyzes:
   - `summary`: Daily report format
   - `reframedContent`: Positive reframing
   - `earnedExp`: Map of GrowthParameter → XP (0-20 each)
   - `navigatorComment`: Personality-based feedback
3. Result saved to Firestore as `QuestEntry`
4. User's parameter XP updated via `UserProvider`

### Navigator System

5 companion personalities:
- **軍師** (Strategist): Analytical and logical
- **兄貴** (Aniki): Motivational and energetic
- **精霊** (Spirit): Mystical and philosophical
- **騎士** (Knight): Honorable and disciplined
- **猫** (Cat): Playful and curious

## Stage 2 Blockers (Critical Dependencies)

The following items are **BLOCKED** and require external resources:

### 1. Firebase Configuration ⚠️

**Status**: MISSING
**Required**: `ios/GoogleService-Info.plist`
**Impact**: App cannot authenticate or access Firestore

**Action Required**:
1. Create Firebase project at https://console.firebase.google.com
2. Add iOS app with bundle ID: `com.example.diaryquest`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/` directory

### 2. Image Assets ⚠️

**Status**: MISSING
**Required**: Navigator character images and base evolution images

**Needed**:
```
assets/images/navigators/
  ├── strategist.png (軍師)
  ├── aniki.png (兄貴)
  ├── spirit.png (精霊)
  ├── knight.png (騎士)
  └── cat.png (猫)

assets/images/bases/
  ├── base_level_1.png
  ├── base_level_2.png
  ├── base_level_3.png
  └── ... (up to level 10)
```

**Action Required**: Create or source PNG images (512x512px recommended)

### 3. Lottie Animations ⚠️

**Status**: MISSING
**Required**: Celebration animations for unlocks

**Needed**:
```
assets/animations/
  ├── level_up.json
  ├── skill_unlock.json
  └── job_unlock.json
```

**Action Required**: See `assets/animations/README.md` for details

## Troubleshooting

### Firebase Initialization Error

**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution**: Ensure `GoogleService-Info.plist` is in `ios/Runner/` and Firebase is initialized in `lib/main.dart`

### OpenAI API Error

**Error**: `Request failed with status code 401`

**Solution**: Check your API key in `secrets/api-key.txt` or use `--dart-define=OPENAI_API_KEY=...`

### Build Errors

**Error**: `Target of URI doesn't exist`

**Solution**: Run `flutter pub get` and `flutter pub run build_runner build`

## Testing Strategy

The project aims for 80%+ test coverage with:

- **Unit Tests**: Services, repositories, providers
- **Widget Tests**: Screens, widgets, user interactions
- **Integration Tests**: Critical user flows with Firebase Emulator

See `test/` directory for examples.

## Contributing

1. Follow the [Code of Conduct](CODE_OF_CONDUCT.md)
2. Read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
3. Follow the branching conventions in [CLAUDE.md](CLAUDE.md)
4. Ensure all tests pass and `flutter analyze` returns 0 issues

## License

See [LICENSE](LICENSE) file for details.

## Credits

- **Concept**: DiaryQuest Team
- **Development**: See contributors on GitHub
- **Design**: Pixel-art retro game style

## Contact

- **Issues**: https://github.com/your-org/diary-quest/issues
- **Discussions**: https://github.com/your-org/diary-quest/discussions

---

**Version**: 1.0.0
**Last Updated**: 2025-01-18
**Status**: Development Phase - Stage 2 blockers prevent production deployment
