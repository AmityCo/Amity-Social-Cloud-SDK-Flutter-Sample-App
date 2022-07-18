extension DurationExtension on Duration {
  String readableString() {
    if (inDays > 0 && inHours > 0) {
      return '$inDays days & $inHours hours';
    }

    return toString();
  }
}
