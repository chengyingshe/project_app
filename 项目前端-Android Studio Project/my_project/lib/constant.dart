import 'package:flutter/material.dart';

const Color kAppBarColor = Color(0xFF00BCD4);

const Color buttonColor = Color(0xFF00838F);

const TextStyle redTitleTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.red,
);

const TextStyle blackNormalTextStyle = TextStyle(
  fontSize: 18,
);

const double logInIconSize = 20.0;

const List<Color> kProbStateColor = [Colors.red, Colors.yellow, Colors.green];

const List<String> kDepartmentList = ['生产员', '问题环节负责生产员', '技术员'];

const List<String> kProbStateText = [
  '问题未处理',
  '正在解决中',
  '问题已解决',
];

// const String hostName = "192.168.43.182"; //服务器地址
// const String hostName = "192.168.101.11";  //服务器地址
const String hostName = "192.168.0.109"; //服务器地址

const String probImageUrl =
    'http://$hostName/webproject/get/get_prob_image.php?prob_id=';
const String solveImageUrl =
    'http://$hostName/webproject/get/get_solve_image.php?prob_id=';
