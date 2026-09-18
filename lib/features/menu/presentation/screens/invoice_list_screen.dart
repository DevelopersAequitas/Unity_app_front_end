import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
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
        res = await _dio.dio.get(ApiEndpoints.myInvoices);
      } catch (_) {
        res = await _dio.dio.get(ApiEndpoints.billingInvoices);
      }
      final data = res?.data;
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        raw = data['data']?['invoices'] as List? ??
            data['data']?['items'] as List? ??
            data['invoices'] as List? ??
            data['data'] as List? ??
            [];
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

  Future<void> _downloadPdf(String invoiceId) async {
    final downloadPath = ApiEndpoints.downloadInvoice(invoiceId);
    final url = downloadPath.startsWith('http')
        ? downloadPath
        : '${ApiEndpoints.baseUrl}$downloadPath';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Membership Invoices',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchInvoices,
        color: AppColor.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Container(
          height: 80,
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
              const SizedBox(height: 8),
              Text(
                'Your payment history and receipts will be stored here.',
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
      itemCount: _invoices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _invoices[index];
        final id = item['id']?.toString() ?? '';
        final number = item['invoice_number']?.toString() ?? item['number']?.toString() ?? 'INV-#$index';
        final date = item['date']?.toString() ?? item['invoice_date']?.toString() ?? '';
        final amount = item['total']?.toString() ?? item['amount']?.toString() ?? '₹0';
        final status = item['status']?.toString().toLowerCase() ?? 'paid';

        return InvoiceItemCard(
          id: id,
          number: number,
          date: date,
          amount: amount,
          status: status,
          onDownload: () => _downloadPdf(id),
        );
      },
    );
  }
}
