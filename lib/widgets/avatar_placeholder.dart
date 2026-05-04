import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AvatarPlaceholder extends StatelessWidget {
  final double radius;
  final String? fotoUrl;
  final VoidCallback? onTapCamera;

  const AvatarPlaceholder({
    super.key,
    this.radius = 30,
    this.fotoUrl,
    this.onTapCamera,
  });

  bool get hasPhoto => fotoUrl != null && fotoUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.softCream,
      backgroundImage: hasPhoto ? NetworkImage(fotoUrl!) : null,
      child: hasPhoto
          ? null
          : Icon(
              Icons.person_rounded,
              size: radius,
              color: AppColors.amberwood,
            ),
    );

    if (onTapCamera == null) {
      return avatar;
    }

    return Stack(
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            radius: radius * 0.33,
            backgroundColor: AppColors.amberwood,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onTapCamera,
              icon: Icon(
                Icons.camera_alt_rounded,
                size: radius * 0.32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}