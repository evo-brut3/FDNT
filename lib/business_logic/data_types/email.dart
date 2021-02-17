/* @TODO generate mail icon */

import 'package:flutter/cupertino.dart';

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
}
