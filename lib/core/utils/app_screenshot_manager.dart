import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

/// Manages capturing screenshots from the application root boundary.
class AppScreenshotManager {
  AppScreenshotManager._();

  /// GlobalKey attached to the root RepaintBoundary in MyApp
  static final GlobalKey rootRepaintKey = GlobalKey();

  /// Captures the current visible screen as a temporary PNG [File].
  /// Returns `null` if the boundary is unavailable or capture fails.
  static Future<File?> captureScreen({double pixelRatio = 1.5}) async {
    try {
      final currentContext = rootRepaintKey.currentContext;
      if (currentContext == null) return null;

      final boundary =
          currentContext.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // Allow a tiny frame delay if painting is in progress
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
      }

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

      final File file = File(filePath);
      await file.writeAsBytes(pngBytes);
      return file;
    } catch (e) {
      debugPrint('[AppScreenshotManager] Failed to capture screen: $e');
      return null;
    }
  }
}
