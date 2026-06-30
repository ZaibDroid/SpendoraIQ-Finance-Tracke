import 'package:flutter/material.dart';
import 'custom_icon_box.dart';

class DashboardMiniCard extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;

  const DashboardMiniCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CustomIconBox(
            icon: icon,
            color: color,
            size: 36,
            iconSize: 20,
            shape: BoxShape.rectangle,
            backgroundColor: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
              ),
              Text(
                amount,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}