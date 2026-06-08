import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../services/rider_service.dart';
import 'delivery_detail_screen.dart';
import 'rider_notifications_screen.dart';

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  List<OrderModel> _deliveries = [];
  bool _loading = true;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final deliveries = await RiderService().getAssignedDeliveries('R001');
    if (mounted) {
      setState(() {
        _deliveries = deliveries;
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

  int get _completedToday => _deliveries
      .where((d) => d.status == OrderStatus.delivered || d.status == OrderStatus.completed)
      .length;

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.readyForDelivery:
        return AppColors.warning;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.completed:
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.orangeOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.riderColor,
            backgroundColor: AppColors.card,
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildStatusToggle(),
                  const SizedBox(height: 20),
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: AppColors.riderColor, strokeWidth: 2),
                      ),
                    )
                  else ...[
                    _buildMetricGrid(),
                    const SizedBox(height: 24),
                    _buildDeliveriesList(),
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

  Widget _buildHeader() {
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
                'Ali Raza',
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RiderNotificationsScreen()),
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
                    child: Text('2', style: GoogleFonts.poppins(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
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
            gradient: LinearGradient(colors: [AppColors.riderColor, Color(0xFFF97316)]),
          ),
          child: Center(
            child: Text(
              'A',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusToggle() {
    return GlassCard(
      borderColor: _isAvailable
          ? AppColors.success.withValues(alpha: 0.4)
          : AppColors.riderColor.withValues(alpha: 0.4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _isAvailable ? AppColors.success : AppColors.riderColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isAvailable ? AppColors.success : AppColors.riderColor).withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAvailable ? 'Available' : 'Busy',
                  style: GoogleFonts.poppins(
                    color: _isAvailable ? AppColors.success : AppColors.riderColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _isAvailable
                      ? 'Ready to receive delivery tasks'
                      : 'Currently on a delivery',
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            onChanged: (v) => setState(() => _isAvailable = v),
            activeColor: AppColors.success,
            inactiveThumbColor: AppColors.riderColor,
            inactiveTrackColor: AppColors.riderColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricGrid() {
    final metrics = [
      {
        'label': "Today's Deliveries",
        'value': '${_deliveries.length}',
        'icon': Icons.local_shipping_rounded,
        'color': AppColors.info,
      },
      {
        'label': 'Completed',
        'value': '$_completedToday',
        'icon': Icons.check_circle_rounded,
        'color': AppColors.success,
      },
      {
        'label': "Today's Earnings",
        'value': 'Rs 850',
        'icon': Icons.payments_rounded,
        'color': AppColors.gold,
      },
      {
        'label': 'Rating',
        'value': '4.8',
        'icon': Icons.star_rounded,
        'color': AppColors.primary,
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

  Widget _buildDeliveriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Assigned Deliveries'),
        const SizedBox(height: 12),
        if (_deliveries.isEmpty)
          const EmptyState(
            icon: Icons.local_shipping_outlined,
            title: 'No deliveries assigned',
            subtitle: 'New tasks will appear here',
          )
        else
          ..._deliveries.map((order) => _DeliveryCard(
            order: order,
            statusColor: _statusColor(order.status),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DeliveryDetailScreen(order: order)),
            ),
          )),
      ],
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;
  final VoidCallback onTap;
  const _DeliveryCard({required this.order, required this.statusColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.riderColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_shipping_rounded, color: AppColors.riderColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.garmentType,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      order.customerName,
                      style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: order.statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.textMuted, size: 13),
              const SizedBox(width: 4),
              Text(
                order.id,
                style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.schedule_rounded, color: AppColors.textMuted, size: 13),
              const SizedBox(width: 4),
              Text(
                order.scheduledDelivery != null
                    ? '${order.scheduledDelivery!.day}/${order.scheduledDelivery!.month}'
                    : 'TBD',
                style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.riderColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'View Details',
                  style: GoogleFonts.poppins(
                    color: AppColors.riderColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
