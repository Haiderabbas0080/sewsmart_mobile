import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';
import '../services/customer_service.dart';
import '../../../core/services/auth_service.dart';
import 'tailor_profile_screen.dart';

class BrowseTailorsScreen extends StatefulWidget {
  const BrowseTailorsScreen({super.key});

  @override
  State<BrowseTailorsScreen> createState() => _BrowseTailorsScreenState();
}

class _BrowseTailorsScreenState extends State<BrowseTailorsScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';
  List<TailorModel> _allTailors = [];
  List<TailorModel> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTailors();
    _searchCtrl.addListener(_applyFilter);
  }

  Future<void> _loadTailors() async {
    final tailors = await CustomerService().getTailors();
    if (mounted) {
      setState(() {
        _allTailors = tailors;
        _filtered = tailors;
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    final query = _searchCtrl.text.toLowerCase();
    // Record searches with 3+ characters into the shared history so both
    // the customer's AI Recommendations page and the tailor's AI Recs
    // page can reflect them live.
    if (query.length >= 3) {
      final userName = AuthService().currentUser?.name ?? 'Customer';
      MockData.recordSearch(query, customerName: userName);
    }
    setState(() {
      _filtered = _allTailors.where((t) {
        final matchCat = _selectedCategory == 'All' || t.category == _selectedCategory || t.specialties.any((s) => s.toLowerCase().contains(_selectedCategory.toLowerCase()));
        final matchSearch = query.isEmpty || t.name.toLowerCase().contains(query) || t.city.toLowerCase().contains(query) || t.specialties.any((s) => s.toLowerCase().contains(query));
        return matchCat && matchSearch;
      }).toList();
    });
  }

  void _selectCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _applyFilter();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SewAppBar(
                title: 'Find a Tailor',
                subtitle: '${_filtered.length} tailors available',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: AppTextField(
                  ctrl: _searchCtrl,
                  hint: 'Search by name, city, specialty...',
                  icon: Icons.search_rounded,
                  suffix: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                          onPressed: () { _searchCtrl.clear(); _applyFilter(); },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = MockData.categories[i];
                    final selected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => _selectCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.poppins(
                            color: selected ? Colors.white : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryLight, strokeWidth: 2))
                    : _filtered.isEmpty
                        ? EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No tailors found',
                            subtitle: 'Try a different search or category',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) => _TailorListCard(tailor: _filtered[i]),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TailorListCard extends StatelessWidget {
  final TailorModel tailor;
  const _TailorListCard({required this.tailor});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TailorProfileScreen(tailor: tailor))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: tailor.isVerified
                        ? [AppColors.primary, AppColors.teal]
                        : [AppColors.cardAlt, AppColors.divider],
                  ),
                ),
                child: Center(
                  child: Text(tailor.userAvatar, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
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
                          child: Text(tailor.name, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis),
                        ),
                        if (tailor.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: AppColors.info, size: 15),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 13),
                        const SizedBox(width: 2),
                        Text(tailor.city, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle_outline, color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 2),
                        Text('${tailor.totalOrders} orders', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StarRating(rating: tailor.rating),
                  const SizedBox(height: 4),
                  Text('from Rs ${tailor.priceFrom.toInt()}', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(tailor.bio, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: tailor.specialties.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                    ),
                    child: Text(s, style: GoogleFonts.poppins(color: AppColors.primaryLight, fontSize: 10)),
                  )).toList(),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TailorProfileScreen(tailor: tailor))),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Book Now', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
