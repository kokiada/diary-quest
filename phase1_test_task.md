# Comprehensive Test Suite Task

## Objective
Build comprehensive test suite with 80%+ code coverage.

## Required Actions

### Unit Tests (80% coverage target)
1. **Service Tests**
   - `lib/core/services/openai_service_test.dart`
     - Test quest analysis functionality
     - Test error handling
     - Test different navigator personalities
   - `lib/core/services/speech_service_test.dart`
     - Test speech recognition
     - Test error handling
   - `lib/core/services/auth_service_test.dart`
     - Test login/logout
     - Test user registration
     - Test error handling

2. **Repository Tests**
   - `lib/repositories/user_repository_test.dart`
     - Test user data operations
     - Test cache invalidation
   - `lib/repositories/quest_repository_test.dart`
     - Test quest CRUD operations
     - Test pagination

3. **Provider Tests**
   - `lib/providers/user_provider_test.dart`
     - Test XP calculation
     - Test unlock detection
     - Test state transitions
   - `lib/providers/quest_provider_test.dart`
     - Test quest analysis state
     - Test error states
   - `lib/providers/auth_provider_test.dart`
     - Test auth state changes
     - Test user loading

### Widget Tests (20% coverage target)
1. **Screen Tests**
   - `test/features/auth/login_screen_test.dart`
   - `test/features/home/home_screen_test.dart`
   - `test/features/quest/quest_screen_test.dart`
   - `test/features/settings/settings_screen_test.dart`

2. **Widget Tests**
   - `test/widgets/base_levelup_dialog_test.dart`
   - `test/widgets/quest_card_test.dart`
   - `test/widgets/parameter_display_test.dart`

### Integration Tests
- `test/integration/quest_flow_test.dart`
- `test/integration/auth_flow_test.dart`

## Deliverables
- Complete test suite with 80%+ coverage
- Test configuration files
- Coverage report
- Testing documentation