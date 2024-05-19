import 'package:flutter/material.dart';
import 'package:my_project/pages/identity_modification.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/identity_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../function/get_item_from_str.dart';

class Identity extends StatelessWidget {
  const Identity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments; //获取传入的参数
    Str2Map cvt = Str2Map(str: data.toString());
    print(cvt.getMapFromString());
    String? name = cvt.getItemFromString('name');
    String? id = cvt.getItemFromString('id');
    String? phone = cvt.getItemFromString('phone');
    dynamic gender = cvt.getItemFromString('gender');
    dynamic department = cvt.getItemFromString('department');
    gender = int.parse(gender);
    department = kDepartmentList[int.parse(department)];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('个人信息'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: gender == 0
                        ? const AssetImage('images/female.png')
                        : const AssetImage('images/male.png'),
                    radius: 45,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('职位：$department',
                            style: const TextStyle(fontSize: 16)),
                        Text('工号：$id', style: const TextStyle(fontSize: 16)),
                        Text('姓名：$name', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(height: 10),
            IdentityCard(
                icon: Icons.phone,
                textString: '手机号：${phone == 'null'? '未绑定手机号': phone}',
                buttonString: '修改手机号',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Modification(
                                type: 'phone',
                              )));
                }),
            const Divider(height: 10),
            IdentityCard(
                icon: Icons.description_outlined,
                textString: '编辑个人资料',
                buttonString: '点击编辑',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Modification(
                                type: 'identity',
                              )));
                }),
            const Divider(height: 10),
            IdentityCard(
                icon: Icons.lock_outline,
                textString: '密码管理',
                buttonString: '修改密码',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Modification(
                                type: 'pwd',
                              )));
                }),
            const Divider(height: 10),
            department == '技术员'
                ? Column(
                    children: [
                      IdentityCard(
                          icon: Icons.supervisor_account,
                          textString: '生产员信息管理',
                          buttonString: '点击查看',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Modification(
                                          type: 'manage',
                                        )));
                          }),
                      const Divider()
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 15),
            Button(
                width: 200,
                height: 50,
                child: const Text('退出登录'),
                onPressed: () {
                  deleteAllLocalDate();
                  Navigator.pushReplacementNamed(context, '/');
                }),
          ],
        ),
      ),
    );
  }

  void deleteAllLocalDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('stateList');
    await prefs.remove('descriptionList');
    await prefs.remove('analyseList');
    await prefs.remove('solutionList');
    await prefs.remove('nowDaysList');
    await prefs.remove('solveDdlList');
    await prefs.remove('probTakenTimeList');
    await prefs.remove('problistNum');
    await prefs.remove('department');
    await prefs.remove('leftDays');
    await prefs.remove('expiringProbIdList');
    await prefs.remove('expiringProbHaveReadList');
    await prefs.remove('expiringProbStateList');
    await prefs.remove('expiringProbLeftDaysList');
  }
}
