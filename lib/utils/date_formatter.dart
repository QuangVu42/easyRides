import 'package:intl/intl.dart';

class DateFormatter {
  /// Truyền DateTime + pattern
  static String format(DateTime dateTime, String pattern) {
    try {
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return dateTime.toString(); // fallback nếu có lỗi format
    }
  }

  /// shortcut: format ISO String sang dd/MM/yyyy HH:mm
  static String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return format(dateTime, 'dd/MM/yyyy HH:mm');
    } catch (e) {
      return isoString;
    }
  }

  /// shortcut: chỉ giờ phút
  static String formatTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return format(dateTime, 'HH:mm');
    } catch (e) {
      return isoString;
    }
  }

  /// shortcut: chỉ ngày tháng
  static String formatDate(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return format(dateTime, 'dd/MM/yyyy');
    } catch (e) {
      return isoString;
    }
  }
}
