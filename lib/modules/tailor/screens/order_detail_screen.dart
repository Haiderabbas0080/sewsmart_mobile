import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../services/tailor_service.dart';
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
                gradient: const LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
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

  Map<String, String> get _measurements {
    final raw = widget.order.measurements;
    final parts = raw.split('-');
    return {
      'Chest': parts.isNotEmpty ? '${parts[0]}"' : '-',
      'Waist': parts.length > 1 ? '${parts[1]}"' : '-',
      'Hip': parts.length > 2 ? '${parts[2]}"' : '-',
      'Length': '42"',
      'Shoulder': '15"',
    };
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
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 16),
                      _buildMeasurements(),
                      if (order.hasDesignRef) ...[
                        const SizedBox(height: 20),
                        _buildDesignRef(),
                      ],
                      const SizedBox(height: 20),
                      _buildStatusUpdate(),
                      const SizedBox(height: 30),
                      _buildChatButton(context, order),
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
                child: const Icon(Icons.checkroom_rounded, color: AppColors.tealLight, size: 26),
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
          const Divider(color: AppColors.divider, height: 1),
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
                          child: const Icon(Icons.straighten_rounded, color: AppColors.tealLight, size: 14),
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
                  if (idx < m.length - 1) const Divider(color: AppColors.divider, height: 1),
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
                child: const Icon(Icons.image_rounded, color: AppColors.primaryLight, size: 28),
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
              const SizedBox(
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
            return GestureDetector(
              onTap: () => _updateStatus(status),
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
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChatButton(BuildContext context, OrderModel order) {
    return GradientButton(
      text: 'Chat with Customer',
      colors: const [AppColors.teal, AppColors.tealLight],
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TailorChatScreen(
            customerName: order.customerName,
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
