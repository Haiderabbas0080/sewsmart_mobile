// ─── Payout Service ───────────────────────────────────────────────────────────
// Payout accounts and withdrawals for tailors and riders. Uses mock data for now.
// The real API reads the user from the token, so no user id is passed.

import '../models/app_models.dart';
import '../data/mock_data.dart';

class PayoutService {
  static final PayoutService _instance = PayoutService._();
  factory PayoutService() => _instance;
  PayoutService._();

  // The app states a minimum payout of Rs 500.
  static const double minimumWithdrawal = 500;

  // ── Payout accounts ─────────────────────────────────────────────────────────
  // TODO: GET /api/payout-accounts
  Future<List<PayoutAccount>> getPayoutAccounts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<PayoutAccount>.from(MockData.payoutAccounts);
  }

  // TODO: POST /api/payout-accounts
  // type is jazzCash, easyPaisa or bank. bankName and iban apply to bank only.
  Future<PayoutAccount?> addPayoutAccount({
    required String type, required String accountNumber,
    required String accountName, String? bankName, String? iban,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final account = PayoutAccount(
      id: 'PA${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      accountNumber: accountNumber,
      accountName: accountName,
      bankName: bankName,
      iban: iban,
      isDefault: MockData.payoutAccounts.isEmpty,
    );
    MockData.payoutAccounts.add(account);
    return account;
  }

  // TODO: PUT /api/payout-accounts/:id/default
  Future<bool> setDefaultPayoutAccount(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!MockData.payoutAccounts.any((a) => a.id == id)) return false;
    MockData.payoutAccounts = MockData.payoutAccounts
        .map((a) => a.copyWith(isDefault: a.id == id))
        .toList();
    return true;
  }

  // TODO: DELETE /api/payout-accounts/:id
  // The default account cannot be removed.
  Future<bool> removePayoutAccount(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = MockData.payoutAccounts.indexWhere((a) => a.id == id);
    if (idx == -1 || MockData.payoutAccounts[idx].isDefault) return false;
    MockData.payoutAccounts.removeAt(idx);
    return true;
  }

  // ── Withdrawals ─────────────────────────────────────────────────────────────
  // TODO: GET /api/withdrawals
  Future<List<WithdrawalModel>> getWithdrawals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<WithdrawalModel>.from(MockData.withdrawals);
  }

  // TODO: POST /api/withdrawals
  // Leave amount out to withdraw the whole available balance.
  Future<WithdrawalModel?> requestWithdrawal({double? amount}) async {
    await Future.delayed(const Duration(seconds: 1));
    final value = amount ?? MockData.availableBalance;
    if (value < minimumWithdrawal || MockData.payoutAccounts.isEmpty) return null;
    final withdrawal = WithdrawalModel(
      id: 'WD${DateTime.now().millisecondsSinceEpoch}',
      amount: value,
      status: 'pending',
      requestedAt: DateTime.now(),
    );
    MockData.withdrawals.insert(0, withdrawal);
    return withdrawal;
  }
}
