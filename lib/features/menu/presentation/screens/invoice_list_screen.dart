import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../widgets/invoice_item_card.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _invoices = [];

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      dynamic res;
      try {
        res = await _dio.dio.get(ApiEndpoints.billingInvoices);
      } catch (_) {
        res = await _dio.dio.get(ApiEndpoints.myInvoices);
      }
      final data = res?.data;
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        if (data['data'] is Map<String, dynamic>) {
          raw = data['data']['items'] as List? ??
              data['data']['invoices'] as List? ??
              [];
        } else if (data['data'] is List) {
          raw = data['data'] as List;
        } else if (data['items'] is List) {
          raw = data['items'] as List;
        } else if (data['invoices'] is List) {
          raw = data['invoices'] as List;
        }
      } else if (data is List) {
        raw = data;
      }
      if (mounted) {
        setState(() {
          _invoices = raw.whereType<Map<String, dynamic>>().toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load invoices.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadPdf(String invoiceId, String? directUrl) async {
    try {
      String url = '';
      if (directUrl != null && directUrl.trim().isNotEmpty && directUrl.startsWith('http')) {
        url = directUrl.trim();
      } else if (invoiceId.isNotEmpty) {
        final downloadPath = ApiEndpoints.downloadInvoice(invoiceId);
        url = downloadPath.startsWith('http')
            ? downloadPath
            : '${AppEnvironment.baseUrl}$downloadPath';
      }
      if (url.isNotEmpty) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final textPrimary = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Invoices & Receipts',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: AppGradientBackground(
        child: RefreshIndicator(
          onRefresh: _fetchInvoices,
          color: AppColor.primaryBlue,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
        ),
      );
    }

    if (_errorMessage != null && _invoices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.lightTextTertiary),
              const SizedBox(height: 8),
              Text(_errorMessage!, style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary)),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _fetchInvoices, child: const Text('Try Again')),
            ],
          ),
        ),
      );
    }

    if (_invoices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long_outlined, size: 28, color: AppColor.primaryBlue),
              ),
              const SizedBox(height: 16),
              Text(
                'No Invoices Found',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your payment history and receipts will appear here.',
                style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _invoices.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _invoices[index];
        final id = item['invoice_id']?.toString() ?? item['id']?.toString() ?? '';
        final number = item['invoice_number']?.toString() ?? item['number']?.toString() ?? 'INV-#${index + 1}';
        final rawDate = item['due_date']?.toString() ?? item['date']?.toString() ?? item['created_time']?.toString();
        final date = rawDate != null && rawDate.isNotEmpty ? AppDateFormatter.format(rawDate) : '';
        final currency = item['currency_code']?.toString() ?? 'INR';
        final symbol = currency == 'INR' ? '₹' : '$currency ';
        final total = item['total']?.toString() ?? item['amount']?.toString() ?? '0';
        final amount = '$symbol$total';
        final status = item['status']?.toString().toLowerCase() ?? 'paid';
        final pdfUrl = item['pdf_url']?.toString() ?? item['invoice_url']?.toString();
        final hasDownload = (pdfUrl != null && pdfUrl.isNotEmpty) || id.isNotEmpty;

        return InvoiceItemCard(
          id: id,
          number: number,
          date: date,
          amount: amount,
          status: status,
          onDownload: hasDownload ? () => _downloadPdf(id, pdfUrl) : null,
        );
      },
    );
  }
}
