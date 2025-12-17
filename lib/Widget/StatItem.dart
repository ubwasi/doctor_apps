import 'package:doctor_apps/Theme/Theme.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String count;
  final String label;

  const StatItem({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final countFontSize = screenWidth * 0.05;
    final labelFontSize = screenWidth * 0.035;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                count,
                style: TextStyle(
                  fontSize: countFontSize,
                  fontWeight: FontWeight.bold,
                  color: LightTheme.titleColors.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: labelFontSize,
                  color: LightTheme.subTitleColors
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
