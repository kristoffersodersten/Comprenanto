import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/subscription_status.dart';
import '../utils/logger.dart';

class NotificationService {
  static const _subscriptionChannelId = 'subscription_notifications';
  static const _subscriptionChannelName = 'Subscription Notifications';
  static const _subscriptionChannelDescription =
      'Notifications related to subscription status';

  final FlutterLocalNotificationsPlugin _notifications;

  NotificationService() : _notifications = FlutterLocalNotificationsPlugin() {
    _initialize();
  }

  Future<void> _initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _subscriptionChannelId,
      _subscriptionChannelName,
      description: _subscriptionChannelDescription,
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showSubscriptionExpiringNotification(
    SubscriptionStatus status,
  ) async {
    if (!status.needsRenewal) return;

    try {
      await _notifications.show(
        1, // Unique ID for this notification
        'Subscription Expiring Soon',
        'Your premium subscription will expire in ${_getDaysRemaining(status)} days. '
            'Renew now to maintain uninterrupted access.',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _subscriptionChannelId,
            _subscriptionChannelName,
            channelDescription: _subscriptionChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      AppLogger.error('Failed to show subscription notification', e);
    }
  }

  Future<void> showTrialEndingNotification(
    SubscriptionStatus status,
  ) async {
    if (!status.isTrialing) return;

    final daysLeft = _getDaysRemaining(status);
    if (daysLeft > 1) return;

    try {
      await _notifications.show(
        2, // Unique ID for trial notifications
        'Trial Ending Soon',
        'Your free trial will end ${daysLeft == 0 ? 'today' : 'tomorrow'}. '
            'Subscribe now to continue enjoying premium features.',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _subscriptionChannelId,
            _subscriptionChannelName,
            channelDescription: _subscriptionChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      AppLogger.error('Failed to show trial notification', e);
    }
  }

  int _getDaysRemaining(SubscriptionStatus status) {
    final endDate =
        status.isTrialing ? status.trialEndDate : status.subscriptionEndDate;

    if (endDate == null) return 0;

    return endDate.difference(DateTime.now()).inDays;
  }
}
