# diaryquest

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Secrets Configuration

### Development Setup

For local development, create a `secrets/api-key.txt` file to store your OpenAI API key:

1. Get your API key from https://platform.openai.com/api-keys
2. Create `secrets/api-key.txt` and add your key (just the key, no extra text)

**Note**: The `secrets/` directory is ignored by Git and will not be committed.

### Production Configuration

In production, use environment variables or a secure secret manager:

```bash
flutter run --dart-define=OPENAI_API_KEY=your_key_here
```
