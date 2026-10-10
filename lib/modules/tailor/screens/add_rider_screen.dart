import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../services/tailor_service.dart';

class AddRiderScreen extends StatefulWidget {
  const AddRiderScreen({super.key});

  @override
  State<AddRiderScreen> createState() => _AddRiderScreenState();
}

class _AddRiderScreenState extends State<AddRiderScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  bool _submitting = false;
  bool _submitted = false;
  // The admin verifies a rider from both sides of the ID card.
  bool _idFrontUploaded = false;
  bool _idBackUploaded = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cnicCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  // What to fix before the rider can be sent for verification, or null.
  String? _problem() {
    if (_nameCtrl.text.trim().isEmpty) return "Enter the rider's full name";
    if (!Validators.isMobile(_phoneCtrl.text)) return 'Enter a valid mobile number, e.g. 0300-1234567';
    if (!Validators.isCnic(_cnicCtrl.text)) return 'Enter the 13-digit CNIC number';
    if (!_idFrontUploaded || !_idBackUploaded) return 'Upload both sides of the ID card';
    return null;
  }

  Future<void> _handleSubmit() async {
    final problem = _problem();
    if (problem != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(problem, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    final ok = await TailorService().addRider(
      tailorId: 'T001',
      riderName: _nameCtrl.text,
      riderPhone: _phoneCtrl.text,
    );
    if (mounted) {
      setState(() {
        _submitting = false;
        _submitted = ok;
      });
    }
  }

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
              const SewAppBar(title: 'Add Rider'),
              Expanded(
                child: _submitted ? _buildSuccessState() : _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.teal, AppColors.success]),
              ),
              child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Application Submitted!',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Documents sent to Admin for verification. You will be notified once the rider is verified and activated.',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Back to Dashboard',
              colors: const [AppColors.teal, AppColors.tealLight],
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            borderColor: AppColors.teal.withValues(alpha: 0.3),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline_rounded, color: AppColors.tealLight, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Riders are assigned by you and verified by Admin before activation.',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Rider Information',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            hint: 'Full Name',
            icon: Icons.person_rounded,
            ctrl: _nameCtrl,
            label: 'Rider Name',
          ),
          const SizedBox(height: 14),
          AppTextField(
            hint: 'Phone Number',
            icon: Icons.phone_rounded,
            ctrl: _phoneCtrl,
            keyboard: TextInputType.phone,
            label: 'Phone',
          ),
          const SizedBox(height: 14),
          AppTextField(
            hint: 'CNIC / ID Number',
            icon: Icons.badge_rounded,
            ctrl: _cnicCtrl,
            keyboard: TextInputType.number,
            label: 'CNIC / ID',
          ),
          const SizedBox(height: 14),
          AppTextField(
            hint: 'City',
            icon: Icons.location_on_rounded,
            ctrl: _cityCtrl,
            label: 'City',
          ),
          const SizedBox(height: 28),
          Text(
            'Upload Rider Documents',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Upload clear images of ID card (front and back)',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _UploadBox(
                  label: 'ID Front',
                  uploaded: _idFrontUploaded,
                  onTap: () => setState(() => _idFrontUploaded = !_idFrontUploaded),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _UploadBox(
                  label: 'ID Back',
                  uploaded: _idBackUploaded,
                  onTap: () => setState(() => _idBackUploaded = !_idBackUploaded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GradientButton(
            text: 'Submit for Verification',
            colors: const [AppColors.teal, AppColors.tealLight],
            loading: _submitting,
            onTap: _handleSubmit,
          ),
        ],
      ),
    );
  }
}

// The form keeps the uploaded state, so it can check both sides before submitting.
class _UploadBox extends StatelessWidget {
  final String label;
  final bool uploaded;
  final VoidCallback onTap;
  const _UploadBox({required this.label, required this.uploaded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: uploaded
              ? AppColors.teal.withValues(alpha: 0.1)
              : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: uploaded
                ? AppColors.tealLight.withValues(alpha: 0.5)
                : AppColors.divider,
            width: uploaded ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              uploaded ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: uploaded ? AppColors.tealLight : AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: uploaded ? AppColors.tealLight : AppColors.textMuted,
                fontSize: 12,
                fontWeight: uploaded ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (uploaded)
              Text(
                'Uploaded',
                style: GoogleFonts.poppins(color: AppColors.success, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }
}
