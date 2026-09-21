class AppDateFormatter {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  /// Parses any incoming date representation from backend/socket (UTC)
  /// and converts it to the device's local timezone.
  static DateTime? parseUtc(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) {
      return raw.isUtc ? raw.toLocal() : raw;
    }
    if (raw is int) {
      // Handles epoch timestamp (seconds or milliseconds)
      final ms = raw < 10000000000 ? raw * 1000 : raw;
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    }
    final rawStr = raw.toString().trim();
    if (rawStr.isEmpty) return null;

    // Check if it is a numeric epoch string
    final epochNum = int.tryParse(rawStr);
    if (epochNum != null) {
      final ms = epochNum < 10000000000 ? epochNum * 1000 : epochNum;
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    }

    try {
      // If it has timezone offset indicator ('Z', '+HH:MM', '-HH:MM' at end)
      final hasTz = rawStr.endsWith('Z') ||
          rawStr.endsWith('z') ||
          RegExp(r'[+-]\d{2}(:?\d{2})?$').hasMatch(rawStr);

      if (hasTz) {
        return DateTime.tryParse(rawStr)?.toLocal();
      }

      // If it's a date-only string like "YYYY-MM-DD", treat as local calendar date
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(rawStr)) {
        return DateTime.tryParse(rawStr);
      }

      // For standard backend UTC datetime without explicit 'Z' (e.g. "YYYY-MM-DD HH:mm:ss" or "YYYY-MM-DDTHH:mm:ss")
      final formattedIso = '${rawStr.replaceAll(' ', 'T')}Z';
      final parsedUtc = DateTime.tryParse(formattedIso);
      if (parsedUtc != null) {
        return parsedUtc.toLocal();
      }

      // Fallback
      return DateTime.tryParse(rawStr)?.toLocal();
    } catch (_) {
      return null;
    }
  }

  /// Converts a local DateTime to a UTC string in "YYYY-MM-DD HH:mm:ss" format for API submission.
  static String toUtcString(DateTime local) {
    final utc = local.toUtc();
    final y = utc.year.toString().padLeft(4, '0');
    final m = utc.month.toString().padLeft(2, '0');
    final d = utc.day.toString().padLeft(2, '0');
    final hh = utc.hour.toString().padLeft(2, '0');
    final mm = utc.minute.toString().padLeft(2, '0');
    final ss = utc.second.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm:$ss';
  }

  /// Converts a local DateTime to a standard ISO 8601 UTC string for API submission.
  static String toUtcIsoString(DateTime local) {
    return local.toUtc().toIso8601String();
  }

  /// Converts a local DateTime to UTC Date string "YYYY-MM-DD" for API submission.
  static String toUtcDateString(DateTime local) {
    final utc = local.toUtc();
    final y = utc.year.toString().padLeft(4, '0');
    final m = utc.month.toString().padLeft(2, '0');
    final d = utc.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Format local Date (e.g. "21 Sep 2026")
  static String format(dynamic dateStr, {String defaultValue = '—'}) {
    final parsed = parseUtc(dateStr);
    if (parsed == null) return dateStr?.toString() ?? defaultValue;
    return '${parsed.day} ${_months[parsed.month - 1]} ${parsed.year}';
  }

  /// Format local Date and Time (e.g. "21 Sep 2026 · 11:30 AM" or "21 Sep 2026, 11:30 AM")
  static String formatDateTime(dynamic dateStr,
      {String defaultValue = '—', String separator = ' · '}) {
    final dt = parseUtc(dateStr);
    if (dt == null) return dateStr?.toString() ?? defaultValue;
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}$separator$hour:$minute $ampm';
  }

  /// Format local Time only (e.g. "11:30 AM")
  static String formatTime(dynamic dateStr, {String defaultValue = '—'}) {
    final dt = parseUtc(dateStr);
    if (dt == null) return dateStr?.toString() ?? defaultValue;
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $ampm';
  }

  /// Format relative time (e.g. "Just now", "5m ago", "2h ago", "3d ago", "21 Sep 2026")
  static String formatTimeAgo(dynamic raw, {String defaultValue = '—'}) {
    final dt = parseUtc(raw);
    if (dt == null) return raw?.toString() ?? defaultValue;
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.isNegative) {
      return format(dt);
    }
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  /// Format Chat date header ("Today", "Yesterday", or "21 Sep 2026")
  static String formatChatDateHeader(dynamic raw) {
    final dt = parseUtc(raw);
    if (dt == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(dt.year, dt.month, dt.day);

    if (msgDate == today) return 'Today';
    if (msgDate == yesterday) return 'Yesterday';
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  /// Format Chat time (e.g. "11:30 AM")
  static String formatChatTime(dynamic raw) {
    return formatTime(raw, defaultValue: '');
  }

  /// Format date range (e.g. "21 Sep 2026 – 25 Sep 2026")
  static String formatRange(dynamic start, dynamic end,
      {String defaultValue = '—'}) {
    final startFmt = (start != null && start.toString().isNotEmpty)
        ? format(start)
        : null;
    final endFmt =
        (end != null && end.toString().isNotEmpty) ? format(end) : null;

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
