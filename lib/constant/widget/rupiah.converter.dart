import 'package:intl/intl.dart';

class RupiahConverter {
  String formatToRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}