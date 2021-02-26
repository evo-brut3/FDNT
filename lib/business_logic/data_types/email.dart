/* @TODO generate mail icon */
import 'package:intl/intl.dart';

class Email {
  String title;
  String sender;
  String sendTime;
  String content;
  bool isRead;
  bool isImportant;

  Email(
      {this.title,
      this.sender,
      this.sendTime,
      this.content,
      this.isRead,
      this.isImportant});

  String dayTime() {
    DateTime time = DateTime.parse(this.sendTime);
    if(_isDateTodayDate()) return DateFormat('kk:mm').format(time);
    else return DateFormat('dd.mm.yyyy').format(time);
  }
  
  bool _isDateTodayDate() {
    final now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return (now == today);
  }

  String get senderName {
    return sender.substring(1,sender.indexOf("\"",2));
  }
}
