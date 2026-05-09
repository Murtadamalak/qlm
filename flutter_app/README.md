# E-Library & Printing Services (Flutter Web + Android)

This Flutter module delivers the customer and staff experience for the Electronic Library & Printing Services System. It is prepared to run as a responsive web app on phone browsers, tablets, laptops, and desktop computers, and it can still be extended for Android.

## Architecture Overview
- **Presentation**: Flutter screens + controllers (Provider) for UI state.
- **Domain**: Entities and repository interfaces.
- **Data**: Firebase implementations for Auth, Firestore, Storage, and Messaging.

```
lib/
  core/
  data/
  domain/
  presentation/
web/
  index.html
  404.html
  manifest.json
  firebase-messaging-sw.js
```

## Firebase Schema

### Collections
- `users/{userId}`
  - `phone_number`, `role`, `display_name`, `fcm_token`
- `orders/{orderId}`
  - print orders only
  - `customer_id`, `file_name`, `file_url`, `paper_size`, `is_color`, `copies`, `binding`, `price`, `status`, `created_at`
- `product_orders/{orderId}`
  - `customer_id`, `items[]`, `total_amount`, `status`, `created_at`
- `products/{productId}`
  - `name`, `description`, `price`, `image_url`, `is_active`
- `pricing_rules/{ruleId}`
  - `paper_size_base_price{size: price}`, `color_multiplier{color|bw: multiplier}`, `binding_price{binding: price}`
- `support_config/whatsapp`
  - `phone_number`
- `notifications/{notificationId}`
  - `user_id`, `title`, `body`, `data`, `created_at`

### Storage
- `print_jobs/{userId}/{timestamp}_{filename}`

## Run locally on web

> The app reads Firebase configuration from `--dart-define` values. This avoids committing Firebase project values directly into source code and works well for GitHub Pages secrets. See `firebase.dart_define.example` for the required keys.

```bash
cd flutter_app
flutter pub get
flutter run -d chrome \
  --dart-define=FIREBASE_API_KEY="YOUR_API_KEY" \
  --dart-define=FIREBASE_APP_ID="YOUR_WEB_APP_ID" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="YOUR_SENDER_ID" \
  --dart-define=FIREBASE_PROJECT_ID="YOUR_PROJECT_ID" \
  --dart-define=FIREBASE_AUTH_DOMAIN="YOUR_PROJECT.firebaseapp.com" \
  --dart-define=FIREBASE_STORAGE_BUCKET="YOUR_PROJECT.appspot.com" \
  --dart-define=FIREBASE_MEASUREMENT_ID="YOUR_MEASUREMENT_ID" \
  --dart-define=FIREBASE_WEB_VAPID_KEY="YOUR_OPTIONAL_WEB_PUSH_KEY"
```

## Build for GitHub Pages manually

Replace `REPOSITORY_NAME` with the GitHub repository name. For example, if your site URL is `https://username.github.io/qlm/`, use `/qlm/`.

```bash
cd flutter_app
flutter build web --release --base-href "/REPOSITORY_NAME/" \
  --dart-define=FIREBASE_API_KEY="YOUR_API_KEY" \
  --dart-define=FIREBASE_APP_ID="YOUR_WEB_APP_ID" \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID="YOUR_SENDER_ID" \
  --dart-define=FIREBASE_PROJECT_ID="YOUR_PROJECT_ID" \
  --dart-define=FIREBASE_AUTH_DOMAIN="YOUR_PROJECT.firebaseapp.com" \
  --dart-define=FIREBASE_STORAGE_BUCKET="YOUR_PROJECT.appspot.com" \
  --dart-define=FIREBASE_MEASUREMENT_ID="YOUR_MEASUREMENT_ID" \
  --dart-define=FIREBASE_WEB_VAPID_KEY="YOUR_OPTIONAL_WEB_PUSH_KEY"
```

Upload `flutter_app/build/web` to GitHub Pages, or use the included GitHub Actions workflow.

## Deploy automatically to GitHub Pages

The repository includes `.github/workflows/deploy-flutter-web.yml`. To use it:

1. In GitHub, open **Settings → Pages** and choose **GitHub Actions** as the Pages source.
2. In **Settings → Secrets and variables → Actions**, add these repository secrets:
   - `FIREBASE_API_KEY`
   - `FIREBASE_APP_ID`
   - `FIREBASE_MESSAGING_SENDER_ID`
   - `FIREBASE_PROJECT_ID`
   - `FIREBASE_AUTH_DOMAIN`
   - `FIREBASE_STORAGE_BUCKET`
   - `FIREBASE_MEASUREMENT_ID`
   - `FIREBASE_WEB_VAPID_KEY` (optional, needed for web push token generation)
3. Push to `work` or `main`, or run the workflow manually.
4. Add the final GitHub Pages domain to Firebase Authentication authorized domains, such as `username.github.io`.

## Firebase setup checklist for web

- Enable **Phone** sign-in provider in Firebase Authentication.
- Add your GitHub Pages domain under **Authentication → Settings → Authorized domains**.
- Create at least one document in `pricing_rules` before accepting print jobs.
- Create `support_config/whatsapp` with a `phone_number` field.
- Configure Firestore and Storage rules so customers only access their own orders/files and admins can manage all resources.

## Arabic quick start / تشغيل سريع بالعربي

1. ثبّت Flutter وشغّل `flutter doctor`.
2. افتح مجلد التطبيق: `cd flutter_app`.
3. نزّل الحزم: `flutter pub get`.
4. شغّل على كروم باستعمال قيم Firebase من مشروعك:
   `flutter run -d chrome --dart-define=FIREBASE_API_KEY=... --dart-define=FIREBASE_APP_ID=...` مع باقي القيم المذكورة أعلاه.
5. للرفع على GitHub Pages، أضف أسرار Firebase في GitHub Secrets ثم فعّل Pages من GitHub Actions.

## Payments
- Current flow is **Cash on Delivery** only. A payment abstraction can be added later to integrate online payments.
