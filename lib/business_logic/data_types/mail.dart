import 'package:flutter/cupertino.dart';

class Mail {
  String title;
  String sender;
  //Image senderIcon;
  String sendTime;
  String content;
  bool isRead;
  bool isImportant;

  Mail(this.title, this.sender, this.sendTime,
    this.content, this.isRead, this.isImportant);
}