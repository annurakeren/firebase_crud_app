import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 56),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.softCream,
            child: Icon(
              icon,
              size: 42,
              color: AppColors.amberwood,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}