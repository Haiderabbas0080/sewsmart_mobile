import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/support_service.dart';
import '../../../core/utils/app_refresh.dart';
import '../../support/screens/raise_dispute_screen.dart';
import '../services/tailor_service.dart';
import 'my_riders_screen.dart';
import 'tailor_chat_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderStatus? _selectedStatus;
  bool _updatingStatus = false;
  bool _sendingRequest = false;
  // The rider who delivers the order, once the order is ready.
  late String? _riderId = widget.order.riderId;
  late String? _riderName = widget.order.riderName;
  bool _assigningRider = false;
  // A dispute about this order, raised by the tailor or the customer.
  DisputeModel? _dispute;

  OrderStatus get _status => _selectedStatus ?? widget.order.status;

  bool get _showsRider =>
      _status == OrderStatus.readyForDelivery ||
      _status == OrderStatus.delivered ||
      _status == OrderStatus.completed;

  Future<void> _assignRider() async {
    final rider = await showAssignRiderSheet(
      context,
      tailorId: widget.order.tailorId,
      currentRiderId: _riderId,
    );
    if (rider == null || !mounted) return;
    setState(() => _assigningRider = true);
    final updated = await TailorService().assignRider(widget.order.id, rider.id);
    if (!mounted) return;
    setState(() {
      _assigningRider = false;
      if (updated != null) {
        _riderId = updated.riderId;
        _riderName = updated.riderName;
      }
    });
    if (updated != null) AppRefresh.ordersChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated != null ? '${rider.name} will deliver this order' : 'Could not assign ${rider.name}. Try another rider.',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: updated != null ? AppColors.success : AppColors.error,
      ),
    );
  }

  Future<void> _loadDispute() async {
    final disputes = await SupportService().getMyDisputes();
    if (!mounted) return;
    setState(() => _dispute = disputes.where((d) => d.orderId == widget.order.id).firstOrNull);
  }

  Future<void> _reportProblem() async {
    // The status and rider may have changed on this screen since it opened.
    final order = widget.order.copyWith(status: _status, riderId: _riderId, riderName: _riderName);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RaiseDisputeScreen(order: order, byTailor: true)),
    );
    if (mounted) _loadDispute();
  }

  final List<OrderStatus> _statusChips = [
    OrderStatus.accepted,
    OrderStatus.inProgress,
    OrderStatus.qualityCheck,
    OrderStatus.readyForDelivery,
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
    _loadDispute();
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.accepted:
        return AppColors.info;
      case OrderStatus.inProgress:
        return AppColors.primary;
      case OrderStatus.qualityCheck:
        return AppColors.secondary;
      case OrderStatus.readyForDelivery:
        return AppColors.teal;
      default:
        return AppColors.textMuted;
    }
  }

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.qualityCheck:
        return 'Quality Check';
      case OrderStatus.readyForDelivery:
        return 'Ready';
      default:
        return s.name;
    }
  }

  Future<void> _updateStatus(OrderStatus status) async {
    if (status == OrderStatus.readyForDelivery) {
      _showDeliveryRequestDialog();
      return;
    }
    setState(() {
      _selectedStatus = status;
      _updatingStatus = true;
    });
    await TailorService().updateOrderStatus(widget.order.id, status);
    AppRefresh.ordersChanged();
    if (mounted) {
      setState(() => _updatingStatus = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to ${_statusLabel(status)}', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.teal,
        ),
      );
    }
  }

  void _showDeliveryRequestDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Send Delivery Request?',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          'This will notify ${widget.order.customerName} to schedule pickup/delivery for their order.',
          style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pop(ctx);
              setState(() {
                _selectedStatus = OrderStatus.readyForDelivery;
                _sendingRequest = true;
              });
              await TailorService().sendDeliveryRequest(widget.order.id);
              AppRefresh.ordersChanged();
              if (mounted) {
                setState(() => _sendingRequest = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Delivery request sent!', style: GoogleFonts.poppins()),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Send Request',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Orders placed in the app store measurements as "C:36 W:30 H:38 L:42 S:15".
  // The sample orders use "36-30-38" (chest, waist, hip). A value the order does
  // not have shows as '-'.
  Map<String, String> get _measurements {
    const names = ['Chest', 'Waist', 'Hip', 'Length', 'Shoulder'];
    final raw = widget.order.measurements.trim();
    final values = <String, String>{};
    if (raw.contains(':')) {
      const keys = {'C': 'Chest', 'W': 'Waist', 'H': 'Hip', 'L': 'Length', 'S': 'Shoulder'};
      for (final part in raw.split(RegExp(r'\s+'))) {
        final pair = part.split(':');
        final name = keys[pair.first];
        if (pair.length == 2 && name != null && pair[1].isNotEmpty) values[name] = pair[1];
      }
    } else {
      final parts = raw.split('-');
      for (var i = 0; i < parts.length && i < names.length; i++) {
        if (parts[i].trim().isNotEmpty) values[names[i]] = parts[i].trim();
      }
    }
    return {for (final name in names) name: values[name] == null ? '-' : '${values[name]}"'};
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.tealOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              SewAppBar(
                title: 'Order Detail',
                subtitle: order.id,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderHeader(order),
                      const SizedBox(height: 20),
                      Divider(color: AppColors.divider),
                      const SizedBox(height: 16),
                      _buildMeasurements(),
                      if (order.hasDesignRef) ...[
                        const SizedBox(height: 20),
                        _buildDesignRef(),
                      ],
                      const SizedBox(height: 20),
                      _buildStatusUpdate(),
                      if (_showsRider) ...[
                        const SizedBox(height: 20),
                        _buildRiderSection(),
                      ],
                      const SizedBox(height: 30),
                      _buildChatButton(context, order),
                      const SizedBox(height: 12),
                      if (_dispute case final dispute?)
                        DisputeStatusCard(dispute: dispute)
                      else
                        Center(
                          child: TextButton.icon(
                            onPressed: _reportProblem,
                            icon: Icon(Icons.report_problem_outlined, color: AppColors.textMuted, size: 16),
                            label: Text(
                              'Report a problem with this order',
                              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
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

  Widget _buildOrderHeader(OrderModel order) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.checkroom_rounded, color: AppColors.tealLight, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.garmentType,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.customerName,
                      style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: order.statusLabel,
                color: _statusColor(_selectedStatus ?? order.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoItem(label: 'Order ID', value: order.id),
              _InfoItem(label: 'Amount', value: 'Rs ${order.amount.toInt()}'),
              _InfoItem(
                label: 'Date',
                value: '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurements() {
    final m = _measurements;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Measurements',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: m.entries.toList().asMap().entries.map((entry) {
              final idx = entry.key;
              final kv = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.straighten_rounded, color: AppColors.tealLight, size: 14),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          kv.key,
                          style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          kv.value,
                          style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (idx < m.length - 1) Divider(color: AppColors.divider, height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesignRef() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Design Reference',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.image_rounded, color: AppColors.primaryLight, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                'Design Reference Image',
                style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusUpdate() {
    // A status only moves forward. A pending order is accepted or rejected on
    // the Orders list first, and a finished order cannot change any more.
    final current = _statusChips.indexOf(_selectedStatus ?? widget.order.status);
    if (current == -1) {
      final status = _selectedStatus ?? widget.order.status;
      final note = status == OrderStatus.pending
          ? 'Accept this order on the Orders screen before updating its status.'
          // The other statuses here are rejected, cancelled, delivered and completed.
          : 'This order is ${status.name}. Its status can no longer be changed.';
      return GlassCard(
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(note, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
            ),
          ],
        ),
      );
    }
    final busy = _updatingStatus || _sendingRequest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Update Status',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            if (_updatingStatus || _sendingRequest)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(color: AppColors.tealLight, strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _statusChips.map((status) {
            final isSelected = _selectedStatus == status;
            final color = _statusColor(status);
            final canPick = !busy && _statusChips.indexOf(status) > current;
            return GestureDetector(
              onTap: canPick ? () => _updateStatus(status) : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: canPick || isSelected ? 1 : 0.4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.2) : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : AppColors.divider,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: GoogleFonts.poppins(
                      color: isSelected ? color : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Who delivers the order. The rider can be picked or changed while the
  // order is ready for delivery.
  Widget _buildRiderSection() {
    final canChange = _status == OrderStatus.readyForDelivery;
    final name = _riderName;
    final String note;
    if (name == null) {
      note = canChange ? 'Pick one of your verified riders' : 'No rider was assigned';
    } else {
      note = canChange ? 'Collects the order from you' : 'Delivered this order';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Rider',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 10),
        GlassCard(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: name == null ? AppColors.cardAlt : null,
                  gradient: name == null
                      ? null
                      : LinearGradient(colors: [AppColors.riderColor, Color(0xFFF97316)]),
                ),
                child: Center(
                  child: name == null
                      ? Icon(Icons.two_wheeler_rounded, color: AppColors.textMuted, size: 20)
                      : Text(
                          initialsOf(name),
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'No rider yet',
                      style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(note, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              if (_assigningRider)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(color: AppColors.tealLight, strokeWidth: 2),
                )
              else if (canChange)
                GestureDetector(
                  onTap: _assignRider,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      name == null ? 'Assign' : 'Change',
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatButton(BuildContext context, OrderModel order) {
    return GradientButton(
      text: 'Chat with Customer',
      colors: [AppColors.teal, AppColors.tealLight],
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TailorChatScreen(
            contactName: order.customerName,
            orderId: order.id,
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label, value;
  const _InfoItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
