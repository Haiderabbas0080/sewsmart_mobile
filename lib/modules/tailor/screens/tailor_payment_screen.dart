// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class TailorPaymentScreen extends StatefulWidget {
  const TailorPaymentScreen({super.key});
  @override
  State<TailorPaymentScreen> createState() => _TailorPaymentScreenState();
}

class _TailorPaymentScreenState extends State<TailorPaymentScreen> {
  // ── Payout methods ────────────────────────────────────────────────────────
  // ignore: prefer_final_fields
  List<_PayoutMethod> _methods = [
    _PayoutMethod(
      type: 'Bank Account',
      label: 'HBL — 0123-4567890',
      name: 'Shahid Tailor',
      icon: Icons.account_balance_rounded,
      color: AppColors.info,
      isDefault: true,
    ),
  ];

  // ── Mock earnings data ────────────────────────────────────────────────────
  static const _kHistory = <_Payout>[
    _Payout('May 2026', 'Rs 12,400', AppColors.success, true),
    _Payout('Apr 2026', 'Rs 9,800',  AppColors.success, true),
    _Payout('Mar 2026', 'Rs 15,200', AppColors.success, true),
    _Payout('Feb 2026', 'Rs 7,600',  AppColors.success, true),
  ];

  // ── Actions ───────────────────────────────────────────────────────────────
  void _setDefault(int i) {
    setState(() {
      for (int j = 0; j < _methods.length; j++) {
        _methods[j] = _methods[j].copyWith(isDefault: j == i);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${_methods[i].type} set as default payout',
          style: GoogleFonts.poppins()),
      backgroundColor: AppColors.success,
    ));
  }

  void _removeMethod(int i) {
    if (_methods[i].isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cannot remove the default payout method',
            style: GoogleFonts.poppins()),
        backgroundColor: AppColors.warning,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Account?',
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        content: Text(
          'Remove "${_methods[i].type}" from your payout accounts?',
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
              setState(() => _methods.removeAt(i));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Account removed', style: GoogleFonts.poppins()),
                backgroundColor: AppColors.error,
              ));
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
        onAdd: (m) {
          setState(() => _methods.add(m));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${m.type} added!', style: GoogleFonts.poppins()),
            backgroundColor: AppColors.success,
          ));
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
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
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      _buildEarningsSummary(),
                      const SizedBox(height: 22),
                      _buildMethodsList(),
                      const SizedBox(height: 14),
                      _buildAddButton(),
                      const SizedBox(height: 26),
                      _buildSupportedMethods(),
                      const SizedBox(height: 26),
                      _buildPayoutHistory(),
                      const SizedBox(height: 26),
                      _buildScheduleNote(),
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

  // ── App bar ───────────────────────────────────────────────────────────────
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
              color: AppColors.tealLight, size: 22),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payment Methods',
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            Text('Manage your payout accounts',
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 11)),
          ]),
        ],
      ),
    );
  }

  // ── Earnings summary ──────────────────────────────────────────────────────
  Widget _buildEarningsSummary() {
    final cards = [
      _EarnCard('Total Earned', 'Rs 44,000', AppColors.success,
          Icons.payments_rounded),
      _EarnCard('Pending Payout', 'Rs 4,200', AppColors.warning,
          Icons.hourglass_top_rounded),
      _EarnCard('Last Payout', 'Rs 12,400', AppColors.info,
          Icons.check_circle_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.bar_chart_rounded,
              color: AppColors.tealLight, size: 15),
          const SizedBox(width: 6),
          Text('EARNINGS OVERVIEW',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 12),
        Row(
          children: cards.asMap().entries.map((e) {
            final i = e.key;
            final c = e.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < cards.length - 1 ? 10 : 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.color.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(c.icon, color: c.color, size: 18),
                    const SizedBox(height: 8),
                    Text(c.amount,
                        style: GoogleFonts.poppins(
                            color: c.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    Text(c.label,
                        style: GoogleFonts.poppins(
                            color: AppColors.textMuted,
                            fontSize: 9,
                            height: 1.4)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Methods list ──────────────────────────────────────────────────────────
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
                    ? AppColors.tealLight.withValues(alpha: 0.55)
                    : AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
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
                              color: AppColors.teal.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Default',
                                style: GoogleFonts.poppins(
                                    color: AppColors.tealLight,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ]),
                      Text('${m.label}  ·  ${m.name}',
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
                                  color: AppColors.textPrimary, fontSize: 13)),
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

  // ── Add button ────────────────────────────────────────────────────────────
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _openAddSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.teal, AppColors.tealLight]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withValues(alpha: 0.4),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_rounded, color: Colors.white, size: 20),
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

  // ── Supported methods ─────────────────────────────────────────────────────
  Widget _buildSupportedMethods() {
    const supported = [
      _SupportItem('JazzCash',     Icons.account_balance_wallet_rounded, AppColors.warning),
      _SupportItem('EasyPaisa',    Icons.mobile_friendly_rounded,        AppColors.success),
      _SupportItem('Bank Account', Icons.account_balance_rounded,        AppColors.info),
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
          children: supported.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < supported.length - 1 ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: s.color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: s.color.withValues(alpha: 0.2)),
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

  // ── Payout history ────────────────────────────────────────────────────────
  Widget _buildPayoutHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.history_rounded,
              color: AppColors.textMuted, size: 14),
          const SizedBox(width: 6),
          Text('PAYOUT HISTORY',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 12),
        ..._kHistory.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: p.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.month,
                      style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  Text('Paid out to default account',
                      style: GoogleFonts.poppins(
                          color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            Text(p.amount,
                style: GoogleFonts.poppins(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
        )),
      ],
    );
  }

  // ── Schedule note ─────────────────────────────────────────────────────────
  Widget _buildScheduleNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.schedule_rounded,
                color: AppColors.tealLight, size: 15),
            const SizedBox(width: 8),
            Text('Payout Schedule',
                style: GoogleFonts.poppins(
                    color: AppColors.tealLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              '• Payouts are processed every Monday\n'
              '• Minimum payout amount: Rs 500\n'
              '• Platform fee: 5% per completed order\n'
              '• Transfers take 1–2 business days',
              style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Add payout sheet
// ═══════════════════════════════════════════════════════════════════════════
class _AddPayoutSheet extends StatefulWidget {
  final void Function(_PayoutMethod) onAdd;
  const _AddPayoutSheet({required this.onAdd});
  @override
  State<_AddPayoutSheet> createState() => _AddPayoutSheetState();
}

class _AddPayoutSheetState extends State<_AddPayoutSheet> {
  String _type = 'JazzCash';
  final _numCtrl      = TextEditingController();
  final _nameCtrl     = TextEditingController();
  final _bankCtrl     = TextEditingController();
  final _ibanCtrl     = TextEditingController();

  static const _types = <_SupportItem>[
    _SupportItem('JazzCash',     Icons.account_balance_wallet_rounded, AppColors.warning),
    _SupportItem('EasyPaisa',    Icons.mobile_friendly_rounded,        AppColors.success),
    _SupportItem('Bank Account', Icons.account_balance_rounded,        AppColors.info),
  ];

  @override
  void dispose() {
    _numCtrl.dispose(); _nameCtrl.dispose();
    _bankCtrl.dispose(); _ibanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBank = _type == 'Bank Account';

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 18),
            // Title
            Row(children: [
              Container(
                width: 4, height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.teal, AppColors.tealLight]),
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
            // Type selector
            Row(
              children: _types.map((t) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _type = t.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _type == t.name
                          ? t.color.withValues(alpha: 0.18)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _type == t.name
                              ? t.color
                              : AppColors.divider),
                    ),
                    child: Column(children: [
                      Icon(t.icon, color: t.color, size: 20),
                      const SizedBox(height: 4),
                      Text(t.name,
                          style: GoogleFonts.poppins(
                              color: _type == t.name
                                  ? t.color
                                  : AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: _type == t.name
                                  ? FontWeight.w600
                                  : FontWeight.normal),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 18),
            // Fields
            if (isBank) ...[
              AppTextField(
                hint: 'Bank Name (e.g. HBL, Meezan, MCB)',
                icon: Icons.account_balance_rounded,
                ctrl: _bankCtrl,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: 'Account Number',
                icon: Icons.tag_rounded,
                ctrl: _numCtrl,
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
                ctrl: _numCtrl,
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
              colors: const [AppColors.teal, AppColors.tealLight],
              onTap: () {
                final t = _types.firstWhere((x) => x.name == _type);
                final label = isBank
                    ? '${_bankCtrl.text.isNotEmpty ? _bankCtrl.text : "Bank"} — ${_numCtrl.text.isNotEmpty ? _numCtrl.text : "—"}'
                    : _numCtrl.text.isNotEmpty
                        ? _numCtrl.text
                        : '—';
                Navigator.pop(context);
                widget.onAdd(_PayoutMethod(
                  type: _type,
                  label: label,
                  name: _nameCtrl.text.isNotEmpty
                      ? _nameCtrl.text
                      : 'Account Holder',
                  icon: t.icon,
                  color: t.color,
                  isDefault: false,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

class _PayoutMethod {
  final String type, label, name;
  final IconData icon;
  final Color color;
  final bool isDefault;

  const _PayoutMethod({
    required this.type,
    required this.label,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
  });

  _PayoutMethod copyWith({bool? isDefault}) => _PayoutMethod(
        type: type, label: label, name: name,
        icon: icon, color: color,
        isDefault: isDefault ?? this.isDefault,
      );
}

class _SupportItem {
  final String name;
  final IconData icon;
  final Color color;
  const _SupportItem(this.name, this.icon, this.color);
}

class _EarnCard {
  final String label, amount;
  final Color color;
  final IconData icon;
  const _EarnCard(this.label, this.amount, this.color, this.icon);
}

class _Payout {
  final String month, amount;
  final Color color;
  final bool paid;
  const _Payout(this.month, this.amount, this.color, this.paid);
}
