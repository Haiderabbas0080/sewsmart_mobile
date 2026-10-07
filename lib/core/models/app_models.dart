// ─── All App Models ───────────────────────────────────────────────────────────

export 'user_model.dart';

// ── Tailor Profile ────────────────────────────────────────────────────────────
class TailorModel {
  final String id, name, category, city, bio;
  final String userAvatar;
  final double rating, priceFrom;
  final int totalOrders;
  final List<String> specialties;
  final bool isVerified;
  final List<String> portfolio;
  final int experienceYears;

  const TailorModel({
    required this.id, required this.name, required this.category,
    required this.city, required this.bio, required this.userAvatar,
    required this.rating, required this.priceFrom, required this.totalOrders,
    required this.specialties, required this.isVerified, this.portfolio = const [],
    this.experienceYears = 0,
  });

  factory TailorModel.fromJson(Map<String, dynamic> j) => TailorModel(
    id: j['id'], name: j['name'], category: j['category'], city: j['city'],
    bio: j['bio'] ?? '', userAvatar: j['avatar'] ?? '',
    rating: (j['rating'] as num).toDouble(),
    priceFrom: (j['price_from'] as num).toDouble(),
    totalOrders: j['total_orders'] ?? 0,
    specialties: List<String>.from(j['specialties'] ?? []),
    isVerified: j['is_verified'] ?? false,
    portfolio: List<String>.from(j['portfolio'] ?? []),
    experienceYears: j['experience_years'] ?? 0,
  );
}

// ── Order ─────────────────────────────────────────────────────────────────────
enum OrderStatus { pending, accepted, rejected, inProgress, qualityCheck, readyForDelivery, delivered, completed, cancelled }

class OrderModel {
  final String id, customerId, tailorId, customerName, tailorName, garmentType;
  final OrderStatus status;
  final double amount;
  final String measurements;
  final bool hasDesignRef;
  final DateTime createdAt;
  final DateTime? scheduledPickup, scheduledDelivery;
  final String? riderId, riderName;
  final String? notes;

  const OrderModel({
    required this.id, required this.customerId, required this.tailorId,
    required this.customerName, required this.tailorName,
    required this.garmentType, required this.status, required this.amount,
    required this.measurements, required this.createdAt,
    this.hasDesignRef = false, this.scheduledPickup, this.scheduledDelivery,
    this.riderId, this.riderName, this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
    id: j['id'], customerId: j['customer_id'], tailorId: j['tailor_id'],
    customerName: j['customer_name'], tailorName: j['tailor_name'],
    garmentType: j['garment_type'],
    status: OrderStatus.values.byName(j['status']),
    amount: (j['amount'] as num).toDouble(),
    measurements: j['measurements'] ?? '',
    createdAt: DateTime.parse(j['created_at']),
    hasDesignRef: j['has_design_ref'] ?? false,
    riderId: j['rider_id'], riderName: j['rider_name'],
    notes: j['notes'],
  );

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.accepted: return 'Accepted';
      case OrderStatus.rejected: return 'Rejected';
      case OrderStatus.inProgress: return 'In Progress';
      case OrderStatus.qualityCheck: return 'Quality Check';
      case OrderStatus.readyForDelivery: return 'Ready';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.completed: return 'Completed';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}

// ── Payment ───────────────────────────────────────────────────────────────────
enum PaymentStatus { pending, completed, failed, refunded }
enum PaymentMethod { jazzCash, easyPaisa, bank, card }

class PaymentModel {
  final String id, orderId, customerId, tailorId;
  final double amount;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final String? transactionId;

  const PaymentModel({
    required this.id, required this.orderId, required this.customerId,
    required this.tailorId, required this.amount, required this.status,
    required this.method, required this.createdAt, this.transactionId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> j) => PaymentModel(
    id: j['id'], orderId: j['order_id'], customerId: j['customer_id'],
    tailorId: j['tailor_id'], amount: (j['amount'] as num).toDouble(),
    status: PaymentStatus.values.byName(j['status']),
    method: PaymentMethod.values.byName(j['method']),
    createdAt: DateTime.parse(j['created_at']),
    transactionId: j['transaction_id'],
  );
}

// ── Message ───────────────────────────────────────────────────────────────────
enum MessageType { text, image, document }

class MessageModel {
  final String id, senderId, receiverId, text;
  final MessageType type;
  final DateTime time;
  final bool isRead;

  const MessageModel({
    required this.id, required this.senderId, required this.receiverId,
    required this.text, required this.type, required this.time,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
    id: j['id'], senderId: j['sender_id'], receiverId: j['receiver_id'],
    text: j['text'] ?? '',
    type: MessageType.values.byName(j['type'] ?? 'text'),
    time: DateTime.parse(j['created_at']),
    isRead: j['is_read'] ?? false,
  );
}

// ── Notification ──────────────────────────────────────────────────────────────
class NotificationModel {
  final String id, title, body, type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id, required this.title, required this.body,
    required this.type, required this.isRead, required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> j) => NotificationModel(
    id: j['id'], title: j['title'], body: j['body'] ?? '',
    type: j['type'] ?? '',
    isRead: j['is_read'] ?? false,
    createdAt: DateTime.parse(j['created_at']),
  );
}

// ── Delivery Schedule ─────────────────────────────────────────────────────────
class DeliveryScheduleModel {
  final String id, orderId, customerId, tailorId;
  final DateTime? preferredPickupDate, preferredDeliveryDate;
  final String? pickupTimeSlot, deliveryTimeSlot;
  final String status; // pending_reply, confirmed, rescheduled
  final String? riderId;

  const DeliveryScheduleModel({
    required this.id, required this.orderId, required this.customerId,
    required this.tailorId, required this.status,
    this.preferredPickupDate, this.preferredDeliveryDate,
    this.pickupTimeSlot, this.deliveryTimeSlot, this.riderId,
  });
}

// ── Review ────────────────────────────────────────────────────────────────────
class ReviewModel {
  final String id, customerId, tailorId, customerName, comment;
  final double rating;
  final DateTime createdAt;

  const ReviewModel({
    required this.id, required this.customerId, required this.tailorId,
    required this.customerName, required this.comment,
    required this.rating, required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> j) => ReviewModel(
    id: j['id'], customerId: j['customer_id'], tailorId: j['tailor_id'],
    customerName: j['customer_name'], comment: j['comment'] ?? '',
    rating: (j['rating'] as num).toDouble(),
    createdAt: DateTime.parse(j['created_at']),
  );
}

// ── Garment Pricing ───────────────────────────────────────────────────────────
// id is empty in the shared default list and set in a tailor's own price list.
class GarmentPricing {
  final String id;
  final String garment, estimatedTime;
  final double price;
  const GarmentPricing({this.id = '', required this.garment, required this.price, required this.estimatedTime});

  factory GarmentPricing.fromJson(Map<String, dynamic> j) => GarmentPricing(
    id: j['id'] ?? '', garment: j['garment'],
    price: (j['price'] as num).toDouble(),
    estimatedTime: j['estimated_time'] ?? '',
  );
}

// ── Portfolio Sample ──────────────────────────────────────────────────────────
class PortfolioItem {
  final String id, tailorId, title, imageUrl;
  final String status; // active, flagged
  final DateTime createdAt;

  const PortfolioItem({
    required this.id, required this.tailorId, required this.title,
    required this.imageUrl, required this.createdAt, this.status = 'active',
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> j) => PortfolioItem(
    id: j['id'], tailorId: j['tailor_id'], title: j['title'] ?? '',
    imageUrl: j['image_url'] ?? '', status: j['status'] ?? 'active',
    createdAt: DateTime.parse(j['created_at']),
  );
}

// ── Coupon ────────────────────────────────────────────────────────────────────
class CouponResult {
  final String code, message;
  final bool valid;
  final double discountPercent, discountAmount;

  const CouponResult({
    required this.code, required this.valid, this.message = '',
    this.discountPercent = 0, this.discountAmount = 0,
  });

  factory CouponResult.fromJson(Map<String, dynamic> j) => CouponResult(
    code: j['code'] ?? '', valid: j['valid'] ?? false, message: j['message'] ?? '',
    discountPercent: ((j['discount_percent'] ?? 0) as num).toDouble(),
    discountAmount: ((j['discount_amount'] ?? 0) as num).toDouble(),
  );
}

// ── Saved Measurements ────────────────────────────────────────────────────────
class MeasurementModel {
  final String unit; // cm, in
  final double height, weight, chest, waist, hips, shoulder, armLength, inseam, neck, wrist;
  final DateTime? updatedAt;

  const MeasurementModel({
    required this.unit, required this.height, required this.weight,
    required this.chest, required this.waist, required this.hips,
    required this.shoulder, required this.armLength, required this.inseam,
    required this.neck, required this.wrist, this.updatedAt,
  });

  factory MeasurementModel.fromJson(Map<String, dynamic> j) => MeasurementModel(
    unit: j['unit'] ?? 'cm',
    height: (j['height'] as num).toDouble(), weight: (j['weight'] as num).toDouble(),
    chest: (j['chest'] as num).toDouble(), waist: (j['waist'] as num).toDouble(),
    hips: (j['hips'] as num).toDouble(), shoulder: (j['shoulder'] as num).toDouble(),
    armLength: (j['arm_length'] as num).toDouble(), inseam: (j['inseam'] as num).toDouble(),
    neck: (j['neck'] as num).toDouble(), wrist: (j['wrist'] as num).toDouble(),
    updatedAt: j['updated_at'] == null ? null : DateTime.parse(j['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'unit': unit, 'height': height, 'weight': weight, 'chest': chest,
    'waist': waist, 'hips': hips, 'shoulder': shoulder, 'arm_length': armLength,
    'inseam': inseam, 'neck': neck, 'wrist': wrist,
  };
}

// ── Saved Payment Method ──────────────────────────────────────────────────────
class SavedPaymentMethod {
  final String id;
  final String type; // jazzCash, easyPaisa, bank, card, cashOnDelivery
  final String detail, accountName;
  final bool isDefault;

  const SavedPaymentMethod({
    required this.id, required this.type, required this.detail,
    this.accountName = '', this.isDefault = false,
  });

  factory SavedPaymentMethod.fromJson(Map<String, dynamic> j) => SavedPaymentMethod(
    id: j['id'], type: j['type'], detail: j['detail'] ?? '',
    accountName: j['account_name'] ?? '', isDefault: j['is_default'] ?? false,
  );

  SavedPaymentMethod copyWith({bool? isDefault}) => SavedPaymentMethod(
    id: id, type: type, detail: detail, accountName: accountName,
    isDefault: isDefault ?? this.isDefault,
  );
}

// ── Payout Account ────────────────────────────────────────────────────────────
class PayoutAccount {
  final String id;
  final String type; // jazzCash, easyPaisa, bank
  final String accountNumber, accountName;
  final String? bankName, iban;
  final bool isDefault;

  const PayoutAccount({
    required this.id, required this.type, required this.accountNumber,
    required this.accountName, this.bankName, this.iban, this.isDefault = false,
  });

  factory PayoutAccount.fromJson(Map<String, dynamic> j) => PayoutAccount(
    id: j['id'], type: j['type'], accountNumber: j['account_number'],
    accountName: j['account_name'] ?? '', bankName: j['bank_name'], iban: j['iban'],
    isDefault: j['is_default'] ?? false,
  );

  PayoutAccount copyWith({bool? isDefault}) => PayoutAccount(
    id: id, type: type, accountNumber: accountNumber, accountName: accountName,
    bankName: bankName, iban: iban, isDefault: isDefault ?? this.isDefault,
  );
}

// ── Withdrawal ────────────────────────────────────────────────────────────────
class WithdrawalModel {
  final String id;
  final String status; // pending, paid, failed
  final double amount;
  final DateTime requestedAt;
  final DateTime? paidAt;

  const WithdrawalModel({
    required this.id, required this.amount, required this.status,
    required this.requestedAt, this.paidAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> j) => WithdrawalModel(
    id: j['id'], amount: (j['amount'] as num).toDouble(), status: j['status'],
    requestedAt: DateTime.parse(j['requested_at']),
    paidAt: j['paid_at'] == null ? null : DateTime.parse(j['paid_at']),
  );
}

// ── Chat Conversation ─────────────────────────────────────────────────────────
// One conversation per order, between its customer and its tailor.
class ConversationModel {
  final String orderId, garmentType, otherUserId, otherUserName, lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ConversationModel({
    required this.orderId, required this.garmentType, required this.otherUserId,
    required this.otherUserName, this.lastMessage = '', this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> j) => ConversationModel(
    orderId: j['order_id'], garmentType: j['garment_type'],
    otherUserId: j['other_user_id'], otherUserName: j['other_user_name'],
    lastMessage: j['last_message'] ?? '',
    lastMessageAt: j['last_message_at'] == null ? null : DateTime.parse(j['last_message_at']),
    unreadCount: j['unread_count'] ?? 0,
  );
}

// ── Design (recommendations and wishlist) ─────────────────────────────────────
class DesignModel {
  final String id, name, category;
  final double priceMin, priceMax;
  final String? imageUrl;

  const DesignModel({
    required this.id, required this.name, required this.category,
    required this.priceMin, required this.priceMax, this.imageUrl,
  });

  factory DesignModel.fromJson(Map<String, dynamic> j) => DesignModel(
    id: j['id'], name: j['name'], category: j['category'],
    priceMin: (j['price_min'] as num).toDouble(),
    priceMax: (j['price_max'] as num).toDouble(),
    imageUrl: j['image_url'],
  );
}

// ── Search History ────────────────────────────────────────────────────────────
class SearchEntry {
  final String query, category;
  final DateTime createdAt;

  const SearchEntry({required this.query, required this.category, required this.createdAt});

  factory SearchEntry.fromJson(Map<String, dynamic> j) => SearchEntry(
    query: j['query'], category: j['category'] ?? 'General',
    createdAt: DateTime.parse(j['created_at']),
  );
}

class TrendingSearch {
  final String query;
  final int count;

  const TrendingSearch({required this.query, required this.count});

  factory TrendingSearch.fromJson(Map<String, dynamic> j) => TrendingSearch(
    query: j['query'], count: j['count'] ?? 0,
  );
}

// ── AI Design Studio ──────────────────────────────────────────────────────────
class DesignConcept {
  final String id, title, category, color, fabric;
  final String? imageUrl;

  const DesignConcept({
    required this.id, required this.title, required this.category,
    required this.color, required this.fabric, this.imageUrl,
  });

  factory DesignConcept.fromJson(Map<String, dynamic> j) => DesignConcept(
    id: j['id'], title: j['title'], category: j['category'],
    color: j['color'], fabric: j['fabric'], imageUrl: j['image_url'],
  );
}

// ── Virtual Try-On ────────────────────────────────────────────────────────────
class TryOnResult {
  final String id, garmentType, resultUrl;
  final String? command;
  final bool isSaved;
  final DateTime createdAt;

  const TryOnResult({
    required this.id, required this.garmentType, required this.resultUrl,
    required this.createdAt, this.command, this.isSaved = false,
  });

  factory TryOnResult.fromJson(Map<String, dynamic> j) => TryOnResult(
    id: j['id'], garmentType: j['garment_type'], resultUrl: j['result_url'] ?? '',
    command: j['command'], isSaved: j['is_saved'] ?? false,
    createdAt: DateTime.parse(j['created_at']),
  );
}

// ── Rider Profile ─────────────────────────────────────────────────────────────
class RiderProfile {
  final String id, name, phone, city;
  final String? assignedTailorId, assignedTailorName;
  final bool isVerified, isAvailable;
  final int totalDeliveries, monthDeliveries;
  final double rating;

  const RiderProfile({
    required this.id, required this.name, required this.phone, required this.city,
    required this.isVerified, required this.isAvailable,
    required this.totalDeliveries, required this.monthDeliveries, required this.rating,
    this.assignedTailorId, this.assignedTailorName,
  });

  factory RiderProfile.fromJson(Map<String, dynamic> j) => RiderProfile(
    id: j['id'], name: j['name'], phone: j['phone'], city: j['city'] ?? '',
    isVerified: j['is_verified'] ?? false, isAvailable: j['is_available'] ?? true,
    totalDeliveries: j['total_deliveries'] ?? 0,
    monthDeliveries: j['month_deliveries'] ?? 0,
    rating: ((j['rating'] ?? 0) as num).toDouble(),
    assignedTailorId: j['assigned_tailor_id'],
    assignedTailorName: j['assigned_tailor_name'],
  );
}

// ── Live Stream ───────────────────────────────────────────────────────────────
class LiveGift {
  final String name;
  final int amount, count;

  const LiveGift({required this.name, required this.amount, this.count = 0});

  factory LiveGift.fromJson(Map<String, dynamic> j) => LiveGift(
    name: j['name'], amount: j['amount'] ?? 0, count: j['count'] ?? 0,
  );
}

class LiveMessage {
  final String id, viewerName, text;
  final DateTime createdAt;

  const LiveMessage({
    required this.id, required this.viewerName, required this.text,
    required this.createdAt,
  });

  factory LiveMessage.fromJson(Map<String, dynamic> j) => LiveMessage(
    id: j['id'], viewerName: j['viewer_name'], text: j['text'] ?? '',
    createdAt: DateTime.parse(j['created_at']),
  );
}

class LiveStream {
  final String id, tailorId, title, category;
  final String status; // live, ended
  final bool giftsEnabled;
  final int viewers, peakViewers, likes, durationSeconds;
  final double earnings;
  final String? pinnedGarmentId;
  final DateTime startedAt;
  final List<LiveGift> gifts;

  const LiveStream({
    required this.id, required this.tailorId, required this.title,
    required this.category, required this.status, required this.startedAt,
    this.giftsEnabled = true, this.viewers = 0, this.peakViewers = 0,
    this.likes = 0, this.durationSeconds = 0, this.earnings = 0,
    this.pinnedGarmentId, this.gifts = const [],
  });

  factory LiveStream.fromJson(Map<String, dynamic> j) => LiveStream(
    id: j['id'], tailorId: j['tailor_id'], title: j['title'],
    category: j['category'], status: j['status'],
    startedAt: DateTime.parse(j['started_at']),
    giftsEnabled: j['gifts_enabled'] ?? true,
    viewers: j['viewers'] ?? 0, peakViewers: j['peak_viewers'] ?? 0,
    likes: j['likes'] ?? 0, durationSeconds: j['duration_seconds'] ?? 0,
    earnings: ((j['earnings'] ?? 0) as num).toDouble(),
    pinnedGarmentId: j['pinned_garment_id'],
    gifts: ((j['gifts'] ?? []) as List)
        .map((g) => LiveGift.fromJson(Map<String, dynamic>.from(g as Map)))
        .toList(),
  );

  LiveStream copyWith({
    String? status, int? viewers, int? peakViewers, int? likes,
    int? durationSeconds, double? earnings, String? pinnedGarmentId,
    List<LiveGift>? gifts,
  }) => LiveStream(
    id: id, tailorId: tailorId, title: title, category: category,
    status: status ?? this.status, startedAt: startedAt,
    giftsEnabled: giftsEnabled,
    viewers: viewers ?? this.viewers, peakViewers: peakViewers ?? this.peakViewers,
    likes: likes ?? this.likes,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    earnings: earnings ?? this.earnings,
    pinnedGarmentId: pinnedGarmentId ?? this.pinnedGarmentId,
    gifts: gifts ?? this.gifts,
  );
}
