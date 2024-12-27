import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    await dotenv.load();
  });

  test('environment variables are loaded correctly', () {
    expect(dotenv.env['API_BASE_URL'], isNotNull);
    expect(dotenv.env['API_VERSION'], isNotNull);
  });
}
