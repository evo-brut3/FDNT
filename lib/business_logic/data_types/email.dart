/* @TODO generate mail icon */

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Email {
  String title;
  String sender;
  //Image senderIcon;
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
    else return DateFormat('yyyy-mm-dd').format(time);
  }
  
  bool _isDateTodayDate() {
    final now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return (now == today);
  }

  String getSenderName() {
    return sender.substring(1,sender.indexOf("\"",2));
  }
}
