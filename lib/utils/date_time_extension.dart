extension DateTimeExtension on DateTime {
  static DateTime parseUtc(String formattedDate) =>
      DateTime.parse(formattedDate).toLocal();

  static DateTime? tryParseUtc(String? formattedDate) {
    if (formattedDate != null) {
      return parseUtc(formattedDate);
    }
    return null;
  }
}
