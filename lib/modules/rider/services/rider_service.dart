// ─── Rider Service ────────────────────────────────────────────────────────────
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';

class RiderService {
  static final RiderService _i = RiderService._();
  factory RiderService() => _i;
  RiderService._();

  // TODO: GET /api/riders/:id/deliveries
  Future<List<OrderModel>> getAssignedDeliveries(String riderId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.orders.where((o) =>
      o.status == OrderStatus.readyForDelivery || o.riderId == riderId
    ).toList();
  }

  // TODO: PUT /api/deliveries/:id/verify-pickup
  Future<bool> verifyPickup(String orderId, String verificationCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: POST /api/deliveries/:id/proof
  Future<bool> uploadDeliveryProof(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  // TODO: PUT /api/deliveries/:id/verify-customer-slip
  Future<bool> verifyCustomerSlip(String orderId, String slipCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: POST /api/deliveries/:id/report-issue
  Future<bool> reportIssue(String orderId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // TODO: GET /api/riders/:id/earnings
  Future<Map<String, dynamic>> getEarnings(String riderId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'total': 45200.0,
      'thisMonth': 8900.0,
      'totalDeliveries': 156,
      'thisMonthDeliveries': 28,
      'pending': 1200.0,
    };
  }
}
