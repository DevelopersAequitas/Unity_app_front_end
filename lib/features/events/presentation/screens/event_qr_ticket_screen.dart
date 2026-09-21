import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/event_registration_entity.dart';
import '../widgets/event_qr_card.dart';

class EventQrTicketScreen extends StatefulWidget {
  final EventRegistrationEntity ticket;

  const EventQrTicketScreen({super.key, required this.ticket});

  @override
  State<EventQrTicketScreen> createState() => _EventQrTicketScreenState();
}

class _EventQrTicketScreenState extends State<EventQrTicketScreen> {
  final GlobalKey _ticketBoundaryKey = GlobalKey();
  bool _isDownloading = false;
  bool _isSharing = false;

  Future<Uint8List?> _captureTicketPng() async {
    try {
      final boundary =
          _ticketBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleDownloadTicket() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final bytes = await _captureTicketPng();
      if (bytes == null || bytes.isEmpty) {
        if (mounted) {
          AppSnackBar.showError(context, 'Unable to capture ticket image.');
        }
        return;
      }

      final fileName =
          'Ticket_${widget.ticket.registrationId.isNotEmpty ? widget.ticket.registrationId : DateTime.now().millisecondsSinceEpoch}';

      try {
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putImageBytes(bytes, name: fileName);
        if (mounted) {
          AppSnackBar.showSuccess(
            context,
            'Ticket saved to your gallery successfully!',
          );
        }
      } catch (e) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$fileName.png');
        await file.writeAsBytes(bytes);
        if (mounted) {
          AppSnackBar.showSuccess(
            context,
            'Ticket downloaded successfully: ${file.path}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Failed to download ticket: $e');
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _handleShareTicket() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final bytes = await _captureTicketPng();
      if (bytes != null && bytes.isNotEmpty) {
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'Ticket_${widget.ticket.registrationId.isNotEmpty ? widget.ticket.registrationId : "Pass"}';
        final file = File('${tempDir.path}/$fileName.png');
        await file.writeAsBytes(bytes);

        final link = AppEnvironment.getEventDeepLink(
          widget.ticket.eventId ?? '',
          occurrenceId: widget.ticket.occurrenceId,
        );
        final shareText =
            '🎟️ My Event Pass for ${widget.ticket.eventTitle ?? "Peers Event"}\nTicket ID: ${widget.ticket.registrationId}\n\nView Event on ${AppEnvironment.appName}: $link';

        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            files: [XFile(file.path)],
            subject: 'Event Pass - ${AppEnvironment.appName}',
          ),
        );
      } else {
        final link = AppEnvironment.getEventDeepLink(
          widget.ticket.eventId ?? '',
          occurrenceId: widget.ticket.occurrenceId,
        );
        final shareText =
            '🎟️ My Event Pass for ${widget.ticket.eventTitle ?? "Peers Event"}\nTicket ID: ${widget.ticket.registrationId}\n\nView Event on ${AppEnvironment.appName}: $link';

        await SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: 'Event Pass - ${AppEnvironment.appName}',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Unable to share ticket: $e');
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const AppCommonBar(
          title: 'Event Ticket',
          showBack: true,
          showSearch: false,
          showChat: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Card & Buttons with horizontal padding
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  children: [
                    // Main Ticket Card captured inside RepaintBoundary
                    RepaintBoundary(
                      key: _ticketBoundaryKey,
                      child: EventQrCard(ticket: widget.ticket),
                    ),
                    const SizedBox(height: 14),

                    // Side-by-side Action Buttons
                    Row(
                      children: [
                        // Button 1: Share Pass
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: OutlinedButton.icon(
                              onPressed: _handleShareTicket,
                              icon: _isSharing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF2563EB),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.share_outlined,
                                      size: 18,
                                      color: Color(0xFF2563EB),
                                    ),
                              label: Text(
                                _isSharing ? 'Sharing...' : 'Share Pass',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isDark
                                    ? AppColor.darkSurface
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF2563EB),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Button 2: Download Pass
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: OutlinedButton.icon(
                              onPressed: _handleDownloadTicket,
                              icon: _isDownloading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF2563EB),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.file_download_outlined,
                                      size: 18,
                                      color: Color(0xFF2563EB),
                                    ),
                              label: Text(
                                _isDownloading ? 'Saving...' : 'Download',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isDark
                                    ? AppColor.darkSurface
                                    : Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF2563EB),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),

              // Full-width Bottom Skyline Graphic with smooth smoky top gradient fade
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white, Colors.white],
                    stops: [0.0, 0.38, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/see_you_there.png',
                  width: double.infinity,

                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
