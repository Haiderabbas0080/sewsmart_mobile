import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class RiderPaymentScreen extends StatefulWidget {
  const RiderPaymentScreen({super.key});

  @override
  State<RiderPaymentScreen> createState() => _RiderPaymentScreenState();
}

class _RiderPaymentScreenState extends State<RiderPaymentScreen> {
  // ignore: prefer_final_fields
  List<_PayoutMethod> _methods = [
    _PayoutMethod(
      type: 'JazzCash',
      number: '0304-5678901',
      name: 'Ali Raza',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.warning,
      isDefault: true,
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
        content: Text('${_methods[index].type} set as default payout',
            style: GoogleFonts.poppins()),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _removeMethod(int index) {
    if (_methods[index].isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot remove the default payout method',
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Account?',
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        content: Text(
          'Remove "${_methods[index].type}" from your payout accounts?',
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
                  content:
                      Text('Account removed', style: GoogleFonts.poppins()),
                  backgroundColor: AppColors.error,
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
      builder: (ctx) => _AddPayoutSheet(
        onAdd: (method) {
          setState(() => _methods.add(method));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${method.type} added!',
                  style: GoogleFonts.poppins()),
              backgroundColor: AppColors.success,
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
        orb1: AppColors.orangeOrb,
        orb2: AppColors.purpleOrb,
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
                      const SizedBox(height: 4),
                      _buildInfoBanner(),
                      const SizedBox(height: 20),
                      _buildMethodsList(),
                      const SizedBox(height: 14),
                      _buildAddButton(),
                      const SizedBox(height: 24),
                      _buildSupportedSection(),
                      const SizedBox(height: 24),
                      _buildPayoutNote(),
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
          const Icon(Icons.account_balance_wallet_rounded,
              color: AppColors.riderColor, size: 22),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payout Methods',
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            Text('Where you receive your earnings',
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 11)),
          ]),
        ],
      ),
    );
  }

  // ── Info Banner ──────────────────────────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.riderColor.withValues(alpha: 0.15),
            AppColors.warning.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.riderColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.riderColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.payments_rounded,
                color: AppColors.riderColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Earnings Payout',
                    style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text(
                  'Earnings are processed every Monday. '
                  'Make sure your payout account is correct.',
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.4),
                ),
              ],
            ),
          ),
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
          const Icon(Icons.account_balance_outlined,
              color: AppColors.textMuted, size: 14),
          const SizedBox(width: 6),
          Text('PAYOUT ACCOUNTS',
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
                    ? AppColors.riderColor.withValues(alpha: 0.5)
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
                              color: AppColors.riderColor
                                  .withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Default',
                                style: GoogleFonts.poppins(
                                    color: AppColors.riderColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ]),
                      Text('${m.number}  ·  ${m.name}',
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
              colors: [AppColors.riderColor, Color(0xFFF97316)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.riderColor.withValues(alpha: 0.4),
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
            Text('Add Payout Account',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ── Supported Section ────────────────────────────────────────────────────────
  Widget _buildSupportedSection() {
    final supported = [
      _SupportedItem(
          'JazzCash', Icons.account_balance_wallet_rounded, AppColors.warning),
      _SupportedItem(
          'EasyPaisa', Icons.mobile_friendly_rounded, AppColors.success),
      _SupportedItem(
          'Bank Account', Icons.account_balance_rounded, AppColors.info),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.textMuted, size: 14),
          const SizedBox(width: 6),
          Text('SUPPORTED METHODS',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 12),
        Row(
          children: supported.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    right: i < supported.length - 1 ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: s.color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: s.color.withValues(alpha: 0.2)),
                ),
                child: Column(children: [
                  Icon(s.icon, color: s.color, size: 22),
                  const SizedBox(height: 6),
                  Text(s.name,
                      style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 10,
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

  // ── Payout Note ──────────────────────────────────────────────────────────────
  Widget _buildPayoutNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.schedule_rounded,
                color: AppColors.info, size: 16),
            const SizedBox(width: 8),
            Text('Payout Schedule',
                style: GoogleFonts.poppins(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                '• Payouts are processed every Monday\n'
                '• Minimum payout amount: Rs 500\n'
                '• Transfers take 1–2 business days',
                style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.6),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Add Payout Sheet ───────────────────────────────────────────────────────────
class _AddPayoutSheet extends StatefulWidget {
  final void Function(_PayoutMethod method) onAdd;
  const _AddPayoutSheet({required this.onAdd});

  @override
  State<_AddPayoutSheet> createState() => _AddPayoutSheetState();
}

class _AddPayoutSheetState extends State<_AddPayoutSheet> {
  String _selectedType = 'JazzCash';
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _ibanCtrl = TextEditingController();

  static const _types = [
    _SupportedItem(
        'JazzCash', Icons.account_balance_wallet_rounded, AppColors.warning),
    _SupportedItem(
        'EasyPaisa', Icons.mobile_friendly_rounded, AppColors.success),
    _SupportedItem(
        'Bank Account', Icons.account_balance_rounded, AppColors.info),
  ];

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _bankNameCtrl.dispose();
    _ibanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBankAccount = _selectedType == 'Bank Account';

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      colors: [AppColors.riderColor, Color(0xFFF97316)]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text('Add Payout Account',
                  style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
            ]),
            const SizedBox(height: 20),
            Text('ACCOUNT TYPE',
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Row(
              children: _types
                  .map((t) => Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedType = t.name),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedType == t.name
                                  ? t.color.withValues(alpha: 0.18)
                                  : AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedType == t.name
                                    ? t.color
                                    : AppColors.divider,
                              ),
                            ),
                            child: Column(children: [
                              Icon(t.icon, color: t.color, size: 20),
                              const SizedBox(height: 4),
                              Text(t.name,
                                  style: GoogleFonts.poppins(
                                      color: _selectedType == t.name
                                          ? t.color
                                          : AppColors.textSecondary,
                                      fontSize: 10,
                                      fontWeight: _selectedType == t.name
                                          ? FontWeight.w600
                                          : FontWeight.normal),
                                  textAlign: TextAlign.center),
                            ]),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 18),
            if (isBankAccount) ...[
              AppTextField(
                hint: 'Bank Name (e.g. HBL, Meezan)',
                icon: Icons.account_balance_rounded,
                ctrl: _bankNameCtrl,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: 'Account Number',
                icon: Icons.tag_rounded,
                ctrl: _numberCtrl,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: 'IBAN (Optional)',
                icon: Icons.credit_score_rounded,
                ctrl: _ibanCtrl,
              ),
            ] else ...[
              AppTextField(
                hint: 'Mobile Number (e.g. 0300-1234567)',
                icon: Icons.phone_android_rounded,
                ctrl: _numberCtrl,
                keyboard: TextInputType.phone,
              ),
            ],
            const SizedBox(height: 10),
            AppTextField(
              hint: 'Account Holder Name',
              icon: Icons.person_rounded,
              ctrl: _nameCtrl,
            ),
            const SizedBox(height: 22),
            GradientButton(
              text: 'Add Account',
              colors: [AppColors.riderColor, const Color(0xFFF97316)],
              onTap: () {
                final type = _types.firstWhere((t) => t.name == _selectedType);
                Navigator.pop(context);
                widget.onAdd(
                  _PayoutMethod(
                    type: _selectedType,
                    number: _numberCtrl.text.isNotEmpty
                        ? _numberCtrl.text
                        : '—',
                    name: _nameCtrl.text.isNotEmpty
                        ? _nameCtrl.text
                        : 'Account Holder',
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

class _PayoutMethod {
  final String type, number, name;
  final IconData icon;
  final Color color;
  final bool isDefault;

  const _PayoutMethod({
    required this.type,
    required this.number,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
  });

  _PayoutMethod copyWith({bool? isDefault}) => _PayoutMethod(
        type: type,
        number: number,
        name: name,
        icon: icon,
        color: color,
        isDefault: isDefault ?? this.isDefault,
      );
}

class _SupportedItem {
  final String name;
  final IconData icon;
  final Color color;
  const _SupportedItem(this.name, this.icon, this.color);
}
