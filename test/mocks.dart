import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock implementations for testing
class MockNavigatorProvider extends Mock {
  static final mockInstance = MockNavigatorProvider();
}

class MockUserProvider extends Mock {
  static final mockInstance = MockUserProvider();
}

class MockQuestProvider extends Mock {
  static final mockInstance = MockQuestProvider();
}

// Mock Firebase services
class MockFirebaseAuth extends Mock {
  static final mockInstance = MockFirebaseAuth();
}

class MockFirestore extends Mock {
  static final mockInstance = MockFirestore();
}