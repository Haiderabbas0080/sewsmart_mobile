import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';

class TailorProfileManageScreen extends StatefulWidget {
  const TailorProfileManageScreen({super.key});

  @override
  State<TailorProfileManageScreen> createState() =>
      _TailorProfileManageScreenState();
}

class _TailorProfileManageScreenState extends State<TailorProfileManageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameCtrl = TextEditingController(text: "Sana's Couture");
  final _phoneCtrl = TextEditingController(text: '0302-3456789');
  final _cityCtrl = TextEditingController(text: 'Lahore');
  final _expCtrl = TextEditingController(text: '8 years');
  final _bioCtrl = TextEditingController(
      text: 'Expert in bridal and formal wear with 8+ years of experience.');

  bool _saving = false;

  final List<GarmentPricing> _pricing = List.from(MockData.garments);

  final List<Color> _portfolioColors = [
    AppColors.primary,
    AppColors.teal,
    AppColors.secondary,
    AppColors.warning,
    AppColors.info,
    AppColors.success,
    AppColors.riderColor,
    AppColors.gold,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _expCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated!', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showAddGarmentDialog() {
    final garmentCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Garment',
          style: GoogleFonts.poppins(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(hint: 'Garment name', ctrl: garmentCtrl),
            const SizedBox(height: 10),
            AppTextField(hint: 'Price (Rs)', ctrl: priceCtrl, keyboard: TextInputType.number),
            const SizedBox(height: 10),
            AppTextField(hint: 'Estimated time (e.g. 3-4 days)', ctrl: timeCtrl),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () {
              if (garmentCtrl.text.isNotEmpty) {
                setState(() {
                  _pricing.add(GarmentPricing(
                    garment: garmentCtrl.text,
                    price: double.tryParse(priceCtrl.text) ?? 0,
                    estimatedTime: timeCtrl.text,
                  ));
                });
              }
              Navigator.pop(ctx);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Add', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGarmentDialog(int index) {
    final item = _pricing[index];
    final garmentCtrl = TextEditingController(text: item.garment);
    final priceCtrl = TextEditingController(text: item.price.toInt().toString());
    final timeCtrl = TextEditingController(text: item.estimatedTime);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Garment',
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(hint: 'Garment name', ctrl: garmentCtrl),
            const SizedBox(height: 10),
            AppTextField(
                hint: 'Price (Rs)',
                ctrl: priceCtrl,
                keyboard: TextInputType.number),
            const SizedBox(height: 10),
            AppTextField(
                hint: 'Estimated time (e.g. 3-4 days)', ctrl: timeCtrl),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Delete this garment
              setState(() => _pricing.removeAt(index));
              Navigator.pop(ctx);
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(
                    color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () {
              if (garmentCtrl.text.isNotEmpty) {
                setState(() {
                  _pricing[index] = GarmentPricing(
                    garment: garmentCtrl.text,
                    price: double.tryParse(priceCtrl.text) ?? item.price,
                    estimatedTime: timeCtrl.text.isEmpty
                        ? item.estimatedTime
                        : timeCtrl.text,
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.teal, AppColors.tealLight]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Save',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.tealOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              const SewAppBar(title: 'My Profile'),
              _buildProfileHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(),
                    _buildPortfolioTab(),
                    _buildPricingTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
                ),
                child: Center(
                  child: Text(
                    'S',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 34),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bg, width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sana's Couture",
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.verified_rounded, color: AppColors.info, size: 18),
            ],
          ),
          const SizedBox(height: 4),
          StarRating(rating: 4.9),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Portfolio'),
          Tab(text: 'Pricing'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          AppTextField(hint: 'Business Name', icon: Icons.storefront_rounded, ctrl: _nameCtrl, label: 'Business Name'),
          const SizedBox(height: 14),
          AppTextField(hint: 'Phone Number', icon: Icons.phone_rounded, ctrl: _phoneCtrl, keyboard: TextInputType.phone, label: 'Phone'),
          const SizedBox(height: 14),
          AppTextField(hint: 'City', icon: Icons.location_on_rounded, ctrl: _cityCtrl, label: 'City'),
          const SizedBox(height: 14),
          AppTextField(hint: 'Years of experience', icon: Icons.work_history_rounded, ctrl: _expCtrl, label: 'Experience'),
          const SizedBox(height: 14),
          AppTextField(hint: 'Bio / Description', icon: Icons.info_outline_rounded, ctrl: _bioCtrl, maxLines: 3, label: 'Bio'),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Save Changes',
            colors: const [AppColors.teal, AppColors.tealLight],
            loading: _saving,
            onTap: _handleSave,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.card,
                  title: Text('Sign Out?', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  content: Text('Are you sure you want to sign out?', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted))),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Sign Out', style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w600))),
                  ],
                ),
              );
              if (confirm == true && mounted) {
                await AuthService().logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.tealLight.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.teal.withValues(alpha: 0.08),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_photo_alternate_rounded, color: AppColors.tealLight, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add Sample',
                      style: GoogleFonts.poppins(color: AppColors.tealLight, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _portfolioColors.length,
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _portfolioColors[i].withValues(alpha: 0.6),
                    _portfolioColors[(i + 1) % _portfolioColors.length].withValues(alpha: 0.4),
                  ],
                ),
              ),
              child: const Icon(Icons.checkroom_rounded, color: Colors.white54, size: 32),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPricingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          ..._pricing.asMap().entries.map((entry) => _PricingItem(
            pricing: entry.value,
            onEdit: () => _showEditGarmentDialog(entry.key),
          )),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _showAddGarmentDialog,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.tealLight.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.teal.withValues(alpha: 0.08),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, color: AppColors.tealLight, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add New Garment',
                      style: GoogleFonts.poppins(color: AppColors.tealLight, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PricingItem extends StatelessWidget {
  final GarmentPricing pricing;
  final VoidCallback onEdit;
  const _PricingItem({required this.pricing, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.checkroom_rounded, color: AppColors.tealLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pricing.garment,
                  style: GoogleFonts.poppins(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  pricing.estimatedTime,
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            'Rs ${pricing.price.toInt()}',
            style: GoogleFonts.poppins(
                color: AppColors.tealLight, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit_rounded, color: AppColors.primaryLight, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
