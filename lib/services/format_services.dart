import 'package:intl/intl.dart';

String formatToRupiah(int number) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID', // Indonesian locale
    symbol: 'Rp ',  // Currency symbol for Rupiah
    decimalDigits: 0, // No decimal places for Rupiah
  );
  return formatCurrency.format(number);
}