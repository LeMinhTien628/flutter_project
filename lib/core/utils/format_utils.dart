import 'package:intl/intl.dart';

class FormatUtils {
  static String formattedPrice(int gia){
    return NumberFormat("#,###").format(gia);
  }
}