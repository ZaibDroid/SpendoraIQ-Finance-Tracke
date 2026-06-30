import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboard_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingController _controller;

  final List<OnboardData> _pages = [
    OnboardData(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Track\nExpenses',
      subtitle: 'Easily record your daily income and expenses.',
      gradient: [const Color(0xFF6C63FF), const Color(0xFF3D5AF1)],
    ),
    OnboardData(
      icon: Icons.insights_rounded,
      title: 'Set\nBudgets',
      subtitle: 'Set monthly limits for categories to control your spending.',
      gradient: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
    ),
    OnboardData(
      icon: Icons.pie_chart_rounded,
      title: 'View\nAnalytics',
      subtitle: 'See where you spend your money with clear charts and graphs.',
      gradient: [const Color(0xFFfc5c65), const Color(0xFFfd9644)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              PageView.builder(
                controller: _controller.pageController,
                onPageChanged: _controller.setPage,
                itemCount: _pages.length,
                itemBuilder: (_, i) => OnboardPage(data: _pages[i]),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 48),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: i == _controller.currentPage ? 28 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white.withValues(
                                  alpha: i == _controller.currentPage ? 1.0 : 0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          if (_controller.currentPage > 0)
                            TextButton(
                              onPressed: _controller.previous,
                              child: const Text('Back',
                                  style: TextStyle(color: Colors.white70)),
                            ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () =>
                                _controller.next(context, _pages.length),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              _controller.currentPage == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      if (_controller.currentPage < _pages.length - 1)
                        TextButton(
                          onPressed: () => _controller.finish(context),
                          child: const Text('Skip',
                              style: TextStyle(color: Colors.white60)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}