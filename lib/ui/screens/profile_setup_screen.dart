import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../controllers/profile_setup_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  final bool isEditing;
  const ProfileSetupScreen({super.key, this.isEditing = false});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late ProfileSetupController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileSetupController();
    _controller.init(context.read<SettingsProvider>(), widget.isEditing);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sp = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Profile' : 'Complete Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: cs.onSurface,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _controller.pickImage(context),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: cs.primary.withValues(alpha: 0.1),
                        backgroundImage: _controller.imagePath != null
                            ? FileImage(File(_controller.imagePath!))
                            : null,
                        child: _controller.imagePath == null
                            ? Icon(Icons.person_rounded,
                                size: 60, color: cs.primary)
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.surface, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _controller.nameCtrl,
                  labelText: 'Full Name',
                  prefixIcon: Icons.badge_rounded,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _controller.contactCtrl,
                  labelText: 'Contact Number or Email',
                  prefixIcon: Icons.contact_mail_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  onPressed: () =>
                      _controller.save(context, sp, widget.isEditing),
                  text: widget.isEditing ? 'Save Changes' : 'Continue',
                  isLoading: _controller.isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}