/* @TODO generate mail icon */
import 'package:intl/intl.dart';

class Email {
  String title;
  String sender;
  DateTime sendTime;
  String content;
  bool isRead = false;
  bool isImportant;

  Email(
      {this.title,
      this.sender,
      this.sendTime,
      this.content,
      this.isImportant});


  String get getTitle {
    return title;
  }

  String get getSender {
    if(sender.startsWith("\""))
      return sender.substring(1, sender.indexOf("\"", 2));
    return sender;
  }

  String dayTime() {
    DateTime time = this.sendTime;
    if(_isDateTodayDate()) return DateFormat('kk:mm').format(time);
    else return DateFormat('dd.MM.yyyy').format(time);
  }
  
  bool _isDateTodayDate() {
    final now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return (now == today);
  }

}
