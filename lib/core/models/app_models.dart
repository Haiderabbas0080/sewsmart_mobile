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

  const TailorModel({
    required this.id, required this.name, required this.category,
    required this.city, required this.bio, required this.userAvatar,
    required this.rating, required this.priceFrom, required this.totalOrders,
    required this.specialties, required this.isVerified, this.portfolio = const [],
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
}

// ── Garment Pricing ───────────────────────────────────────────────────────────
class GarmentPricing {
  final String garment, estimatedTime;
  final double price;
  const GarmentPricing({required this.garment, required this.price, required this.estimatedTime});
}
