/* @TODO generate mail icon */

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/cupertino.dart';

class Email {
  String title;
  String sender;
  //Image senderIcon;
  String sendTime;
  MimeMessage content;
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
