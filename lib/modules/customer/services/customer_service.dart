// ─── Customer Service ─────────────────────────────────────────────────────────
// API-ready: all methods return Future<T>. Replace mock with real API calls.

import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';

class CustomerService {
  static final CustomerService _i = CustomerService._();
  factory CustomerService() => _i;
  CustomerService._();

  // TODO: GET /api/tailors?category=&city=&rating=&price=
  Future<List<TailorModel>> getTailors({String? category, String? city, double? minRating}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var list = MockData.tailors;
    if (category != null && category != 'All') list = list.where((t) => t.category == category).toList();
    if (minRating != null) list = list.where((t) => t.rating >= minRating).toList();
    return list;
  }

  // TODO: GET /api/tailors/:id
  Future<TailorModel?> getTailorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.tailors.where((t) => t.id == id).firstOrNull;
  }

  // TODO: GET /api/orders?customerId=
  Future<List<OrderModel>> getMyOrders(String customerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.orders.where((o) => o.customerId == customerId).toList();
  }

  // TODO: POST /api/orders
  Future<OrderModel?> placeOrder({
    required String customerId, required String tailorId,
    required String garmentType, required double amount,
    required String measurements, bool hasDesignRef = false, String? notes,
    String? couponCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final tailor = MockData.tailors.firstWhere((t) => t.id == tailorId);
    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId, tailorId: tailorId,
      customerName: 'Customer', tailorName: tailor.name,
      garmentType: garmentType, status: OrderStatus.pending,
      amount: amount, measurements: measurements,
      createdAt: DateTime.now(), hasDesignRef: hasDesignRef, notes: notes,
    );
    MockData.orders.add(order);
    return order;
  }

  // TODO: PUT /api/orders/:id/delivery-schedule
  Future<bool> setDeliverySchedule({
    required String orderId, required DateTime pickupDate,
    required DateTime deliveryDate, required String pickupSlot,
    required String deliverySlot,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: POST /api/payments
  Future<PaymentModel?> makePayment({
    required String orderId, required String customerId,
    required String tailorId, required double amount,
    required PaymentMethod method,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return PaymentModel(
      id: 'PAY${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId, customerId: customerId, tailorId: tailorId,
      amount: amount, status: PaymentStatus.completed,
      method: method, createdAt: DateTime.now(),
      transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // TODO: POST /api/reviews
  Future<bool> submitReview({
    required String tailorId, required String customerId,
    required String customerName, required double rating, required String comment,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: GET /api/notifications?userId=
  Future<List<NotificationModel>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.notifications;
  }

  // TODO: GET /api/garments/pricing
  Future<List<GarmentPricing>> getGarmentPricing() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.garments;
  }

  // ── Garment categories ──────────────────────────────────────────────────────
  // TODO: GET /api/categories
  // The list the admin manages in settings. The screen adds its own "All" chip.
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.categories.where((c) => c != 'All').toList();
  }

  // ── Tailor price list and reviews ───────────────────────────────────────────
  // TODO: GET /api/tailors/:id/garments
  Future<List<GarmentPricing>> getTailorGarments(String tailorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<GarmentPricing>.from(MockData.tailorGarments);
  }

  // TODO: GET /api/tailors/:id/reviews
  Future<List<ReviewModel>> getTailorReviews(String tailorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.reviews.where((r) => r.tailorId == tailorId).toList();
  }

  // ── Coupons ─────────────────────────────────────────────────────────────────
  // TODO: POST /api/coupons/validate
  Future<CouponResult> validateCoupon({required String code, required double amount, String? tailorId}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final value = code.trim().toUpperCase();
    if (value == 'EID20') {
      return CouponResult(
        code: value, valid: true, discountPercent: 20,
        discountAmount: amount * 0.2, message: '20% discount applied!',
      );
    }
    return CouponResult(code: value, valid: false, message: 'Invalid coupon code');
  }

  // ── Saved measurements ──────────────────────────────────────────────────────
  // TODO: GET /api/measurements
  Future<MeasurementModel?> getMeasurements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.measurements;
  }

  // TODO: PUT /api/measurements
  Future<bool> saveMeasurements(MeasurementModel measurements) async {
    await Future.delayed(const Duration(milliseconds: 900));
    MockData.measurements = measurements;
    return true;
  }

  // ── Saved payment methods ───────────────────────────────────────────────────
  // TODO: GET /api/payment-methods
  Future<List<SavedPaymentMethod>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<SavedPaymentMethod>.from(MockData.paymentMethods);
  }

  // TODO: POST /api/payment-methods
  // type is jazzCash, easyPaisa, bank, card or cashOnDelivery.
  Future<SavedPaymentMethod?> addPaymentMethod({required String type, String? accountNumber, String? accountName}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final method = SavedPaymentMethod(
      id: 'PM${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      detail: accountNumber ?? '',
      accountName: accountName ?? '',
      isDefault: MockData.paymentMethods.isEmpty,
    );
    MockData.paymentMethods.add(method);
    return method;
  }

  // TODO: PUT /api/payment-methods/:id/default
  Future<bool> setDefaultPaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!MockData.paymentMethods.any((m) => m.id == id)) return false;
    MockData.paymentMethods = MockData.paymentMethods
        .map((m) => m.copyWith(isDefault: m.id == id))
        .toList();
    return true;
  }

  // TODO: DELETE /api/payment-methods/:id
  // The default method cannot be removed.
  Future<bool> removePaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = MockData.paymentMethods.indexWhere((m) => m.id == id);
    if (idx == -1 || MockData.paymentMethods[idx].isDefault) return false;
    MockData.paymentMethods.removeAt(idx);
    return true;
  }

  // ── Wishlist ────────────────────────────────────────────────────────────────
  // TODO: GET /api/wishlist
  Future<List<DesignModel>> getWishlist() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.designs.where((d) => MockData.wishlist.contains(d.id)).toList();
  }

  // TODO: POST /api/wishlist
  Future<bool> addToWishlist(String designId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!MockData.designs.any((d) => d.id == designId)) return false;
    if (!MockData.wishlist.contains(designId)) MockData.wishlist.add(designId);
    return true;
  }

  // TODO: DELETE /api/wishlist/:designId
  Future<bool> removeFromWishlist(String designId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.wishlist.remove(designId);
  }

  // ── Searches and AI recommendations ─────────────────────────────────────────
  // customerName is only for the mock. The real API reads the user from the token.
  // TODO: POST /api/searches
  Future<void> recordSearch(String query, {String customerName = 'Customer'}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    MockData.recordSearch(query, customerName: customerName);
  }

  // TODO: GET /api/searches
  Future<List<SearchEntry>> getMySearches({String customerName = 'Customer'}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.searchHistory
        .where((s) => (s['customerName'] as String).toLowerCase() == customerName.toLowerCase())
        .map((s) => SearchEntry(
              query: s['query'] as String,
              category: s['category'] as String,
              createdAt: DateTime.now().subtract(Duration(hours: s['hoursAgo'] as int)),
            ))
        .toList();
  }

  // TODO: GET /api/searches/trending?limit=10
  Future<List<TrendingSearch>> getTrendingSearches({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final counts = <String, int>{};
    for (final s in MockData.searchHistory) {
      final query = s['query'] as String;
      counts[query] = (counts[query] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries
        .take(limit)
        .map((e) => TrendingSearch(query: e.key, count: e.value))
        .toList();
  }

  // TODO: GET /api/ai/recommendations?query=&limit=
  // Without a query the real API returns designs picked from the user's own searches.
  Future<List<DesignModel>> getRecommendations({String? query, int limit = 6}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final q = (query ?? '').trim();
    if (q.isEmpty) return MockData.designs.take(limit).toList();
    final category = MockData.designCategoryFor(q);
    return MockData.designs.where((d) => d.category == category).take(limit).toList();
  }

  // ── AI design studio ────────────────────────────────────────────────────────
  // TODO: POST /api/ai/designs
  Future<List<DesignConcept>> generateDesigns({
    required String prompt, required String category,
    required String color, required String fabric,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    final stamp = DateTime.now().millisecondsSinceEpoch;
    const titles = ['Classic Elegance', 'Modern Twist', 'Royal Style', 'Minimalist'];
    return [
      for (var i = 0; i < titles.length; i++)
        DesignConcept(
          id: 'AID$stamp$i', title: titles[i],
          category: category, color: color, fabric: fabric,
        ),
    ];
  }

  // TODO: POST /api/ai/designs/:id/send
  Future<bool> sendDesignToTailor(String designId, String tailorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // ── Virtual try-on ──────────────────────────────────────────────────────────
  // TODO: POST /api/ai/try-on
  // Sent as multipart form data. photoPath is the local file picked by the user.
  Future<TryOnResult?> generateTryOn({required String photoPath, required String garmentType, String? command}) async {
    await Future.delayed(const Duration(seconds: 3));
    return TryOnResult(
      id: 'TRY${DateTime.now().millisecondsSinceEpoch}',
      garmentType: garmentType, command: command,
      resultUrl: '', createdAt: DateTime.now(),
    );
  }

  // TODO: PUT /api/ai/try-on/:id/save
  Future<bool> saveTryOn(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
