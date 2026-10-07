# SewSmart API contract

Draft 2, 7 October 2026. The 36 admin panel endpoints and the 50 mobile endpoints that were missing are designed in full. The 29 mobile endpoints that the app already named are listed, and their request and response details still have to be written.

This file is the agreement between the Flutter apps and the backend. Every endpoint below has a matching `// TODO: METHOD /path` comment above the service method that will call it. To change an endpoint, change this file and that comment in the same pull request.

## Contents

1. [Conventions](#1-conventions)
2. [Values](#2-values)
3. [Mobile app endpoints](#3-mobile-app-endpoints)
4. [Admin panel endpoints](#4-admin-panel-endpoints)
5. [Not designed yet](#5-not-designed-yet)
6. [Decisions to confirm](#6-decisions-to-confirm)

## 1. Conventions

| Topic | Rule |
| --- | --- |
| Base path | `/api`. Admin routes sit under `/api/admin`. |
| Format | JSON request and response bodies. An endpoint that takes a file uses `multipart/form-data` and says so. |
| Field names | snake_case, for example `created_at`, `is_verified`, `total_orders`. The mobile models already read these names. |
| IDs | Every object has a string `id`. Do not return MongoDB's `_id`. Orders, payments and disputes show their ID to people, so give them short readable IDs such as `ORD-1042`. |
| Dates | ISO 8601 in UTC, for example `2024-06-01T09:30:00.000Z`. |
| Money | Plain numbers in PKR. No currency symbol and no separators. |
| Values | Status, role and method values are lower camelCase and listed in section 2. The mobile app parses them with `values.byName`, which throws on any other spelling. |
| Lists | A JSON array, newest first unless the endpoint says otherwise. Filters are optional query parameters. Leave one out to get everything. |
| Authentication | `Authorization: Bearer <token>` on every route except login, register, OTP and forgot password. Admin routes need an admin token. |
| Success | `200` with the object or array, `201` when something is created, `204` with no body when there is nothing to return, such as delete and logout. An action such as approve, cancel or resolve returns the updated object. |
| Errors | The status code plus `{ "message": "..." }`. `400` invalid input, `401` missing or expired token or wrong credentials, `403` wrong role, `404` not found, `409` not allowed in the current state. |

## 2. Values

The API always sends and accepts the values in the middle column. The admin panel shows them as labels. Its mock data holds the labels today, so the conversion belongs in the admin models' `fromJson` when the screens are connected. The mobile screens also hold labels such as Bank Account and Cash on Delivery, and convert the same way.

| Field | API values | Admin panel label |
| --- | --- | --- |
| `role` | `customer`, `tailor`, `rider` | Same word, capitalised |
| Account `status` | `active`, `suspended` | Same word, capitalised |
| Verification `status` | `pending`, `approved`, `rejected` | Same word, capitalised |
| Order `status` | `pending`, `accepted`, `rejected`, `inProgress`, `qualityCheck`, `readyForDelivery`, `delivered`, `completed`, `cancelled` | Four tabs, see the next table |
| Payment `status` | `pending`, `completed`, `failed`, `refunded` | `pending` is Processing, `completed` is Paid, `refunded` is Refunded. `failed` has no label yet. |
| Payment `method` | `jazzCash`, `easyPaisa`, `bank`, `card` | JazzCash, EasyPaisa, Bank, Card |
| Dispute `status` | `open`, `resolved` | Same word, capitalised |
| Dispute `resolution` | `refund`, `warning`, `dismiss` | Same word, capitalised |
| Design `status`, also a portfolio sample | `active`, `flagged` | Same word, capitalised |
| Review `status` | `published`, `flagged` | Same word, capitalised |
| Content report `status` | `pending`, `resolved` | Same word, capitalised |
| Content report `action` | `remove`, `warn`, `dismiss` | Remove Content, Issue Warning, Dismiss Report |
| Report `range` | `today`, `thisWeek`, `thisMonth`, `custom` | Today, This Week, This Month, Custom |
| Saved payment method `type` | `jazzCash`, `easyPaisa`, `bank`, `card`, `cashOnDelivery` | Not shown in the admin panel |
| Payout account `type` | `jazzCash`, `easyPaisa`, `bank` | Not shown in the admin panel |
| Withdrawal `status` | `pending`, `paid`, `failed` | Not shown in the admin panel |
| Message `type` | `text`, `image`, `document` | Not shown in the admin panel |
| Stream `status` | `live`, `ended` | Not shown in the admin panel |
| Measurement `unit` | `cm`, `in` | Not shown in the admin panel |
| Notification `type` | `order`, `payment`, `chat`, `delivery`, `new_order`, `message`, `verified`, `pickup_assigned`, `delivery_confirmed`, `issue_resolved` | Not shown in the admin panel |

Notification types are the one exception to the camelCase rule. The three notification screens already compare these exact strings to pick an icon, and an unknown type gets a default icon. The customer screen expects `chat` for a new message and the tailor screen expects `message`.

The admin Orders screen has four tabs for the nine order statuses. The grouping follows how the customer app already splits active and finished orders.

| Admin tab | Order statuses |
| --- | --- |
| Pending | `pending` |
| In Progress | `accepted`, `inProgress`, `qualityCheck`, `readyForDelivery` |
| Completed | `delivered`, `completed` |
| Cancelled | `rejected`, `cancelled` |

## 3. Mobile app endpoints

The mobile app needs 79 endpoints. The service files already named 29 of them as TODO comments. The other 50 were added on 7 October 2026 for the features that had no endpoint at all. Each new one is a mock-backed method with its endpoint as a TODO comment. No screen calls the new methods yet.

A user keeps one ID across the app. The tailor `T001` in `/api/tailors/T001` is the user `T001`, and the same holds for riders.

### 3.1 Endpoints the app already named

Their methods and paths are fixed by the app. Response fields are fixed only where a model has `fromJson`. Their request and response details still have to be written here.

#### Auth

Service: `lib/core/services/auth_service.dart`

| Endpoint | Service method | Purpose |
| --- | --- | --- |
| `POST /api/auth/login` | `login` | Sign in with email and password. Returns a token and the user. |
| `POST /api/auth/register` | `register` | Create a customer, tailor or rider account. |
| `POST /api/auth/send-otp` | `sendOtp` | Send a 4-digit code to a phone number. |
| `POST /api/auth/verify-otp` | `verifyOtp` | Check the code. |
| `POST /api/auth/forgot-password` | `forgotPassword` | Email a password reset link. |
| `POST /api/auth/logout` | `logout` | End the session. |

#### Customer

Service: `lib/modules/customer/services/customer_service.dart`

| Endpoint | Service method | Purpose |
| --- | --- | --- |
| `GET /api/tailors?category=&city=&rating=&price=` | `getTailors` | Search and filter tailors. |
| `GET /api/tailors/:id` | `getTailorById` | One tailor's public profile. |
| `GET /api/orders?customerId=` | `getMyOrders` | The customer's orders. |
| `POST /api/orders` | `placeOrder` | Place an order. |
| `PUT /api/orders/:id/delivery-schedule` | `setDeliverySchedule` | Choose pickup and delivery dates and time slots. |
| `POST /api/payments` | `makePayment` | Pay for an order. |
| `POST /api/reviews` | `submitReview` | Rate a tailor. |
| `GET /api/notifications?userId=` | `getNotifications` | The user's notifications. |
| `GET /api/garments/pricing` | `getGarmentPricing` | Garment price list. |

#### Tailor

Service: `lib/modules/tailor/services/tailor_service.dart`

| Endpoint | Service method | Purpose |
| --- | --- | --- |
| `GET /api/orders?tailorId=&status=` | `getOrders` | The tailor's orders, optionally by status. |
| `PUT /api/orders/:id/accept` | `acceptOrder` | Accept a pending order. |
| `PUT /api/orders/:id/reject` | `rejectOrder` | Reject a pending order. |
| `PUT /api/orders/:id/status` | `updateOrderStatus` | Move an order to its next status. |
| `POST /api/orders/:id/delivery-request` | `sendDeliveryRequest` | Ask the customer to schedule delivery. |
| `GET /api/tailors/:id/earnings` | `getEarnings` | Earnings totals and monthly chart. |
| `POST /api/riders` | `addRider` | Add a rider under the tailor. |
| `PUT /api/riders/:id/verify-pickup` | `verifyRiderPickup` | Confirm the rider who collects an order. |

#### Rider

Service: `lib/modules/rider/services/rider_service.dart`

| Endpoint | Service method | Purpose |
| --- | --- | --- |
| `GET /api/riders/:id/deliveries` | `getAssignedDeliveries` | Deliveries assigned to the rider. |
| `PUT /api/deliveries/:id/verify-pickup` | `verifyPickup` | Verify pickup with the tailor's code. |
| `POST /api/deliveries/:id/proof` | `uploadDeliveryProof` | Upload a delivery proof photo. |
| `PUT /api/deliveries/:id/verify-customer-slip` | `verifyCustomerSlip` | Close the delivery with the code on the customer's slip. |
| `POST /api/deliveries/:id/report-issue` | `reportIssue` | Report a problem with a delivery. |
| `GET /api/riders/:id/earnings` | `getEarnings` | Earnings totals and delivery counts. |

### 3.2 Endpoints added by this contract

Three services are new and sit in `lib/core/services/` because more than one role uses them: `NotificationService`, `ChatService` and `PayoutService`.

| Endpoint | Service method | Screen that needs it |
| --- | --- | --- |
| `POST /api/auth/reset-password` | `AuthService.resetPassword` | None yet |
| `GET /api/users/me` | `AuthService.getProfile` | Customer profile, rider profile |
| `PUT /api/users/me` | `AuthService.updateProfile` | Customer profile, rider profile |
| `PUT /api/tailors/:id` | `TailorService.updateProfile` | Tailor profile |
| `GET /api/tailors/:id/portfolio` | `TailorService.getPortfolio` | Tailor profile |
| `POST /api/tailors/:id/portfolio` | `TailorService.addPortfolioSample` | Tailor profile |
| `DELETE /api/tailors/:id/portfolio/:itemId` | `TailorService.removePortfolioSample` | Tailor profile |
| `GET /api/tailors/:id/garments` | `TailorService.getGarments`, `CustomerService.getTailorGarments` | Tailor profile, place order, tailor public profile |
| `POST /api/tailors/:id/garments` | `TailorService.addGarment` | Tailor profile |
| `PUT /api/tailors/:id/garments/:garmentId` | `TailorService.updateGarment` | Tailor profile |
| `DELETE /api/tailors/:id/garments/:garmentId` | `TailorService.removeGarment` | Tailor profile |
| `GET /api/tailors/:id/reviews` | `CustomerService.getTailorReviews` | Tailor public profile |
| `GET /api/categories` | `CustomerService.getCategories` | Browse tailors |
| `POST /api/coupons/validate` | `CustomerService.validateCoupon` | Place order |
| `GET /api/measurements` | `CustomerService.getMeasurements` | Measure |
| `PUT /api/measurements` | `CustomerService.saveMeasurements` | Measure |
| `GET /api/payment-methods` | `CustomerService.getPaymentMethods` | Payment methods |
| `POST /api/payment-methods` | `CustomerService.addPaymentMethod` | Payment methods |
| `PUT /api/payment-methods/:id/default` | `CustomerService.setDefaultPaymentMethod` | Payment methods |
| `DELETE /api/payment-methods/:id` | `CustomerService.removePaymentMethod` | Payment methods |
| `GET /api/wishlist` | `CustomerService.getWishlist` | Customer profile |
| `POST /api/wishlist` | `CustomerService.addToWishlist` | AI recommendations |
| `DELETE /api/wishlist/:designId` | `CustomerService.removeFromWishlist` | None yet |
| `POST /api/searches` | `CustomerService.recordSearch` | AI recommendations, browse tailors |
| `GET /api/searches` | `CustomerService.getMySearches` | AI recommendations |
| `GET /api/searches/trending` | `CustomerService.getTrendingSearches` | AI recommendations |
| `GET /api/ai/recommendations` | `CustomerService.getRecommendations` | AI recommendations |
| `POST /api/ai/designs` | `CustomerService.generateDesigns` | AI design studio |
| `POST /api/ai/designs/:id/send` | `CustomerService.sendDesignToTailor` | AI design studio |
| `POST /api/ai/try-on` | `CustomerService.generateTryOn` | Virtual try-on |
| `PUT /api/ai/try-on/:id/save` | `CustomerService.saveTryOn` | Virtual try-on |
| `GET /api/payout-accounts` | `PayoutService.getPayoutAccounts` | Tailor payment, rider payment |
| `POST /api/payout-accounts` | `PayoutService.addPayoutAccount` | Tailor payment, rider payment |
| `PUT /api/payout-accounts/:id/default` | `PayoutService.setDefaultPayoutAccount` | Tailor payment, rider payment |
| `DELETE /api/payout-accounts/:id` | `PayoutService.removePayoutAccount` | Tailor payment, rider payment |
| `GET /api/withdrawals` | `PayoutService.getWithdrawals` | Tailor payment |
| `POST /api/withdrawals` | `PayoutService.requestWithdrawal` | Tailor earnings, rider earnings, live stream |
| `GET /api/conversations` | `ChatService.getConversations` | Chat tab for customers and tailors |
| `GET /api/orders/:id/messages` | `ChatService.getMessages` | Chat |
| `POST /api/orders/:id/messages` | `ChatService.sendMessage` | Chat |
| `PUT /api/orders/:id/messages/read` | `ChatService.markMessagesRead` | Chat |
| `PUT /api/notifications/:id/read` | `NotificationService.markRead` | Tailor notifications, rider notifications |
| `PUT /api/notifications/read-all` | `NotificationService.markAllRead` | All three notification screens |
| `GET /api/riders/:id` | `RiderService.getProfile` | Rider profile |
| `PUT /api/riders/:id/availability` | `RiderService.setAvailability` | Rider dashboard |
| `POST /api/streams` | `TailorService.startStream` | Live stream |
| `GET /api/streams/:id` | `TailorService.getStream` | Live stream |
| `GET /api/streams/:id/messages` | `TailorService.getStreamMessages` | Live stream |
| `PUT /api/streams/:id/pin` | `TailorService.pinStreamItem` | Live stream |
| `PUT /api/streams/:id/end` | `TailorService.endStream` | Live stream |

### 3.3 Account

**`GET /api/users/me`**

Returns the signed-in user, the same object that login returns.

```json
{
  "id": "C001",
  "name": "Ayesha Khan",
  "email": "ayesha@email.com",
  "phone": "0300-1234567",
  "role": "customer",
  "is_verified": true,
  "avatar": null,
  "city": "Lahore",
  "created_at": "2025-01-15T00:00:00.000Z"
}
```

**`PUT /api/users/me`**

Send any of `name`, `phone` and `city`. Returns the updated user. `400` when `name` is empty and `409` when the phone number belongs to another account. The edit dialog has only name and phone today.

```json
{
  "name": "Ayesha Khan",
  "phone": "0300-1234567"
}
```

**`POST /api/auth/reset-password`**

```json
{
  "token": "token-from-the-reset-link",
  "new_password": "new-password"
}
```

Returns `204`. `400` when the token is wrong or older than 15 minutes, or the password is shorter than 4 characters, which is the rule the register screen applies. The app has no screen for this step, so the link in the email must open a page or a screen that makes this call.

### 3.4 Tailor profile, portfolio and price list

Only the tailor who owns the profile may change it. Any other token gets `403`.

**`PUT /api/tailors/:id`**

Send any of these fields. Returns the tailor object from `GET /api/tailors/:id`, which now also carries `experience_years`.

```json
{
  "name": "Sana's Couture",
  "phone": "0302-3456789",
  "city": "Lahore",
  "experience_years": 8,
  "bio": "Expert in bridal and formal wear with 8+ years of experience."
}
```

`name` is the business name. `phone` is stored on the user account.

**`GET /api/tailors/:id/portfolio`**

```json
[
  {
    "id": "PF001",
    "tailor_id": "T001",
    "title": "Royal Bridal Lehenga",
    "image_url": "https://example.com/uploads/portfolio/pf001.jpg",
    "status": "active",
    "created_at": "2026-05-01T00:00:00.000Z"
  }
]
```

These are the items the admin panel lists as designs. The `portfolio` field inside the tailor object stays a plain array of the `image_url` values, because `TailorModel` reads it that way.

**`POST /api/tailors/:id/portfolio`**

Multipart form data with `image` as the file and an optional `title`. Returns `201` with the new item.

**`DELETE /api/tailors/:id/portfolio/:itemId`**

Returns `204`.

**`GET /api/tailors/:id/garments`**

The tailor's own price list. Anyone signed in may read it.

```json
[
  {
    "id": "G001",
    "garment": "Shalwar Kameez",
    "price": 1800,
    "estimated_time": "3-4 days"
  }
]
```

**`POST /api/tailors/:id/garments`**

```json
{
  "garment": "Abaya",
  "price": 2800,
  "estimated_time": "4-5 days"
}
```

Returns `201` with the new item.

**`PUT /api/tailors/:id/garments/:garmentId`**

Send any of the three fields. Returns the updated item.

**`DELETE /api/tailors/:id/garments/:garmentId`**

Returns `204`.

**`GET /api/tailors/:id/reviews`**

The tailor's published reviews, newest first.

```json
[
  {
    "id": "REV001",
    "customer_id": "C001",
    "tailor_id": "T001",
    "customer_name": "Ayesha K.",
    "comment": "Amazing bridal work! Exactly as I imagined.",
    "rating": 5,
    "created_at": "2026-09-23T10:00:00.000Z"
  }
]
```

### 3.5 Coupons

**`POST /api/coupons/validate`**

```json
{
  "code": "EID20",
  "amount": 5000,
  "tailor_id": "T001"
}
```

Response `200`:

```json
{
  "code": "EID20",
  "valid": true,
  "discount_percent": 20,
  "discount_amount": 1000,
  "message": "20% discount applied!"
}
```

An unknown or expired code also returns `200`, with `valid` false, both discounts 0 and a message to show.

When the order is placed, send the code as `coupon_code` in `POST /api/orders`. `placeOrder` has an optional `couponCode` parameter for it. The server works out the discount again and never trusts the amount the app sends. Nothing in the admin panel creates coupons, so they start as seed data.

### 3.6 Saved measurements

One set per customer.

**`GET /api/measurements`**

```json
{
  "unit": "cm",
  "height": 165,
  "weight": 60,
  "chest": 36,
  "waist": 30,
  "hips": 38,
  "shoulder": 15,
  "arm_length": 24,
  "inseam": 28,
  "neck": 14,
  "wrist": 6,
  "updated_at": "2026-10-01T09:30:00.000Z"
}
```

`404` when the customer has saved nothing yet. `weight` is always in kilograms. The other nine values are in `unit`.

**`PUT /api/measurements`**

Send the same fields without `updated_at`. Creates the set the first time and replaces it afterwards. Returns the saved set.

These measurements are separate from an order. The place order screen still sends its own five values, in inches, as one string.

### 3.7 Saved payment methods

**`GET /api/payment-methods`**

```json
[
  {
    "id": "PM001",
    "type": "jazzCash",
    "detail": "0301-2345678",
    "account_name": "Ayesha Khan",
    "is_default": true
  }
]
```

`detail` is the text the list shows: the wallet or bank account number, the last four digits of a card, and an empty string for cash on delivery.

**`POST /api/payment-methods`**

```json
{
  "type": "easyPaisa",
  "account_number": "0345-1112223",
  "account_name": "Ayesha Khan"
}
```

Returns `201` with the new item. The first method a customer saves becomes the default. Never store a full card number. Keep the last four digits only.

**`PUT /api/payment-methods/:id/default`**

No body. Returns the updated item. The previous default loses the flag.

**`DELETE /api/payment-methods/:id`**

Returns `204`. `409` when it is the default method.

### 3.8 Wishlist

The wishlist holds designs from the recommendation catalogue in 3.9. The Saved number on the customer profile is the length of this list.

**`GET /api/wishlist`**

An array of design objects, as in 3.9.

**`POST /api/wishlist`**

```json
{
  "design_id": "D001"
}
```

Returns `204`. Saving a design twice is not an error.

**`DELETE /api/wishlist/:designId`**

Returns `204`.

### 3.9 Searches and AI recommendations

**`POST /api/searches`**

The app sends every search of three characters or more, from the recommendations search bar and from the browse tailors search bar.

```json
{
  "query": "bridal lehenga"
}
```

Returns `201`. The server works out the category.

```json
{
  "query": "bridal lehenga",
  "category": "Bridal",
  "created_at": "2026-10-07T04:50:00.000Z"
}
```

**`GET /api/searches`**

The signed-in customer's own searches, newest first, as an array of the object above.

**`GET /api/searches/trending?limit=10`**

The most frequent searches of all customers in the last seven days, highest count first. `limit` defaults to 10.

```json
[
  { "query": "Bridal Lehenga", "count": 14 }
]
```

**`GET /api/ai/recommendations?query=&limit=`**

With `query`, the designs most similar to it. Without `query`, designs picked from the customer's own recent searches. `limit` defaults to 6.

```json
[
  {
    "id": "D001",
    "name": "Heavy Bridal Lehenga",
    "category": "Bridal",
    "price_min": 4500,
    "price_max": 8000,
    "image_url": null
  }
]
```

`category` is Bridal, Formal, Eastern, Casual, Western or General. The screen picks a colour from it.

### 3.10 AI design studio

**`POST /api/ai/designs`**

```json
{
  "prompt": "A red bridal lehenga with golden embroidery and floral patterns",
  "category": "Bridal",
  "color": "Red",
  "fabric": "Silk"
}
```

Returns `201` with four design concepts.

```json
[
  {
    "id": "AID1001",
    "title": "Classic Elegance",
    "category": "Bridal",
    "color": "Red",
    "fabric": "Silk",
    "image_url": "https://example.com/uploads/designs/aid1001.png"
  }
]
```

**`POST /api/ai/designs/:id/send`**

```json
{
  "tailor_id": "T001"
}
```

Returns `204`. The tailor gets a notification with the design. The screen has no tailor picker yet, and no other screen opens the design studio.

### 3.11 Virtual try-on

The app talks only to the Node API, which passes the request to the Flask service.

**`POST /api/ai/try-on`**

Multipart form data with `photo` as the file, `garment_type`, and an optional `command` such as "Make it red". The call can take several seconds, and the app shows a processing state while it waits. Returns `201`.

```json
{
  "id": "TRY1001",
  "garment_type": "Bridal Lehenga",
  "command": "Make it red",
  "result_url": "https://example.com/uploads/try-on/try1001.png",
  "is_saved": false,
  "created_at": "2026-10-07T04:55:00.000Z"
}
```

`400` when the photo is missing or cannot be read.

**`PUT /api/ai/try-on/:id/save`**

No body. Returns the result with `is_saved` true. Share uses the phone's share sheet and needs no endpoint.

### 3.12 Payout accounts and withdrawals

For tailors and riders.

**`GET /api/payout-accounts`**

```json
[
  {
    "id": "PA001",
    "type": "bank",
    "account_number": "0123-4567890",
    "account_name": "Shahid Tailor",
    "bank_name": "HBL",
    "iban": null,
    "is_default": true
  }
]
```

**`POST /api/payout-accounts`**

```json
{
  "type": "bank",
  "account_number": "0123-4567890",
  "account_name": "Shahid Tailor",
  "bank_name": "HBL",
  "iban": "PK36HABB0000123456789012"
}
```

Returns `201` with the new account. `bank_name` is required for `bank` and `iban` is optional. For `jazzCash` and `easyPaisa`, `account_number` is the mobile number. The first account becomes the default.

**`PUT /api/payout-accounts/:id/default`**

No body. Returns the updated account.

**`DELETE /api/payout-accounts/:id`**

Returns `204`. `409` when it is the default account.

**`GET /api/withdrawals`**

The user's withdrawals, newest first. The payout history on the tailor payment screen shows the `paid` ones.

```json
[
  {
    "id": "WD004",
    "amount": 12400,
    "status": "paid",
    "requested_at": "2026-05-25T09:00:00.000Z",
    "paid_at": "2026-05-26T11:30:00.000Z"
  }
]
```

**`POST /api/withdrawals`**

```json
{
  "amount": 4200
}
```

`amount` is optional. The Withdraw button sends none, which means the whole available balance. Returns `201` with the withdrawal as `pending`. `400` when the amount is below Rs 500 or above the available balance. `409` when the user has no payout account.

The app says payouts are processed every Monday, so a `pending` withdrawal becomes `paid` then. Nothing in the admin panel lists or pays withdrawals yet.

### 3.13 Chat

Each order has one conversation, between its customer and its tailor, so the order ID identifies it.

**`GET /api/conversations`**

One entry per order of the signed-in user, most recent activity first.

```json
[
  {
    "order_id": "ORD001",
    "garment_type": "Bridal Lehenga",
    "other_user_id": "T001",
    "other_user_name": "Sana's Couture",
    "last_message": "Perfect, thank you so much!",
    "last_message_at": "2026-10-07T03:05:00.000Z",
    "unread_count": 0
  }
]
```

An order with no messages has an empty `last_message` and a null `last_message_at`.

**`GET /api/orders/:id/messages`**

Oldest first.

```json
[
  {
    "id": "MSG001",
    "sender_id": "C001",
    "receiver_id": "T001",
    "text": "Hello! I wanted to check on my order ORD001.",
    "type": "text",
    "is_read": true,
    "created_at": "2026-10-07T02:20:00.000Z"
  }
]
```

**`POST /api/orders/:id/messages`**

```json
{
  "text": "When will it be ready?",
  "type": "text"
}
```

Returns `201` with the new message. `403` when the user is neither the order's customer nor its tailor.

**`PUT /api/orders/:id/messages/read`**

No body. Marks every message addressed to the signed-in user as read. Returns `204`.

### 3.14 Notifications

`NotificationService.getNotifications` calls the existing `GET /api/notifications` without `userId`. The tailor and rider notification screens need it too, because they build their lists locally today.

```json
[
  {
    "id": "N001",
    "title": "Order Update",
    "body": "Your bridal lehenga is In Progress!",
    "type": "order",
    "is_read": false,
    "created_at": "2026-10-07T04:40:00.000Z"
  }
]
```

**`PUT /api/notifications/:id/read`**

No body. Returns `204`.

**`PUT /api/notifications/read-all`**

No body. Returns `204`.

### 3.15 Rider

**`GET /api/riders/:id`**

```json
{
  "id": "R001",
  "name": "Ali Raza",
  "phone": "0304-5678901",
  "city": "Lahore",
  "assigned_tailor_id": "T001",
  "assigned_tailor_name": "Sana's Couture",
  "is_verified": true,
  "is_available": true,
  "total_deliveries": 156,
  "month_deliveries": 28,
  "rating": 4.8
}
```

The rider changes name and phone with `PUT /api/users/me`.

**`PUT /api/riders/:id/availability`**

```json
{
  "is_available": false
}
```

Returns `204`. A rider who is not available gets no new deliveries.

### 3.16 Live stream

These endpoints cover the tailor's side only.

**`POST /api/streams`**

```json
{
  "title": "Bridal Lehenga Live Stitching Session",
  "category": "Bridal Work",
  "gifts_enabled": true
}
```

Returns `201` with the stream.

```json
{
  "id": "LIVE1001",
  "tailor_id": "T001",
  "title": "Bridal Lehenga Live Stitching Session",
  "category": "Bridal Work",
  "status": "live",
  "gifts_enabled": true,
  "viewers": 0,
  "peak_viewers": 0,
  "likes": 0,
  "earnings": 0,
  "duration_seconds": 0,
  "pinned_garment_id": null,
  "started_at": "2026-10-07T18:00:00.000Z",
  "gifts": []
}
```

`category` is the text the tailor picks: Bridal Work, Stitching Tutorial, Design Showcase or Q&A Session.

**`GET /api/streams/:id`**

The same object with the current numbers. The app asks again every few seconds while the stream is live.

**`GET /api/streams/:id/messages`**

The latest 40 chat lines, oldest first.

```json
[
  {
    "id": "LM001",
    "viewer_name": "Fatima K.",
    "text": "Can you make this for me?",
    "created_at": "2026-10-07T18:02:10.000Z"
  }
]
```

**`PUT /api/streams/:id/pin`**

```json
{
  "garment_id": "G002"
}
```

Pins an item from the tailor's price list so viewers can order it. Returns the updated stream.

**`PUT /api/streams/:id/end`**

No body. Returns the stream with `status` `ended`, the final numbers, and one `gifts` entry per gift type received.

```json
{
  "id": "LIVE1001",
  "tailor_id": "T001",
  "title": "Bridal Lehenga Live Stitching Session",
  "category": "Bridal Work",
  "status": "ended",
  "gifts_enabled": true,
  "viewers": 0,
  "peak_viewers": 212,
  "likes": 1840,
  "earnings": 700,
  "duration_seconds": 1260,
  "pinned_garment_id": "G002",
  "started_at": "2026-10-07T18:00:00.000Z",
  "gifts": [
    { "name": "Rose", "amount": 50, "count": 4 },
    { "name": "Crown", "amount": 500, "count": 1 }
  ]
}
```

`earnings` is the total of the gifts and is added to the tailor's available balance. The gift types are fixed in the app: Star Rs 10, Rose Rs 50, Diamond Rs 100 and Crown Rs 500.

### 3.17 Garment categories

**`GET /api/categories`**

The list the admin manages in settings (4.11), for the category chips on the browse tailors screen. The screen adds its own All chip in front.

```json
["Bridal", "Eastern", "Western", "Casual", "Children"]
```

## 4. Admin panel endpoints

All 36 endpoints are called from `sewsmart_admin/lib/core/services/admin_service.dart`. Every route except login needs an admin token.

### 4.1 Overview

| Endpoint | Service method | Used by |
| --- | --- | --- |
| `POST /api/admin/auth/login` | `login` | Login |
| `POST /api/admin/auth/logout` | `logout` | Sidebar |
| `PUT /api/admin/auth/password` | `changePassword` | Settings |
| `GET /api/admin/stats` | `getStats` | Dashboard |
| `GET /api/admin/revenue/monthly` | `getMonthlyRevenue` | Dashboard |
| `GET /api/admin/tailors/top` | `getTopTailors` | Dashboard |
| `GET /api/admin/users` | `getUsers` | Customers |
| `PUT /api/admin/users/:id/status` | `suspendUser` | Customers |
| `DELETE /api/admin/users/:id` | `deleteUser` | Customers |
| `GET /api/admin/tailors` | `getTailors` | Tailors |
| `PUT /api/admin/tailors/:id/status` | `suspendTailor` | Tailors |
| `DELETE /api/admin/tailors/:id` | `removeTailor` | Tailors |
| `GET /api/admin/riders` | `getRiders` | Riders |
| `PUT /api/admin/riders/:id/status` | `suspendRider` | Riders |
| `DELETE /api/admin/riders/:id` | `removeRider` | Riders |
| `GET /api/admin/verifications` | `getPendingVerifications`, `getAllVerifications` | Verifications, Tailors, Riders, Dashboard |
| `PUT /api/admin/verifications/:id/approve` | `approveVerification` | Verifications, Tailors, Riders, Dashboard |
| `PUT /api/admin/verifications/:id/reject` | `rejectVerification` | Verifications, Tailors, Riders, Dashboard |
| `POST /api/admin/verifications/:id/request-documents` | `requestMoreDocuments` | Verifications, Tailors |
| `GET /api/admin/orders` | `getAllOrders`, `getRecentOrders` | Orders, Dashboard |
| `PUT /api/admin/orders/:id/cancel` | `cancelOrder` | Orders |
| `GET /api/admin/payments` | `getAllPayments` | Payments |
| `GET /api/admin/payments/summary` | `getPaymentSummary` | Payments |
| `GET /api/admin/disputes` | `getDisputes` | Disputes |
| `PUT /api/admin/disputes/:id/resolve` | `resolveDispute` | Disputes |
| `GET /api/admin/reports` | `getReports` | Reports |
| `GET /api/admin/content/designs` | `getDesigns` | Content |
| `DELETE /api/admin/content/designs/:id` | `removeDesign` | Content |
| `GET /api/admin/content/reviews` | `getReviews` | Content |
| `DELETE /api/admin/content/reviews/:id` | `removeReview` | Content |
| `GET /api/admin/content/reports` | `getFlaggedContent` | Content |
| `PUT /api/admin/content/reports/:id/resolve` | `resolveFlaggedContent` | Content |
| `GET /api/admin/settings` | `getSettings` | Settings |
| `PUT /api/admin/settings` | `updateSettings` | Settings |
| `POST /api/admin/settings/categories` | `addCategory` | Settings |
| `DELETE /api/admin/settings/categories/:name` | `removeCategory` | Settings |

### 4.2 Auth

There is no admin sign-up. Create the first admin with a seed script and store the password hashed. `admin` is not a role in the mobile app, so an admin must not be able to sign in through `/api/auth/login`.

**`POST /api/admin/auth/login`**

Request:

```json
{
  "email": "admin@sewsmart.com",
  "password": "your-password"
}
```

Response `200`:

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.example",
  "admin": {
    "id": "ad001",
    "name": "Admin",
    "email": "admin@sewsmart.com"
  }
}
```

`401` when the email or password is wrong.

**`POST /api/admin/auth/logout`**

No body. Returns `204`.

**`PUT /api/admin/auth/password`**

Request:

```json
{
  "current_password": "old-password",
  "new_password": "new-password"
}
```

Returns `204`. `400` when the current password is wrong or the new one is shorter than 8 characters. The app must compare the Confirm Password box itself. It is not sent.

### 4.3 Dashboard

**`GET /api/admin/stats`**

Response `200`:

```json
{
  "total_users": 1248,
  "total_orders": 3874,
  "total_revenue": 2845600,
  "active_orders": 142,
  "pending_verifications": 7,
  "registered_tailors": 312,
  "active_riders": 89,
  "open_disputes": 4,
  "this_month_revenue": 184200,
  "last_month_revenue": 162500,
  "average_tailor_rating": 4.6
}
```

| Field | Meaning |
| --- | --- |
| `total_users` | All customer, tailor and rider accounts |
| `total_orders` | All orders ever placed |
| `total_revenue` | Sum of `completed` payments, before commission |
| `active_orders` | Orders that are `accepted`, `inProgress`, `qualityCheck` or `readyForDelivery` |
| `pending_verifications` | Verification requests with status `pending` |
| `registered_tailors` | Tailor accounts |
| `active_riders` | Rider accounts with status `active` |
| `open_disputes` | Disputes with status `open` |
| `this_month_revenue`, `last_month_revenue` | `total_revenue` limited to the current and the previous calendar month |
| `average_tailor_rating` | Average rating across tailors that have at least one review, to one decimal |

**`GET /api/admin/revenue/monthly?months=6`**

`months` defaults to 6. The array is oldest first, because the chart draws it left to right. `month` is `YYYY-MM` and the app shows the short month name.

```json
[
  { "month": "2024-05", "revenue": 162500 },
  { "month": "2024-06", "revenue": 184200 }
]
```

**`GET /api/admin/tailors/top?limit=5`**

`limit` defaults to 5. Highest revenue first.

```json
[
  {
    "id": "ta001",
    "name": "Noor Stitching Studio",
    "city": "Lahore",
    "total_orders": 156,
    "rating": 4.8,
    "revenue": 284500,
    "completion_rate": 97.4
  }
]
```

`completion_rate` is a percentage: completed orders out of the tailor's finished orders, where finished means completed, cancelled or rejected.

The Recent Orders card uses `GET /api/admin/orders?limit=5`, described in 4.6.

### 4.4 Customers, tailors and riders

The three lists follow one pattern. Each has its own endpoint because the rows carry different fields.

**`GET /api/admin/users?role=&status=`**

`role` defaults to `customer`, which is the only value the Customers screen uses. `status` is `active` or `suspended`.

```json
[
  {
    "id": "cu001",
    "name": "Ayesha Malik",
    "email": "ayesha.malik@email.com",
    "phone": "+92-300-1234567",
    "city": "Lahore",
    "role": "customer",
    "status": "active",
    "created_at": "2024-01-15T00:00:00.000Z",
    "total_orders": 12,
    "total_spent": 45600
  }
]
```

`total_orders` and `total_spent` are calculated from the customer's orders and completed payments.

**`GET /api/admin/tailors?status=`**

```json
[
  {
    "id": "ta001",
    "name": "Noor Stitching Studio",
    "email": "noor.studio@email.com",
    "phone": "+92-300-9991234",
    "city": "Lahore",
    "category": "Bridal",
    "status": "active",
    "is_verified": true,
    "created_at": "2023-11-10T00:00:00.000Z",
    "total_orders": 156,
    "rating": 4.8,
    "revenue": 284500
  }
]
```

**`GET /api/admin/riders?status=`**

```json
[
  {
    "id": "ri001",
    "name": "Ali Hassan",
    "phone": "+92-302-1234567",
    "city": "Lahore",
    "assigned_tailor_id": "ta001",
    "assigned_tailor_name": "Noor Stitching Studio",
    "status": "active",
    "is_verified": true,
    "created_at": "2024-01-20T00:00:00.000Z",
    "total_deliveries": 234,
    "rating": 4.7
  }
]
```

**`PUT /api/admin/users/:id/status`**, **`PUT /api/admin/tailors/:id/status`**, **`PUT /api/admin/riders/:id/status`**

Request:

```json
{
  "status": "suspended"
}
```

Returns the updated object. The body carries the status you want, not a toggle, so a repeated request cannot undo itself. A suspended account cannot sign in.

**`DELETE /api/admin/users/:id`**, **`DELETE /api/admin/tailors/:id`**, **`DELETE /api/admin/riders/:id`**

Returns `204`. Keep the account's orders, payments and reviews. Mark the account as deleted instead of removing the document, so order history and revenue totals stay correct.

### 4.5 Verifications

A request is created by the mobile flows: when a tailor or rider registers, and when a tailor adds a rider with `POST /api/riders`. The admin API only reads requests and decides them.

**`GET /api/admin/verifications?status=`**

`status` is `pending`, `approved` or `rejected`. The screens filter by role themselves.

```json
[
  {
    "id": "pv001",
    "name": "Modern Stitching Co.",
    "phone": "+92-301-2223334",
    "city": "Karachi",
    "role": "tailor",
    "submitted_at": "2024-06-01T00:00:00.000Z",
    "status": "pending",
    "documents_submitted": true
  }
]
```

`documents_submitted` is `true` when the role's extra document is on file: business proof for a tailor, driving licence for a rider.

**`PUT /api/admin/verifications/:id/approve`**

No body. Sets the request to `approved`, sets the account's `is_verified` to `true` and notifies the applicant.

**`PUT /api/admin/verifications/:id/reject`**

Request:

```json
{
  "reason": "CNIC photo is not readable"
}
```

Sets the request to `rejected` and notifies the applicant with the reason.

**`POST /api/admin/verifications/:id/request-documents`**

Request, where `message` is optional:

```json
{
  "message": "Please upload a clearer photo of your CNIC"
}
```

Returns `204`. The request stays `pending` and the applicant gets a notification.

### 4.6 Orders

**`GET /api/admin/orders?status=&limit=`**

`status` is one order status. The Orders screen loads every order once and filters its tabs and search box locally, so it sends no filter. The dashboard sends `limit=5`.

```json
[
  {
    "id": "ORD-002",
    "customer_id": "cu002",
    "customer_name": "Sara Ahmed",
    "tailor_id": "ta002",
    "tailor_name": "Karachi Fashion House",
    "garment_type": "Evening Gown",
    "amount": 8400,
    "status": "inProgress",
    "created_at": "2024-06-01T00:00:00.000Z",
    "city": "Karachi"
  }
]
```

This is the mobile order object plus `city`, the customer's city. Extra mobile fields such as `measurements` and `notes` may be returned. The admin panel ignores them.

**`PUT /api/admin/orders/:id/cancel`**

No body. Sets the order to `cancelled`. `409` when the order is already `delivered`, `completed`, `rejected` or `cancelled`.

### 4.7 Payments

**`GET /api/admin/payments?method=&status=`**

```json
[
  {
    "id": "PAY-0421",
    "transaction_id": "TXN-8821",
    "order_id": "ORD-001",
    "customer_name": "Ayesha Malik",
    "tailor_name": "Noor Stitching Studio",
    "amount": 12500,
    "method": "jazzCash",
    "status": "completed",
    "created_at": "2024-05-28T00:00:00.000Z"
  }
]
```

This is the mobile payment object plus the two names. The admin table shows `transaction_id`.

**`GET /api/admin/payments/summary`**

```json
{
  "total_revenue": 18900,
  "this_month": 5670,
  "pending": 26400,
  "refunded": 7800
}
```

| Field | Meaning |
| --- | --- |
| `total_revenue` | Sum of `completed` payments |
| `this_month` | Sum of `completed` payments in the current calendar month |
| `pending` | Sum of `pending` payments |
| `refunded` | Sum of `refunded` payments |

### 4.8 Disputes

**`GET /api/admin/disputes?status=`**

`status` is `open` or `resolved`.

```json
[
  {
    "id": "DIS-002",
    "order_id": "ORD-004",
    "customer_name": "Nadia Hussain",
    "tailor_name": "Islamabad Couture",
    "issue": "Garment measurements not matching specifications",
    "amount": 4600,
    "created_at": "2024-05-22T00:00:00.000Z",
    "status": "resolved",
    "resolution": "refund",
    "resolution_notes": "Partial refund of Rs. 1200 issued"
  }
]
```

`resolution` and `resolution_notes` are `null` while the dispute is open.

**`PUT /api/admin/disputes/:id/resolve`**

Request:

```json
{
  "resolution": "refund",
  "notes": "Full refund issued and tailor warned"
}
```

Sets the dispute to `resolved` and stores both values. `409` when it is already resolved.

### 4.9 Reports

**`GET /api/admin/reports?range=thisMonth`**

`range` is `today`, `thisWeek`, `thisMonth` or `custom`. A `custom` range also needs `from` and `to` as `YYYY-MM-DD`.

| Field | Content |
| --- | --- |
| `range` | The range that was applied |
| `stats` | The object from `GET /api/admin/stats` |
| `monthly_revenue` | The array from `GET /api/admin/revenue/monthly`, always the last six months |
| `revenue_by_category` | Array of `{ "category": "Bridal", "amount": 742000 }`. The app picks the chart colours. |
| `top_tailors` | The array from `GET /api/admin/tailors/top` |
| `order_status_distribution` | Order count per status, for example `{ "pending": 287, "inProgress": 142, "completed": 2841, "cancelled": 604 }` |

The range applies to `total_orders` and `total_revenue` inside `stats`, and to `revenue_by_category`, `top_tailors` and `order_status_distribution`. Every other number is a current total.

### 4.10 Content moderation

Designs are the portfolio samples that tailors upload.

**`GET /api/admin/content/designs`**

```json
[
  {
    "id": "d005",
    "creator_name": "Raza Tailoring Works",
    "title": "Men's Casual Wear",
    "type": "design",
    "status": "flagged",
    "created_at": "2024-05-25T00:00:00.000Z"
  }
]
```

**`DELETE /api/admin/content/designs/:id`**

Returns `204`.

**`GET /api/admin/content/reviews`**

```json
[
  {
    "id": "r002",
    "customer_name": "Sara Ahmed",
    "tailor_name": "Karachi Fashion House",
    "rating": 2,
    "comment": "Very disappointed with the quality and late delivery.",
    "created_at": "2024-06-02T00:00:00.000Z",
    "status": "published"
  }
]
```

`rating` is a number from 1 to 5.

**`DELETE /api/admin/content/reviews/:id`**

Returns `204`. Recalculate the tailor's average rating afterwards.

**`GET /api/admin/content/reports?status=`**

`status` is `pending` or `resolved`.

```json
[
  {
    "id": "f001",
    "reporter_name": "Amna Butt",
    "reported_item": "Design by Raza Works",
    "target_type": "design",
    "target_id": "d005",
    "reason": "Inappropriate image content",
    "created_at": "2024-06-01T00:00:00.000Z",
    "status": "pending"
  }
]
```

`reported_item` is the text the admin reads. `target_type` is `design`, `review` or `profile`, and with `target_id` it tells the backend what the report points at.

**`PUT /api/admin/content/reports/:id/resolve`**

Request:

```json
{
  "action": "remove"
}
```

Sets the report to `resolved`. `remove` deletes the reported design or review, `warn` notifies its owner, and `dismiss` closes the report with no other effect.

### 4.11 Settings

**`GET /api/admin/settings`**

```json
{
  "commission_rate": 8.5,
  "categories": ["Bridal", "Eastern", "Western", "Casual", "Children"],
  "notify_new_order": true,
  "notify_order_complete": true,
  "notify_new_verification": true,
  "notify_dispute": true,
  "notify_payment": false,
  "notify_marketing": false,
  "two_fa_enabled": false,
  "session_timeout": 30
}
```

| Field | Meaning |
| --- | --- |
| `commission_rate` | Percentage the platform keeps from each transaction, from 2 to 20 in steps of 0.5 |
| `categories` | Garment categories. Change them with the two category endpoints. |
| `notify_*` | Which events notify the admin |
| `two_fa_enabled` | Stored only. The login screen has no second step yet. |
| `session_timeout` | Minutes of inactivity before the admin is signed out: 15, 30, 60 or 120 |

**`PUT /api/admin/settings`**

Send any of the fields above except `categories`. Fields that are left out keep their value. Returns the full settings object.

**`POST /api/admin/settings/categories`**

Request:

```json
{
  "name": "Formal"
}
```

Returns `201` with the updated list of category names. `400` when the name is empty and `409` when it already exists.

**`DELETE /api/admin/settings/categories/:name`**

URL-encode the name. Returns `204`. Tailors that already use the category keep it.

### 4.12 Left for later

These parts of the admin panel are outside this draft, because the screen or the data behind them is not ready.

- Document files on a verification request. The cards show CNIC front, CNIC back and business proof or driving licence, but nothing is uploaded yet. Add a `documents` array of `{ "type", "url" }` once file upload exists.
- An `image_url` on designs. The cards show a coloured placeholder.
- Status dates for the order timeline. The dialog works them out from the current status and repeats the order date.
- The change badges on the stat cards, such as +12%. They are fixed text.
- The Export buttons. They only show a message.
- A date picker for the Custom report range.
- The search and notification icons in the top bar. Their handlers are empty.
- The View buttons on the Tailors and Riders screens. Their handlers are empty, and the lists already return what a detail dialog would show.

## 5. Not designed yet

Every feature in both apps now has its endpoints named. These parts are still open.

| Open part | Why |
| --- | --- |
| Request and response details of the 29 endpoints in 3.1 | Only their methods and paths are fixed. Each needs the same detail as the newer endpoints before its backend work starts. |
| File uploads | The portfolio and try-on endpoints take multipart form data, and so will the design reference on an order, the rider documents and the delivery proof. Where files are stored and their size limits are not decided. The app has no image picker yet. |
| Watching a live stream | No customer screen exists, so listing live streams, joining, commenting, liking and sending gifts have no endpoints. The video itself needs a streaming service. |
| Paying withdrawals | The mobile app can request a withdrawal, but no admin screen lists or pays them. |
| Coupons | The app can validate a code, but no admin screen creates one. |
| Rider issue reports | Riders send them with `POST /api/deliveries/:id/report-issue`, and no admin screen shows them. |
| Live updates | Chat, notifications and stream numbers are read by asking again. Socket.IO can deliver them live later without changing these endpoints. |
| Push notifications | Nothing registers a device for push yet. |

Screens that have to be built before some endpoints can be used:

- A screen to set the new password after a reset link.
- A screen where a customer submits a review. `submitReview` exists, but nothing calls it.
- Screens where a customer or tailor raises a dispute or reports content. Until then the admin Disputes screen and the Reports tab of the Content screen have no source of data.
- A wishlist screen and a list of saved try-on results. Both can be saved, and neither can be opened again.
- A tailor picker in the AI design studio, and a way to open the studio from another screen.
- A screen where a tailor sees their riders and assigns one to an order.

## 6. Decisions to confirm

Each item states what this draft assumes. Change the draft if the team decides otherwise.

1. **One set of values for both apps.** The mobile app reads `inProgress`, `completed` and `jazzCash`. The admin panel shows In Progress, Paid and JazzCash. This draft makes the API use the mobile spelling everywhere, and the admin panel converts values to labels.
2. **Commission rate.** Admin settings start at 8.5%, while the tailor payout screen says "Platform fee: 5% per completed order". This draft treats `commission_rate` as the only source, so the mobile text should read it from the API.
3. **Garment categories.** The mobile app lists Bridal, Eastern, Western, Casual and Formal. Admin settings list Bridal, Eastern, Western, Casual and Children. This draft treats admin settings as the only list, and the mobile app reads it with `GET /api/categories`.
4. **Refunds.** The resolve dialog has no amount field, so a `refund` resolution refunds the full dispute amount. Cancelling an order that is already paid does not refund it automatically.
5. **Revenue.** Every revenue figure is the gross amount customers paid, as the Payments screen calculates it today, not the commission the platform earned.
6. **Whose data.** Several mobile endpoints take a user ID from the app, such as `?customerId=`, `?userId=` and `/riders/:id/earnings`. The backend should read the user from the token and check the ID against it, so one user cannot read another user's data.
7. **Reports against a profile.** `remove` is defined for designs and reviews only. What it does to a reported profile is open.
8. **Cash on delivery.** The payment methods screen lets a customer save Cash on Delivery, but the payment screen and the `PaymentMethod` enum do not offer it. This draft allows `cashOnDelivery` as a saved method only, so an order cannot be paid that way yet.
9. **Price lists.** `GET /api/garments/pricing` is one shared list, while each tailor edits their own list. This draft treats the tailor's own list as the real one, so the place order and tailor profile screens should load `GET /api/tailors/:id/garments`.
10. **Recommended designs.** The recommendations come from a catalogue of designs with a name, a category and a price range. Whether that catalogue is seeded by the team or built from the tailors' portfolio samples is open.
11. **Try-on result.** The screen shows a 3D viewer with rotate buttons. This draft returns one image, in one request that waits for the result.
12. **Live video.** The stream endpoints carry the title, the numbers and the chat. The video needs a streaming service, and the response to `POST /api/streams` will have to carry that service's channel and token once one is chosen.
13. **Password length.** The register screen accepts 4 characters, and this draft asks for 8 on the admin password. One rule for both would be simpler.
