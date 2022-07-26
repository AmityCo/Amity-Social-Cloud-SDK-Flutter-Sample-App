import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String format({String dateFormat = 'dd MMMM yyyy hh:mm aa'}) {
    return DateFormat(dateFormat).format(this);
  }

  String beforeTime() {
    Duration duration = DateTime.now().toUtc().difference(toUtc());
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    if (duration.inSeconds > 0) {
      return '${duration.inSeconds}s';
    }
    return '${duration.inSeconds}s';
  }
}
