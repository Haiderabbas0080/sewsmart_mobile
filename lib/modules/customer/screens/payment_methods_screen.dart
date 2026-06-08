import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // ignore: prefer_final_fields
  List<_PayMethod> _methods = [
    _PayMethod(
      type: 'JazzCash',
      detail: '0301-2345678',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.warning,
      isDefault: true,
    ),
    _PayMethod(
      type: 'Cash on Delivery',
      detail: 'Pay when received',
      icon: Icons.payments_rounded,
      color: AppColors.success,
      isDefault: false,
    ),
  ];

  void _setDefault(int index) {
    setState(() {
      for (int i = 0; i < _methods.length; i++) {
        _methods[i] = _methods[i].copyWith(isDefault: i == index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_methods[index].type} set as default',
            style: GoogleFonts.poppins()),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeMethod(int index) {
    if (_methods[index].isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot remove the default payment method',
              style: GoogleFonts.poppins()),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Method?',
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        content: Text(
          'Remove "${_methods[index].type}" from your saved methods?',
          style: GoogleFonts.poppins(
              color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _methods.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment method removed',
                      style: GoogleFonts.poppins()),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text('Remove',
                style: GoogleFonts.poppins(
                    color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (ctx) => _AddMethodSheet(
        onAdd: (method) {
          setState(() => _methods.add(method));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${method.type} added!',
                  style: GoogleFonts.poppins()),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.purpleOrb,
        orb2: AppColors.tealOrb,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildMethodsList(),
                      const SizedBox(height: 14),
                      _buildAddButton(),
                      const SizedBox(height: 24),
                      _buildAcceptedMethods(),
                      const SizedBox(height: 24),
                      _buildSecurityNote(),
                      const SizedBox(height: 30),
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
          const Icon(Icons.credit_card_rounded,
              color: AppColors.primaryLight, size: 22),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payment Methods',
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            Text('Manage your payment options',
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 11)),
          ]),
        ],
      ),
    );
  }

  // ── Methods List ─────────────────────────────────────────────────────────────
  Widget _buildMethodsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.account_balance_wallet_outlined,
              color: AppColors.textMuted, size: 14),
          const SizedBox(width: 6),
          Text('SAVED METHODS',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 10),
        ..._methods.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: m.isDefault
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: m.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(m.icon, color: m.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(m.type,
                            style: GoogleFonts.poppins(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        if (m.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Default',
                                style: GoogleFonts.poppins(
                                    color: AppColors.primaryLight,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ]),
                      Text(m.detail,
                          style: GoogleFonts.poppins(
                              color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: AppColors.cardAlt,
                  icon: const Icon(Icons.more_vert_rounded,
                      color: AppColors.textMuted, size: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onSelected: (v) {
                    if (v == 'default') _setDefault(i);
                    if (v == 'remove') _removeMethod(i);
                  },
                  itemBuilder: (_) => [
                    if (!m.isDefault)
                      PopupMenuItem(
                        value: 'default',
                        child: Row(children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.success, size: 16),
                          const SizedBox(width: 8),
                          Text('Set as Default',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textPrimary,
                                  fontSize: 13)),
                        ]),
                      ),
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(children: [
                        const Icon(Icons.delete_outline_rounded,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: 8),
                        Text('Remove',
                            style: GoogleFonts.poppins(
                                color: AppColors.error, fontSize: 13)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Add Button ───────────────────────────────────────────────────────────────
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _openAddSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Add Payment Method',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ── Accepted Methods ─────────────────────────────────────────────────────────
  Widget _buildAcceptedMethods() {
    final methods = [
      _AcceptedMethod('JazzCash', Icons.account_balance_wallet_rounded,
          AppColors.warning),
      _AcceptedMethod(
          'EasyPaisa', Icons.mobile_friendly_rounded, AppColors.success),
      _AcceptedMethod(
          'Bank Transfer', Icons.account_balance_rounded, AppColors.info),
      _AcceptedMethod('Card', Icons.credit_card_rounded, AppColors.primary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.textMuted, size: 14),
          const SizedBox(width: 6),
          Text('ACCEPTED PAYMENTS',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 12),
        Row(
          children: methods.asMap().entries.map((entry) {
            final i = entry.key;
            final m = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < methods.length - 1 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: m.color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: m.color.withValues(alpha: 0.2)),
                ),
                child: Column(children: [
                  Icon(m.icon, color: m.color, size: 20),
                  const SizedBox(height: 4),
                  Text(m.name,
                      style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                ]),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Security Note ────────────────────────────────────────────────────────────
  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        const Icon(Icons.lock_outline_rounded,
            color: AppColors.success, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Your payment information is encrypted and securely stored.',
            style: GoogleFonts.poppins(
                color: AppColors.textSecondary, fontSize: 11),
          ),
        ),
      ]),
    );
  }
}

// ── Add Method Bottom Sheet ────────────────────────────────────────────────────
class _AddMethodSheet extends StatefulWidget {
  final void Function(_PayMethod method) onAdd;
  const _AddMethodSheet({required this.onAdd});

  @override
  State<_AddMethodSheet> createState() => _AddMethodSheetState();
}

class _AddMethodSheetState extends State<_AddMethodSheet> {
  String _selectedType = 'JazzCash';
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  static const _types = [
    _AcceptedMethod('JazzCash', Icons.account_balance_wallet_rounded,
        AppColors.warning),
    _AcceptedMethod(
        'EasyPaisa', Icons.mobile_friendly_rounded, AppColors.success),
    _AcceptedMethod(
        'Bank Transfer', Icons.account_balance_rounded, AppColors.info),
    _AcceptedMethod('Cash on Delivery', Icons.payments_rounded, AppColors.teal),
    _AcceptedMethod(
        'Debit / Credit Card', Icons.credit_card_rounded, AppColors.primary),
  ];

  bool get _needsDetail => _selectedType != 'Cash on Delivery';

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.teal]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text('Add Payment Method',
                  style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
            ]),
            const SizedBox(height: 20),
            Text('PAYMENT TYPE',
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types
                  .map((t) => GestureDetector(
                        onTap: () =>
                            setState(() => _selectedType = t.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedType == t.name
                                ? t.color.withValues(alpha: 0.18)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedType == t.name
                                  ? t.color
                                  : AppColors.divider,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(t.icon, color: t.color, size: 14),
                              const SizedBox(width: 6),
                              Text(t.name,
                                  style: GoogleFonts.poppins(
                                      color: _selectedType == t.name
                                          ? t.color
                                          : AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: _selectedType == t.name
                                          ? FontWeight.w600
                                          : FontWeight.normal)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            if (_needsDetail) ...[
              const SizedBox(height: 18),
              AppTextField(
                hint: 'Account Number / Mobile Number',
                icon: Icons.tag_rounded,
                ctrl: _numberCtrl,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: 'Account Holder Name',
                icon: Icons.person_rounded,
                ctrl: _nameCtrl,
              ),
            ],
            const SizedBox(height: 22),
            GradientButton(
              text: 'Add Method',
              onTap: () {
                final type = _types.firstWhere((t) => t.name == _selectedType);
                Navigator.pop(context);
                widget.onAdd(
                  _PayMethod(
                    type: _selectedType,
                    detail: _selectedType == 'Cash on Delivery'
                        ? 'Pay when received'
                        : (_numberCtrl.text.isNotEmpty
                            ? _numberCtrl.text
                            : '—'),
                    icon: type.icon,
                    color: type.color,
                    isDefault: false,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data models ────────────────────────────────────────────────────────────────

class _PayMethod {
  final String type;
  final String detail;
  final IconData icon;
  final Color color;
  final bool isDefault;

  const _PayMethod({
    required this.type,
    required this.detail,
    required this.icon,
    required this.color,
    required this.isDefault,
  });

  _PayMethod copyWith({bool? isDefault}) => _PayMethod(
        type: type,
        detail: detail,
        icon: icon,
        color: color,
        isDefault: isDefault ?? this.isDefault,
      );
}

class _AcceptedMethod {
  final String name;
  final IconData icon;
  final Color color;
  const _AcceptedMethod(this.name, this.icon, this.color);
}
