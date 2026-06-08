import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../services/rider_service.dart';

class RiderEarningsScreen extends StatefulWidget {
  const RiderEarningsScreen({super.key});

  @override
  State<RiderEarningsScreen> createState() => _RiderEarningsScreenState();
}

class _RiderEarningsScreenState extends State<RiderEarningsScreen> {
  Map<String, dynamic>? _earnings;
  List<OrderModel> _deliveries = [];
  bool _loading = true;
  bool _withdrawing = false;

  final List<Map<String, dynamic>> _weeklyData = [
    {'day': 'Mon', 'deliveries': 4},
    {'day': 'Tue', 'deliveries': 6},
    {'day': 'Wed', 'deliveries': 3},
    {'day': 'Thu', 'deliveries': 7},
    {'day': 'Fri', 'deliveries': 8},
    {'day': 'Sat', 'deliveries': 5},
    {'day': 'Sun', 'deliveries': 2},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final earnings = await RiderService().getEarnings('R001');
    final deliveries = await RiderService().getAssignedDeliveries('R001');
    if (mounted) {
      setState(() {
        _earnings = earnings;
        _deliveries = deliveries;
        _loading = false;
      });
    }
  }

  Future<void> _handleWithdraw() async {
    setState(() => _withdrawing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _withdrawing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Withdrawal request submitted!', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.success,
        ),
      );
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
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.riderColor, strokeWidth: 2),
                )
              : Column(
                  children: [
                    const SewAppBar(title: 'Earnings'),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryCard(),
                            const SizedBox(height: 20),
                            _buildMetricGrid(),
                            const SizedBox(height: 24),
                            _buildBarChart(),
                            const SizedBox(height: 24),
                            _buildDeliveryHistory(),
                            const SizedBox(height: 24),
                            GradientButton(
                              text: 'Withdraw Earnings',
                              colors: const [AppColors.riderColor, Color(0xFFF97316)],
                              loading: _withdrawing,
                              onTap: _handleWithdraw,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final total = _earnings?['total'] as double? ?? 0;
    final thisMonth = _earnings?['thisMonth'] as double? ?? 0;
    final totalDeliveries = _earnings?['totalDeliveries'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.riderColor, Color(0xFFC2410C)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.riderColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings',
            style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Rs ${total.toInt()}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Rs ${thisMonth.toInt()}',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'This Month',
                      style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.7), fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.25)),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$totalDeliveries',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Total Deliveries',
                      style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.7), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricGrid() {
    final pending = _earnings?['pending'] as double? ?? 0;
    final thisMonthDel = _earnings?['thisMonthDeliveries'] as int? ?? 0;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        MetricCard(
          label: 'Pending Payout',
          value: 'Rs ${pending.toInt()}',
          icon: Icons.pending_rounded,
          color: AppColors.warning,
        ),
        MetricCard(
          label: 'This Month',
          value: '$thisMonthDel deliveries',
          icon: Icons.local_shipping_rounded,
          color: AppColors.info,
        ),
        MetricCard(
          label: 'Avg Per Delivery',
          value: 'Rs 289',
          icon: Icons.payments_rounded,
          color: AppColors.success,
        ),
        MetricCard(
          label: 'Rating',
          value: '4.8',
          icon: Icons.star_rounded,
          color: AppColors.gold,
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    final maxVal = _weeklyData
        .map((d) => d['deliveries'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Deliveries',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 14),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          child: SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal + 2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.card,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      '${rod.toY.toInt()} deliveries',
                      GoogleFonts.poppins(color: AppColors.riderColor, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _weeklyData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _weeklyData[idx]['day'] as String,
                            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.divider,
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _weeklyData.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;
                  final isToday = i == 4;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (d['deliveries'] as int).toDouble(),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isToday
                              ? [AppColors.riderColor, const Color(0xFFF97316)]
                              : [
                                  AppColors.riderColor.withValues(alpha: 0.4),
                                  AppColors.riderColor.withValues(alpha: 0.6),
                                ],
                        ),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery History',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        if (_deliveries.isEmpty)
          const EmptyState(icon: Icons.history_rounded, title: 'No deliveries yet')
        else
          ..._deliveries.map((order) => _DeliveryHistoryRow(order: order)),
      ],
    );
  }
}

class _DeliveryHistoryRow extends StatelessWidget {
  final OrderModel order;
  const _DeliveryHistoryRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.status == OrderStatus.completed || order.status == OrderStatus.delivered;
    final color = isCompleted ? AppColors.success : AppColors.warning;
    final icon = isCompleted ? Icons.check_circle_rounded : Icons.local_shipping_rounded;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
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
                    fontSize: 12,
                  ),
                ),
                Text(
                  order.customerName,
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs 300',
                style: GoogleFonts.poppins(
                  color: AppColors.riderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                order.statusLabel,
                style: GoogleFonts.poppins(color: color, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
