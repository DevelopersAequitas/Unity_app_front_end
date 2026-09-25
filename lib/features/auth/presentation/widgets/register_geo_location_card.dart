import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class RegisterGeoLocationCard extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final VoidCallback onPickLocation;

  const RegisterGeoLocationCard({
    super.key,
    this.latitude,
    this.longitude,
    required this.onPickLocation,
  });

  @override
  Widget build(BuildContext context) {
    if (latitude != null && longitude != null) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColor.primaryBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.my_location, size: 14, color: AppColor.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pin: ${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)} (Geo-Tagged)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onPickLocation,
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onPickLocation,
      child: const Padding(
        padding: EdgeInsets.only(top: 6, left: 4, right: 4),
        child: Row(
          children: [
            Icon(Icons.touch_app_outlined, size: 14, color: AppColor.primaryBlue),
            SizedBox(width: 4),
            Text(
              'Pick company pin on map for Near Me Peers',
              style: TextStyle(
                fontSize: 12,
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
