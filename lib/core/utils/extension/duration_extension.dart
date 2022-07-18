extension DurationExtension on Duration {
  String readableString() {
    if (inDays > 0) {
      return '$inDays days';
    }
    if (inHours > 0) {
      return '$inHours hours';
    }
    if (inMinutes > 0) {
      return '$inMinutes mins';
    }

    return toString();
  }
}
