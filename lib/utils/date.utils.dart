import 'dart:developer' as developer;

class DateUtil {
  static final DateUtil singleton = DateUtil._internal();

  factory DateUtil() {
    return singleton;
  }

  DateUtil._internal();

  String StringifyYesterday() {
    developer.log('yesterday called', name: 'yesterday called');
    DateTime dateTime = DateTime.now().subtract(Duration(days: 1));
    String result = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    developer.log(result, name: 'yesterday');
    return result;
  }
}
