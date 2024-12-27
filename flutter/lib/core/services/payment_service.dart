import 'package:flutter/material.dart'; // Correct import for ThemeMode
import '../models/payment_intent.dart';
import '../models/app_error.dart';
import '../utils/logger.dart';
import 'stripe_backend_service.dart';

class PaymentService {
  final StripeBackendService _stripeBackend;

  PaymentService(this._stripeBackend);

  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
  }) async {
    try {
      // Create payment intent
      final paymentIntent = await _stripeBackend.createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      // Configure payment sheet
      await _initPaymentSheet(paymentIntent.clientSecret);

      // Present payment sheet
      await _presentPaymentSheet();

      // Verify payment
      final success = await _stripeBackend.verifySubscription(
        paymentIntent.id,
      );

      if (!success) {
        throw AppError(
          title: 'Payment Verification Failed',
          message: 'Unable to verify your payment. Please contact support.',
        );
      }

      return PaymentResult(
        success: true,
        paymentIntentId: paymentIntent.id,
      );
    } catch (e) {
      AppLogger.error('Payment processing failed', e);
      return PaymentResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _initPaymentSheet(String clientSecret) async {
    // Check if Stripe is available
    if (Stripe.instance == null) {
      throw AppError(
        title: 'Stripe Initialization Failed',
        message: 'Stripe is not available. Please check your setup.',
      );
    }

    await Stripe.instance!.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Voice Translator',
        style: ThemeMode.system,
      ),
    );
  }

  Future<void> _presentPaymentSheet() async {
    // Check if Stripe is available
    if (Stripe.instance == null) {
      throw AppError(
        title: 'Stripe Presentation Failed',
        message: 'Stripe is not available. Please check your setup.',
      );
    }

    await Stripe.instance!.presentPaymentSheet();
  }
}

class PaymentResult {
  final bool success;
  final String? paymentIntentId;
  final String? error;

  const PaymentResult({
    required this.success,
    this.paymentIntentId,
    this.error,
  });
}
