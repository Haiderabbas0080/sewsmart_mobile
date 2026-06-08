import '../data/admin_mock_data.dart';
import '../models/admin_models.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  // ── Stats ─────────────────────────────────────────────────
  Future<PlatformStats> getStats() async {
    await _delay();
    return AdminMockData.platformStats;
  }

  // ── Users ─────────────────────────────────────────────────
  Future<List<AdminUser>> getUsers({String? role, String? status}) async {
    await _delay();
    var users = List<AdminUser>.from(AdminMockData.allUsers);
    if (role != null && role != 'All') {
      users = users.where((u) => u.role.toLowerCase() == role.toLowerCase()).toList();
    }
    if (status != null && status != 'All') {
      users = users.where((u) => u.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return users;
  }

  Future<bool> suspendUser(String id) async {
    await _delay();
    final idx = AdminMockData.customers.indexWhere((u) => u.id == id);
    if (idx != -1) {
      AdminMockData.customers[idx].status =
          AdminMockData.customers[idx].status == 'Active' ? 'Suspended' : 'Active';
      return true;
    }
    return false;
  }

  Future<bool> deleteUser(String id) async {
    await _delay();
    AdminMockData.customers.removeWhere((u) => u.id == id);
    return true;
  }

  // ── Tailors ───────────────────────────────────────────────
  Future<List<AdminTailor>> getTailors({String? status}) async {
    await _delay();
    var tailors = List<AdminTailor>.from(AdminMockData.tailors);
    if (status != null && status != 'All') {
      tailors = tailors.where((t) => t.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return tailors;
  }

  Future<bool> suspendTailor(String id) async {
    await _delay();
    final idx = AdminMockData.tailors.indexWhere((t) => t.id == id);
    if (idx != -1) {
      AdminMockData.tailors[idx].status =
          AdminMockData.tailors[idx].status == 'Active' ? 'Suspended' : 'Active';
      return true;
    }
    return false;
  }

  // ── Riders ────────────────────────────────────────────────
  Future<List<AdminRider>> getRiders({String? status}) async {
    await _delay();
    var riders = List<AdminRider>.from(AdminMockData.riders);
    if (status != null && status != 'All') {
      riders = riders.where((r) => r.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return riders;
  }

  Future<bool> suspendRider(String id) async {
    await _delay();
    final idx = AdminMockData.riders.indexWhere((r) => r.id == id);
    if (idx != -1) {
      AdminMockData.riders[idx].status =
          AdminMockData.riders[idx].status == 'Active' ? 'Suspended' : 'Active';
      return true;
    }
    return false;
  }

  // ── Verifications ─────────────────────────────────────────
  Future<List<PendingVerification>> getPendingVerifications() async {
    await _delay();
    return AdminMockData.pendingVerifications
        .where((v) => v.status == 'Pending')
        .toList();
  }

  Future<List<PendingVerification>> getAllVerifications() async {
    await _delay();
    return List<PendingVerification>.from(AdminMockData.pendingVerifications);
  }

  Future<bool> approveVerification(String id) async {
    await _delay();
    final idx = AdminMockData.pendingVerifications.indexWhere((v) => v.id == id);
    if (idx != -1) {
      AdminMockData.pendingVerifications[idx].status = 'Approved';
      return true;
    }
    return false;
  }

  Future<bool> rejectVerification(String id, String reason) async {
    await _delay();
    final idx = AdminMockData.pendingVerifications.indexWhere((v) => v.id == id);
    if (idx != -1) {
      AdminMockData.pendingVerifications[idx].status = 'Rejected';
      return true;
    }
    return false;
  }

  // ── Orders ────────────────────────────────────────────────
  Future<List<AdminOrder>> getAllOrders({String? status}) async {
    await _delay();
    var orders = List<AdminOrder>.from(AdminMockData.orders);
    if (status != null && status != 'All') {
      orders = orders.where((o) => o.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return orders;
  }

  Future<bool> cancelOrder(String id) async {
    await _delay();
    final idx = AdminMockData.orders.indexWhere((o) => o.id == id);
    if (idx != -1) {
      AdminMockData.orders[idx].status = 'Cancelled';
      return true;
    }
    return false;
  }

  // ── Payments ──────────────────────────────────────────────
  Future<List<AdminPayment>> getAllPayments({String? method, String? status}) async {
    await _delay();
    var payments = List<AdminPayment>.from(AdminMockData.payments);
    if (method != null && method != 'All') {
      payments = payments.where((p) => p.method == method).toList();
    }
    if (status != null && status != 'All') {
      payments = payments.where((p) => p.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return payments;
  }

  // ── Disputes ──────────────────────────────────────────────
  Future<List<AdminDispute>> getDisputes({String? status}) async {
    await _delay();
    var disputes = List<AdminDispute>.from(AdminMockData.disputes);
    if (status != null && status != 'All') {
      disputes = disputes.where((d) => d.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return disputes;
  }

  Future<bool> resolveDispute(String id, String resolution, String notes) async {
    await _delay();
    final idx = AdminMockData.disputes.indexWhere((d) => d.id == id);
    if (idx != -1) {
      AdminMockData.disputes[idx].status = 'Resolved';
      AdminMockData.disputes[idx].resolution = '$resolution: $notes';
      return true;
    }
    return false;
  }

  // ── Reports ───────────────────────────────────────────────
  Future<Map<String, dynamic>> getReports() async {
    await _delay();
    return {
      'stats': AdminMockData.platformStats,
      'monthlyRevenue': AdminMockData.monthlyRevenue,
      'revenueByCategory': AdminMockData.revenueByCategory,
      'topTailors': AdminMockData.topTailors,
    };
  }
}
