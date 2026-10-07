class PlatformStats {
  final int totalUsers;
  final int totalOrders;
  final double totalRevenue;
  final int activeOrders;
  final int pendingVerifications;
  final int registeredTailors;
  final int activeRiders;
  final int openDisputes;
  final double thisMonthRevenue;
  final double lastMonthRevenue;
  final double averageTailorRating;

  const PlatformStats({
    required this.totalUsers,
    required this.totalOrders,
    required this.totalRevenue,
    required this.activeOrders,
    required this.pendingVerifications,
    required this.registeredTailors,
    required this.activeRiders,
    required this.openDisputes,
    required this.thisMonthRevenue,
    required this.lastMonthRevenue,
    required this.averageTailorRating,
  });
}

class MonthlyRevenue {
  final String month;
  final double revenue;

  const MonthlyRevenue({required this.month, required this.revenue});
}

class CategoryRevenue {
  final String category;
  final double amount;
  final int color;

  const CategoryRevenue({
    required this.category,
    required this.amount,
    required this.color,
  });
}

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String role;
  String status;
  final String joinDate;
  final int totalOrders;
  final double totalSpent;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.role,
    required this.status,
    required this.joinDate,
    required this.totalOrders,
    required this.totalSpent,
  });
}

class AdminTailor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String category;
  String status;
  final bool isVerified;
  final String joinDate;
  final int totalOrders;
  final double rating;
  final double revenue;

  AdminTailor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.category,
    required this.status,
    required this.isVerified,
    required this.joinDate,
    required this.totalOrders,
    required this.rating,
    required this.revenue,
  });
}

class AdminRider {
  final String id;
  final String name;
  final String phone;
  final String city;
  final String assignedTailorId;
  final String assignedTailorName;
  String status;
  final bool isVerified;
  final String joinDate;
  final int totalDeliveries;
  final double rating;

  AdminRider({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.assignedTailorId,
    required this.assignedTailorName,
    required this.status,
    required this.isVerified,
    required this.joinDate,
    required this.totalDeliveries,
    required this.rating,
  });
}

class PendingVerification {
  final String id;
  final String name;
  final String phone;
  final String city;
  final String role;
  final String submittedDate;
  String status;
  final bool documentsSubmitted;

  PendingVerification({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.role,
    required this.submittedDate,
    required this.status,
    required this.documentsSubmitted,
  });
}

class AdminOrder {
  final String id;
  final String customerId;
  final String customerName;
  final String tailorId;
  final String tailorName;
  final String garment;
  final double amount;
  String status;
  final String date;
  final String city;

  AdminOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.tailorId,
    required this.tailorName,
    required this.garment,
    required this.amount,
    required this.status,
    required this.date,
    required this.city,
  });
}

class AdminPayment {
  final String id;
  final String orderId;
  final String customerName;
  final String tailorName;
  final double amount;
  final String method;
  final String status;
  final String date;

  const AdminPayment({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.tailorName,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
  });
}

class AdminDispute {
  final String id;
  final String orderId;
  final String customerName;
  final String tailorName;
  final String issue;
  final double amount;
  final String dateRaised;
  String status;
  String? resolution;

  AdminDispute({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.tailorName,
    required this.issue,
    required this.amount,
    required this.dateRaised,
    required this.status,
    this.resolution,
  });
}

class TopTailor {
  final String id;
  final String name;
  final String city;
  final int orders;
  final double rating;
  final double revenue;
  final double completionRate;

  const TopTailor({
    required this.id,
    required this.name,
    required this.city,
    required this.orders,
    required this.rating,
    required this.revenue,
    required this.completionRate,
  });
}

class ContentItem {
  final String id;
  final String creator;
  final String title;
  final String type;
  String status;
  final String date;

  ContentItem({
    required this.id,
    required this.creator,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
  });
}

class ReviewItem {
  final String id;
  final String customer;
  final String tailor;
  final int rating;
  final String comment;
  final String date;
  String status;

  ReviewItem({
    required this.id,
    required this.customer,
    required this.tailor,
    required this.rating,
    required this.comment,
    required this.date,
    required this.status,
  });
}

class FlaggedItem {
  final String id;
  final String reporter;
  final String reportedItem;
  final String reason;
  final String date;
  String status;

  FlaggedItem({
    required this.id,
    required this.reporter,
    required this.reportedItem,
    required this.reason,
    required this.date,
    required this.status,
  });
}

class AdminAuthResult {
  final bool success;
  final String? token;
  final String? name;
  final String? email;
  final String? error;

  const AdminAuthResult({
    required this.success,
    this.token,
    this.name,
    this.email,
    this.error,
  });
}

class PaymentSummary {
  final double totalRevenue;
  final double thisMonth;
  final double pending;
  final double refunded;

  const PaymentSummary({
    required this.totalRevenue,
    required this.thisMonth,
    required this.pending,
    required this.refunded,
  });
}

class AdminReport {
  final String range;
  final PlatformStats stats;
  final List<MonthlyRevenue> monthlyRevenue;
  final List<CategoryRevenue> revenueByCategory;
  final List<TopTailor> topTailors;
  final Map<String, int> orderStatusDistribution;

  const AdminReport({
    required this.range,
    required this.stats,
    required this.monthlyRevenue,
    required this.revenueByCategory,
    required this.topTailors,
    required this.orderStatusDistribution,
  });
}

class AdminSettings {
  double commissionRate;
  final List<String> categories;
  bool notifyNewOrder;
  bool notifyOrderComplete;
  bool notifyNewVerification;
  bool notifyDispute;
  bool notifyPayment;
  bool notifyMarketing;
  bool twoFaEnabled;
  int sessionTimeout;

  AdminSettings({
    required this.commissionRate,
    required this.categories,
    required this.notifyNewOrder,
    required this.notifyOrderComplete,
    required this.notifyNewVerification,
    required this.notifyDispute,
    required this.notifyPayment,
    required this.notifyMarketing,
    required this.twoFaEnabled,
    required this.sessionTimeout,
  });
}
