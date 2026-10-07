// ─── Admin Service ────────────────────────────────────────────────────────────
// API-ready: every method returns a Future and runs on mock data for now.
// The TODO above each method names the endpoint that replaces its mock.
// Request and response shapes are in docs/API.md at the repository root.
// Screens should call this service and never read AdminMockData directly.

import '../data/admin_mock_data.dart';
import '../models/admin_models.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  // ── Session ───────────────────────────────────────────────
  // Set by login and cleared by logout. With the real API the token goes in
  // the Authorization header of every request.
  AdminAuthResult? _session;
  bool get isLoggedIn => _session != null;
  String get adminName => _session?.name ?? 'Admin';
  String get adminEmail => _session?.email ?? '';

  // ── Auth ──────────────────────────────────────────────────
  // TODO: POST /api/admin/auth/login
  Future<AdminAuthResult> login(String email, String password) async {
    await _delay();
    if (email.trim() == 'admin@sewsmart.com' && password == 'admin123') {
      const result = AdminAuthResult(
        success: true,
        token: 'mock_admin_token',
        name: 'Admin',
        email: 'admin@sewsmart.com',
      );
      _session = result;
      return result;
    }
    return const AdminAuthResult(
      success: false,
      error: 'Invalid credentials. Please try again.',
    );
  }

  // TODO: POST /api/admin/auth/logout
  Future<void> logout() async {
    _session = null;
    await _delay();
  }

  // TODO: PUT /api/admin/auth/password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    await _delay();
    return currentPassword.isNotEmpty && newPassword.isNotEmpty;
  }

  // ── Dashboard ─────────────────────────────────────────────
  // TODO: GET /api/admin/stats
  Future<PlatformStats> getStats() async {
    await _delay();
    return AdminMockData.platformStats;
  }

  // TODO: GET /api/admin/revenue/monthly?months=6
  Future<List<MonthlyRevenue>> getMonthlyRevenue({int months = 6}) async {
    await _delay();
    final data = AdminMockData.monthlyRevenue;
    final start = data.length > months ? data.length - months : 0;
    return data.sublist(start);
  }

  // TODO: GET /api/admin/tailors/top?limit=5
  Future<List<TopTailor>> getTopTailors({int limit = 5}) async {
    await _delay();
    return AdminMockData.topTailors.take(limit).toList();
  }

  // TODO: GET /api/admin/orders?limit=5
  Future<List<AdminOrder>> getRecentOrders({int limit = 5}) async {
    await _delay();
    return AdminMockData.orders.take(limit).toList();
  }

  // ── Users ─────────────────────────────────────────────────
  // TODO: GET /api/admin/users?role=&status=
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

  // TODO: PUT /api/admin/users/:id/status
  // The mock flips Active and Suspended. The real call sends the new status.
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

  // TODO: DELETE /api/admin/users/:id
  Future<bool> deleteUser(String id) async {
    await _delay();
    AdminMockData.customers.removeWhere((u) => u.id == id);
    return true;
  }

  // ── Tailors ───────────────────────────────────────────────
  // TODO: GET /api/admin/tailors?status=
  Future<List<AdminTailor>> getTailors({String? status}) async {
    await _delay();
    var tailors = List<AdminTailor>.from(AdminMockData.tailors);
    if (status != null && status != 'All') {
      tailors = tailors.where((t) => t.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return tailors;
  }

  // TODO: PUT /api/admin/tailors/:id/status
  // The mock flips Active and Suspended. The real call sends the new status.
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

  // TODO: DELETE /api/admin/tailors/:id
  Future<bool> removeTailor(String id) async {
    await _delay();
    final before = AdminMockData.tailors.length;
    AdminMockData.tailors.removeWhere((t) => t.id == id);
    return AdminMockData.tailors.length < before;
  }

  // ── Riders ────────────────────────────────────────────────
  // TODO: GET /api/admin/riders?status=
  Future<List<AdminRider>> getRiders({String? status}) async {
    await _delay();
    var riders = List<AdminRider>.from(AdminMockData.riders);
    if (status != null && status != 'All') {
      riders = riders.where((r) => r.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return riders;
  }

  // TODO: PUT /api/admin/riders/:id/status
  // The mock flips Active and Suspended. The real call sends the new status.
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

  // TODO: DELETE /api/admin/riders/:id
  Future<bool> removeRider(String id) async {
    await _delay();
    final before = AdminMockData.riders.length;
    AdminMockData.riders.removeWhere((r) => r.id == id);
    return AdminMockData.riders.length < before;
  }

  // ── Verifications ─────────────────────────────────────────
  // TODO: GET /api/admin/verifications?status=pending
  Future<List<PendingVerification>> getPendingVerifications() async {
    await _delay();
    return AdminMockData.pendingVerifications
        .where((v) => v.status == 'Pending')
        .toList();
  }

  // TODO: GET /api/admin/verifications
  Future<List<PendingVerification>> getAllVerifications() async {
    await _delay();
    return List<PendingVerification>.from(AdminMockData.pendingVerifications);
  }

  // TODO: PUT /api/admin/verifications/:id/approve
  Future<bool> approveVerification(String id) async {
    await _delay();
    final idx = AdminMockData.pendingVerifications.indexWhere((v) => v.id == id);
    if (idx != -1) {
      AdminMockData.pendingVerifications[idx].status = 'Approved';
      return true;
    }
    return false;
  }

  // TODO: PUT /api/admin/verifications/:id/reject
  Future<bool> rejectVerification(String id, String reason) async {
    await _delay();
    final idx = AdminMockData.pendingVerifications.indexWhere((v) => v.id == id);
    if (idx != -1) {
      AdminMockData.pendingVerifications[idx].status = 'Rejected';
      return true;
    }
    return false;
  }

  // TODO: POST /api/admin/verifications/:id/request-documents
  Future<bool> requestMoreDocuments(String id) async {
    await _delay();
    return AdminMockData.pendingVerifications.any((v) => v.id == id);
  }

  // ── Orders ────────────────────────────────────────────────
  // TODO: GET /api/admin/orders?status=
  Future<List<AdminOrder>> getAllOrders({String? status}) async {
    await _delay();
    var orders = List<AdminOrder>.from(AdminMockData.orders);
    if (status != null && status != 'All') {
      orders = orders.where((o) => o.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return orders;
  }

  // TODO: PUT /api/admin/orders/:id/cancel
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
  // TODO: GET /api/admin/payments?method=&status=
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

  // TODO: GET /api/admin/payments/summary
  // The mock estimates "this month" as 30% of the total, as the screen does today.
  Future<PaymentSummary> getPaymentSummary() async {
    await _delay();
    double sum(String status) => AdminMockData.payments
        .where((p) => p.status == status)
        .fold(0.0, (a, b) => a + b.amount);
    final paid = sum('Paid');
    return PaymentSummary(
      totalRevenue: paid,
      thisMonth: paid * 0.3,
      pending: sum('Processing'),
      refunded: sum('Refunded'),
    );
  }

  // ── Disputes ──────────────────────────────────────────────
  // TODO: GET /api/admin/disputes?status=
  Future<List<AdminDispute>> getDisputes({String? status}) async {
    await _delay();
    var disputes = List<AdminDispute>.from(AdminMockData.disputes);
    if (status != null && status != 'All') {
      disputes = disputes.where((d) => d.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return disputes;
  }

  // TODO: PUT /api/admin/disputes/:id/resolve
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
  // TODO: GET /api/admin/reports?range=
  Future<AdminReport> getReports({String range = 'This Month'}) async {
    await _delay();
    return AdminReport(
      range: range,
      stats: AdminMockData.platformStats,
      monthlyRevenue: AdminMockData.monthlyRevenue,
      revenueByCategory: AdminMockData.revenueByCategory,
      topTailors: AdminMockData.topTailors,
      orderStatusDistribution: AdminMockData.orderStatusDistribution,
    );
  }

  // ── Content moderation ────────────────────────────────────
  // TODO: GET /api/admin/content/designs
  Future<List<ContentItem>> getDesigns() async {
    await _delay();
    return List<ContentItem>.from(AdminMockData.designs);
  }

  // TODO: DELETE /api/admin/content/designs/:id
  Future<bool> removeDesign(String id) async {
    await _delay();
    final before = AdminMockData.designs.length;
    AdminMockData.designs.removeWhere((d) => d.id == id);
    return AdminMockData.designs.length < before;
  }

  // TODO: GET /api/admin/content/reviews
  Future<List<ReviewItem>> getReviews() async {
    await _delay();
    return List<ReviewItem>.from(AdminMockData.reviews);
  }

  // TODO: DELETE /api/admin/content/reviews/:id
  Future<bool> removeReview(String id) async {
    await _delay();
    final before = AdminMockData.reviews.length;
    AdminMockData.reviews.removeWhere((r) => r.id == id);
    return AdminMockData.reviews.length < before;
  }

  // TODO: GET /api/admin/content/reports?status=
  Future<List<FlaggedItem>> getFlaggedContent({String? status}) async {
    await _delay();
    var items = List<FlaggedItem>.from(AdminMockData.flaggedContent);
    if (status != null && status != 'All') {
      items = items.where((f) => f.status.toLowerCase() == status.toLowerCase()).toList();
    }
    return items;
  }

  // TODO: PUT /api/admin/content/reports/:id/resolve
  // action is "Remove Content", "Issue Warning" or "Dismiss Report".
  Future<bool> resolveFlaggedContent(String id, String action) async {
    await _delay();
    final idx = AdminMockData.flaggedContent.indexWhere((f) => f.id == id);
    if (idx != -1) {
      AdminMockData.flaggedContent[idx].status = 'Resolved';
      return true;
    }
    return false;
  }

  // ── Settings ──────────────────────────────────────────────
  // TODO: GET /api/admin/settings
  Future<AdminSettings> getSettings() async {
    await _delay();
    return AdminMockData.settings;
  }

  // TODO: PUT /api/admin/settings
  // Categories are not part of this call. They change through the two
  // category endpoints below.
  Future<bool> updateSettings(AdminSettings settings) async {
    await _delay();
    AdminMockData.settings
      ..commissionRate = settings.commissionRate
      ..notifyNewOrder = settings.notifyNewOrder
      ..notifyOrderComplete = settings.notifyOrderComplete
      ..notifyNewVerification = settings.notifyNewVerification
      ..notifyDispute = settings.notifyDispute
      ..notifyPayment = settings.notifyPayment
      ..notifyMarketing = settings.notifyMarketing
      ..twoFaEnabled = settings.twoFaEnabled
      ..sessionTimeout = settings.sessionTimeout;
    return true;
  }

  // TODO: POST /api/admin/settings/categories
  Future<bool> addCategory(String name) async {
    await _delay();
    final value = name.trim();
    final categories = AdminMockData.settings.categories;
    if (value.isEmpty || categories.contains(value)) return false;
    categories.add(value);
    return true;
  }

  // TODO: DELETE /api/admin/settings/categories/:name
  Future<bool> removeCategory(String name) async {
    await _delay();
    return AdminMockData.settings.categories.remove(name);
  }
}
