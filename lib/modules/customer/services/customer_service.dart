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
}
