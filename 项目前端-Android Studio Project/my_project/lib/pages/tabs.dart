import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:my_project/constant.dart';
import 'tabs/identity.dart';
import 'tabs/message.dart';
import 'tabs/problem_list.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  DateTime? _lastPressedAt; //记录上次点击的时间
  int _currentIndex = 0;
  final List<Widget> _pagesList = [
    const ProblemList(),
    const Message(),
    const Identity(),
  ];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
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
      child: Scaffold(
        body: _pagesList[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: buttonColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              label: '问题单',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: '消息通知',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '个人信息',
            ),
          ],
        ),
      ),
    );
  }
}
