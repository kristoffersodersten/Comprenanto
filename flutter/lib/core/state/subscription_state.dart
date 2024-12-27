import 'package:flutter/foundation.dart';
import '../models/subscription_status.dart';
import '../services/subscription_service.dart';
import '../services/analytics_service.dart';
import '../utils/logger.dart';

class SubscriptionState extends ChangeNotifier {
  final SubscriptionService _subscriptionService;
  final AnalyticsService _analyticsService;

  SubscriptionStatus? _status;
  bool _isLoading = false;
  String? _error;

  SubscriptionState(this._subscriptionService, this._analyticsService);

  SubscriptionStatus? get status => _status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSubscribed => _status?.isActive ?? false;
  bool get isTrialing => _status?.isTrialing ?? false;

  Future<void> checkStatus() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final oldStatus = _status;
      // Corrected method call to use SubscriptionBackend instead of SubscriptionService
      _status = await _subscriptionService.getBackendStatus();

      if (oldStatus != null &&
          _status != null &&
          oldStatus.status != _status!.status) {
        await _analyticsService.logSubscriptionStatusChange(
          oldStatus: oldStatus,
          newStatus: _status!,
        );
      }
    } catch (e) {
      _error = 'Failed to check subscription status';
      AppLogger.error(_error!, e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startTrial() async {
    try {
      // Corrected to not expect a return value from startTrial
      await _subscriptionService.startTrial();
      await _analyticsService.logTrialStarted();
      await checkStatus();
    } catch (e) {
      _error = 'Failed to start trial';
      AppLogger.error(_error!, e);
    }
  }

  Future<bool> subscribe() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _subscriptionService.subscribe();
      if (success) {
        await checkStatus();
      }
      return success;
    } catch (e) {
      _error = 'Failed to process subscription';
      AppLogger.error(_error!, e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
