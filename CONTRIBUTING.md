# Contributing to DiaryQuest

Thank you for your interest in contributing to DiaryQuest! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful, inclusive environment. Be constructive in your feedback and welcoming to all contributors.

## Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or higher
- Firebase account (for development/testing)
- OpenAI API key (for AI features)
- Familiarity with Dart, Flutter, and Riverpod

### Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/diary-quest.git
   cd diary-quest
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/original-org/diary-quest.git
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```

## Development Workflow

### 1. Branch Strategy

Always create a branch from `master` for your work:

```bash
git checkout master
git pull upstream master
git checkout -b feature/your-feature-name
```

**Branch Naming Convention**:
- `feature/<description>` - New features
- `bugfix/<description>` - Bug fixes
- `hotfix/<description>` - Urgent production fixes
- `docs/<description>` - Documentation updates
- `test/<description>` - Test additions/updates
- `refactor/<description>` - Code refactoring

### 2. Making Changes

#### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format .` to format code
- Run `flutter analyze` - it should return 0 issues
- Keep functions small and focused
- Add comments for complex logic
- Use meaningful variable and function names

#### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Aim for 80%+ code coverage on new code
- Run `flutter test` before committing

#### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Test additions/updates
- `chore`: Maintenance tasks

**Example**:
```
feat(auth): add Google Sign-In authentication

Implement OAuth authentication flow with Google credentials.
Users can now sign in with their Google account in addition
to email/password.

Closes #123

Co-Authored-By: Your Name <your.email@example.com>
```

### 3. Quality Checks

Before creating a PR, ensure:

```bash
# Format code
dart format .

# Run static analysis
flutter analyze
# Expected: No issues found

# Run tests
flutter test
# Expected: All tests pass

# Build for iOS (if on macOS)
flutter build ios --debug

# Run code generation (if you modified models)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Creating a Pull Request

1. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a PR via GitHub with:
   - Clear title describing the change
   - Detailed description of what you did and why
   - Reference related issues (e.g., "Closes #123")
   - Screenshots for UI changes (if applicable)

3. Fill out the PR template (see below)

### 5. PR Review Process

- At least one maintainer approval required
- All CI checks must pass
- Address review comments promptly
- Keep PRs focused and small (one feature/fix per PR)

### 6. After Merge

- Delete your branch from GitHub
- Sync your local master:
  ```bash
  git checkout master
  git pull upstream master
  ```

## Project-Specific Guidelines

### Architecture

Follow the existing Clean Architecture:

```
lib/
├── core/           # Shared utilities and constants
├── models/         # Data models (use Freezed)
├── repositories/   # Data access layer
├── providers/      # Riverpod state management
├── features/       # Feature modules
└── widgets/        # Shared widgets
```

### State Management

- Use Riverpod for all state management
- Prefer `AsyncValue` for async operations
- Use `ref.watch()` for reactive values
- Use `ref.read()` for callbacks
- Keep providers focused and testable

### Firebase Usage

- Always handle network errors
- Use transactions for multi-document updates
- Implement offline support where appropriate
- Test with Firebase Emulator locally

### Adding New Features

1. Create feature directory in `lib/features/`
2. Implement models in `lib/models/` (if needed)
3. Add repository in `lib/repositories/` (if needed)
4. Create provider in `lib/providers/`
5. Build UI screens and widgets
6. Write tests (unit + widget)
7. Update documentation

### UI Guidelines

- Japanese text for user-facing strings
- English text for code comments and variables
- Follow existing pixel-art retro game style
- Test on multiple screen sizes
- Ensure accessibility (contrast, text sizes)

## Testing Guidelines

### Unit Tests

Test in isolation with mocks:

```dart
void main() {
  group('MyService', () {
    test('should return result', () async {
      final service = MyService(mockClient);
      final result = await service.doSomething();
      expect(result, isNotEmpty);
    });
  });
}
```

### Widget Tests

Test user interactions and UI state:

```dart
void main() {
  testWidgets('should show loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProvider.overrideWithValue(mockValue),
        ],
        child: MyScreen(),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### Integration Tests

Test critical user flows with Firebase Emulator:

```dart
void main() {
  integrationTests('User flow', () {
    test('sign up and create quest', () async {
      // Full user flow test
    });
  });
}
```

## Questions?

- Check existing [Issues](https://github.com/original-org/diary-quest/issues)
- Start a [Discussion](https://github.com/original-org/diary-quest/discussions)
- Contact maintainers

## Recognition

Contributors will be acknowledged in the project credits. Thank you for making DiaryQuest better!

---

**Last Updated**: 2025-01-18
