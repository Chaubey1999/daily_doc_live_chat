import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Mq{
  static double height(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double width(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}
class FormattingMethods{
  static conversationDate(DateTime date){
    var format = DateFormat("hh:mm a");
    var dateString = format.format(date);
    return dateString;
  }
}