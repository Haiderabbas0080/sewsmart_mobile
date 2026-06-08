import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/data/mock_data.dart';
import '../services/tailor_service.dart';
import 'incoming_orders_screen.dart';
import 'order_detail_screen.dart';
import 'add_rider_screen.dart';
import 'tailor_notifications_screen.dart';
import 'tailor_profile_manage_screen.dart';
import 'tailor_live_screen.dart';
import 'tailor_payment_screen.dart';

class TailorDashboardScreen extends StatefulWidget {
  const TailorDashboardScreen({super.key});

  @override
  State<TailorDashboardScreen> createState() => _TailorDashboardScreenState();
}

class _TailorDashboardScreenState extends State<TailorDashboardScreen> {
  List<OrderModel> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final orders = await TailorService().getOrders('T001');
    if (mounted) {
      setState(() {
        _orders = orders;
        _loading = false;
      });
    }
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  int get _pendingCount => _orders.where((o) => o.status == OrderStatus.pending).length;
  int get _inProgressCount => _orders.where((o) => o.status == OrderStatus.inProgress || o.status == OrderStatus.accepted).length;
  double get _thisMonthEarnings {
    return MockData.monthlyEarnings.isNotEmpty
        ? (MockData.monthlyEarnings.last['amount'] as double)
        : 0.0;
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return AppColors.warning;
      case OrderStatus.accepted: return AppColors.info;
      case OrderStatus.inProgress: return AppColors.info;
      case OrderStatus.qualityCheck: return AppColors.primary;
      case OrderStatus.readyForDelivery: return AppColors.teal;
      case OrderStatus.completed: return AppColors.success;
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final tailor = MockData.tailors.firstWhere(
      (t) => t.id == 'T001',
      orElse: () => MockData.tailors.first,
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.tealOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.tealLight,
            backgroundColor: AppColors.card,
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(user, tailor),
                  const SizedBox(height: 16),
                  if (!_loading && _pendingCount > 0) _buildPendingBanner(),
                  const SizedBox(height: 20),
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: AppColors.tealLight, strokeWidth: 2),
                      ),
                    )
                  else ...[
                    _buildMetricGrid(),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildRecentOrders(context),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel? user, dynamic tailor) {
    return Row(
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
                tailor.name,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TailorNotificationsScreen()),
          ),
          child: Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 20),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
          ),
          child: Center(
            child: Text(
              'S',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$_pendingCount new order${_pendingCount > 1 ? 's' : ''} waiting!',
              style: GoogleFonts.poppins(color: AppColors.warning, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IncomingOrdersScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'View',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricGrid() {
    final metrics = [
      {
        'label': 'New Orders',
        'value': '$_pendingCount',
        'icon': Icons.inbox_rounded,
        'color': AppColors.warning,
      },
      {
        'label': 'In Progress',
        'value': '$_inProgressCount',
        'icon': Icons.pending_actions_rounded,
        'color': AppColors.info,
      },
      {
        'label': 'This Month',
        'value': 'Rs ${_thisMonthEarnings.toInt()}',
        'icon': Icons.payments_rounded,
        'color': AppColors.success,
      },
      {
        'label': 'Rating',
        'value': '4.9',
        'icon': Icons.star_rounded,
        'color': AppColors.gold,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: metrics.map((m) => MetricCard(
        label: m['label'] as String,
        value: m['value'] as String,
        icon: m['icon'] as IconData,
        color: m['color'] as Color,
      )).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.directions_bike_rounded,
        'label': 'Add Rider',
        'gradient': [AppColors.riderColor, const Color(0xFFF97316)],
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRiderScreen())),
      },
      {
        'icon': Icons.photo_library_rounded,
        'label': 'Samples',
        'gradient': [AppColors.primary, AppColors.primaryLight],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TailorProfileManageScreen()),
            ),
      },
      {
        'icon': Icons.live_tv_rounded,
        'label': 'Live',
        'gradient': [AppColors.error, Color(0xFFF87171)],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TailorLiveScreen()),
            ),
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'label': 'Payments',
        'gradient': [AppColors.teal, AppColors.tealLight],
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TailorPaymentScreen()),
            ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: actions.asMap().entries.map((entry) {
            final i = entry.key;
            final a = entry.value;
            final gradient = a['gradient'] as List<Color>;
            return Expanded(
              child: GestureDetector(
                onTap: a['onTap'] as VoidCallback,
                child: Container(
                  margin: EdgeInsets.only(right: i < actions.length - 1 ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient.map((c) => c.withValues(alpha: 0.18)).toList(),
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: gradient.first.withValues(alpha: 0.35)),
                  ),
                  child: Column(
                    children: [
                      Icon(a['icon'] as IconData, color: gradient.first, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        a['label'] as String,
                        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    final recent = _orders.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Orders',
          action: 'View All',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IncomingOrdersScreen()),
          ),
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          const EmptyState(icon: Icons.receipt_long_rounded, title: 'No orders yet')
        else
          ...recent.map((order) => _OrderCard(
            order: order,
            statusColor: _statusColor(order.status),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
            ),
          )),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;
  final VoidCallback onTap;
  const _OrderCard({required this.order, required this.statusColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.checkroom_rounded, color: AppColors.tealLight, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.garmentType,
                  style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  order.customerName,
                  style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 11),
                ),
                Text(
                  'Rs ${order.amount.toInt()}',
                  style: GoogleFonts.poppins(color: AppColors.tealLight, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          StatusBadge(label: order.statusLabel, color: statusColor),
        ],
      ),
    );
  }
}
