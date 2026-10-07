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

  // ── Tailor Price List ──────────────────────────────────────────────────────
  // The real API keeps one list per tailor. The mock shares one list.
  static final List<GarmentPricing> tailorGarments = [
    for (var i = 0; i < garments.length; i++)
      GarmentPricing(
        id: 'G00${i + 1}',
        garment: garments[i].garment,
        price: garments[i].price,
        estimatedTime: garments[i].estimatedTime,
      ),
  ];

  // ── Portfolio Samples ──────────────────────────────────────────────────────
  static final List<PortfolioItem> portfolio = [
    PortfolioItem(id: 'PF001', tailorId: 'T001', title: 'Royal Bridal Lehenga', imageUrl: '', createdAt: DateTime(2026, 5, 1)),
    PortfolioItem(id: 'PF002', tailorId: 'T001', title: 'Mehndi Outfit', imageUrl: '', createdAt: DateTime(2026, 5, 6)),
    PortfolioItem(id: 'PF003', tailorId: 'T001', title: 'Formal Embroidered Suit', imageUrl: '', createdAt: DateTime(2026, 5, 12)),
    PortfolioItem(id: 'PF004', tailorId: 'T001', title: 'Nikkah Dress', imageUrl: '', createdAt: DateTime(2026, 5, 18)),
    PortfolioItem(id: 'PF005', tailorId: 'T002', title: 'Printed Lawn Suit', imageUrl: '', createdAt: DateTime(2026, 5, 20)),
    PortfolioItem(id: 'PF006', tailorId: 'T002', title: 'Party Wear Anarkali', imageUrl: '', createdAt: DateTime(2026, 5, 24)),
  ];

  // ── Saved Measurements ─────────────────────────────────────────────────────
  static MeasurementModel? measurements = const MeasurementModel(
    unit: 'cm', height: 165, weight: 60, chest: 36, waist: 30, hips: 38,
    shoulder: 15, armLength: 24, inseam: 28, neck: 14, wrist: 6,
  );

  // ── Saved Payment Methods ──────────────────────────────────────────────────
  static List<SavedPaymentMethod> paymentMethods = [
    const SavedPaymentMethod(id: 'PM001', type: 'jazzCash', detail: '0301-2345678', accountName: 'Ayesha Khan', isDefault: true),
    const SavedPaymentMethod(id: 'PM002', type: 'cashOnDelivery', detail: ''),
  ];

  // ── Payout Accounts and Withdrawals ────────────────────────────────────────
  // The mock keeps one set. The real API returns the signed-in user's own.
  static List<PayoutAccount> payoutAccounts = [
    const PayoutAccount(id: 'PA001', type: 'bank', accountNumber: '0123-4567890', accountName: 'Shahid Tailor', bankName: 'HBL', isDefault: true),
  ];
  static const double availableBalance = 4200;
  static final List<WithdrawalModel> withdrawals = [
    WithdrawalModel(id: 'WD004', amount: 12400, status: 'paid', requestedAt: DateTime(2026, 5, 25), paidAt: DateTime(2026, 5, 26)),
    WithdrawalModel(id: 'WD003', amount: 9800, status: 'paid', requestedAt: DateTime(2026, 4, 27), paidAt: DateTime(2026, 4, 28)),
    WithdrawalModel(id: 'WD002', amount: 15200, status: 'paid', requestedAt: DateTime(2026, 3, 30), paidAt: DateTime(2026, 3, 31)),
    WithdrawalModel(id: 'WD001', amount: 7600, status: 'paid', requestedAt: DateTime(2026, 2, 23), paidAt: DateTime(2026, 2, 24)),
  ];

  // ── Chat Messages (by order id) ────────────────────────────────────────────
  static final Map<String, List<MessageModel>> messages = {
    'ORD001': [
      MessageModel(id: 'MSG001', senderId: 'C001', receiverId: 'T001', text: 'Hello! I wanted to check on my order ORD001.', type: MessageType.text, time: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)), isRead: true),
      MessageModel(id: 'MSG002', senderId: 'T001', receiverId: 'C001', text: 'Hi! Yes, I have started working on your ORD001. The fabric is cut and initial stitching is done.', type: MessageType.text, time: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)), isRead: true),
      MessageModel(id: 'MSG003', senderId: 'C001', receiverId: 'T001', text: 'That sounds great! When do you think it will be ready?', type: MessageType.text, time: DateTime.now().subtract(const Duration(hours: 2)), isRead: true),
      MessageModel(id: 'MSG004', senderId: 'T001', receiverId: 'C001', text: 'I estimate 3-4 more days. I will send you pictures once the main fitting is done.', type: MessageType.text, time: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)), isRead: true),
      MessageModel(id: 'MSG005', senderId: 'C001', receiverId: 'T001', text: 'Perfect, thank you so much!', type: MessageType.text, time: DateTime.now().subtract(const Duration(hours: 1, minutes: 45))),
    ],
  };

  // ── Design Catalogue (recommendations and wishlist) ────────────────────────
  static const List<DesignModel> designs = [
    DesignModel(id: 'D001', name: 'Heavy Bridal Lehenga', category: 'Bridal', priceMin: 4500, priceMax: 8000),
    DesignModel(id: 'D002', name: 'Embroidered Bridal Set', category: 'Bridal', priceMin: 5000, priceMax: 9000),
    DesignModel(id: 'D003', name: 'Silk Wedding Gown', category: 'Bridal', priceMin: 6000, priceMax: 12000),
    DesignModel(id: 'D004', name: 'Golden Nikkah Dress', category: 'Bridal', priceMin: 3500, priceMax: 6000),
    DesignModel(id: 'D005', name: 'Formal Shalwar Kameez', category: 'Formal', priceMin: 1800, priceMax: 3200),
    DesignModel(id: 'D006', name: 'Linen Executive Suit', category: 'Formal', priceMin: 2200, priceMax: 4000),
    DesignModel(id: 'D007', name: 'Classic Kurta Pajama', category: 'Formal', priceMin: 1500, priceMax: 2800),
    DesignModel(id: 'D008', name: 'Sherwani Set', category: 'Formal', priceMin: 4000, priceMax: 8000),
    DesignModel(id: 'D009', name: 'Long Anarkali Frock', category: 'Eastern', priceMin: 2500, priceMax: 4500),
    DesignModel(id: 'D010', name: 'Printed Georgette Suit', category: 'Eastern', priceMin: 1800, priceMax: 3000),
    DesignModel(id: 'D011', name: 'Floor-length Maxi', category: 'Eastern', priceMin: 2000, priceMax: 3800),
    DesignModel(id: 'D012', name: 'Cotton Palazzo Set', category: 'Eastern', priceMin: 1500, priceMax: 2500),
    DesignModel(id: 'D013', name: 'Lawn Summer Suit', category: 'Casual', priceMin: 1200, priceMax: 2000),
    DesignModel(id: 'D014', name: 'Casual Cotton Kameez', category: 'Casual', priceMin: 900, priceMax: 1500),
    DesignModel(id: 'D015', name: 'Kids Party Frock', category: 'Casual', priceMin: 800, priceMax: 1400),
    DesignModel(id: 'D016', name: 'Comfy Loungewear Set', category: 'Casual', priceMin: 1100, priceMax: 1800),
    DesignModel(id: 'D017', name: 'Party Wear Short Dress', category: 'Western', priceMin: 2000, priceMax: 4000),
    DesignModel(id: 'D018', name: 'Formal Blazer & Trousers', category: 'Western', priceMin: 3500, priceMax: 6000),
    DesignModel(id: 'D019', name: 'Flared Midi Dress', category: 'Western', priceMin: 2200, priceMax: 3800),
    DesignModel(id: 'D020', name: 'Denim Jacket Set', category: 'Western', priceMin: 1800, priceMax: 3000),
    DesignModel(id: 'D021', name: 'Embroidered Suit', category: 'General', priceMin: 2000, priceMax: 4000),
    DesignModel(id: 'D022', name: 'Printed Lawn Pair', category: 'General', priceMin: 1200, priceMax: 2200),
    DesignModel(id: 'D023', name: 'Festive Sharara', category: 'General', priceMin: 3000, priceMax: 5500),
    DesignModel(id: 'D024', name: 'Classic Kameez', category: 'General', priceMin: 1000, priceMax: 1800),
  ];
  static final List<String> wishlist = ['D001', 'D009', 'D017'];

  /// Design category that matches a search, as the recommendations screen groups them.
  static String designCategoryFor(String query) {
    final q = query.toLowerCase();
    if (q.contains('bridal') || q.contains('wedding') || q.contains('lehenga') || q.contains('nikkah')) {
      return 'Bridal';
    } else if (q.contains('shalwar') || q.contains('kameez') || q.contains('kurta') || q.contains('formal')) {
      return 'Formal';
    } else if (q.contains('anarkali') || q.contains('eastern') || q.contains('suit') || q.contains('maxi')) {
      return 'Eastern';
    } else if (q.contains('casual') || q.contains('lawn') || q.contains('summer') || q.contains('kids')) {
      return 'Casual';
    } else if (q.contains('party') || q.contains('western') || q.contains('dress') || q.contains('short')) {
      return 'Western';
    }
    return 'General';
  }

  // ── Live Stream ────────────────────────────────────────────────────────────
  static LiveStream? liveStream;
  static final List<LiveMessage> liveMessages = [
    LiveMessage(id: 'LM001', viewerName: 'Fatima K.', text: 'Mashallah so beautiful work!', createdAt: DateTime.now().subtract(const Duration(seconds: 40))),
    LiveMessage(id: 'LM002', viewerName: 'Zara M.', text: 'Can you make this for me?', createdAt: DateTime.now().subtract(const Duration(seconds: 25))),
    LiveMessage(id: 'LM003', viewerName: 'Sana A.', text: 'How much does this cost?', createdAt: DateTime.now().subtract(const Duration(seconds: 10))),
  ];
  static const List<LiveGift> giftTypes = [
    LiveGift(name: 'Star', amount: 10),
    LiveGift(name: 'Rose', amount: 50),
    LiveGift(name: 'Diamond', amount: 100),
    LiveGift(name: 'Crown', amount: 500),
  ];

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
