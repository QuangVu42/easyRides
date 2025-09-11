import 'package:intl/intl.dart';

class DateFormatter {
  /// truyền format
  static String format(String isoString, String pattern) {
    try {
      final dateTime = DateTime.parse(isoString);
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return isoString; // fallback nếu parse lỗi
    }
  }
  /// shortcut: format ISO sang dd/MM/yyyy HH:mm
  static String formatDateTime(String isoString) {
    return format(isoString, 'dd/MM/yyyy HH:mm');
  }

  /// shortcut: chỉ giờ phút
  static String formatTime(String isoString) {
    return format(isoString, 'HH:mm');
  }

  /// shortcut: chỉ ngày tháng
  static String formatDate(String isoString) {
    return format(isoString, 'dd/MM/yyyy');
  }

}
