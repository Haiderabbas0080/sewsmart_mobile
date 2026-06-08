// ─── Tailor Service ───────────────────────────────────────────────────────────
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';

class TailorService {
  static final TailorService _i = TailorService._();
  factory TailorService() => _i;
  TailorService._();

  // TODO: GET /api/orders?tailorId=&status=
  Future<List<OrderModel>> getOrders(String tailorId, {OrderStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var list = MockData.orders.where((o) => o.tailorId == tailorId).toList();
    if (status != null) list = list.where((o) => o.status == status).toList();
    return list;
  }

  // TODO: PUT /api/orders/:id/accept
  Future<bool> acceptOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = MockData.orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final o = MockData.orders[idx];
      MockData.orders[idx] = OrderModel(
        id: o.id, customerId: o.customerId, tailorId: o.tailorId,
        customerName: o.customerName, tailorName: o.tailorName,
        garmentType: o.garmentType, status: OrderStatus.accepted,
        amount: o.amount, measurements: o.measurements, createdAt: o.createdAt,
      );
      return true;
    }
    return false;
  }

  // TODO: PUT /api/orders/:id/reject
  Future<bool> rejectOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: PUT /api/orders/:id/status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: POST /api/orders/:id/delivery-request
  Future<bool> sendDeliveryRequest(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  // TODO: GET /api/tailors/:id/earnings
  Future<Map<String, dynamic>> getEarnings(String tailorId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'total': 148900.0,
      'thisMonth': 28900.0,
      'pending': 6300.0,
      'withdrawn': 112400.0,
      'monthly': MockData.monthlyEarnings,
    };
  }

  // TODO: POST /api/riders (add rider under tailor)
  Future<bool> addRider({required String tailorId, required String riderName, required String riderPhone}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  // TODO: PUT /api/riders/:id/verify-pickup
  Future<bool> verifyRiderPickup(String riderId, String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
