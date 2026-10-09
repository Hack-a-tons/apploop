import 'package:flutter/material.dart';

/// Honest placeholder for loop stages that land in later features.
/// Shows what is coming — no fake buttons.
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final String feature;

  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '$title arrive in $feature.\n\nSee PLAN.md for the build order.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
