import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isIncome;
  final String currencySymbol;

  const AmountInputCard({
    super.key,
    required this.controller,
    required this.isIncome,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isIncome
              ? [const Color(0xFF11998e), const Color(0xFF38ef7d)]
              : [cs.primary, cs.primary.withBlue(220)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Enter Amount',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currencySymbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IntrinsicWidth(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 44,
                    ),
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
