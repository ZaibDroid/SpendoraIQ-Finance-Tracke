import 'package:flutter/material.dart';
import '../widgets/policy_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: June 2026',
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 24),
            const PolicySection(
              title: '1. Data Collection and Storage',
              content: 'SpendoraIQ is built on a privacy-first, offline architecture. All your financial data, including transactions, budgets, and profile information, is stored exclusively and locally on your device. We do not collect, transmit, or store your personal or financial data on any external servers.',
            ),
            const PolicySection(
              title: '2. Profile Information',
              content: 'Your name, contact details, and profile image are used solely to personalize your experience within the app. This information never leaves your device unless you manually initiate a data export.',
            ),
            const PolicySection(
              title: '3. Data Exporting',
              content: 'You have the ability to export your data into a JSON file for backup purposes. When you choose to export your data, the file is generated locally and shared via your device\'s native sharing mechanisms. It is your responsibility to store this exported file securely.',
            ),
            const PolicySection(
              title: '4. Third-Party Services',
              content: 'Because the app operates offline, we do not share your data with third-party analytics, marketing, or tracking services.',
            ),
            const PolicySection(
              title: '5. Changes to This Policy',
              content: 'We may update our Privacy Policy from time to time. Since the app does not connect to our servers, any updates to the policy will be distributed via app updates through your respective app store.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'By using the app, you agree to this policy.',
                style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}