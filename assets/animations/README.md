# Animation Assets

This directory requires Lottie JSON animation files.

## Required Animations

### 1. Level Up Animation (`level_up.json`)
- **Description**: Base/Home evolution celebration animation
- **Trigger**: When user levels up (baseLevel increases)
- **Duration**: ~2-3 seconds
- **Style**: RPG-style level up effects with sparkles and glow
- **Used by**: `lib/widgets/base_levelup_dialog.dart`

### 2. Skill Unlock Animation (`skill_unlock.json`)
- **Description**: New skill unlock celebration
- **Trigger**: When user earns enough XP to unlock a new skill
- **Duration**: ~2 seconds
- **Style**: Book or scroll opening with magical effects
- **Used by**: `lib/widgets/skill_unlock_dialog.dart`

### 3. Job Unlock Animation (`job_unlock.json`)
- **Description**: New job/class unlock celebration
- **Trigger**: When user meets requirements for a new job
- **Duration**: ~2-3 seconds
- **Style**: Badge or shield reveal with grand effects
- **Used by**: `lib/widgets/job_unlock_dialog.dart`

## Placeholder Status

Currently using placeholder containers. To add real animations:

1. Download or create Lottie JSON files
2. Place them in this directory with the names above
3. The dialogs will automatically load and display them

## Resources

- Lottie Files: https://lottiefiles.com/
- Create custom: https://lottiefiles.com/create
- Flutter Lottie package: https://pub.dev/packages/lottie

## Current Implementation

The animation dialogs are implemented in:
- `lib/widgets/base_levelup_dialog.dart`
- `lib/widgets/skill_unlock_dialog.dart`
- `lib/widgets/job_unlock_dialog.dart`

They use `Lottie.asset()` to load animations from this directory.
