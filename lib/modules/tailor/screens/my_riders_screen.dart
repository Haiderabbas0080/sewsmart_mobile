import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/auth_service.dart';
import '../services/tailor_service.dart';
import 'add_rider_screen.dart';

// The riders a tailor added. The admin verifies each one before it can be
// given a delivery. Riders are assigned from an order that is ready for
// delivery, with showAssignRiderSheet below.
class MyRidersScreen extends StatefulWidget {
  const MyRidersScreen({super.key});

  @override
  State<MyRidersScreen> createState() => _MyRidersScreenState();
}

class _MyRidersScreenState extends State<MyRidersScreen> {
  List<RiderProfile> _riders = [];
  bool _loading = true;

  String get _tailorId => AuthService().currentUser?.id ?? 'T001';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final riders = await TailorService().getRiders(_tailorId);
    if (!mounted) return;
    setState(() {
      _riders = riders;
      _loading = false;
    });
  }

  Future<void> _addRider() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRiderScreen()));
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final verified = _riders.where((r) => r.isVerified).length;
    final available = _riders.where((r) => r.isVerified && r.isAvailable).length;
    final pending = _riders.length - verified;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.tealOrb,
        orb2: AppColors.orangeOrb,
        child: SafeArea(
          child: Column(
            children: [
              SewAppBar(
                title: 'My Riders',
                subtitle: _loading ? null : '${_riders.length} rider${_riders.length == 1 ? '' : 's'}',
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.tealLight, strokeWidth: 2))
                    : RefreshIndicator(
                        color: AppColors.tealLight,
                        backgroundColor: AppColors.card,
                        onRefresh: _load,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                          children: [
                            Row(
                              children: [
                                _CountBox(label: 'Verified', value: verified, color: AppColors.success),
                                const SizedBox(width: 10),
                                _CountBox(label: 'Available', value: available, color: AppColors.tealLight),
                                const SizedBox(width: 10),
                                _CountBox(label: 'Pending', value: pending, color: AppColors.warning),
                              ],
                            ),
                            const SizedBox(height: 18),
                            if (_riders.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: EmptyState(
                                  icon: Icons.two_wheeler_rounded,
                                  title: 'No riders yet',
                                  subtitle: 'Add a rider to deliver your orders',
                                ),
                              ),
                            ..._riders.map((rider) => _RiderCard(rider: rider)),
                            const SizedBox(height: 8),
                            GradientButton(
                              text: 'Add Rider',
                              colors: const [AppColors.teal, AppColors.tealLight],
                              onTap: _addRider,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.info.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Assign a rider from an order that is ready for delivery. '
                                      'Riders waiting for verification cannot take deliveries yet.',
                                      style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
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
}

class _CountBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _CountBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              Text(
                '$value',
                style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
            ],
          ),
        ),
      );
}

class _RiderCard extends StatelessWidget {
  final RiderProfile rider;
  const _RiderCard({required this.rider});

  @override
  Widget build(BuildContext context) {
    final r = rider;
    final String status;
    final Color statusColor;
    if (!r.isVerified) {
      status = 'Pending verification';
      statusColor = AppColors.warning;
    } else if (r.isAvailable) {
      status = 'Available';
      statusColor = AppColors.success;
    } else {
      status = 'Busy';
      statusColor = AppColors.info;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _RiderAvatar(name: r.name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        r.name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    if (r.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: AppColors.info, size: 14),
                    ],
                  ],
                ),
                Text(
                  [r.phone, if (r.city.isNotEmpty) r.city].join(' · '),
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    StatusBadge(label: status, color: statusColor),
                    if (r.isVerified) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.local_shipping_outlined, color: AppColors.textMuted, size: 13),
                      const SizedBox(width: 3),
                      Text(
                        '${r.totalDeliveries}',
                        style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                      ),
                      if (r.rating > 0) ...[
                        const SizedBox(width: 10),
                        StarRating(rating: r.rating, size: 11),
                      ],
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiderAvatar extends StatelessWidget {
  final String name;
  final double size;
  const _RiderAvatar({required this.name, this.size = 46});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [AppColors.riderColor, Color(0xFFF97316)]),
        ),
        child: Center(
          child: Text(
            initialsOf(name),
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size * 0.34),
          ),
        ),
      );
}

// Lets the tailor pick a rider for an order that is ready for delivery. Only
// verified riders who are available can be picked. Returns the chosen rider,
// or null when the sheet is closed.
Future<RiderProfile?> showAssignRiderSheet(
  BuildContext context, {
  required String tailorId,
  String? currentRiderId,
}) {
  return showModalBottomSheet<RiderProfile>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _AssignRiderSheet(tailorId: tailorId, currentRiderId: currentRiderId),
  );
}

class _AssignRiderSheet extends StatefulWidget {
  final String tailorId;
  final String? currentRiderId;
  const _AssignRiderSheet({required this.tailorId, this.currentRiderId});

  @override
  State<_AssignRiderSheet> createState() => _AssignRiderSheetState();
}

class _AssignRiderSheetState extends State<_AssignRiderSheet> {
  List<RiderProfile>? _riders;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final riders = await TailorService().getRiders(widget.tailorId);
    if (mounted) setState(() => _riders = riders);
  }

  @override
  Widget build(BuildContext context) {
    final riders = _riders;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Assign a Rider',
              style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'The rider collects the order from you and delivers it to the customer.',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 14),
            if (riders == null)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator(color: AppColors.tealLight, strokeWidth: 2)),
              )
            else if (riders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'You have no riders yet. Add one from My Riders on your profile.',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: riders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _buildOption(riders[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(RiderProfile r) {
    final canAssign = r.isVerified && r.isAvailable;
    final current = r.id == widget.currentRiderId;
    final String note;
    if (!r.isVerified) {
      note = 'Waiting for verification';
    } else if (!r.isAvailable) {
      note = 'Busy right now';
    } else if (current) {
      note = 'Assigned to this order';
    } else {
      note = '${r.totalDeliveries} deliveries · ${r.rating.toStringAsFixed(1)} rating';
    }
    return GestureDetector(
      onTap: canAssign && !current ? () => Navigator.pop(context, r) : null,
      child: Opacity(
        opacity: canAssign ? 1 : 0.45,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: current ? AppColors.teal.withValues(alpha: 0.12) : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: current ? AppColors.tealLight : AppColors.divider),
          ),
          child: Row(
            children: [
              _RiderAvatar(name: r.name, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.name,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(note, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              if (current)
                const Icon(Icons.check_circle_rounded, color: AppColors.tealLight, size: 20)
              else if (canAssign)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Assign',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
