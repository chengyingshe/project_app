import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_project/function/get_item_from_str.dart';
import 'constant.dart';
import 'package:toast/toast.dart';
import 'widgets/button.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _unameController =
      TextEditingController(); //存放用户名输入
  final TextEditingController _pwdController = TextEditingController(); //存放密码输入
  final FocusNode _unameFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  FocusScopeNode? focusScopeNode;
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool pwdShow = false; //密码显示
  bool isLogIn = false; //点击登录按钮后停顿两秒，按钮上的文本变为正在登陆

  @override
  void dispose() {
    // 重写dispose方法
    super.dispose();
    _unameController.dispose();
    _pwdController.dispose(); //完成输入后关闭两个controller放置资源占用
    _unameFocus.dispose();
    _pwdFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Image.asset(
            'images/logo.png',
            width: 260,
            color: Colors.blueGrey[800],
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _unameController,
                  focusNode: _unameFocus,
                  autofocus: true,
                  validator: (v) {
                    return v == null || v.trim().isEmpty ? '账号不能为空' : null;
                  },
                  readOnly: isLogIn,
                  //登陆时只读
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.perm_identity_outlined,
                      size: logInIconSize,
                    ),
                    labelText: '账号',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: _pwdController,
                  focusNode: _pwdFocus,
                  obscureText: !pwdShow,
                  validator: (v) {
                    return v == null || v.trim().isEmpty ? '密码不能为空' : null;
                  },
                  readOnly: isLogIn,
                  onEditingComplete: () {
                    (_formKey.currentState as FormState).validate();
                    focusScopeNode ??= FocusScope.of(context);
                    focusScopeNode!.unfocus();
                    verifyPwd();
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: logInIconSize,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        size: logInIconSize,
                        color: pwdShow ? Colors.blue : Colors.grey,
                      ),
                    ),
                    labelText: '密码',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Button(
                    child: !isLogIn
                        ? const Text(
                            '登录',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                '登录中...',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                    onPressed: () {
                      (_formKey.currentState as FormState).validate();
                      focusScopeNode ??= FocusScope.of(context);
                      focusScopeNode!.unfocus();
                      verifyPwd();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('账户注册')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'forget_pwd');
                  },
                  child: const Text('忘记密码')),
            ],
          ),
        ),
      ],
    );
  }

  void verifyPwd() async {
    final Dio dio = Dio();
    if ((_formKey.currentState as FormState).validate()) {
      var response = await dio.get(
          'http://$hostName/webproject/get/get_pwd.php',
          queryParameters: {'id': _unameController.text});
      setState(() {
        isLogIn = true;
      });
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        // print(response);
        if (response.statusCode == 200) {
          //网络正常时
          String htmlData = response.data;
          print('htmlData=$htmlData');
          if (htmlData == 'failed') {
            //连接MySQL数据库失败
            Toast.show('数据库连接失败，请联系相关技术人员', gravity: Toast.bottom);
          } else if (htmlData == '') {
            //未找到对应账号时
            Toast.show('账号或密码错误', gravity: Toast.bottom);
          } else {
            //找到对应的账号（将数据转换为字典存放）
            Str2Map cvt = Str2Map(str: htmlData);
            String? rightPwd = cvt.getItemFromString('pwd');
            if (rightPwd != _pwdController.text) {
              //密码校验
              //账户不存在时或密码错误时
              Toast.show('账号或密码错误', gravity: Toast.bottom);
            } else {
              //密码输入正确时
              Toast.show('账号和密码正确', gravity: Toast.bottom);
              Future.delayed(const Duration(milliseconds: 500)).then((value) =>
                  Navigator.pushReplacementNamed(context, '/tabs',
                      arguments: htmlData)); //路由跳转（传入参数dataMap）
            }
          }
        } else {
          //网络异常
          Toast.show('网络异常', gravity: Toast.bottom);
        }
        setState(() {
          isLogIn = false;
        });
      });
    }
  }
}
