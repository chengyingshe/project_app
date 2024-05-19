import 'package:flutter/material.dart';
import 'package:my_project/forget_pwd_page.dart';
import 'package:my_project/pages/create_problist.dart';
import 'package:my_project/pages/identity_modification.dart';
import 'package:my_project/pages/modify_problist.dart';
import 'package:my_project/pages/search_problist.dart';
import 'package:my_project/pages/tabs.dart';
import 'package:my_project/register_page.dart';
import 'package:toast/toast.dart';
import 'log_in.dart';
import 'constant.dart';
import 'pages/tabs/problem_list.dart';
import 'pages/tabs/message.dart';
import 'pages/tabs/identity.dart';

void main() => runApp(const MainScaffold());

class MainScaffold extends StatelessWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? _lastPressedAt;
    ToastContext().init(context);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/tabs':(cxt) => const Tabs(),  //底部导航栏页面
        '/problist':(cxt) => const ProblemList(),
        '/message':(cxt) => const Message(),
        '/identity':(cxt) => const Identity(),
        '/register':(cxt) => const RegisterPage(),  //用户注册
        '/create_problist':(cxt)=>const CreateProblist() , //新建问题单
        '/search_problist':(cxt)=>const SearchProblist(),
        '/forget_pwd':(cxt)=>const ForgetPwdPage(),
        '/modification':(cxt)=>const Modification(),
        '/modify_phone':(cxt)=>const ModifyPhoneNumber(),
        '/modify_identity': (cxt)=>const ModifyIdentity(),
        '/modify_pwd':(cxt)=>const ModifyPwd(),
        '/modify_problist':(cxt)=>const ModifyProblist(),
      },
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: const Text('用户登录'),
        ),
        body: WillPopScope(
            onWillPop: () async {
              if (_lastPressedAt == null ||
                  DateTime.now().difference(_lastPressedAt!) >
                      const Duration(seconds: 1)) {
                _lastPressedAt = DateTime.now();
                Toast.show('再按一次退出应用', gravity: Toast.bottom);
                return false; //两次连续点击时间间隔小于1s时不退出
              }
              return true;
            },
            child: const LogIn()),
      ),
    );
  }

}
