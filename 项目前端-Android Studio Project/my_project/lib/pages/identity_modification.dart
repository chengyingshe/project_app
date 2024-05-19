import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constant.dart';

import '../widgets/employee_info_card.dart';

class Modification extends StatefulWidget {
  const Modification({Key? key, this.type}) : super(key: key);
  final String? type;

  @override
  State<Modification> createState() => _ModificationState();
}

class _ModificationState extends State<Modification> {
  @override
  void initState() {
    super.initState();
    getAllEmployesInfo();
  }

  @override
  Widget build(BuildContext context) {
    String appBarString = '';
    Widget bodyWidget;
    switch (widget.type) {
      case 'phone':
        appBarString = '修改手机号';
        bodyWidget = ModifyPhoneNumber();
        break;
      case 'identity':
        appBarString = '修改个人资料';
        bodyWidget = ModifyIdentity();
        break;
      case 'pwd':
        appBarString = '修改密码';
        bodyWidget = ModifyPwd();
        break;
      default:
        appBarString = '管理生产员信息';
        bodyWidget = ManageAllEmploys();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text(appBarString),
      ),
      body: bodyWidget,
    );
  }
}

//修改手机号界面
class ModifyPhoneNumber extends StatefulWidget {
  const ModifyPhoneNumber({Key? key}) : super(key: key);

  @override
  State<ModifyPhoneNumber> createState() => _ModifyPhoneNumberState();
}

class _ModifyPhoneNumberState extends State<ModifyPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//修改个人资料界面（姓名、性别）
class ModifyIdentity extends StatefulWidget {
  const ModifyIdentity({Key? key}) : super(key: key);

  @override
  State<ModifyIdentity> createState() => _ModifyIdentityState();
}

class _ModifyIdentityState extends State<ModifyIdentity> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//修改密码界面
class ModifyPwd extends StatefulWidget {
  const ModifyPwd({Key? key}) : super(key: key);

  @override
  State<ModifyPwd> createState() => _ModifyPwdState();
}

class _ModifyPwdState extends State<ModifyPwd> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//管理生产员信息
class ManageAllEmploys extends StatefulWidget {
  const ManageAllEmploys({Key? key}) : super(key: key);

  @override
  State<ManageAllEmploys> createState() => _ManageAllEmploysState();
}

int employeesNum = 0;
List<String> nameList = [];
List<String> idList = [];
List<String> pwdList = [];
List<String> phoneList = [];

class _ManageAllEmploysState extends State<ManageAllEmploys> {
  @override
  void initState() {
    super.initState();
    getAllEmployesInfo();
  }

  @override
  Widget build(BuildContext context) {
    return nameList.isEmpty
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                child: Text('未请求到数据，请退出后重新进入！', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        )
        : ListView.builder(
            itemCount: employeesNum,
            itemBuilder: (BuildContext context, int index) {
              return EmployeeInfoCard(
                name: nameList[index],
                id: idList[index],
                pwd: pwdList[index],
                onPressForDetails: () {
                  // getAllEmployesInfo();
                },
              );
            });
  }
}

Future<void> getAllEmployesInfo() async {
  final Dio dio = Dio();
  var response = await dio
      .get('http://$hostName/webproject/get/get_all_employees_info.php');
  if (response.statusCode == 200) {
    List employeesInfo = json.decode(response.data);
    employeesNum = employeesInfo.length;
    nameList = [];
    idList = [];
    pwdList = [];
    for (int i = 0; i < employeesNum; i++) {
      nameList.add(employeesInfo[i]['name']);
      idList.add(employeesInfo[i]['id']);
      pwdList.add(employeesInfo[i]['pwd']);
    }
  }
}
