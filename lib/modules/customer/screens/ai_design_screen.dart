import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class AiDesignScreen extends StatefulWidget {
  const AiDesignScreen({super.key});

  @override
  State<AiDesignScreen> createState() => _AiDesignScreenState();
}

class _AiDesignScreenState extends State<AiDesignScreen> {
  final _promptCtrl = TextEditingController();
  String _selectedCategory = 'Bridal';
  String _selectedColor = 'Red';
  String _selectedFabric = 'Silk';
  bool _generating = false;
  bool _hasResult = false;

  final _categories = [
    'Bridal', 'Shalwar Kameez', 'Formal', 'Casual', 'Abaya', 'Lehenga',
  ];
  final _colors = [
    'Red', 'Blue', 'Green', 'Pink', 'Gold', 'Black', 'White', 'Teal',
  ];
  final _fabrics = [
    'Silk', 'Cotton', 'Chiffon', 'Lawn', 'Velvet', 'Organza',
  ];

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_promptCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please describe your design first',
              style: GoogleFonts.poppins()),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    setState(() {
      _generating = true;
      _hasResult = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _generating = false;
        _hasResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.purpleOrb,
        orb2: const Color(0x884C1D95),
        orb3: AppColors.pinkOrb,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeroBanner(),
                      const SizedBox(height: 20),
                      _buildPromptSection(),
                      const SizedBox(height: 20),
                      _buildCategorySection(),
                      const SizedBox(height: 20),
                      _buildColorSection(),
                      const SizedBox(height: 20),
                      _buildFabricSection(),
                      const SizedBox(height: 28),
                      GradientButton(
                        text: _generating ? 'Generating...' : 'Generate Design  ✨',
                        loading: _generating,
                        onTap: _generate,
                        colors: [AppColors.primary, const Color(0xFFA855F7)],
                      ),
                      if (_hasResult) ...[
                        const SizedBox(height: 28),
                        _buildResults(),
                      ],
                      const SizedBox(height: 40),
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

  // ── App Bar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
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
            child: const Icon(Icons.auto_awesome_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Design Studio',
                  style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
              Text('Describe your dream outfit',
                  style: GoogleFonts.poppins(
                      color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text('AI Powered',
                style: GoogleFonts.poppins(
                    color: AppColors.primaryLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Hero Banner ──────────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            const Color(0xFFA855F7).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Fashion Designer',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  'Describe any outfit and our AI will generate unique design concepts for you',
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.5),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FeaturePill('Smart AI', Icons.psychology_rounded,
                        AppColors.primaryLight),
                    const SizedBox(width: 8),
                    _FeaturePill(
                        'Instant', Icons.bolt_rounded, AppColors.gold),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 70,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [AppColors.primary, Color(0xFFA855F7)],
                ).createShader(b),
                child: const Icon(Icons.auto_fix_high_rounded,
                    color: Colors.white, size: 42),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Prompt Section ───────────────────────────────────────────────────────────
  Widget _buildPromptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('Design Description', Icons.edit_note_rounded,
            AppColors.primaryLight),
        const SizedBox(height: 8),
        AppTextField(
          hint:
              'E.g. A red bridal lehenga with golden embroidery and floral patterns...',
          icon: Icons.auto_awesome_mosaic_rounded,
          ctrl: _promptCtrl,
          maxLines: 3,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            'Red bridal lehenga',
            'Blue formal suit',
            'Golden anarkali',
            'Casual kameez',
          ]
              .map((s) => GestureDetector(
                    onTap: () => _promptCtrl.text = s,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.cardAlt,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text(s,
                          style: GoogleFonts.poppins(
                              color: AppColors.textSecondary, fontSize: 11)),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ── Category Section ─────────────────────────────────────────────────────────
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
            'Garment Category', Icons.checkroom_rounded, AppColors.primary),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories
              .map((c) => _SelectChip(
                    label: c,
                    selected: _selectedCategory == c,
                    color: AppColors.primary,
                    onTap: () => setState(() => _selectedCategory = c),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ── Color Section ────────────────────────────────────────────────────────────
  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('Color Palette', Icons.palette_rounded, AppColors.secondary),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _colors.map((c) {
              final colorVal = _colorFromName(c);
              final selected = _selectedColor == c;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 72 : 50,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: colorVal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected ? colorVal : AppColors.divider,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colorVal,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1),
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(c,
                              style: GoogleFonts.poppins(
                                  color: colorVal,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Fabric Section ───────────────────────────────────────────────────────────
  Widget _buildFabricSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
            'Fabric Type', Icons.texture_rounded, AppColors.teal),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _fabrics
              .map((f) => _SelectChip(
                    label: f,
                    selected: _selectedFabric == f,
                    color: AppColors.teal,
                    onTap: () => setState(() => _selectedFabric = f),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────────
  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
            'Generated Designs', Icons.auto_awesome_rounded, AppColors.primaryLight),
        const SizedBox(height: 4),
        Text('Tap any design to select it',
            style: GoogleFonts.poppins(
                color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
          children: List.generate(
            4,
            (i) => _DesignCard(
              index: i,
              category: _selectedCategory,
              color: _selectedColor,
              fabric: _selectedFabric,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(14),
          borderColor: AppColors.primary.withValues(alpha: 0.4),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Design sent to tailor!',
                  style: GoogleFonts.poppins()),
              backgroundColor: AppColors.success,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.send_rounded,
                    color: AppColors.primaryLight, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Send to Tailor',
                        style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    Text('Share these designs with your selected tailor',
                        style: GoogleFonts.poppins(
                            color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.textMuted, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Color _colorFromName(String name) {
    switch (name) {
      case 'Red':
        return Colors.red[400]!;
      case 'Blue':
        return Colors.blue[400]!;
      case 'Green':
        return Colors.green[400]!;
      case 'Pink':
        return Colors.pink[300]!;
      case 'Gold':
        return AppColors.gold;
      case 'Black':
        return Colors.grey[500]!;
      case 'White':
        return Colors.grey[200]!;
      case 'Teal':
        return AppColors.teal;
      default:
        return AppColors.primary;
    }
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _FeaturePill(this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 11),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _SectionLabel(this.text, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(text,
              style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      );
}

class _SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _SelectChip(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.18) : AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? color : AppColors.divider),
          ),
          child: Text(label,
              style: GoogleFonts.poppins(
                  color: selected ? color : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal)),
        ),
      );
}

class _DesignCard extends StatelessWidget {
  final int index;
  final String category, color, fabric;
  const _DesignCard(
      {required this.index,
      required this.category,
      required this.color,
      required this.fabric});

  @override
  Widget build(BuildContext context) {
    final gradients = [
      [AppColors.primary, const Color(0xFFA855F7)],
      [AppColors.secondary, const Color(0xFFEC4899)],
      [AppColors.teal, AppColors.tealLight],
      [AppColors.warning, AppColors.gold],
    ];
    final g = gradients[index % gradients.length];
    const names = ['Classic Elegance', 'Modern Twist', 'Royal Style', 'Minimalist'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            g[0].withValues(alpha: 0.15),
            g[1].withValues(alpha: 0.22),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: g[0].withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        LinearGradient(colors: [g[0], g[1]]).createShader(b),
                    child: const Icon(Icons.checkroom_rounded,
                        color: Colors.white, size: 52),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [g[0], g[1]]),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[index % names.length],
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11)),
                Text('$category · $fabric',
                    style: GoogleFonts.poppins(
                        color: AppColors.textMuted, fontSize: 9)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Text('Design selected!',
                              style: GoogleFonts.poppins()),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 1),
                        )),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [g[0], g[1]]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('Select',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Icon(Icons.favorite_border_rounded,
                          color: AppColors.textMuted, size: 12),
                    ),
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
