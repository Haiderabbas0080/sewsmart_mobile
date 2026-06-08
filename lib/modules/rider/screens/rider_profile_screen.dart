import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';
import 'rider_earnings_screen.dart';
import 'rider_payment_screen.dart';

class RiderProfileScreen extends StatelessWidget {
  const RiderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.orangeOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SewAppBar(title: 'My Profile'),
                _buildProfileHeader(),
                _buildStatRow(),
                const SizedBox(height: 20),
                _buildMenuItems(context),
                const SizedBox(height: 24),
                _buildAssignedNote(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.riderColor, Color(0xFFF97316)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
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
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ali Raza',
                  style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.verified_rounded, color: AppColors.info, size: 18),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Delivery Rider',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 8),
            const StarRating(rating: 4.8, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow() {
    final stats = [
      {'label': 'Total Deliveries', 'value': '156', 'color': AppColors.riderColor},
      {'label': 'This Month', 'value': '28', 'color': AppColors.info},
      {'label': 'Rating', 'value': '4.8', 'color': AppColors.gold},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: stats.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return Expanded(
              child: Column(
                children: [
                  Text(
                    s['value'] as String,
                    style: GoogleFonts.poppins(
                      color: s['color'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    s['label'] as String,
                    style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  if (i < stats.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(),
                    ),
                ],
              ),
            );
          }).toList()
            ..insert(1, Expanded(flex: 0, child: Container(width: 1, height: 40, color: AppColors.divider)))
            ..insert(3, Expanded(flex: 0, child: Container(width: 1, height: 40, color: AppColors.divider))),
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final items = [
      {
        'icon': Icons.edit_rounded,
        'label': 'Edit Profile',
        'color': AppColors.riderColor,
        'onTap': () => _showEditProfileDialog(context),
      },
      {
        'icon': Icons.folder_rounded,
        'label': 'Documents',
        'color': AppColors.info,
        'onTap': () => _showInfoDialog(context, 'Documents',
            'Your documents are verified and on file.\nCNIC: ****-*******-1\nLicense: Verified ✓'),
      },
      {
        'icon': Icons.history_rounded,
        'label': 'Earnings History',
        'color': AppColors.gold,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RiderEarningsScreen()),
            ),
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'label': 'Payment Methods',
        'color': AppColors.warning,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RiderPaymentScreen()),
            ),
      },
      {
        'icon': Icons.help_rounded,
        'label': 'Help & Support',
        'color': AppColors.primary,
        'onTap': () => _showInfoDialog(context, 'Help & Support',
            'For support contact:\nsupport@sewsmart.com\n\nOr call: 0300-SEWSMART\nAvailable 9AM – 9PM'),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ...items.map((item) => _MenuItem(
            icon: item['icon'] as IconData,
            label: item['label'] as String,
            color: item['color'] as Color,
            onTap: item['onTap'] as VoidCallback,
          )),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            color: AppColors.error,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.card,
                  title: Text('Sign Out?', style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  content: Text('Are you sure you want to sign out?', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text('Sign Out', style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.textMuted, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                  children: [
                    const TextSpan(text: 'Assigned by '),
                    TextSpan(
                      text: "Sana's Couture",
                      style: GoogleFonts.poppins(
                        color: AppColors.tealLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                    const TextSpan(text: ' · Verified by '),
                    TextSpan(
                      text: 'Admin',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
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

// ── Helper dialogs ─────────────────────────────────────────────────────────────
void _showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title,
          style: GoogleFonts.poppins(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      content: Text(message,
          style: GoogleFonts.poppins(
              color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Close',
              style: GoogleFonts.poppins(color: AppColors.primaryLight)),
        ),
      ],
    ),
  );
}

void _showEditProfileDialog(BuildContext context) {
  final nameCtrl = TextEditingController(text: 'Ali Raza');
  final phoneCtrl = TextEditingController(text: '0304-5678901');
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Edit Profile',
          style: GoogleFonts.poppins(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(hint: 'Full Name', icon: Icons.person_rounded, ctrl: nameCtrl),
          const SizedBox(height: 10),
          AppTextField(
              hint: 'Phone',
              icon: Icons.phone_rounded,
              ctrl: phoneCtrl,
              keyboard: TextInputType.phone),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel',
              style: GoogleFonts.poppins(color: AppColors.textMuted)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated!',
                    style: GoogleFonts.poppins()),
                backgroundColor: AppColors.success,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.riderColor, Color(0xFFF97316)]),
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.error.withValues(alpha: 0.06) : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? AppColors.error.withValues(alpha: 0.25) : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
