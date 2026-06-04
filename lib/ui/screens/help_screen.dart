import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const _FaqItem(
            question: 'How do I add an expense?',
            answer: 'Tap the prominent "+" button at the bottom of the screen to open the Add Expense sheet. Fill in the amount, title, and category, then tap Save.',
          ),
          const _FaqItem(
            question: 'How do I set a budget?',
            answer: 'Navigate to the Budget tab from the bottom navigation bar. Tap on any category to set or update your monthly spending limit.',
          ),
          const _FaqItem(
            question: 'How do I view my past spending?',
            answer: 'Go to the Analytics tab. You can use the date picker at the top to select any custom date range to see your category breakdown and total expenses.',
          ),
          const _FaqItem(
            question: 'Is my data safe?',
            answer: 'Yes! All your data is stored locally on your device. We do not transmit your financial data to any external servers.',
          ),
          const _FaqItem(
            question: 'How do I backup my data?',
            answer: 'Go to Settings > Data Management > Export Data. This will generate a JSON file containing all your records which you can save to your device or email to yourself.',
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Need more help? Contact us at\nsupport@smartexpense.app',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w500, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(fontSize: 15, color: cs.onSurface.withValues(alpha: 0.8), height: 1.4),
          ),
        ],
      ),
    );
  }
}
