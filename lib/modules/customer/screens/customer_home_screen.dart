import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/auth_service.dart';
import '../services/customer_service.dart';
import 'browse_tailors_screen.dart';
import 'tailor_profile_screen.dart';
import 'order_tracking_screen.dart';
import 'order_history_screen.dart';
import 'notifications_screen.dart';
import 'virtual_tryon_screen.dart';
import 'customer_ai_recommendations_screen.dart';
import 'measure_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<TailorModel> _tailors = [];
  List<OrderModel> _orders = [];
  int _unreadNotifications = 0;
  bool _loadingTailors = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = AuthService().currentUser;
    if (user == null) return;
    final tailors = await CustomerService().getTailors();
    final orders = await CustomerService().getMyOrders(user.id);
    final notifications = await CustomerService().getNotifications(user.id);
    if (mounted) {
      setState(() {
        _tailors = tailors;
        _orders = orders;
        _unreadNotifications = notifications.where((n) => !n.isRead).length;
        _loadingTailors = false;
      });
    }
  }

  OrderModel? get _activeOrder {
    try {
      return _orders.firstWhere((o) =>
        o.status == OrderStatus.inProgress || o.status == OrderStatus.accepted || o.status == OrderStatus.qualityCheck
      );
    } catch (_) {
      return null;
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final firstName = user?.name.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.purpleOrb,
        orb2: AppColors.pinkOrb,
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primaryLight,
            backgroundColor: AppColors.card,
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(firstName),
                  _buildSearchBar(),
                  _buildFeatureTiles(),
                  _buildPromoBanner(),
                  if (_activeOrder != null) _buildActiveOrderCard(_activeOrder!),
                  _buildTopTailors(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String firstName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting,',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
                ),
                Text(
                  firstName,
                  style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            child: Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                ),
                if (_unreadNotifications > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bg, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '$_unreadNotifications',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BrowseTailorsScreen())),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: [BoxShadow(color: AppColors.purpleOrb.withValues(alpha: 0.3), blurRadius: 12)],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.teal]),
              ),
              child: const Icon(Icons.search_rounded, color: Colors.white, size: 15),
            ),
            const SizedBox(width: 12),
            Text('Search tailors, styles...', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTiles() {
    final tiles = [
      {
        'icon': Icons.recommend_rounded,
        'label': 'AI Recs',
        'gradient': [AppColors.primary, const Color(0xFFA855F7)],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CustomerAiRecommendationsScreen()),
            ),
      },
      {
        'icon': Icons.view_in_ar_rounded,
        'label': 'Try-On',
        'gradient': [AppColors.teal, AppColors.tealLight],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VirtualTryOnScreen()),
            ),
      },
      {
        'icon': Icons.straighten_rounded,
        'label': 'Measure',
        'gradient': [AppColors.secondary, const Color(0xFFEC4899)],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MeasureScreen()),
            ),
      },
      {
        'icon': Icons.receipt_long_rounded,
        'label': 'My Orders',
        'gradient': [AppColors.warning, AppColors.gold],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: tiles.asMap().entries.map((entry) {
              final tile = entry.value;
              return Expanded(
                child: GestureDetector(
                  onTap: tile['onTap'] as VoidCallback,
                  child: Container(
                    margin: EdgeInsets.only(right: entry.key < tiles.length - 1 ? 10 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: (tile['gradient'] as List<Color>).map((c) => c.withValues(alpha: 0.18)).toList(),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: (tile['gradient'] as List<Color>).first.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(tile['icon'] as IconData, color: (tile['gradient'] as List<Color>).first, size: 26),
                        const SizedBox(height: 6),
                        Text(tile['label'] as String, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFFBE185D), Color(0xFFEA580C)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text('LIMITED OFFER', style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                const SizedBox(height: 8),
                Text('Eid Special', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('20% off on all bridal orders', style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Text('Book Now', style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text('Active Order', style: GoogleFonts.poppins(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
              const Spacer(),
              StatusBadge(label: order.statusLabel, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 10),
          Text(order.garmentType, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          Text(order.tailorName, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order))),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text('Track Order', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTailors() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Top Rated Tailors',
            action: 'See All',
            onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BrowseTailorsScreen())),
          ),
          const SizedBox(height: 14),
          if (_loadingTailors)
            const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator(color: AppColors.primaryLight, strokeWidth: 2)))
          else
            ..._tailors.take(4).map((tailor) => _TailorListCard(tailor: tailor)),
        ],
      ),
    );
  }
}

class _TailorListCard extends StatelessWidget {
  final TailorModel tailor;
  const _TailorListCard({required this.tailor});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TailorProfileScreen(tailor: tailor))),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.teal]),
            ),
            child: Center(
              child: Text(tailor.userAvatar, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(tailor.name, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    if (tailor.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: AppColors.info, size: 14),
                    ],
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 12),
                    const SizedBox(width: 2),
                    Text(tailor.city, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(width: 8),
                    StarRating(rating: tailor.rating, size: 11),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: tailor.specialties.take(2).map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: Text(s, style: GoogleFonts.poppins(color: AppColors.primaryLight, fontSize: 9)),
                  )).toList(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Rs ${tailor.priceFrom.toInt()}+', style: GoogleFonts.poppins(color: AppColors.primaryLight, fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Book', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
