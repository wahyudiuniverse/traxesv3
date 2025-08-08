class IntToMonth {
  static String intToMonth(int month) {
    if (month < 1 || month > 12) {
      throw Exception("Invalid Month");
    }

    final monthNames = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    return monthNames[month - 1];
  }
}
