import 'dart:io';
import 'package:flutter/material.dart';
import '../../providers/settings_provider.dart';
import '../screens/profile_setup_screen.dart';
import 'dashboard_mini_card.dart';

class DashboardHeader extends StatelessWidget {
  final SettingsProvider sp;
  final double balance;
  final double monthInc;
  final double monthExp;

  const DashboardHeader({
    super.key,
    required this.sp,
    required this.balance,
    required this.monthInc,
    required this.monthExp,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 260,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.primary.withBlue(220)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sp.userName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                'Hi, ${sp.userName}',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          Text(
                            'Total Balance',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sp.formatAmountFull(balance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ProfileSetupScreen(isEditing: true))),
                        child: sp.userImagePath != null
                            ? CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                backgroundImage:
                                    FileImage(File(sp.userImagePath!)),
                              )
                            : CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                child: const Icon(Icons.person_rounded,
                                    color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardMiniCard(
                          label: 'Income',
                          amount: sp.formatAmount(monthInc),
                          icon: Icons.arrow_downward_rounded,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardMiniCard(
                          label: 'Expenses',
                          amount: sp.formatAmount(monthExp),
                          icon: Icons.arrow_upward_rounded,
                          color: const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}