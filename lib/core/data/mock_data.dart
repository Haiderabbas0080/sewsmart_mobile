// ─── Mock Data ────────────────────────────────────────────────────────────────
// Replace service calls with real API calls when backend is ready.

import '../models/app_models.dart';

class MockData {
  // ── Users ──────────────────────────────────────────────────────────────────
  static final List<UserModel> users = [
    UserModel(id: 'C001', name: 'Ayesha Khan', email: 'ayesha@email.com', phone: '0300-1234567', role: UserRole.customer, isVerified: true, city: 'Lahore', createdAt: DateTime(2025, 1, 15)),
    UserModel(id: 'C002', name: 'Sara Ahmed', email: 'sara@email.com', phone: '0301-2345678', role: UserRole.customer, isVerified: true, city: 'Karachi', createdAt: DateTime(2025, 2, 10)),
    UserModel(id: 'T001', name: 'Sana Fatima', email: 'sana@couture.com', phone: '0302-3456789', role: UserRole.tailor, isVerified: true, city: 'Lahore', createdAt: DateTime(2024, 11, 5)),
    UserModel(id: 'T002', name: 'Mehak Boutique', email: 'mehak@boutique.com', phone: '0303-4567890', role: UserRole.tailor, isVerified: true, city: 'Karachi', createdAt: DateTime(2024, 12, 1)),
    UserModel(id: 'R001', name: 'Ali Raza', email: 'ali@rider.com', phone: '0304-5678901', role: UserRole.rider, isVerified: true, city: 'Lahore', createdAt: DateTime(2025, 3, 1)),
  ];

  // ── Tailors ────────────────────────────────────────────────────────────────
  static final List<TailorModel> tailors = [
    TailorModel(id: 'T001', name: "Sana's Couture", category: 'Bridal', city: 'Lahore',
      bio: 'Expert in bridal and formal wear with 8+ years of experience.',
      userAvatar: 'S', rating: 4.9, priceFrom: 2500, totalOrders: 245,
      specialties: ['Bridal', 'Formal', 'Heavy Embroidery'], isVerified: true),
    TailorModel(id: 'T002', name: 'Mehak Boutique', category: 'Eastern', city: 'Karachi',
      bio: 'Specializing in eastern casual and party wear.',
      userAvatar: 'M', rating: 4.7, priceFrom: 1800, totalOrders: 183,
      specialties: ['Eastern', 'Casual', 'Party Wear'], isVerified: true),
    TailorModel(id: 'T003', name: 'Zara Stitching', category: 'Western', city: 'Islamabad',
      bio: 'Modern western and fusion designs.',
      userAvatar: 'Z', rating: 4.6, priceFrom: 1500, totalOrders: 120,
      specialties: ['Western', 'Fusion', 'Formal'], isVerified: true),
    TailorModel(id: 'T004', name: 'Nadia Creations', category: 'Bridal', city: 'Lahore',
      bio: 'Luxury bridal wear specialist.',
      userAvatar: 'N', rating: 4.8, priceFrom: 3000, totalOrders: 310,
      specialties: ['Bridal', 'Heavy Formals', 'Couture'], isVerified: true),
    TailorModel(id: 'T005', name: 'Farah Fashion', category: 'Casual', city: 'Faisalabad',
      bio: 'Affordable everyday stitching.',
      userAvatar: 'F', rating: 4.5, priceFrom: 1200, totalOrders: 98,
      specialties: ['Casual', 'Kids', 'Summer'], isVerified: false),
  ];

  // ── Orders ─────────────────────────────────────────────────────────────────
  static List<OrderModel> orders = [
    OrderModel(id: 'ORD001', customerId: 'C001', tailorId: 'T001', customerName: 'Ayesha Khan', tailorName: "Sana's Couture", garmentType: 'Bridal Lehenga', status: OrderStatus.inProgress, amount: 4500, measurements: '36-30-38', createdAt: DateTime.now().subtract(const Duration(days: 3)), hasDesignRef: true),
    OrderModel(id: 'ORD002', customerId: 'C001', tailorId: 'T002', customerName: 'Ayesha Khan', tailorName: 'Mehak Boutique', garmentType: 'Lawn Suit', status: OrderStatus.completed, amount: 2200, measurements: '34-28-36', createdAt: DateTime.now().subtract(const Duration(days: 12))),
    OrderModel(id: 'ORD003', customerId: 'C002', tailorId: 'T001', customerName: 'Sara Ahmed', tailorName: "Sana's Couture", garmentType: 'Formal Shirt', status: OrderStatus.pending, amount: 1800, measurements: '36-30-38', createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    OrderModel(id: 'ORD004', customerId: 'C002', tailorId: 'T003', customerName: 'Sara Ahmed', tailorName: 'Zara Stitching', garmentType: 'Party Dress', status: OrderStatus.readyForDelivery, amount: 3200, measurements: '32-26-34', createdAt: DateTime.now().subtract(const Duration(days: 7))),
  ];

  // ── Garment Pricing ────────────────────────────────────────────────────────
  static const List<GarmentPricing> garments = [
    GarmentPricing(garment: 'Shalwar Kameez', price: 1800, estimatedTime: '3-4 days'),
    GarmentPricing(garment: 'Bridal Lehenga', price: 5000, estimatedTime: '7-10 days'),
    GarmentPricing(garment: 'Formal Shirt', price: 1500, estimatedTime: '2-3 days'),
    GarmentPricing(garment: 'Lawn Suit', price: 2200, estimatedTime: '3-5 days'),
    GarmentPricing(garment: 'Party Dress', price: 3500, estimatedTime: '5-7 days'),
    GarmentPricing(garment: 'Abaya', price: 2800, estimatedTime: '4-5 days'),
    GarmentPricing(garment: 'Kurta', price: 1200, estimatedTime: '2-3 days'),
    GarmentPricing(garment: 'Kids Dress', price: 900, estimatedTime: '2-3 days'),
  ];

  // ── Notifications ──────────────────────────────────────────────────────────
  static List<NotificationModel> notifications = [
    NotificationModel(id: 'N001', title: 'Order Update', body: 'Your bridal lehenga is In Progress!', type: 'order', isRead: false, createdAt: DateTime.now().subtract(const Duration(minutes: 10))),
    NotificationModel(id: 'N002', title: 'Payment Confirmed', body: 'Rs 4,500 payment received for ORD001', type: 'payment', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    NotificationModel(id: 'N003', title: 'New Message', body: "Sana's Couture sent you a message", type: 'chat', isRead: true, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    NotificationModel(id: 'N004', title: 'Delivery Request', body: 'Your order ORD004 is ready. Set delivery schedule.', type: 'delivery', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 1))),
  ];

  // ── Reviews ────────────────────────────────────────────────────────────────
  static final List<ReviewModel> reviews = [
    ReviewModel(id: 'REV001', customerId: 'C001', tailorId: 'T001', customerName: 'Ayesha K.', comment: 'Amazing bridal work! Exactly as I imagined.', rating: 5.0, createdAt: DateTime.now().subtract(const Duration(days: 14))),
    ReviewModel(id: 'REV002', customerId: 'C002', tailorId: 'T001', customerName: 'Sara A.', comment: 'Very professional and on-time delivery.', rating: 4.5, createdAt: DateTime.now().subtract(const Duration(days: 20))),
    ReviewModel(id: 'REV003', customerId: 'C001', tailorId: 'T002', customerName: 'Hina M.', comment: 'Good quality, will order again.', rating: 4.0, createdAt: DateTime.now().subtract(const Duration(days: 30))),
  ];

  // ── Monthly Earnings ───────────────────────────────────────────────────────
  static const monthlyEarnings = [
    {'month': 'Jan', 'amount': 18500.0, 'orders': 8},
    {'month': 'Feb', 'amount': 22000.0, 'orders': 10},
    {'month': 'Mar', 'amount': 19800.0, 'orders': 9},
    {'month': 'Apr', 'amount': 27500.0, 'orders': 13},
    {'month': 'May', 'amount': 31200.0, 'orders': 15},
    {'month': 'Jun', 'amount': 28900.0, 'orders': 14},
  ];

  // ── Time Slots ─────────────────────────────────────────────────────────────
  static const timeSlots = ['9:00 AM - 11:00 AM', '11:00 AM - 1:00 PM', '2:00 PM - 4:00 PM', '4:00 PM - 6:00 PM', '6:00 PM - 8:00 PM'];
  static const categories = ['All', 'Bridal', 'Eastern', 'Western', 'Casual', 'Formal'];

  // ── Customer Search History ─────────────────────────────────────────────────
  // Each entry: query, customerName, category, hoursAgo (int)
  static List<Map<String, dynamic>> searchHistory = [
    {'query': 'Bridal Lehenga',          'customerName': 'Ayesha Khan', 'category': 'Bridal',   'hoursAgo': 1},
    {'query': 'Red embroidered dress',   'customerName': 'Sara Ahmed',  'category': 'Bridal',   'hoursAgo': 2},
    {'query': 'Shalwar Kameez formal',   'customerName': 'Ayesha Khan', 'category': 'Formal',   'hoursAgo': 3},
    {'query': 'Anarkali blue silk',      'customerName': 'Sara Ahmed',  'category': 'Eastern',  'hoursAgo': 4},
    {'query': 'Wedding outfit golden',   'customerName': 'Ayesha Khan', 'category': 'Bridal',   'hoursAgo': 5},
    {'query': 'Casual lawn summer suit', 'customerName': 'Sara Ahmed',  'category': 'Casual',   'hoursAgo': 6},
    {'query': 'Party wear short dress',  'customerName': 'Ayesha Khan', 'category': 'Western',  'hoursAgo': 8},
    {'query': 'Formal white kameez',     'customerName': 'Sara Ahmed',  'category': 'Formal',   'hoursAgo': 10},
    {'query': 'Kids frock pink',         'customerName': 'Ayesha Khan', 'category': 'Casual',   'hoursAgo': 12},
    {'query': 'Heavy embroidery set',    'customerName': 'Sara Ahmed',  'category': 'Bridal',   'hoursAgo': 14},
  ];

  /// Called from the customer search bar; inserts a new entry at the front.
  static void recordSearch(String query, {String customerName = 'Customer'}) {
    final q = query.trim();
    if (q.isEmpty) return;
    // Avoid exact duplicates recorded within the same session (hoursAgo == 0)
    searchHistory.removeWhere(
        (s) => (s['query'] as String).toLowerCase() == q.toLowerCase() && s['hoursAgo'] == 0);
    searchHistory.insert(0, {
      'query': q,
      'customerName': customerName,
      'category': _inferCategory(q),
      'hoursAgo': 0,
    });
  }

  static String _inferCategory(String q) {
    final lower = q.toLowerCase();
    if (lower.contains('bridal') || lower.contains('wedding') || lower.contains('lehenga')) {
      return 'Bridal';
    } else if (lower.contains('western') || lower.contains('dress') || lower.contains('jeans')) {
      return 'Western';
    } else if (lower.contains('formal') || lower.contains('kameez') || lower.contains('shalwar')) {
      return 'Formal';
    } else if (lower.contains('casual') || lower.contains('lawn') || lower.contains('kids')) {
      return 'Casual';
    } else if (lower.contains('anarkali') || lower.contains('eastern') || lower.contains('suit')) {
      return 'Eastern';
    }
    return 'General';
  }
}
