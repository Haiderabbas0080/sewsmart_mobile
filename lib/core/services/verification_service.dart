// ─── Verification Service ─────────────────────────────────────────────────────
// Tailors and riders send their documents here, and the admin approves or
// rejects them on the Verifications screen. Uses mock data for now.
// The real API reads the user from the token, so no user id is passed.

import '../models/app_models.dart';
import '../data/mock_data.dart';
import 'auth_service.dart';

class VerificationService {
  static final VerificationService _instance = VerificationService._();
  factory VerificationService() => _instance;
  VerificationService._();

  // TODO: GET /api/verifications/me
  // The latest request of the signed-in tailor or rider, or null when they have
  // not sent one yet (the API answers 404).
  Future<VerificationRequest?> getMyVerification() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final user = AuthService().currentUser;
    if (user == null) return null;
    return MockData.verifications[user.id];
  }

  // TODO: POST /api/verifications
  // Sent as multipart form data: cnic_number plus one file per document.
  // documents maps a type (cnicFront, cnicBack, businessProof or
  // drivingLicence) to the local file picked by the user.
  Future<VerificationRequest?> submitVerification({
    required String cnicNumber, required Map<String, String> documents,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final user = AuthService().currentUser;
    if (user == null || documents.isEmpty) return null;
    final request = VerificationRequest(
      id: 'VR${DateTime.now().millisecondsSinceEpoch}',
      status: 'pending',
      cnicNumber: cnicNumber.trim(),
      documents: [
        for (final entry in documents.entries)
          VerificationDocument(type: entry.key, url: entry.value),
      ],
      submittedAt: DateTime.now(),
    );
    MockData.verifications[user.id] = request;
    return request;
  }
}
