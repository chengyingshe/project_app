import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_project/constant.dart';

import 'package:my_project/widgets/message_card.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../function/get_now_days.dart';
import '../modify_problist.dart';

List<String> expiringProbIdList = [];
List<String> expiringProbStateList = [];
List<String> expiringProbLeftDaysList = [];
List<String> expiringProbHaveReadList = [];
int? leftDays;
int? department;
List<String>? nowDaysList;
List<String>? descriptionList;
List<String>? analyseList;
List<String>? solutionList;
bool resetExpiring = true;

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  void initState() {
    super.initState();
    getExpiringProblistFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('消息通知'),
      ),
      body: leftDays == null
          ? null
          : ListView.builder(
              itemCount: expiringProbIdList.length,
              itemBuilder: (context, index) {
                return MessageCard(
                  department: department!,
                  state: int.parse(expiringProbStateList[index]),
                  probId: int.parse(expiringProbIdList[index]),
                  leftDays: int.parse(expiringProbLeftDaysList[index]),
                  haveRead:
                      expiringProbHaveReadList[index] == '0' ? false : true,
                  onPressToRead: () async {
                    setState(() {
                      resetExpiring = false;
                      if (expiringProbHaveReadList[index] == '0') {
                        expiringProbHaveReadList[index] = '1';
                      } else {
                        expiringProbHaveReadList[index] = '0';
                      }
                    });
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setStringList(
                        'expiringProbHaveReadList', expiringProbHaveReadList);
                    print(expiringProbHaveReadList);
                    Navigator.of(context).pop();
                  },
                  onPressToDelete: () async {
                    //probId == index + 1
                    setState(() {
                      resetExpiring = false;
                      expiringProbIdList.removeAt(index);
                      expiringProbHaveReadList.removeAt(index);
                      expiringProbStateList.removeAt(index);
                      expiringProbLeftDaysList.removeAt(index);
                    });
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setStringList(
                        'expiringProbIdList', expiringProbIdList);
                    prefs.setStringList(
                        'expiringProbHaveReadList', expiringProbHaveReadList);
                    prefs.setStringList(
                        'expiringProbStateList', expiringProbStateList);
                    prefs.setStringList(
                        'expiringProbLeftDaysList', expiringProbLeftDaysList);
                    Navigator.of(context).pop();
                  },
                  onPressToModify: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyProblist(
                                index: int.parse(expiringProbIdList[index]),
                                nowDays: int.parse(nowDaysList![
                                    int.parse(expiringProbIdList[index]) - 1]),
                                description: descriptionList![
                                    int.parse(expiringProbIdList[index]) - 1],
                                analyse: analyseList![
                                    int.parse(expiringProbIdList[index]) - 1],
                                solution: solutionList![
                                    int.parse(expiringProbIdList[index]) - 1],
                                probImageUrl: probImageUrl +
                                    (expiringProbIdList[index]).toString(),
                                solveImageUrl: solveImageUrl +
                                    (expiringProbIdList[index]).toString())));
                  },
                );
              }),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.add),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.alarm, color: Colors.white),
              backgroundColor: Colors.blue,
              label: '设置消息提醒时间',
              onTap: () async {
                setState(() {
                  resetExpiring = true;
                });
                leftDays = (await setLeftDays())!;
                print(leftDays);
                if (leftDays != 0) {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setInt('leftDays', leftDays!);
                }
              }),
          SpeedDialChild(
              child: const Icon(Icons.delete_forever_outlined, color: Colors.white),
              backgroundColor: Colors.blue,
              label: '删除所有已读消息',
              onTap: () async {
                setState(() {
                  resetExpiring = false;
                });
                for (int i = 0; i < expiringProbIdList.length; i++) {
                  print(expiringProbHaveReadList.length);
                  print('第$i个为${expiringProbHaveReadList[i]}');
                  if (expiringProbHaveReadList[i] == '1') {
                    print('删除第 $i 个');
                    setState(() {
                      expiringProbIdList.removeAt(i);
                      expiringProbHaveReadList.removeAt(i);
                      expiringProbStateList.removeAt(i);
                      expiringProbLeftDaysList.removeAt(i);
                    });
                  }
                }
                final prefs = await SharedPreferences.getInstance();
                prefs.setStringList('expiringProbIdList', expiringProbIdList);
                prefs.setStringList(
                    'expiringProbHaveReadList', expiringProbHaveReadList);
                prefs.setStringList(
                    'expiringProbStateList', expiringProbStateList);
                prefs.setStringList(
                    'expiringProbLeftDaysList', expiringProbLeftDaysList);
                print(expiringProbHaveReadList);
              }),
          SpeedDialChild(
              child: const Icon(Icons.drafts_outlined, color: Colors.white),
              backgroundColor: Colors.blue,
              label: '标记已读所有消息',
              onTap: () async {
                setState(() {
                  resetExpiring = false;
                });
                for (int i = 0; i < expiringProbHaveReadList.length; i++) {
                  setState(() {
                    expiringProbHaveReadList[i] = '1';
                  });
                }
                final prefs = await SharedPreferences.getInstance();
                prefs.setStringList(
                    'expiringProbHaveReadList', expiringProbHaveReadList);
                print(expiringProbHaveReadList);
              }),
        ],
      ),
    );
  }

  Future<void> getExpiringProblistFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    nowDaysList = prefs.getStringList('nowDaysList');
    descriptionList = prefs.getStringList('descriptionList');
    analyseList = prefs.getStringList('analyseList');
    solutionList = prefs.getStringList('solutionList');
    List<String>? solveDdlList = prefs.getStringList('solveDdlList');
    List<String>? probTakenTimeList = prefs.getStringList('probTakenTimeList');
    List<String>? stateList = prefs.getStringList('stateList');
    leftDays = prefs.getInt('leftDays');
    department = prefs.getInt('department');
    print('leftDays=$leftDays');
    print('resetExpiring=$resetExpiring');
    if (resetExpiring) {
      //当修改了日期，则需要重新获取数据，并保存到本地，重新加载当前界面时只需要从本地获取数据
      print('重新获取数据并保存到本地');
      expiringProbIdList = [];
      expiringProbStateList = [];
      expiringProbLeftDaysList = [];
      expiringProbHaveReadList = [];
      if (probTakenTimeList != null) {
        for (int i = 0; i < probTakenTimeList.length; i++) {
          int days = int.parse(getDays(probTakenTimeList[i]));
          if (leftDays != null &&
              solveDdlList![i] != 'null' &&
              int.parse(solveDdlList[i]) - days <= leftDays!) {
            print(
                'probId=${i + 1}, solveDdl=${solveDdlList[i]}, nowDays=$days');
            setState(() {
              expiringProbIdList.add((i + 1).toString());
              expiringProbStateList.add(stateList![i]);
              expiringProbLeftDaysList
                  .add((int.parse(solveDdlList[i]) - days).toString());
              expiringProbHaveReadList.add('0');
            });
          }
        }
      }
      //将数据保存到本地
      prefs.setStringList('expiringProbIdList', expiringProbIdList);
      prefs.setStringList('expiringProbHaveReadList', expiringProbHaveReadList);
      prefs.setStringList('expiringProbStateList', expiringProbStateList);
      prefs.setStringList('expiringProbLeftDaysList', expiringProbLeftDaysList);
    }
    //从本地获取数据
    expiringProbIdList = prefs.getStringList('expiringProbIdList')!;
    expiringProbHaveReadList = prefs.getStringList('expiringProbHaveReadList')!;
    expiringProbStateList = prefs.getStringList('expiringProbStateList')!;
    expiringProbLeftDaysList = prefs.getStringList('expiringProbLeftDaysList')!;

    print('expiringProbIdList=$expiringProbIdList');
    print('expiringProbHaveReadList=$expiringProbHaveReadList');
    print('expiringProbStateList=$expiringProbStateList');
    print('expiringProbLeftDaysList=$expiringProbLeftDaysList');
  }

  //设置消息提醒时间
  Future<int?> setLeftDays() async {
    TextEditingController setLeftDaysCtr = TextEditingController();
    const List<String> items = <String>['天', '周', '月'];
    String? _selectedVal = items[0];
    final prefs = await SharedPreferences.getInstance();
    int? leftDays = prefs.getInt('leftDays');
    if (leftDays != null && leftDays != 0) {
      setLeftDaysCtr.text = leftDays.toString();
    }
    return showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          title: const Text("设置消息提醒时间"),
          actions: [
            TextButton(
                onPressed: () {
                  if (_selectedVal == '月') {
                    leftDays = int.parse(setLeftDaysCtr.text) * 30;
                  } else if (_selectedVal == '周') {
                    leftDays = int.parse(setLeftDaysCtr.text) * 7;
                  } else {
                    leftDays = int.parse(setLeftDaysCtr.text);
                  }
                  resetExpiring = true;
                  Navigator.of(context).pop(leftDays);
                },
                child: Text('确定')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                child: Text('取消')),
          ],
          content: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 45,
                  child: TextFormField(
                    autofocus: true,
                    controller: setLeftDaysCtr,
                    maxLength: 4,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        counterText: '', border: InputBorder.none),
                  ),
                ),
              ),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return DropdownButton(
                    value: _selectedVal,
                    underline: const SizedBox(),
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedVal = v.toString();
                      });
                    });
              }),
            ],
          ),
        );
      },
    );
  }
}
