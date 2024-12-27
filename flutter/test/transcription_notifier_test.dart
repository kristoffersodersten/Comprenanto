import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/notifiers/transcription_notifier.dart'; // Ensure this path is correct

class MockTranscriptionNotifier extends Mock implements TranscriptionNotifier {
  String someMethod() {
    return 'testValue';
  }
}

void main() {
  test('TranscriptionNotifier test', () {
    final notifier = MockTranscriptionNotifier();
    final someValue = 'testValue'; // Define someValue
    when(notifier.someMethod()).thenReturn(someValue);
    expect(notifier.someMethod(), someValue);

    // Add your test logic here
  });
}
