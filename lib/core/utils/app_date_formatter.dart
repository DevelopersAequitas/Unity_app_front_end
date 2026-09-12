class AppDateFormatter {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static String format(String? dateStr, {String defaultValue = '—'}) {
    if (dateStr == null || dateStr.trim().isEmpty) return defaultValue;
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed == null) return dateStr;
      return '${parsed.day} ${_months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return dateStr;
    }
  }

  static String formatRange(String? start, String? end, {String defaultValue = '—'}) {
    final startFmt = (start != null && start.isNotEmpty) ? format(start) : null;
    final endFmt = (end != null && end.isNotEmpty) ? format(end) : null;

    if (startFmt != null && endFmt != null) {
      return '$startFmt – $endFmt';
    } else if (startFmt != null) {
      return 'Since $startFmt';
    } else if (endFmt != null) {
      return 'Valid till $endFmt';
    }
    return defaultValue;
  }
}
