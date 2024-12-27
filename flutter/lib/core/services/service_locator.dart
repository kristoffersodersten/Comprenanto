import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_service.dart';
import 'transcription_service.dart';
import 'translation_service.dart';
import 'middleware_service.dart';
import 'theme_service.dart';
import 'storage_service.dart';
import 'subscription_service.dart';
import 'receipt_manager.dart';
import 'subscription_backend.dart';
import 'purchase_verifier.dart';
import 'notification_service.dart';
import 'analytics_service.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static late final SubscriptionService subscriptionService;
  static late final ReceiptManager receiptManager;
  static late final SubscriptionBackend subscriptionBackend;

  static Future<void> setup() async {
    // Register SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register services
    getIt.registerSingleton<AudioService>(AudioService());
    getIt.registerSingleton<TranscriptionService>(TranscriptionService());
    getIt.registerSingleton<TranslationService>(TranslationService());
    getIt.registerSingleton<MiddlewareService>(MiddlewareService());
    getIt.registerSingleton<ThemeService>(ThemeService());
    getIt.registerSingleton<StorageService>(StorageService());
    getIt.registerSingleton<SubscriptionService>(SubscriptionService());
    getIt.registerSingleton<ReceiptManager>(ReceiptManager());
    getIt.registerSingleton<SubscriptionBackend>(SubscriptionBackend());
    getIt.registerSingleton<PurchaseVerifier>(PurchaseVerifier());
    getIt.registerSingleton<NotificationService>(NotificationService());
    getIt.registerSingleton<AnalyticsService>(AnalyticsService());

    // Initialize services that require setup
    subscriptionService = getIt<SubscriptionService>();
    receiptManager = getIt<ReceiptManager>();
    subscriptionBackend = getIt<SubscriptionBackend>();

    await subscriptionService.initialize();
    await receiptManager.initialize();
    await subscriptionBackend.initialize();
  }
}
