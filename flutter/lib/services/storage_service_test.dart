import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/storage_service.dart'; // Ensure this path is correct

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late StorageService storageService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = StorageService(mockPrefs);
  });

  group('StorageService', () {
    test('saves string data', () async {
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      final result = await storageService.saveData('key', 'value');

      expect(result, true);
      verify(mockPrefs.setString('key', 'value')).called(1);
    });

    test('retrieves string data', () {
      when(mockPrefs.getString(any)).thenReturn('value');

      final result = storageService.getData<String>('key');

      expect(result, 'value');
      verify(mockPrefs.getString('key')).called(1);
    });
  });
}
