import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/requirement.dart';

class RequirementShareHelper {
  RequirementShareHelper._();

  static Future<void> shareRequirement(Requirement requirement) async {
    final link = AppEnvironment.getRequirementDeepLink(requirement.id);
    final user = requirement.user;
    final userName = user?.fullName ?? 'Peer Member';
    final company = user?.company;
    final city = (user?.city?.isNotEmpty == true) ? user!.city! : requirement.cityName;

    final buffer = StringBuffer();
    buffer.writeln('📋 Business Requirement');
    buffer.writeln('📌 Subject: ${requirement.subject}');
    buffer.writeln('👤 Posted by: $userName');
    if (company != null && company.isNotEmpty) {
      buffer.writeln('🏢 Company: $company');
    }
    if (city != null && city.isNotEmpty) {
      buffer.writeln('📍 Location: $city');
    }
    if (requirement.category != null && requirement.category!.isNotEmpty) {
      buffer.writeln('🏷️ Category: ${requirement.category}');
    }
    if (requirement.description.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('“${requirement.description.trim()}”');
    }
    buffer.writeln();
    buffer.writeln('Can you help or collaborate? View on ${AppEnvironment.appName}: $link');

    final text = buffer.toString();
    final subject = 'Requirement: ${requirement.subject} on ${AppEnvironment.appName}';

    SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }
}
