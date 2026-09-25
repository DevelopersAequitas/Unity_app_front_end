import 'package:flutter/services.dart';

/// A [TextInputFormatter] that automatically inserts separators (like `/` or `-`)
/// as the user types digits.
///
/// Example with separator `/`:
/// - Typing "07" -> "07"
/// - Typing "0719" -> "07/19"
/// - Typing "07192003" -> "07/19/2003"
class DateAutoSeparatorInputFormatter extends TextInputFormatter {
  final String separator;

  DateAutoSeparatorInputFormatter({this.separator = '/'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Extract only digits
    final clean = text.replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final digits = clean.length > 8 ? clean.substring(0, 8) : clean;
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write(separator);
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    // Calculate cursor position matching the number of digits before the cursor
    int digitCountBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.end && i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) {
        digitCountBeforeCursor++;
      }
    }

    int newCursor = 0;
    int currentDigits = 0;
    while (newCursor < formatted.length && currentDigits < digitCountBeforeCursor) {
      if (RegExp(r'\d').hasMatch(formatted[newCursor])) {
        currentDigits++;
      }
      newCursor++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor.clamp(0, formatted.length)),
    );
  }
}

/// Helper alias for slash-separated date formatter (e.g. DD/MM/YYYY)
class DateAutoSlashInputFormatter extends DateAutoSeparatorInputFormatter {
  DateAutoSlashInputFormatter() : super(separator: '/');
}

/// Helper alias for hyphen-separated date formatter (e.g. DD-MM-YYYY)
class DateAutoHyphenInputFormatter extends DateAutoSeparatorInputFormatter {
  DateAutoHyphenInputFormatter() : super(separator: '-');
}
