import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';
import 'place_order_screen.dart';

class TailorProfileScreen extends StatefulWidget {
  final TailorModel tailor;
  const TailorProfileScreen({super.key, required this.tailor});

  @override
  State<TailorProfileScreen> createState() => _TailorProfileScreenState();
}

class _TailorProfileScreenState extends State<TailorProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<GarmentPricing> _pricing = MockData.garments;
  final List<ReviewModel> _reviews = MockData.reviews;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tailor;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(t),
              _buildStatRow(t),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPortfolio(),
                    _buildPricingTab(),
                    _buildReviewsTab(),
                  ],
                ),
              ),
              _buildBottomBar(t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TailorModel t) {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.teal.withValues(alpha: 0.2)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.textPrimary, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.teal],
                      ),
                      border: Border.all(color: AppColors.bg, width: 3),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 16)],
                    ),
                    child: Center(
                      child: Text(t.userAvatar, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(t.name, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 17), overflow: TextOverflow.ellipsis),
                            ),
                            if (t.isVerified) ...[
                              const SizedBox(width: 5),
                              const Icon(Icons.verified_rounded, color: AppColors.info, size: 16),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 13),
                            const SizedBox(width: 2),
                            Text(t.city, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        StarRating(rating: t.rating, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(t.bio, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: t.specialties.map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Text(s, style: GoogleFonts.poppins(color: AppColors.tealLight, fontSize: 10)),
                )).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(TailorModel t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          _StatBox(label: 'Orders', value: '${t.totalOrders}', icon: Icons.receipt_long_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          _StatBox(label: 'Rating', value: '${t.rating}', icon: Icons.star_rounded, color: AppColors.gold),
          const SizedBox(width: 10),
          _StatBox(label: 'From', value: 'Rs ${t.priceFrom.toInt()}', icon: Icons.payments_outlined, color: AppColors.teal),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        tabs: const [
          Tab(text: 'Portfolio'),
          Tab(text: 'Pricing'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildPortfolio() {
    final colors = [
      [AppColors.primary, AppColors.primaryLight],
      [AppColors.teal, AppColors.tealLight],
      [AppColors.secondary, const Color(0xFFEC4899)],
      [AppColors.warning, AppColors.gold],
      [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
      [AppColors.info, const Color(0xFF60A5FA)],
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.0,
      ),
      itemCount: 6,
      itemBuilder: (context, i) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors[i % colors.length],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera_outlined, color: Colors.white.withValues(alpha: 0.7), size: 32),
            const SizedBox(height: 8),
            Text('Design ${i + 1}', style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _pricing.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final p = _pricing[i];
        return GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.checkroom_outlined, color: AppColors.primaryLight, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.garment, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    Row(
                      children: [
                        const Icon(Icons.schedule_outlined, color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 4),
                        Text(p.estimatedTime, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              Text('Rs ${p.price.toInt()}', style: GoogleFonts.poppins(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    if (_reviews.isEmpty) {
      return const EmptyState(icon: Icons.rate_review_outlined, title: 'No reviews yet', subtitle: 'Be the first to review!');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final r = _reviews[i];
        return GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: Center(child: Text(r.customerName[0], style: GoogleFonts.poppins(color: AppColors.primaryLight, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.customerName, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(
                          '${r.createdAt.day}/${r.createdAt.month}/${r.createdAt.year}',
                          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  StarRating(rating: r.rating),
                ],
              ),
              const SizedBox(height: 10),
              Text(r.comment, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(TailorModel t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
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
                    const SizedBox(width: 6),
                    Text('Chat', style: GoogleFonts.poppins(color: AppColors.primaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GradientButton(
              text: 'Place Order',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceOrderScreen(tailor: t))),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
        ],
      ),
    ),
  );
}
