import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/app_models.dart';
import '../../../core/data/mock_data.dart';
import '../../auth/screens/login_screen.dart';
import 'payment_methods_screen.dart';
// ignore_for_file: use_build_context_synchronously

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _signingOut = false;

  UserModel? get _user => AuthService().currentUser;

  int get _totalOrders => MockData.orders.where((o) => o.customerId == _user?.id).length;
  int get _reviewCount => MockData.reviews.where((r) => r.customerId == _user?.id).length;

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    await AuthService().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(user),
                _buildStatRow(),
                const SizedBox(height: 8),
                _buildAccountSection(user),
                _buildAppSection(),
                _buildSupportSection(),
                const SizedBox(height: 20),
                _buildSignOutButton(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight, AppColors.teal],
                  ),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20)],
                ),
                child: Center(
                  child: Text(user.initials, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(user.name, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(user.email, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(user.phone, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.customerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.customerColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_rounded, color: AppColors.customerColor, size: 14),
                const SizedBox(width: 5),
                Text('Customer', style: GoogleFonts.poppins(color: AppColors.customerColor, fontSize: 11, fontWeight: FontWeight.w600)),
                if (user.isVerified) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded, color: AppColors.info, size: 14),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          _StatBox(label: 'Orders', value: '$_totalOrders', icon: Icons.receipt_long_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          _StatBox(label: 'Reviews', value: '$_reviewCount', icon: Icons.star_rounded, color: AppColors.gold),
          const SizedBox(width: 10),
          _StatBox(label: 'Saved', value: '3', icon: Icons.bookmark_rounded, color: AppColors.teal),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
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

  void _showEditProfileDialog(UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone);
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
                  content: Text('Profile updated!', style: GoogleFonts.poppins()),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight]),
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

  Widget _buildAccountSection(UserModel user) {
    return _SettingsSection(
      title: 'Account',
      icon: Icons.person_outline_rounded,
      children: [
        _SettingsTile(
          icon: Icons.edit_outlined,
          label: 'Edit Profile',
          onTap: () => _showEditProfileDialog(user),
        ),
        _SettingsTile(
          icon: Icons.location_on_outlined,
          label: 'Addresses',
          trailing: user.city ?? 'Not set',
          onTap: () => _showInfoDialog('Addresses',
              'Default Address:\n${user.city ?? 'No city set'}\n\nTo add more addresses, a full address management screen will be available soon.'),
        ),
        _SettingsTile(
          icon: Icons.credit_card_outlined,
          label: 'Payment Methods',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PaymentMethodsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSection() {
    return _SettingsSection(
      title: 'App Settings',
      icon: Icons.settings_outlined,
      children: [
        _SettingsTile(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          trailing: Switch(
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            activeColor: AppColors.primaryLight,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onTap: null,
        ),
        _SettingsTile(icon: Icons.language_outlined, label: 'Language', trailing: 'English', onTap: () {}),
        _SettingsTile(
          icon: Icons.dark_mode_outlined,
          label: 'Dark Mode',
          trailing: Switch(
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
            activeColor: AppColors.primaryLight,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onTap: null,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _SettingsSection(
      title: 'Support',
      icon: Icons.help_outline_rounded,
      children: [
        _SettingsTile(
          icon: Icons.help_center_outlined,
          label: 'Help Center',
          onTap: () => _showInfoDialog('Help Center',
              'Frequently Asked Questions:\n\n• How to place an order?\n  Tap a tailor → Book → Fill details\n\n• How to track my order?\n  Go to Orders tab → Track Order\n\n• Contact: support@sewsmart.com\n• Call: 0300-SEWSMART (9AM–9PM)'),
        ),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'Privacy Policy',
          onTap: () => _showInfoDialog('Privacy Policy',
              'SewSmart collects only the data needed to provide tailoring services. Your personal information is never shared with third parties without consent.\n\nFor the full policy visit: sewsmart.com/privacy'),
        ),
        _SettingsTile(
          icon: Icons.info_outline_rounded,
          label: 'About SewSmart',
          trailing: 'v1.0.0',
          onTap: () => _showInfoDialog('About SewSmart',
              'SewSmart v1.0.0\n\nAI-powered digital tailoring marketplace connecting customers with skilled tailors across Pakistan.\n\nDeveloped as Final Year Project\nUniversity of Central Punjab\n\n© 2025 SewSmart'),
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: _signOut,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_signingOut)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.error, strokeWidth: 2))
              else ...[
                const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                const SizedBox(width: 10),
                Text('Sign Out', style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ],
          ),
        ),
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
          Text(value, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
        ],
      ),
    ),
  );
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 14),
            const SizedBox(width: 6),
            Text(title, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(children: children),
        ),
      ],
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic trailing;
  final VoidCallback? onTap;
  const _SettingsTile({required this.icon, required this.label, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget;
    if (trailing is Widget) {
      trailingWidget = trailing as Widget;
    } else if (trailing is String) {
      trailingWidget = Text(trailing as String, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12));
    } else {
      trailingWidget = const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.cardAlt, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: AppColors.textSecondary, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13))),
            trailingWidget,
          ],
        ),
      ),
    );
  }
}
