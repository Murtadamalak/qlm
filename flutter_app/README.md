# E-Library & Printing Services (Flutter)

This Flutter module delivers the mobile experience for the Electronic Library & Printing Services System. It follows a clean architecture with separation of presentation, domain, and data layers.

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
```

## Firebase Schema

### Collections
- `users/{userId}`
  - `phone_number`, `role`, `display_name`
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

### Storage
- `print_jobs/{userId}/{timestamp}_{filename}`

## Setup Notes
- Run `flutterfire configure` to generate `firebase_options.dart`. The app expects Firebase options via `FirebaseOptionsLoader`.
- Configure pricing rules and WhatsApp support number in Firestore before running.

## Payments
- Current flow is **Cash on Delivery** only. A payment abstraction can be added later to integrate online payments.
