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

  // ── Profile ─────────────────────────────────────────────────────────────────
  // TODO: PUT /api/tailors/:id
  // name is the business name. phone is stored on the user account, so the mock ignores it.
  Future<TailorModel?> updateProfile({
    required String tailorId, String? name, String? phone, String? city,
    int? experienceYears, String? bio,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final idx = MockData.tailors.indexWhere((t) => t.id == tailorId);
    if (idx == -1) return null;
    final current = MockData.tailors[idx];
    final updated = TailorModel(
      id: current.id, name: name ?? current.name, category: current.category,
      city: city ?? current.city, bio: bio ?? current.bio,
      userAvatar: current.userAvatar, rating: current.rating,
      priceFrom: current.priceFrom, totalOrders: current.totalOrders,
      specialties: current.specialties, isVerified: current.isVerified,
      portfolio: current.portfolio,
      experienceYears: experienceYears ?? current.experienceYears,
    );
    MockData.tailors[idx] = updated;
    return updated;
  }

  // ── Portfolio ───────────────────────────────────────────────────────────────
  // TODO: GET /api/tailors/:id/portfolio
  Future<List<PortfolioItem>> getPortfolio(String tailorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.portfolio.where((p) => p.tailorId == tailorId).toList();
  }

  // TODO: POST /api/tailors/:id/portfolio
  // Sent as multipart form data. imagePath is the local file picked by the tailor.
  Future<PortfolioItem?> addPortfolioSample({required String tailorId, required String imagePath, String? title}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final item = PortfolioItem(
      id: 'PF${DateTime.now().millisecondsSinceEpoch}',
      tailorId: tailorId, title: title ?? '', imageUrl: imagePath,
      createdAt: DateTime.now(),
    );
    MockData.portfolio.insert(0, item);
    return item;
  }

  // TODO: DELETE /api/tailors/:id/portfolio/:itemId
  Future<bool> removePortfolioSample(String tailorId, String itemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final before = MockData.portfolio.length;
    MockData.portfolio.removeWhere((p) => p.id == itemId && p.tailorId == tailorId);
    return MockData.portfolio.length < before;
  }

  // ── Price list ──────────────────────────────────────────────────────────────
  // TODO: GET /api/tailors/:id/garments
  Future<List<GarmentPricing>> getGarments(String tailorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<GarmentPricing>.from(MockData.tailorGarments);
  }

  // TODO: POST /api/tailors/:id/garments
  Future<GarmentPricing?> addGarment({
    required String tailorId, required String garment,
    required double price, required String estimatedTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final item = GarmentPricing(
      id: 'G${DateTime.now().millisecondsSinceEpoch}',
      garment: garment, price: price, estimatedTime: estimatedTime,
    );
    MockData.tailorGarments.add(item);
    return item;
  }

  // TODO: PUT /api/tailors/:id/garments/:garmentId
  Future<GarmentPricing?> updateGarment({
    required String tailorId, required String garmentId,
    String? garment, double? price, String? estimatedTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = MockData.tailorGarments.indexWhere((g) => g.id == garmentId);
    if (idx == -1) return null;
    final current = MockData.tailorGarments[idx];
    final updated = GarmentPricing(
      id: current.id, garment: garment ?? current.garment,
      price: price ?? current.price,
      estimatedTime: estimatedTime ?? current.estimatedTime,
    );
    MockData.tailorGarments[idx] = updated;
    return updated;
  }

  // TODO: DELETE /api/tailors/:id/garments/:garmentId
  Future<bool> removeGarment(String tailorId, String garmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final before = MockData.tailorGarments.length;
    MockData.tailorGarments.removeWhere((g) => g.id == garmentId);
    return MockData.tailorGarments.length < before;
  }

  // ── Live stream ─────────────────────────────────────────────────────────────
  // TODO: POST /api/streams
  Future<LiveStream?> startStream({
    required String tailorId, required String title,
    required String category, bool giftsEnabled = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (title.trim().isEmpty) return null;
    final stream = LiveStream(
      id: 'LIVE${DateTime.now().millisecondsSinceEpoch}',
      tailorId: tailorId, title: title.trim(), category: category,
      status: 'live', startedAt: DateTime.now(), giftsEnabled: giftsEnabled,
    );
    MockData.liveStream = stream;
    return stream;
  }

  // TODO: GET /api/streams/:id
  Future<LiveStream?> getStream(String streamId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final stream = MockData.liveStream;
    if (stream == null || stream.id != streamId) return null;
    if (stream.status != 'live') return stream;
    return stream.copyWith(
      durationSeconds: DateTime.now().difference(stream.startedAt).inSeconds,
    );
  }

  // TODO: GET /api/streams/:id/messages
  Future<List<LiveMessage>> getStreamMessages(String streamId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<LiveMessage>.from(MockData.liveMessages);
  }

  // TODO: PUT /api/streams/:id/pin
  // garmentId is an item from the tailor's price list.
  Future<bool> pinStreamItem(String streamId, String garmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final stream = MockData.liveStream;
    if (stream == null || stream.id != streamId) return false;
    MockData.liveStream = stream.copyWith(pinnedGarmentId: garmentId);
    return true;
  }

  // TODO: PUT /api/streams/:id/end
  Future<LiveStream?> endStream(String streamId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final stream = MockData.liveStream;
    if (stream == null || stream.id != streamId) return null;
    final ended = stream.copyWith(
      status: 'ended',
      durationSeconds: DateTime.now().difference(stream.startedAt).inSeconds,
    );
    MockData.liveStream = ended;
    return ended;
  }
}
