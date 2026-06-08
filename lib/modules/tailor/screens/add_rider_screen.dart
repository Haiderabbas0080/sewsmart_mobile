import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cnicCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields', style: GoogleFonts.poppins()),
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
              Expanded(child: _UploadBox(label: 'ID Front')),
              const SizedBox(width: 14),
              Expanded(child: _UploadBox(label: 'ID Back')),
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

class _UploadBox extends StatefulWidget {
  final String label;
  const _UploadBox({required this.label});

  @override
  State<_UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends State<_UploadBox> {
  bool _uploaded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _uploaded = !_uploaded),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: _uploaded
              ? AppColors.teal.withValues(alpha: 0.1)
              : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _uploaded
                ? AppColors.tealLight.withValues(alpha: 0.5)
                : AppColors.divider,
            width: _uploaded ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _uploaded ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: _uploaded ? AppColors.tealLight : AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: GoogleFonts.poppins(
                color: _uploaded ? AppColors.tealLight : AppColors.textMuted,
                fontSize: 12,
                fontWeight: _uploaded ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (_uploaded)
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
