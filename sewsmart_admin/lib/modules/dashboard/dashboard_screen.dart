import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/admin_theme.dart';
import '../../core/widgets/admin_widgets.dart';
import '../../core/data/admin_mock_data.dart';
import '../../core/services/admin_service.dart';
import '../../core/models/admin_models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _service = AdminService();
  PlatformStats? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _service.getStats();
    if (mounted) setState(() => _stats = stats);
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats ?? AdminMockData.platformStats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PageHeader(
            title: 'Dashboard',
            subtitle: 'Welcome back, Admin! Here\'s what\'s happening today.',
            action: AdminButton(
              label: 'Refresh',
              icon: Icons.refresh_rounded,
              onPressed: _loadStats,
              isSmall: true,
            ),
          ),
          const SizedBox(height: 24),

          // Row 1: 4 stat cards
          _StatsRow1(stats: stats, fmt: _fmt),
          const SizedBox(height: 16),

          // Row 2: 3 more stat cards
          _StatsRow2(stats: stats),
          const SizedBox(height: 24),

          // Revenue Chart
          _RevenueChart(),
          const SizedBox(height: 24),

          // Recent Orders + Top Tailors
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _RecentOrdersCard()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _TopTailorsCard()),
            ],
          ),
          const SizedBox(height: 24),

          // Pending Verifications
          _PendingVerificationsCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatsRow1 extends StatelessWidget {
  final PlatformStats stats;
  final String Function(double) fmt;
  const _StatsRow1({required this.stats, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.people_rounded,
            iconColor: AdminColors.customerColor,
            value: '${stats.totalUsers}',
            label: 'Total Users',
            changeText: '+12%',
            isPositiveChange: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.receipt_long_rounded,
            iconColor: AdminColors.info,
            value: '${stats.activeOrders}',
            label: 'Active Orders',
            changeText: '+8%',
            isPositiveChange: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.payments_rounded,
            iconColor: AdminColors.success,
            value: 'Rs. ${fmt(stats.thisMonthRevenue)}',
            label: 'Revenue This Month',
            changeText: '+13%',
            isPositiveChange: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.pending_actions_rounded,
            iconColor: AdminColors.warning,
            value: '${stats.pendingVerifications}',
            label: 'Pending Verifications',
            changeText: '+2',
            isPositiveChange: false,
          ),
        ),
      ],
    );
  }
}

class _StatsRow2 extends StatelessWidget {
  final PlatformStats stats;
  const _StatsRow2({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.design_services_rounded,
            iconColor: AdminColors.tailorColor,
            value: '${stats.registeredTailors}',
            label: 'Registered Tailors',
            changeText: '+5%',
            isPositiveChange: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.delivery_dining_rounded,
            iconColor: AdminColors.riderColor,
            value: '${stats.activeRiders}',
            label: 'Active Riders',
            changeText: '+3%',
            isPositiveChange: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.gavel_rounded,
            iconColor: AdminColors.error,
            value: '${stats.openDisputes}',
            label: 'Open Disputes',
            changeText: '-1',
            isPositiveChange: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            icon: Icons.star_rounded,
            iconColor: AdminColors.warning,
            value: '4.6',
            label: 'Avg. Tailor Rating',
            changeText: '+0.2',
            isPositiveChange: true,
          ),
        ),
      ],
    );
  }
}

class _RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = AdminMockData.monthlyRevenue;
    final maxY = data.map((d) => d.revenue).reduce((a, b) => a > b ? a : b) * 1.2;

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Revenue Overview',
            action: AdminBadge(
              label: 'Last 6 Months',
              color: AdminColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AdminColors.border,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        final label = value >= 1000
                            ? '${(value / 1000).toStringAsFixed(0)}K'
                            : value.toStringAsFixed(0);
                        return Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AdminColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            data[idx].month,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (i) => FlSpot(i.toDouble(), data[i].revenue),
                    ),
                    isCurved: true,
                    color: AdminColors.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: AdminColors.primary,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AdminColors.primary.withOpacity(0.18),
                          AdminColors.primary.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = AdminMockData.orders.take(5).toList();
    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SectionTitle(
              title: 'Recent Orders',
              action: TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AdminColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AdminColors.border),
          TableHeader(
            columns: const ['ORDER ID', 'CUSTOMER', 'TAILOR', 'AMOUNT', 'STATUS'],
            flexValues: const [1.5, 2, 2, 1.5, 1.5],
          ),
          ...orders.map(
            (o) => Column(
              children: [
                AdminRow(
                  cells: [
                    Text(o.id,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AdminColors.primary)),
                    Text(o.customerName,
                        style: GoogleFonts.poppins(fontSize: 12)),
                    Text(o.tailorName,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AdminColors.textSecondary),
                        overflow: TextOverflow.ellipsis),
                    Text('Rs. ${o.amount.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    statusBadge(o.status),
                  ],
                  flexValues: const [1.5, 2, 2, 1.5, 1.5],
                ),
                const Divider(height: 1, color: AdminColors.border),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTailorsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tailors = AdminMockData.topTailors.take(5).toList();
    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: SectionTitle(title: 'Top Tailors'),
          ),
          const Divider(height: 1, color: AdminColors.border),
          ...tailors.asMap().entries.map(
            (e) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: e.key == 0
                              ? AdminColors.warning.withOpacity(0.15)
                              : AdminColors.bg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '#${e.key + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: e.key == 0
                                  ? AdminColors.warning
                                  : AdminColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AdminAvatar(
                        name: e.value.name,
                        size: 32,
                        color: AdminColors.tailorColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.value.name,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AdminColors.text,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${e.value.orders} orders',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AdminColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rs. ${(e.value.revenue / 1000).toStringAsFixed(0)}K',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.text,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 12, color: AdminColors.warning),
                              const SizedBox(width: 2),
                              Text(
                                e.value.rating.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AdminColors.border),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingVerificationsCard extends StatefulWidget {
  @override
  State<_PendingVerificationsCard> createState() =>
      _PendingVerificationsCardState();
}

class _PendingVerificationsCardState extends State<_PendingVerificationsCard> {
  final _service = AdminService();
  late List<PendingVerification> _items;
  final Set<String> _processing = {};

  @override
  void initState() {
    super.initState();
    _items = AdminMockData.pendingVerifications
        .where((v) => v.status == 'Pending')
        .take(3)
        .toList();
  }

  void _approve(String id) async {
    setState(() => _processing.add(id));
    await _service.approveVerification(id);
    if (mounted) {
      setState(() {
        _processing.remove(id);
        _items.removeWhere((v) => v.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account activated successfully!',
              style: GoogleFonts.poppins()),
          backgroundColor: AdminColors.success,
        ),
      );
    }
  }

  void _reject(String id) async {
    setState(() => _processing.add(id));
    await _service.rejectVerification(id, 'Rejected from dashboard');
    if (mounted) {
      setState(() {
        _processing.remove(id);
        _items.removeWhere((v) => v.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application rejected.', style: GoogleFonts.poppins()),
          backgroundColor: AdminColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SectionTitle(
              title: 'Pending Verifications',
              action: _items.isNotEmpty
                  ? AdminBadge(
                      label: '${_items.length} pending',
                      color: AdminColors.warning,
                    )
                  : null,
            ),
          ),
          const Divider(height: 1, color: AdminColors.border),
          if (_items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: EmptyState(
                icon: Icons.check_circle_outline_rounded,
                message: 'All caught up!',
                subMessage: 'No pending verifications.',
              ),
            )
          else
            ...(_items.map(
              (v) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        AdminAvatar(
                          name: v.name,
                          size: 40,
                          color: v.role == 'tailor'
                              ? AdminColors.tailorColor
                              : AdminColors.riderColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${v.city} • ${v.role.toUpperCase()} • Submitted ${v.submittedDate}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AdminColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AdminBadge(
                          label: v.role,
                          color: v.role == 'tailor'
                              ? AdminColors.tailorColor
                              : AdminColors.riderColor,
                        ),
                        const SizedBox(width: 12),
                        AdminButton(
                          label: 'Approve',
                          color: AdminColors.success,
                          isSmall: true,
                          isLoading: _processing.contains(v.id),
                          onPressed: () => _approve(v.id),
                        ),
                        const SizedBox(width: 8),
                        OutlineAdminButton(
                          label: 'Reject',
                          color: AdminColors.error,
                          isSmall: true,
                          onPressed: () => _reject(v.id),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AdminColors.border),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
