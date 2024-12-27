import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../notifiers/transcription_notifier.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core Services
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(),
  );

  // Notifiers
  serviceLocator.registerLazySingleton<TranscriptionNotifier>(
    () => TranscriptionNotifier(serviceLocator<ApiService>()),
  );
}
