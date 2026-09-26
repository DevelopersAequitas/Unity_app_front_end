import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/ask_item_entity.dart';

class AskShareHelper {
  AskShareHelper._();

  static Future<void> shareAsk({
    required AskItemEntity item,
    String? currentUserName,
  }) async {
    final link = AppEnvironment.getAskDeepLink(item.id);
    final title = item.title.isNotEmpty ? item.title : 'Collaboration Ask';
    final flow = item.flowName.isNotEmpty ? item.flowName : 'Ask';
    final type = item.typeName.isNotEmpty ? ' · ${item.typeName}' : '';

    final buffer = StringBuffer();
    buffer.writeln('📢 $flow Need$type');
    buffer.writeln();
    buffer.writeln('“$title”');
    if (item.subtitle != null && item.subtitle!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(item.subtitle);
    }
    buffer.writeln();
    if (currentUserName != null && currentUserName.isNotEmpty) {
      buffer.writeln('Shared by $currentUserName on ${AppEnvironment.appName}');
    }
    buffer.writeln('View & respond on ${AppEnvironment.appName}: $link');

    final text = buffer.toString();
    final subject = '$flow: $title on ${AppEnvironment.appName}';

    SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }

  static Future<void> shareTimelineAsk({
    required String askId,
    String? title,
    String? flowName,
    String? typeName,
    String? currentUserName,
  }) async {
    final link = AppEnvironment.getAskDeepLink(askId);
    final displayTitle = (title != null && title.isNotEmpty) ? title : 'Collaboration Ask';
    final flow = (flowName != null && flowName.isNotEmpty) ? flowName : 'Ask';
    final type = (typeName != null && typeName.isNotEmpty) ? ' · $typeName' : '';

    final buffer = StringBuffer();
    buffer.writeln('📢 $flow Need$type');
    buffer.writeln();
    buffer.writeln('“$displayTitle”');
    buffer.writeln();
    if (currentUserName != null && currentUserName.isNotEmpty) {
      buffer.writeln('Shared by $currentUserName on ${AppEnvironment.appName}');
    }
    buffer.writeln('View & respond on ${AppEnvironment.appName}: $link');

    final text = buffer.toString();
    final subject = '$flow: $displayTitle on ${AppEnvironment.appName}';

    SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }
}
