import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_info.dart';

class PaymentService {
  static const String _paymentInfoKey = 'payment_info';

  static Future<void> savePaymentInfo(PaymentInfo paymentInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final paymentInfoJson = jsonEncode(paymentInfo.toJson());
    await prefs.setString(_paymentInfoKey, paymentInfoJson);
  }

  static Future<PaymentInfo?> loadPaymentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentInfoJson = prefs.getString(_paymentInfoKey);
    if (paymentInfoJson != null) {
      final paymentInfoMap = jsonDecode(paymentInfoJson);
      return PaymentInfo.fromJson(paymentInfoMap);
    }
    return null;
  }

  static Future<void> clearPaymentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_paymentInfoKey);
  }
}
