import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../services/rider_service.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final OrderModel order;
  const DeliveryDetailScreen({super.key, required this.order});

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  bool _pickupVerified = false;
  bool _deliveryProofUploaded = false;
  bool _slipVerified = false;

  bool _verifyingPickup = false;
  bool _uploadingProof = false;
  bool _verifyingSlip = false;
  bool _reportingIssue = false;

  Future<void> _showOtpDialog() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Verify Pickup',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the OTP provided by the tailor to verify pickup.',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Enter OTP',
              ctrl: ctrl,
              keyboard: TextInputType.number,
              icon: Icons.lock_outline_rounded,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(ctx, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.riderColor, Color(0xFFF97316)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Verify', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      setState(() => _verifyingPickup = true);
      await RiderService().verifyPickup(widget.order.id, ctrl.text);
      if (mounted) {
        setState(() {
          _verifyingPickup = false;
          _pickupVerified = true;
        });
        _showSnackBar('Pickup verified!', AppColors.success);
      }
    }
  }

  Future<void> _handleUploadProof() async {
    setState(() => _uploadingProof = true);
    await RiderService().uploadDeliveryProof(widget.order.id);
    if (mounted) {
      setState(() {
        _uploadingProof = false;
        _deliveryProofUploaded = true;
      });
      _showSnackBar('Delivery proof uploaded!', AppColors.success);
    }
  }

  Future<void> _showSlipDialog() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Verify Customer Slip',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the confirmation code from the customer\'s slip.',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Enter confirmation code',
              ctrl: ctrl,
              keyboard: TextInputType.number,
              icon: Icons.qr_code_rounded,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(ctx, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.success, Color(0xFF4ADE80)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Verify', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      setState(() => _verifyingSlip = true);
      await RiderService().verifyCustomerSlip(widget.order.id, ctrl.text);
      if (mounted) {
        setState(() {
          _verifyingSlip = false;
          _slipVerified = true;
        });
        _showSnackBar('Delivery completed!', AppColors.success);
      }
    }
  }

  Future<void> _showReportDialog() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Report Issue',
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Describe the issue you encountered with this delivery.',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            AppTextField(
              hint: 'Describe the issue...',
              ctrl: ctrl,
              maxLines: 3,
              icon: Icons.warning_amber_rounded,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(ctx, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Submit Report', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      setState(() => _reportingIssue = true);
      await RiderService().reportIssue(widget.order.id, ctrl.text);
      if (mounted) {
        setState(() => _reportingIssue = false);
        _showSnackBar('Issue reported to support team', AppColors.warning);
      }
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins()),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.orangeOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              SewAppBar(title: 'Delivery Detail', subtitle: order.id),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderCard(order),
                      const SizedBox(height: 16),
                      _buildPickupSection(order),
                      const SizedBox(height: 16),
                      _buildDeliverySection(order),
                      const SizedBox(height: 24),
                      _buildReportButton(),
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

  Widget _buildOrderCard(OrderModel order) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.riderColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.checkroom_rounded, color: AppColors.riderColor, size: 22),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'by ${order.tailorName}',
                      style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: order.statusLabel, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              _OrderInfoItem(label: 'Customer', value: order.customerName),
              _OrderInfoItem(label: 'Amount', value: 'Rs ${order.amount.toInt()}'),
              _OrderInfoItem(label: 'Order ID', value: order.id),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickupSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.riderColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _pickupVerified
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.riderColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.riderColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront_rounded, color: AppColors.riderColor, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'Pickup from Tailor',
                style: GoogleFonts.poppins(
                  color: AppColors.riderColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (_pickupVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 12),
                      const SizedBox(width: 4),
                      Text('Verified', style: GoogleFonts.poppins(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.person_rounded, label: order.tailorName),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.location_on_rounded, label: 'Gulberg III, Lahore'),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: order.scheduledPickup != null
                ? '${order.scheduledPickup!.day}/${order.scheduledPickup!.month}/${order.scheduledPickup!.year} · 10:00 AM - 12:00 PM'
                : 'To be scheduled',
          ),
          if (!_pickupVerified) ...[
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _verifyingPickup ? null : _showOtpDialog,
              child: Container(
                width: double.infinity,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.riderColor, Color(0xFFF97316)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.riderColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _verifyingPickup
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Verify Pickup',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliverySection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _slipVerified
              ? AppColors.success.withValues(alpha: 0.5)
              : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home_rounded, color: AppColors.success, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'Deliver to Customer',
                style: GoogleFonts.poppins(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (_slipVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 12),
                      const SizedBox(width: 4),
                      Text('Delivered', style: GoogleFonts.poppins(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.person_rounded, label: order.customerName),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.location_on_rounded, label: 'DHA Phase 5, Lahore'),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: order.scheduledDelivery != null
                ? '${order.scheduledDelivery!.day}/${order.scheduledDelivery!.month}/${order.scheduledDelivery!.year} · 2:00 PM - 4:00 PM'
                : 'To be scheduled',
          ),
          if (!_slipVerified) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (_uploadingProof || _deliveryProofUploaded) ? null : _handleUploadProof,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _deliveryProofUploaded
                              ? AppColors.success.withValues(alpha: 0.5)
                              : AppColors.success.withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: _deliveryProofUploaded
                            ? AppColors.success.withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: _uploadingProof
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: AppColors.success, strokeWidth: 2))
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _deliveryProofUploaded ? Icons.check_rounded : Icons.camera_alt_rounded,
                                    color: AppColors.success,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _deliveryProofUploaded ? 'Proof Sent' : 'Upload Proof',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _verifyingSlip ? null : _showSlipDialog,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.success, Color(0xFF4ADE80)]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _verifyingSlip
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                'Verify Slip',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportButton() {
    return GestureDetector(
      onTap: _reportingIssue ? null : _showReportDialog,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: _reportingIssue
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppColors.error, strokeWidth: 2))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flag_rounded, color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Report Issue',
                      style: GoogleFonts.poppins(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _OrderInfoItem extends StatelessWidget {
  final String label, value;
  const _OrderInfoItem({required this.label, required this.value});

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
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
