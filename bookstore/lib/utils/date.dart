import 'package:cloud_firestore/cloud_firestore.dart';

extension DeliveryDate on Timestamp{
  static const List<String> month_calendar = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  String get formatDate{
    DateTime dateTime = toDate();
    return "${month_calendar[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}";
  }
}