import 'package:flutter/material.dart';

class ForgetPwdPage extends StatefulWidget {
  const ForgetPwdPage({Key? key}) : super(key: key);

  @override
  State<ForgetPwdPage> createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  final GlobalKey _key = GlobalKey<FormState>(); //存储表单状态，由于密码校验

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('忘记密码'),
      ),
      body: Form(
        child: Column(
          children: [
            Text(''),
          ],
        ),
      ),
    );
  }
}
