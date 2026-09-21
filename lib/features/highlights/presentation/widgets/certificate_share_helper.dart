import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/widgets/app_snack_bar.dart';

class CertificateShareHelper {
  CertificateShareHelper._();

  static String normalizeUrl(String rawUrl) {
    var trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('//')) {
      return 'https:$trimmed';
    }
    if (!trimmed.startsWith('/')) {
      trimmed = '/$trimmed';
    }
    return 'https://peersunity.com$trimmed';
  }

  static Future<Uint8List?> _fetchBytes(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.data != null && response.data!.isNotEmpty) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      debugPrint('Certificate Dio download failed: $e. Trying HttpClient fallback...');
    }

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 25);
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        if (bytes.isNotEmpty) return bytes;
      }
    } catch (e) {
      debugPrint('Certificate HttpClient fallback failed: $e');
    }
    return null;
  }

  static String _detectExtension(Uint8List bytes, String url) {
    if (bytes.length >= 4) {
      // PNG magic bytes
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
        return 'png';
      }
      // JPEG magic bytes
      if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
        return 'jpg';
      }
      // WEBP magic bytes
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) {
        return 'webp';
      }
      // PDF magic bytes
      if (bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46) {
        return 'pdf';
      }
    }
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? '';
    if (path.endsWith('.png')) return 'png';
    if (path.endsWith('.webp')) return 'webp';
    if (path.endsWith('.jpeg') || path.endsWith('.jpg')) return 'jpg';
    if (path.endsWith('.pdf')) return 'pdf';
    return 'jpg';
  }

  static Future<bool> _saveToGal(Uint8List bytes, {String? name}) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }
      final effectiveName =
          name ?? 'Certificate_${DateTime.now().millisecondsSinceEpoch}';
      await Gal.putImageBytes(bytes, name: effectiveName);
      return true;
    } catch (e) {
      debugPrint('Gal.putImageBytes failed: $e. Trying file-based Gal fallback...');
      try {
        final ext = _detectExtension(bytes, '');
        final tempDir = await getTemporaryDirectory();
        final file = File(
          '${tempDir.path}/${name ?? 'cert_${DateTime.now().millisecondsSinceEpoch}'}.$ext',
        );
        await file.writeAsBytes(bytes);
        await Gal.putImage(file.path);
        return true;
      } catch (fileErr) {
        debugPrint('Gal.putImage fallback failed: $fileErr');
        return false;
      }
    }
  }

  static Future<void> shareCertificate({
    required BuildContext context,
    required String title,
    required String tier,
    required String certificateUrl,
    int? score,
    num? percentage,
  }) async {
    final normalizedUrl = normalizeUrl(certificateUrl);
    final text =
        '🏆 I have successfully earned the $title ($tier) on ${AppEnvironment.appName}!\n\nScore: ${score ?? 0}/100 (${percentage ?? 0}%)\n\nView Certificate: $normalizedUrl';

    if (normalizedUrl.isEmpty) {
      SharePlus.instance.share(
        ShareParams(text: text, subject: '$title - $tier'),
      );
      return;
    }

    try {
      final bytes = await _fetchBytes(normalizedUrl);
      if (bytes != null && bytes.isNotEmpty) {
        final ext = _detectExtension(bytes, normalizedUrl);
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'cert_${DateTime.now().millisecondsSinceEpoch}.$ext';
        final filePath = '${tempDir.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        if (await file.exists()) {
          SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: text,
              subject: '$title - $tier',
            ),
          );
          return;
        }
      }
    } catch (e) {
      debugPrint('Error preparing certificate for share: $e');
    }

    SharePlus.instance.share(
      ShareParams(text: text, subject: '$title - $tier'),
    );
  }

  static Future<void> downloadOrOpenCertificate({
    required BuildContext context,
    required String url,
    String? fileName,
  }) async {
    final normalizedUrl = normalizeUrl(url);
    if (normalizedUrl.isEmpty) {
      if (context.mounted) {
        AppSnackBar.showError(context, 'Certificate URL not available');
      }
      return;
    }

    try {
      if (context.mounted) {
        AppSnackBar.showInfo(context, 'Saving certificate to Gallery...');
      }

      final bytes = await _fetchBytes(normalizedUrl);
      if (bytes == null || bytes.isEmpty) {
        throw Exception('Could not fetch certificate data');
      }

      final ext = _detectExtension(bytes, normalizedUrl);
      final rawName = fileName ?? 'Certificate_${DateTime.now().millisecondsSinceEpoch}';
      final cleanName = rawName.replaceAll(
        RegExp(r'\.(jpg|jpeg|png|webp|pdf)$', caseSensitive: false),
        '',
      );

      if (ext == 'pdf') {
        final tempDir = await getTemporaryDirectory();
        final pdfFile = File('${tempDir.path}/$cleanName.pdf');
        await pdfFile.writeAsBytes(bytes);
        final uri = Uri.parse(normalizedUrl);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          AppSnackBar.showSuccess(context, 'Opening certificate document...');
        }
        return;
      }

      final saved = await _saveToGal(bytes, name: cleanName);
      if (saved) {
        if (context.mounted) {
          AppSnackBar.showSuccess(
            context,
            'Certificate saved to Gallery successfully!',
          );
        }
        return;
      } else {
        throw Exception('Failed to write to device gallery');
      }
    } catch (e) {
      debugPrint('Certificate gallery save error: $e');
      try {
        final uri = Uri.parse(normalizedUrl);
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
        if (context.mounted) {
          AppSnackBar.showInfo(
            context,
            'Opening certificate in browser...',
          );
        }
        return;
      } catch (_) {
        if (context.mounted) {
          AppSnackBar.showError(context, 'Could not save certificate.');
        }
      }
    }
  }
}
