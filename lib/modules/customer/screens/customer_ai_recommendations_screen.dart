// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/auth_service.dart';
import 'browse_tailors_screen.dart';

class CustomerAiRecommendationsScreen extends StatefulWidget {
  const CustomerAiRecommendationsScreen({super.key});

  @override
  State<CustomerAiRecommendationsScreen> createState() =>
      _CustomerAiRecommendationsScreenState();
}

class _CustomerAiRecommendationsScreenState
    extends State<CustomerAiRecommendationsScreen> {

  // ── State ────────────────────────────────────────────────────────────────────
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  List<_DesignCard> _liveResults = [];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Current user ─────────────────────────────────────────────────────────────
  UserModel? get _user => AuthService().currentUser;

  // ── My previous searches (filtered for current customer) ─────────────────────
  List<Map<String, dynamic>> get _mySearches {
    final name = _user?.name ?? 'Ayesha Khan';
    return MockData.searchHistory
        .where((s) =>
            (s['customerName'] as String).toLowerCase() == name.toLowerCase())
        .toList();
  }

  // ── Trending: aggregate all searches by term ──────────────────────────────────
  List<MapEntry<String, int>> get _trending {
    final counts = <String, int>{};
    for (final s in MockData.searchHistory) {
      final key = _cap(s['query'] as String);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return (counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(10)
        .toList();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  String _cap(String s) {
    s = s.trim();
    if (s.isEmpty) return s;
    if (s.length > 24) s = '${s.substring(0, 24)}…';
    return s[0].toUpperCase() + s.substring(1);
  }

  String _timeLabel(int h) {
    if (h == 0) return 'Just now';
    if (h == 1) return '1 hr ago';
    if (h < 24) return '${h}h ago';
    return '${h ~/ 24}d ago';
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Bridal':  return AppColors.secondary;
      case 'Formal':  return AppColors.info;
      case 'Eastern': return AppColors.teal;
      case 'Western': return AppColors.primary;
      case 'Casual':  return AppColors.warning;
      default:        return AppColors.textMuted;
    }
  }

  // ── Search handler ───────────────────────────────────────────────────────────
  void _onSearch(String q) {
    final trimmed = q.trim();
    final results = trimmed.isEmpty ? <_DesignCard>[] : _similarFor(trimmed);

    // Record meaningful searches (3+ chars) into history
    if (trimmed.length >= 3) {
      final userName = _user?.name ?? 'Customer';
      MockData.recordSearch(trimmed, customerName: userName);
    }
    setState(() {
      _searchQuery = trimmed;
      _liveResults = results;
    });
  }

  void _applyTrending(String term) {
    _searchCtrl.text = term;
    _onSearch(term);
  }

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() {
      _searchQuery = '';
      _liveResults = [];
    });
  }

  // ── Similar-design lookup ─────────────────────────────────────────────────────
  List<_DesignCard> _similarFor(String query) {
    final q = query.toLowerCase();
    if (q.contains('bridal') || q.contains('wedding') ||
        q.contains('lehenga') || q.contains('nikkah')) {
      return _kSimilar['bridal']!;
    } else if (q.contains('shalwar') || q.contains('kameez') ||
        q.contains('kurta') || q.contains('formal')) {
      return _kSimilar['formal']!;
    } else if (q.contains('anarkali') || q.contains('eastern') ||
        q.contains('suit') || q.contains('maxi')) {
      return _kSimilar['eastern']!;
    } else if (q.contains('casual') || q.contains('lawn') ||
        q.contains('summer') || q.contains('kids')) {
      return _kSimilar['casual']!;
    } else if (q.contains('party') || q.contains('western') ||
        q.contains('dress') || q.contains('short')) {
      return _kSimilar['western']!;
    }
    return _kSimilar['general']!;
  }

  // ── Static catalogue ──────────────────────────────────────────────────────────
  static const _kSimilar = <String, List<_DesignCard>>{
    'bridal': [
      _DesignCard('Heavy Bridal Lehenga',    'Rs 4,500 – 8,000',  AppColors.secondary, Icons.diamond_rounded,             'Bridal'),
      _DesignCard('Embroidered Bridal Set',   'Rs 5,000 – 9,000',  AppColors.primary,   Icons.auto_awesome_rounded,        'Bridal'),
      _DesignCard('Silk Wedding Gown',        'Rs 6,000 – 12,000', AppColors.gold,      Icons.star_rounded,                'Bridal'),
      _DesignCard('Golden Nikkah Dress',      'Rs 3,500 – 6,000',  AppColors.warning,   Icons.brightness_5_rounded,        'Bridal'),
    ],
    'formal': [
      _DesignCard('Formal Shalwar Kameez',    'Rs 1,800 – 3,200',  AppColors.info,      Icons.business_center_rounded,     'Formal'),
      _DesignCard('Linen Executive Suit',     'Rs 2,200 – 4,000',  AppColors.teal,      Icons.checkroom_rounded,           'Formal'),
      _DesignCard('Classic Kurta Pajama',     'Rs 1,500 – 2,800',  AppColors.primary,   Icons.style_rounded,               'Formal'),
      _DesignCard('Sherwani Set',             'Rs 4,000 – 8,000',  AppColors.secondary, Icons.military_tech_rounded,       'Formal'),
    ],
    'eastern': [
      _DesignCard('Long Anarkali Frock',      'Rs 2,500 – 4,500',  AppColors.teal,      Icons.layers_rounded,              'Eastern'),
      _DesignCard('Printed Georgette Suit',   'Rs 1,800 – 3,000',  AppColors.secondary, Icons.palette_rounded,             'Eastern'),
      _DesignCard('Floor-length Maxi',        'Rs 2,000 – 3,800',  AppColors.primary,   Icons.view_day_rounded,            'Eastern'),
      _DesignCard('Cotton Palazzo Set',       'Rs 1,500 – 2,500',  AppColors.info,      Icons.air_rounded,                 'Eastern'),
    ],
    'casual': [
      _DesignCard('Lawn Summer Suit',         'Rs 1,200 – 2,000',  AppColors.warning,   Icons.wb_sunny_rounded,            'Casual'),
      _DesignCard('Casual Cotton Kameez',     'Rs 900 – 1,500',    AppColors.success,   Icons.dry_cleaning_rounded,        'Casual'),
      _DesignCard('Kids Party Frock',         'Rs 800 – 1,400',    AppColors.secondary, Icons.child_care_rounded,          'Casual'),
      _DesignCard('Comfy Loungewear Set',     'Rs 1,100 – 1,800',  AppColors.teal,      Icons.self_improvement_rounded,    'Casual'),
    ],
    'western': [
      _DesignCard('Party Wear Short Dress',   'Rs 2,000 – 4,000',  AppColors.primary,   Icons.nightlife_rounded,           'Western'),
      _DesignCard('Formal Blazer & Trousers', 'Rs 3,500 – 6,000',  AppColors.info,      Icons.work_rounded,                'Western'),
      _DesignCard('Flared Midi Dress',        'Rs 2,200 – 3,800',  AppColors.secondary, Icons.accessibility_rounded,       'Western'),
      _DesignCard('Denim Jacket Set',         'Rs 1,800 – 3,000',  AppColors.teal,      Icons.grid_on_rounded,             'Western'),
    ],
    'general': [
      _DesignCard('Embroidered Suit',         'Rs 2,000 – 4,000',  AppColors.primary,   Icons.auto_fix_high_rounded,       'General'),
      _DesignCard('Printed Lawn Pair',        'Rs 1,200 – 2,200',  AppColors.teal,      Icons.texture_rounded,             'General'),
      _DesignCard('Festive Sharara',          'Rs 3,000 – 5,500',  AppColors.secondary, Icons.celebration_rounded,         'General'),
      _DesignCard('Classic Kameez',           'Rs 1,000 – 1,800',  AppColors.warning,   Icons.checkroom_rounded,           'General'),
    ],
  };

  // ── "You May Also Like" picks ─────────────────────────────────────────────────
  List<_DesignCard> get _youMayLike {
    final seen = <String>{};
    final picks = <_DesignCard>[];
    for (final s in _mySearches) {
      for (final card in _similarFor(s['query'] as String)) {
        if (seen.add(card.name) && picks.length < 6) picks.add(card);
      }
    }
    if (picks.isEmpty) picks.addAll(_kSimilar['general']!);
    return picks;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final mySearches = _mySearches;
    final isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.purpleOrb,
        orb2: AppColors.pinkOrb,
        orb3: AppColors.tealOrb,
        child: SafeArea(
          child: Column(
            children: [
              // ── Fixed header ───────────────────────────────────────────────
              _buildAppBar(),
              _buildSearchBar(),
              // ── Scrollable body ────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isSearching) ...[
                        _buildBanner(mySearches),
                        _buildTrendingRow(),
                        if (mySearches.isEmpty)
                          _buildEmptyState()
                        else ...[
                          _sectionHead(
                            'Based on Your Searches',
                            Icons.history_rounded,
                            AppColors.primaryLight,
                            top: 20,
                          ),
                          ...mySearches.map((s) => _SearchBlock(
                                search: s,
                                suggestions:
                                    _similarFor(s['query'] as String),
                                timeLabel: _timeLabel(s['hoursAgo'] as int),
                                catColor:
                                    _catColor(s['category'] as String),
                                onCardTap: (card) =>
                                    _showDesignSheet(card),
                              )),
                        ],
                        _sectionHead(
                          'You May Also Like',
                          Icons.auto_awesome_rounded,
                          AppColors.gold,
                          top: 24,
                          bottom: 12,
                        ),
                        _buildGrid(_youMayLike),
                      ] else ...[
                        // ── Live search results ──────────────────────────────
                        _buildSearchResultsSection(),
                      ],
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

  // ═══════════════════════════════════════════════════════════════════════════
  // WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  // ── App Bar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: AppColors.textPrimary, size: 20),
          ),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.primary, Color(0xFFA855F7)],
            ).createShader(b),
            child: const Icon(Icons.recommend_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Recommendations',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                Text('Designs tailored just for you',
                    style: GoogleFonts.poppins(
                        color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {}),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.refresh_rounded,
                  color: AppColors.primaryLight, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _searchQuery.isNotEmpty
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFA855F7)],
                ).createShader(b),
                child: const Icon(Icons.search_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                onSubmitted: _onSearch,
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText:
                      'Search designs — e.g. "bridal lehenga", "anarkali"…',
                  hintStyle: GoogleFonts.poppins(
                      color: AppColors.textMuted, fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: _clearSearch,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.textMuted, size: 14),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('AI',
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Live Search Results ───────────────────────────────────────────────────────
  Widget _buildSearchResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHead(
          'Results for "$_searchQuery"',
          Icons.search_rounded,
          AppColors.primaryLight,
          top: 20,
          bottom: 4,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Text('${_liveResults.length} similar designs found',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 11)),
        ),
        _buildGrid(_liveResults),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const BrowseTailorsScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.explore_rounded,
                      color: AppColors.primaryLight, size: 18),
                  const SizedBox(width: 8),
                  Text('Browse All Tailors for this Design',
                      style: GoogleFonts.poppins(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Banner ────────────────────────────────────────────────────────────────────
  Widget _buildBanner(List<Map<String, dynamic>> searches) {
    final name = _user?.name.split(' ').first ?? 'You';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            const Color(0xFFA855F7).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hey $name! 👋',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  searches.isEmpty
                      ? 'Search designs above to get personalised recommendations.'
                      : 'We found styles similar to your ${searches.length} recent searches.',
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.45),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  _Pill('${searches.length} Searches',
                      AppColors.primaryLight),
                  const SizedBox(width: 8),
                  _Pill('AI Powered', AppColors.teal),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFA855F7)],
                ).createShader(b),
                child: const Icon(Icons.recommend_rounded,
                    color: Colors.white, size: 36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Trending Row ─────────────────────────────────────────────────────────────
  Widget _buildTrendingRow() {
    final trends = _trending;
    if (trends.isEmpty) return const SizedBox.shrink();

    final colors = [
      AppColors.secondary, AppColors.teal, AppColors.primary,
      AppColors.warning,   AppColors.info,  AppColors.success,
      AppColors.riderColor, AppColors.gold, AppColors.primaryLight, AppColors.tealLight,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHead('Trending This Week',
            Icons.local_fire_department_rounded, AppColors.riderColor,
            top: 20, bottom: 10),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: trends.length,
            itemBuilder: (_, i) {
              final t = trends[i];
              final c = colors[i % colors.length];
              return GestureDetector(
                onTap: () => _applyTrending(t.key),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: c.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.key,
                          style: GoogleFonts.poppins(
                              color: c,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: c.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${t.value}',
                            style: GoogleFonts.poppins(
                                color: c,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: EmptyState(
        icon: Icons.search_rounded,
        title: 'No searches yet',
        subtitle:
            'Type a design above or explore tailors — we\'ll suggest similar styles here',
      ),
    );
  }

  // ── Design grid ───────────────────────────────────────────────────────────────
  Widget _buildGrid(List<_DesignCard> cards) {
    if (cards.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemCount: cards.length,
        itemBuilder: (_, i) => _DesignTile(
          card: cards[i],
          onTap: () => _showDesignSheet(cards[i]),
        ),
      ),
    );
  }

  // ── Section heading ───────────────────────────────────────────────────────────
  Widget _sectionHead(String text, IconData icon, Color color,
      {double top = 0, double bottom = 0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, top, 16, bottom),
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(text,
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ]),
    );
  }

  // ── Design detail sheet ───────────────────────────────────────────────────────
  void _showDesignSheet(_DesignCard card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            // Icon + name row
            Row(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: card.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(card.icon, color: card.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.name,
                          style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 2),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: card.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(card.category,
                              style: GoogleFonts.poppins(
                                  color: card.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ]),
              ),
            ]),
            const SizedBox(height: 18),
            // Price
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: card.color.withValues(alpha: 0.2)),
              ),
              child: Row(children: [
                Icon(Icons.payments_outlined,
                    color: card.color, size: 18),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Price Range',
                          style: GoogleFonts.poppins(
                              color: AppColors.textMuted, fontSize: 11)),
                      Text(card.price,
                          style: GoogleFonts.poppins(
                              color: card.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ]),
              ]),
            ),
            const SizedBox(height: 12),
            // Delivery time
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(children: [
                const Icon(Icons.schedule_rounded,
                    color: AppColors.textMuted, size: 16),
                const SizedBox(width: 10),
                Text('Estimated delivery: 3 – 10 days',
                    style: GoogleFonts.poppins(
                        color: AppColors.textSecondary, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 22),
            // Find Tailors button
            GradientButton(
              text: 'Find Tailors for this Design',
              colors: [card.color, card.color.withValues(alpha: 0.7)],
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BrowseTailorsScreen()),
                );
              },
            ),
            const SizedBox(height: 10),
            // Save button
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${card.name} saved to wishlist!',
                      style: GoogleFonts.poppins()),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bookmark_border_rounded,
                        color: AppColors.success, size: 18),
                    const SizedBox(width: 8),
                    Text('Save to Wishlist',
                        style: GoogleFonts.poppins(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _SearchBlock — one "Searched X → Similar Y" row
// ══════════════════════════════════════════════════════════════════════════════
class _SearchBlock extends StatelessWidget {
  final Map<String, dynamic> search;
  final List<_DesignCard> suggestions;
  final String timeLabel;
  final Color catColor;
  final void Function(_DesignCard) onCardTap;

  const _SearchBlock({
    required this.search,
    required this.suggestions,
    required this.timeLabel,
    required this.catColor,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final query = search['query'] as String;
    final cat = search['category'] as String;
    final q = query.isEmpty ? query : query[0].toUpperCase() + query.substring(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label row ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(children: [
            Icon(Icons.search_rounded, color: catColor, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Text(q,
                  style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: catColor.withValues(alpha: 0.3)),
              ),
              child: Text(cat,
                  style: GoogleFonts.poppins(
                      color: catColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Text(timeLabel,
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 10)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 36, bottom: 8),
          child: Text('Similar designs you might love:',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 11)),
        ),
        // ── Horizontal card strip ─────────────────────────────────────────────
        SizedBox(
          height: 154,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: suggestions.length,
            itemBuilder: (_, i) => _DesignTile(
              card: suggestions[i],
              width: 134,
              onTap: () => onCardTap(suggestions[i]),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// _DesignTile
// ══════════════════════════════════════════════════════════════════════════════
class _DesignTile extends StatelessWidget {
  final _DesignCard card;
  final double? width;
  final VoidCallback onTap;

  const _DesignTile({
    required this.card,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 10, bottom: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              card.color.withValues(alpha: 0.14),
              card.color.withValues(alpha: 0.07),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: card.color.withValues(alpha: 0.38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: card.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(card.icon, color: card.color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(card.name,
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const Spacer(),
            Text(card.price,
                style: GoogleFonts.poppins(
                    color: card.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 10)),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: card.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(card.category,
                      style: GoogleFonts.poppins(
                          color: card.color,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: card.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.arrow_forward_rounded,
                    color: card.color, size: 13),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Data models ────────────────────────────────────────────────────────────────
class _DesignCard {
  final String name, price, category;
  final Color color;
  final IconData icon;
  const _DesignCard(this.name, this.price, this.color, this.icon, this.category);
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10)),
      );
}
