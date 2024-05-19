import 'package:flutter/material.dart';
import 'package:my_project/constant.dart';
import 'package:my_project/widgets/Button.dart';
import 'package:my_project/widgets/text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账户注册'),
        backgroundColor: kAppBarColor,
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _verify = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _verifyPwd = TextEditingController();
  final GlobalKey _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: _key,
        child: Column(
          children: [
            const SizedBox(height: 10),
            MyTextField(
              prefixText: '手机号',
              hintText: '请输入您的手机号',
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: (v) {
                return v == ''? '手机号不能为空':null;
              },
            ),
            const SizedBox(height: 10),
            MyTextField(
              prefixText: '验证码',
              hintText: '请输入验证码',
              controller: _verify,
              keyboardType: TextInputType.number,
              validator: (v) {
                return v == ''? '验证码不能为空':null;
              },
              suffix: TextButton(
                child: const Text('发送验证码'),
                onPressed: () {
                  if (_phone.text == '') {
                    (_key.currentState as FormState).validate();
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            MyTextField(
              prefixText: '密码',
              hintText: '请输入密码',
              obscureText: true,
              controller: _pwd,
              validator: (v) {
                return v == ''? '密码不能为空':null;
              },
            ),
            const SizedBox(height: 10),
            MyTextField(
              prefixText: '确认密码',
              hintText: '再次输入密码确认',
              obscureText: true,
              controller: _verifyPwd,
              validator: (v) {
                return v == ''? '密码不能为空':null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Button(child: const Text('确认'), onPressed: () {
                    (_key.currentState as FormState).validate();
                  })),
            ),
          ],
        ),
      ),
    );
  }
}

void getVerificationCode() async {
  //点击获取验证码按钮进行api请求

}
