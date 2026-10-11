// ─── Support Service ──────────────────────────────────────────────────────────
// Disputes about an order and reports about content. Customers and tailors both
// use it, and the admin panel works through what it creates (Disputes screen,
// Reports tab of the Content screen). Uses mock data for now.
// The real API reads the user from the token, so no user id is passed.

import '../models/app_models.dart';
import '../data/mock_data.dart';

class SupportService {
  static final SupportService _instance = SupportService._();
  factory SupportService() => _instance;
  SupportService._();

  // ── Disputes ────────────────────────────────────────────────────────────────
  // TODO: POST /api/disputes
  // The customer or the tailor of the order raises it. An order has at most one
  // open dispute, so a second one returns null.
  Future<DisputeModel?> raiseDispute({
    required String orderId, required String reason, required String details,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (MockData.disputes.any((d) => d.orderId == orderId && d.isOpen)) return null;
    final dispute = DisputeModel(
      id: 'DIS-${101 + MockData.disputes.length}',
      orderId: orderId, reason: reason, details: details.trim(),
      status: 'open', createdAt: DateTime.now(),
    );
    MockData.disputes.insert(0, dispute);
    return dispute;
  }

  // TODO: GET /api/disputes
  // Disputes on the signed-in user's orders, whoever raised them.
  Future<List<DisputeModel>> getMyDisputes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<DisputeModel>.from(MockData.disputes);
  }

  // ── Content reports ─────────────────────────────────────────────────────────
  // TODO: POST /api/content-reports
  // targetType is design, review or profile, and targetId is its id.
  Future<bool> reportContent({
    required String targetType, required String targetId,
    required String reason, String? details,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (targetId.isEmpty || reason.trim().isEmpty) return false;
    MockData.contentReports.add({
      'target_type': targetType,
      'target_id': targetId,
      'reason': reason.trim(),
      'details': details?.trim() ?? '',
    });
    return true;
  }
}
