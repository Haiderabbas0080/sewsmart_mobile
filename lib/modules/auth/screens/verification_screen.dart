import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/verification_service.dart';
import '../../../core/utils/validators.dart';

// Tailors and riders send their CNIC and one more document, and the admin
// verifies them on the Verifications screen. Tailors send business proof,
// riders a driving licence. The screen shows the state of the last request.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _DocumentType {
  final String type, label, hint;
  final IconData icon;
  const _DocumentType(this.type, this.label, this.hint, this.icon);
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _cnicFront = _DocumentType(
    'cnicFront', 'CNIC Front', 'The front of your CNIC', Icons.badge_rounded);
  static const _cnicBack = _DocumentType(
    'cnicBack', 'CNIC Back', 'The back of your CNIC', Icons.badge_outlined);
  static const _businessProof = _DocumentType(
    'businessProof',
    'Business Proof',
    'Shop photo with the signboard, a registration certificate or a utility bill in the business name',
    Icons.storefront_rounded,
  );
  static const _drivingLicence = _DocumentType(
    'drivingLicence', 'Driving Licence', 'A valid motorcycle driving licence', Icons.two_wheeler_rounded);

  final _cnicCtrl = TextEditingController();
  final Set<String> _uploaded = {};
  VerificationRequest? _request;
  bool _loading = true;
  bool _editing = false;
  bool _submitting = false;

  bool get _isRider => AuthService().currentUser?.role == UserRole.rider;
  Color get _accent => _isRider ? AppColors.riderColor : AppColors.teal;
  Color get _accentLight => _isRider ? const Color(0xFFF97316) : AppColors.tealLight;
  List<_DocumentType> get _documents =>
      [_cnicFront, _cnicBack, _isRider ? _drivingLicence : _businessProof];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _cnicCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final request = await VerificationService().getMyVerification();
    if (!mounted) return;
    setState(() {
      _request = request;
      _loading = false;
      _editing = request == null;
      if (request != null) _cnicCtrl.text = request.cnicNumber;
    });
  }

  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text, style: GoogleFonts.poppins()), backgroundColor: color));
  }

  // Opens the form again after a rejection or a request for more documents.
  void _startAgain() {
    setState(() {
      _editing = true;
      _uploaded.clear();
    });
  }

  void _toggleUpload(String type) {
    setState(() {
      if (_uploaded.contains(type)) {
        _uploaded.remove(type);
      } else {
        _uploaded.add(type);
      }
    });
  }

  Future<void> _submit() async {
    if (!Validators.isCnic(_cnicCtrl.text)) {
      _showMessage('Enter your 13-digit CNIC number', AppColors.error);
      return;
    }
    final missing = _documents.where((d) => !_uploaded.contains(d.type)).toList();
    if (missing.isNotEmpty) {
      _showMessage('Upload the ${missing.first.label}', AppColors.error);
      return;
    }
    setState(() => _submitting = true);
    // Uploads are simulated until an image picker is added, so each document
    // is sent as a file name only.
    final request = await VerificationService().submitVerification(
      cnicNumber: _cnicCtrl.text,
      documents: {for (final d in _documents) d.type: '${d.type}.jpg'},
    );
    if (!mounted) return;
    setState(() {
      _submitting = false;
      if (request != null) {
        _request = request;
        _editing = false;
      }
    });
    _showMessage(
      request != null ? 'Documents sent. The admin will review them soon.' : 'Could not send the documents. Try again.',
      request != null ? AppColors.success : AppColors.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = _request;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: _isRider ? AppColors.orangeOrb : AppColors.tealOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              const SewAppBar(title: 'Verification', subtitle: 'Documents checked by SewSmart'),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator(color: _accentLight, strokeWidth: 2))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (request != null) _buildStatusCard(request),
                            if (request != null && !_editing) ...[
                              const SizedBox(height: 20),
                              _buildDocumentsOnFile(request),
                            ],
                            if (_editing) ...[
                              if (request != null) const SizedBox(height: 20),
                              _buildForm(request),
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

  Widget _title(String text) => Text(
        text,
        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
      );

  Widget _buildStatusCard(VerificationRequest request) {
    final message = request.adminMessage;
    final IconData icon;
    final Color color;
    final String title;
    final String body;
    if (request.status == 'approved') {
      icon = Icons.verified_rounded;
      color = AppColors.success;
      title = 'Verified';
      body = _isRider
          ? 'You can be assigned deliveries. Your documents are on file.'
          : 'Customers see the verified badge on your profile.';
    } else if (request.status == 'rejected') {
      icon = Icons.cancel_rounded;
      color = AppColors.error;
      title = 'Not approved';
      body = request.rejectionReason ?? 'The admin could not verify your documents.';
    } else if (message != null) {
      icon = Icons.upload_file_rounded;
      color = AppColors.warning;
      title = 'More documents needed';
      body = message;
    } else {
      icon = Icons.hourglass_top_rounded;
      color = AppColors.info;
      title = 'Under review';
      body = 'Sent on ${_date(request.submittedAt)}. The admin usually checks documents within two working days.';
    }
    final canSendAgain = request.status == 'rejected' || message != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.18)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(body, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          if (canSendAgain && !_editing) ...[
            const SizedBox(height: 14),
            GradientButton(text: 'Send Documents Again', colors: [_accent, _accentLight], onTap: _startAgain),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentsOnFile(VerificationRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title('Documents on File'),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            children: [
              _InfoRow(icon: Icons.credit_card_rounded, label: 'CNIC number', value: _maskCnic(request.cnicNumber)),
              ..._documents.map((d) => _InfoRow(
                    icon: d.icon,
                    label: d.label,
                    value: request.has(d.type) ? 'Received' : 'Missing',
                    valueColor: request.has(d.type) ? AppColors.success : AppColors.error,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm(VerificationRequest? request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (request == null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accent.withValues(alpha: 0.18), _accentLight.withValues(alpha: 0.06)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _accent.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user_rounded, color: _accentLight, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isRider ? 'Get verified to take deliveries' : 'Get the verified badge',
                        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        _isRider
                            ? 'The admin checks your CNIC and driving licence before you can be assigned deliveries.'
                            : 'Customers trust verified tailors more. Send your CNIC and proof of your business to the admin.',
                        style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
        ],
        _title('CNIC Number'),
        const SizedBox(height: 10),
        AppTextField(
          ctrl: _cnicCtrl,
          hint: '35202-1234567-1',
          icon: Icons.credit_card_rounded,
          keyboard: TextInputType.number,
        ),
        const SizedBox(height: 22),
        _title('Documents'),
        const SizedBox(height: 4),
        Text(
          'Upload clear photos where every word can be read. Tap a document to upload it.',
          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ..._documents.map((d) => _UploadTile(
              document: d,
              uploaded: _uploaded.contains(d.type),
              color: _accentLight,
              onTap: () => _toggleUpload(d.type),
            )),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 13),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Only the SewSmart admin sees these documents.',
                style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GradientButton(
          text: 'Submit for Verification',
          colors: [_accent, _accentLight],
          loading: _submitting,
          onTap: _submit,
        ),
        if (request != null) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => setState(() => _editing = false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color valueColor;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13)),
            ),
            Text(value, style: GoogleFonts.poppins(color: valueColor, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      );
}

class _UploadTile extends StatelessWidget {
  final _DocumentType document;
  final bool uploaded;
  final Color color;
  final VoidCallback onTap;
  const _UploadTile({required this.document, required this.uploaded, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: uploaded ? color.withValues(alpha: 0.1) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: uploaded ? color.withValues(alpha: 0.5) : AppColors.divider,
            width: uploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(document.icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.label,
                    style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Text(
                    uploaded ? 'Uploaded. Tap to remove.' : document.hint,
                    style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              uploaded ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: uploaded ? AppColors.success : AppColors.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

String _date(DateTime date) => '${date.day}/${date.month}/${date.year}';

// 3520212345671 as "35202-*******-1".
String _maskCnic(String cnic) {
  final digits = Validators.digitsOnly(cnic);
  if (digits.length != 13) return cnic;
  return '${digits.substring(0, 5)}-*******-${digits.substring(12)}';
}
