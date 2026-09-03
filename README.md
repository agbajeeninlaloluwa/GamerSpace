
# GamerSpace - RevenueCat Shipaton 2026

Gaming bucket list app for Influencer Gaming Award.

## Quick Start (Windows)
1. Create AVD with API 35 (not 37) in Android Studio > Virtual Device Manager
2. flutter create gamerspace --org com.gamerspace.app
3. Copy these lib/ files into the new project
4. flutter pub get
5. flutter run

## RevenueCat Setup (Required for submission)
1. Create account at app.revenuecat.com
2. Add App > Android > com.gamerspace.app
3. Create Entitlement: pro
4. Create Product: gamerspace_pro_monthly, gamerspace_pro_yearly (create in Play Console first)
5. Create Offering: default with monthly + yearly packages
6. Copy API key goog_... into lib/services/revenuecat_service.dart
7. Add <uses-permission android:name="android.permission.INTERNET"/> already there

## RAWG API
1. Get free key at rawg.io/apidocs
2. Replace YOUR_RAWG_KEY in providers/backlog_provider.dart

## Monetization Strategy for Judges
- Free: 50 games limit, rewarded ad to unlock AI suggestion (Catvertising)
- Pro: Unlimited, stats, themes, no ads
- Use OneSignal: send push when user hasn't opened 3 days: "You have 12 games in Want to Play"

## Store Submission Checklist
- Icon 1024x1024
- Screenshot 1179x2556
- 2 min video
- Promo code: create in RevenueCat > Customer Center or make free trial entitlement
