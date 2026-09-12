import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileAboutBusinessCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileAboutBusinessCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final mainCat = profile.mainBusinessCategory ?? profile.businessType ?? profile.businessCategory;
    final subCat = (profile.isOtherCategory ? profile.otherCategoryName : null) ??
        profile.businessSubCategory ??
        profile.otherCategoryName;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business_center_outlined, size: 16, color: AppColor.lightTextTertiary),
              const SizedBox(width: 6),
              Text(
                'Business Details',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  color: AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (mainCat != null && mainCat.isNotEmpty) _buildRow('Main Category', mainCat),
          if (subCat != null && subCat.isNotEmpty && subCat != mainCat) _buildRow('Sub Category', subCat),
          if (profile.businessType != null && profile.businessType!.isNotEmpty && profile.businessType != mainCat)
            _buildRow('Business Type', profile.businessType!),
          if (profile.companyType != null && profile.companyType!.isNotEmpty) _buildRow('Company Type', profile.companyType!),
          if (profile.experienceYears != null) _buildRow('Experience', '${profile.experienceYears} Years'),
          if (profile.yearOfEstablishment != null) _buildRow('Established', '${profile.yearOfEstablishment}'),
          if (profile.numberOfEmployees != null && profile.numberOfEmployees!.isNotEmpty)
            _buildRow('Team Size', '${profile.numberOfEmployees} members'),
          if (profile.annualRevenueRange != null && profile.annualRevenueRange!.isNotEmpty)
            _buildRow('Revenue Range', profile.annualRevenueRange!),
          if (profile.gstNumber != null && profile.gstNumber!.isNotEmpty) _buildRow('GST Number', profile.gstNumber!),
          if (profile.businessWebsite != null && profile.businessWebsite!.isNotEmpty) _buildRow('Website', profile.businessWebsite!),
          if (profile.productsServicesOffered != null && profile.productsServicesOffered!.isNotEmpty)
            _buildRow('Offerings', profile.productsServicesOffered!),
          if (profile.superpower != null && profile.superpower!.isNotEmpty) _buildRow('Superpower', profile.superpower!),
          if (profile.businessCity != null && profile.businessCity!.isNotEmpty) _buildRow('Business City', profile.businessCity!),
          if (profile.businessAddress != null && profile.businessAddress!.isNotEmpty) _buildRow('Address', profile.businessAddress!),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: AppColor.lightTextTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
