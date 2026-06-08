import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';
import '../services/customer_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _scheduleSaved = false;
  bool _savingSchedule = false;

  final List<DateTime> _futureDates = List.generate(7, (i) => DateTime.now().add(Duration(days: i + 1)));
  final List<String> _timeSlots = MockData.timeSlots;

  int get _currentStepIndex {
    switch (widget.order.status) {
      case OrderStatus.pending: return 0;
      case OrderStatus.accepted: return 1;
      case OrderStatus.inProgress: return 2;
      case OrderStatus.qualityCheck: return 3;
      case OrderStatus.readyForDelivery: return 4;
      case OrderStatus.delivered: return 5;
      case OrderStatus.completed: return 5;
      case OrderStatus.cancelled: return -1;
      case OrderStatus.rejected: return -1;
    }
  }

  Future<void> _confirmSchedule() async {
    if (_selectedDate == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date and time slot', style: GoogleFonts.poppins(fontSize: 12)), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _savingSchedule = true);
    final success = await CustomerService().setDeliverySchedule(
      orderId: widget.order.id,
      pickupDate: _selectedDate!,
      deliveryDate: _selectedDate!.add(const Duration(days: 1)),
      pickupSlot: _selectedTimeSlot!,
      deliverySlot: _selectedTimeSlot!,
    );
    if (!mounted) return;
    setState(() { _savingSchedule = false; _scheduleSaved = success; });
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delivery scheduled!', style: GoogleFonts.poppins(fontSize: 12)), backgroundColor: AppColors.success),
      );
    }
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[month - 1];
  }

  String _dayName(DateTime d) {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return days[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: [
              SewAppBar(title: 'Track Order', subtitle: widget.order.id),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderInfoCard(),
                      const SizedBox(height: 20),
                      _buildTimeline(),
                      if (widget.order.status == OrderStatus.readyForDelivery && !_scheduleSaved) ...[
                        const SizedBox(height: 24),
                        _buildScheduleSection(),
                      ],
                      if (_scheduleSaved) ...[
                        const SizedBox(height: 20),
                        _buildScheduleConfirmed(),
                      ],
                      const SizedBox(height: 24),
                      _buildContactButtons(),
                      const SizedBox(height: 24),
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

  Widget _buildOrderInfoCard() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.order.id, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
              StatusBadge(label: widget.order.statusLabel, color: _statusColor()),
            ],
          ),
          const SizedBox(height: 10),
          Text(widget.order.garmentType, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.cut_rounded, color: AppColors.textMuted, size: 13),
              const SizedBox(width: 4),
              Text(widget.order.tailorName, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
                  Text('Rs ${widget.order.amount.toInt()}', style: GoogleFonts.poppins(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Ordered', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
                  Text(
                    '${widget.order.createdAt.day}/${widget.order.createdAt.month}/${widget.order.createdAt.year}',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor() {
    switch (widget.order.status) {
      case OrderStatus.pending: return AppColors.warning;
      case OrderStatus.accepted: return AppColors.info;
      case OrderStatus.inProgress: return AppColors.primary;
      case OrderStatus.qualityCheck: return const Color(0xFF8B5CF6);
      case OrderStatus.readyForDelivery: return AppColors.success;
      case OrderStatus.delivered: return AppColors.teal;
      case OrderStatus.completed: return AppColors.success;
      case OrderStatus.cancelled: return AppColors.error;
      case OrderStatus.rejected: return AppColors.error;
    }
  }

  Widget _buildTimeline() {
    final steps = [
      {'label': 'Order Placed', 'icon': Icons.add_shopping_cart_rounded, 'sub': 'Your order was placed'},
      {'label': 'Accepted', 'icon': Icons.thumb_up_rounded, 'sub': 'Tailor accepted your order'},
      {'label': 'In Progress', 'icon': Icons.cut_rounded, 'sub': 'Tailor is stitching'},
      {'label': 'Quality Check', 'icon': Icons.verified_rounded, 'sub': 'Final quality inspection'},
      {'label': 'Ready', 'icon': Icons.check_circle_rounded, 'sub': 'Ready for pickup/delivery'},
      {'label': 'Delivered', 'icon': Icons.local_shipping_rounded, 'sub': 'Delivered to you'},
    ];
    final current = _currentStepIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Progress', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          final isDone = i <= current;
          final isActive = i == current;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isDone
                          ? LinearGradient(colors: isActive ? [AppColors.primary, AppColors.primaryLight] : [AppColors.success, AppColors.teal])
                          : null,
                      color: isDone ? null : AppColors.card,
                      border: Border.all(color: isDone ? Colors.transparent : AppColors.divider, width: 1.5),
                      boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 10)] : [],
                    ),
                    child: Icon(step['icon'] as IconData, color: isDone ? Colors.white : AppColors.textMuted, size: 17),
                  ),
                  if (i < steps.length - 1)
                    Container(
                      width: 2,
                      height: 36,
                      color: isDone && i < current ? AppColors.success : AppColors.divider,
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: i < steps.length - 1 ? 20 : 0, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['label'] as String,
                        style: GoogleFonts.poppins(
                          color: isActive ? AppColors.textPrimary : (isDone ? AppColors.textSecondary : AppColors.textMuted),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      if (isDone)
                        Text(step['sub'] as String, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Schedule Delivery', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 4),
        Text('Your order is ready! Choose a delivery date and time.', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 14),
        Text('Select Date', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(
          height: 68,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _futureDates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final date = _futureDates[i];
              final selected = _selectedDate?.day == date.day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: selected ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]) : null,
                    color: selected ? null : AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_dayName(date), style: GoogleFonts.poppins(color: selected ? Colors.white70 : AppColors.textMuted, fontSize: 10)),
                      Text('${date.day}', style: GoogleFonts.poppins(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(_monthName(date.month), style: GoogleFonts.poppins(color: selected ? Colors.white70 : AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text('Select Time Slot', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _timeSlots.map((slot) {
            final selected = _selectedTimeSlot == slot;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeSlot = slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  gradient: selected ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]) : null,
                  color: selected ? null : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                ),
                child: Text(slot, style: GoogleFonts.poppins(color: selected ? Colors.white : AppColors.textSecondary, fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        GradientButton(
          text: 'Confirm Schedule',
          onTap: _confirmSchedule,
          loading: _savingSchedule,
          colors: const [AppColors.success, Color(0xFF16A34A)],
        ),
      ],
    );
  }

  Widget _buildScheduleConfirmed() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success.withValues(alpha: 0.15)),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Scheduled!', style: GoogleFonts.poppins(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(
                  '${_selectedDate?.day}/${_selectedDate?.month} — $_selectedTimeSlot',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Tailor', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryLight, size: 18),
                      const SizedBox(width: 8),
                      Text('Chat', style: GoogleFonts.poppins(color: AppColors.primaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_outlined, color: AppColors.tealLight, size: 18),
                      const SizedBox(width: 8),
                      Text('Video', style: GoogleFonts.poppins(color: AppColors.tealLight, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
