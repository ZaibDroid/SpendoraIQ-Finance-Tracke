import 'package:flutter/material.dart';

class OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  OnboardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class OnboardPage extends StatelessWidget {
  final OnboardData data;

  const OnboardPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Icon(data.icon, size: 90, color: Colors.white),
              ),
              const Spacer(),
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data.subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 160),
            ],
          ),
        ),
      ),
    );
  }
}
