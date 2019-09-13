import 'dart:async';
import 'package:flutter/services.dart';

class StripeSource {
  static const MethodChannel _channel = const MethodChannel('stripe_payment');

  static bool _publishableKeySet = false;
  static String merchantIdentifier = "";

  static bool get ready => _publishableKeySet;
  static bool get nativePayReady => merchantIdentifier.isNotEmpty;

  static void setPublishableKey(String apiKey) {
    _channel.invokeMethod('setPublishableKey', apiKey);
    _publishableKeySet = true;
  }

  static void setMerchantIdentifier(String identifier) {
    _channel.invokeMethod('setMerchantIdentifier', identifier);
    merchantIdentifier = identifier;
  }

  static Future<String> addSource() async {
    final String token = await _channel.invokeMethod('addSource');
    return token;
  }

  static Future<String> useNativePay() async {
    final String nativeToken = await _channel.invokeMethod('nativePay');
    return nativeToken;
  }

}