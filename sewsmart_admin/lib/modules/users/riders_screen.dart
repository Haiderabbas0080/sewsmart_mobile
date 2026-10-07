import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/admin_theme.dart';
import '../../core/widgets/admin_widgets.dart';
import '../../core/services/admin_service.dart';
import '../../core/models/admin_models.dart';

class RidersScreen extends StatefulWidget {
  const RidersScreen({super.key});

  @override
  State<RidersScreen> createState() => _RidersScreenState();
}

class _RidersScreenState extends State<RidersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _service = AdminService();
  List<AdminRider> _riders = [];
  List<AdminRider> _filtered = [];
  List<PendingVerification> _pending = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final riders = await _service.getRiders();
    final pending = await _service.getPendingVerifications();
    if (mounted) {
      setState(() {
        _riders = riders;
        _filtered = riders;
        _pending = pending.where((v) => v.role == 'rider').toList();
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      _filtered = _riders.where((r) {
        return _search.isEmpty ||
            r.name.toLowerCase().contains(_search.toLowerCase()) ||
            r.city.toLowerCase().contains(_search.toLowerCase()) ||
            r.assignedTailorName.toLowerCase().contains(_search.toLowerCase());
      }).toList();
    });
  }

  Future<void> _approve(String id) async {
    await _service.approveVerification(id);
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rider account activated!', style: GoogleFonts.poppins()),
          backgroundColor: AdminColors.success,
        ),
      );
    }
  }

  void _showRejectDialog(String id) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Reject Application',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason for rejection:',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AdminColors.textSecondary)),
            const SizedBox(height: 12),
            AdminTextField(hint: 'Enter reason...', controller: ctrl, maxLines: 3),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: AdminColors.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _service.rejectVerification(id, ctrl.text);
              _load();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text('Reject', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(AdminRider rider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Remove Rider',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
            'Are you sure you want to permanently remove ${rider.name}? This action cannot be undone.',
            style: GoogleFonts.poppins(
                fontSize: 14, color: AdminColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: AdminColors.textSecondary))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _service.removeRider(rider.id);
              if (mounted) _load();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text('Remove', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Riders',
            subtitle: 'Manage delivery riders across the platform',
            badge: AdminBadge(label: '${_riders.length}', color: AdminColors.riderColor),
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AdminColors.primary,
            unselectedLabelColor: AdminColors.textSecondary,
            indicatorColor: AdminColors.primary,
            labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
            tabs: [
              const Tab(text: 'All Riders'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Pending Approval'),
                    if (_pending.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AdminColors.warning,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${_pending.length}',
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.sizeOf(context).height - 280,
            child: TabBarView(
              controller: _tabController,
              children: [
                _allRidersTab(),
                _pendingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allRidersTab() {
    return Column(
      children: [
        AdminTextField(
          hint: 'Search by name, city or assigned tailor...',
          prefixIcon: Icons.search_rounded,
          onChanged: (v) {
            _search = v;
            _applyFilter();
          },
        ),
        const SizedBox(height: 12),
        Expanded(
          child: AdminCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                TableHeader(
                  columns: const ['NAME', 'PHONE', 'CITY', 'ASSIGNED TAILOR', 'DELIVERIES', 'RATING', 'STATUS', 'ACTIONS'],
                  flexValues: const [2, 1.8, 1.2, 2.5, 1.2, 1, 1.3, 2],
                ),
                if (_loading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (_filtered.isEmpty)
                  const Expanded(child: EmptyState(icon: Icons.delivery_dining_outlined, message: 'No riders found'))
                else
                  Expanded(
                    child: ListView(
                      children: _filtered.map((r) => Column(
                        children: [
                          AdminRow(
                            cells: [
                              Row(children: [
                                AdminAvatar(name: r.name, size: 30, color: AdminColors.riderColor),
                                const SizedBox(width: 8),
                                Expanded(child: Text(r.name,
                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis)),
                              ]),
                              Text(r.phone, style: GoogleFonts.poppins(fontSize: 12)),
                              Text(r.city, style: GoogleFonts.poppins(fontSize: 12)),
                              Text(r.assignedTailorName,
                                  style: GoogleFonts.poppins(fontSize: 12, color: AdminColors.tailorColor),
                                  overflow: TextOverflow.ellipsis),
                              Text('${r.totalDeliveries}',
                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                              Row(children: [
                                const Icon(Icons.star_rounded, size: 13, color: AdminColors.warning),
                                const SizedBox(width: 2),
                                Text(r.rating.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 12)),
                              ]),
                              statusBadge(r.status),
                              Row(children: [
                                _ActionBtn(icon: Icons.visibility_rounded, color: AdminColors.info, tooltip: 'View', onTap: () {}),
                                const SizedBox(width: 4),
                                _ActionBtn(
                                  icon: r.status == 'Active' ? Icons.block_rounded : Icons.check_circle_rounded,
                                  color: r.status == 'Active' ? AdminColors.warning : AdminColors.success,
                                  tooltip: r.status == 'Active' ? 'Suspend' : 'Activate',
                                  onTap: () async {
                                    await _service.suspendRider(r.id);
                                    _load();
                                  },
                                ),
                                const SizedBox(width: 4),
                                _ActionBtn(icon: Icons.delete_rounded, color: AdminColors.error, tooltip: 'Remove', onTap: () => _confirmRemove(r)),
                              ]),
                            ],
                            flexValues: const [2, 1.8, 1.2, 2.5, 1.2, 1, 1.3, 2],
                          ),
                          const Divider(height: 1, color: AdminColors.border),
                        ],
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pendingTab() {
    if (_pending.isEmpty) {
      return const EmptyState(
        icon: Icons.check_circle_outline_rounded,
        message: 'No pending rider approvals',
      );
    }
    return ListView(
      children: _pending.map((v) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AdminCard(
          child: Row(
            children: [
              AdminAvatar(name: v.name, size: 48, color: AdminColors.riderColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('${v.phone} • ${v.city} • Submitted: ${v.submittedDate}',
                        style: GoogleFonts.poppins(fontSize: 12, color: AdminColors.textSecondary)),
                    const SizedBox(height: 8),
                    Row(children: [
                      _DocPlaceholder(label: 'CNIC Front', color: AdminColors.info),
                      const SizedBox(width: 12),
                      _DocPlaceholder(label: 'CNIC Back', color: AdminColors.info),
                      const SizedBox(width: 12),
                      _DocPlaceholder(
                        label: 'License',
                        color: v.documentsSubmitted ? AdminColors.riderColor : AdminColors.border,
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AdminBadge(
                    label: v.documentsSubmitted ? 'Docs OK' : 'Docs Missing',
                    color: v.documentsSubmitted ? AdminColors.success : AdminColors.warning,
                  ),
                  const SizedBox(height: 12),
                  AdminButton(label: 'Approve', color: AdminColors.success, isSmall: true, onPressed: () => _approve(v.id)),
                  const SizedBox(height: 6),
                  OutlineAdminButton(label: 'Reject', color: AdminColors.error, isSmall: true, onPressed: () => _showRejectDialog(v.id)),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _DocPlaceholder extends StatelessWidget {
  final String label;
  final Color color;
  const _DocPlaceholder({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, size: 14, color: color),
        ),
      ),
    );
  }
}
