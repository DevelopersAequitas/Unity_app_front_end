import 'package:flutter/material.dart';
import '../../domain/entities/claim_activity_entity.dart';
import 'claim_activity_bottom_sheet.dart';

class ClaimActivityDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required ClaimActivityEntity activity,
  }) {
    return ClaimActivityBottomSheet.show(context, activity: activity);
  }
}
