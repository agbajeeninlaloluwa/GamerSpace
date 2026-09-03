
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';

class RevenueCatService {
  static const entitlementId = 'pro';

  Future<void> init() async {
    // TODO: Replace with your RevenueCat API keys from app.revenuecat.com
    // Android: goog_...
    // iOS: appl_...
    String apiKey = Platform.isAndroid 
      ? 'goog_YOUR_ANDROID_KEY' 
      : 'appl_YOUR_IOS_KEY';

    if (apiKey.contains('YOUR_')) {
      print('⚠️ RevenueCat: Using placeholder key. Add real keys before store submission!');
      return;
    }

    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration config = PurchasesConfiguration(apiKey);
    await Purchases.configure(config);
  }

  Future<bool> isPro() async {
    try {
      CustomerInfo info = await Purchases.getCustomerInfo();
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (_) {
      return false; // Allow dev without keys
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print('RevenueCat offerings error: $e');
      return null;
    }
  }

  Future<bool> purchase(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
final CustomerInfo info = purchaseResult.customerInfo;
      return info.entitlements.all[entitlementId]?.isActive ?? false;
    } catch (e) {
      print('Purchase error: $e');
      return false;
    }
  }

  Future<void> restore() async {
    await Purchases.restorePurchases();
  }
}

