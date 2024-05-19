import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_project/function/get_item_from_str.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../widgets/prob_list_card.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_project/function/get_now_days.dart';
import 'package:my_project/pages/search_problist.dart';

class ProblemList extends StatefulWidget {
  const ProblemList({Key? key}) : super(key: key);

  @override
  State<ProblemList> createState() => _ProblemListState();
}

// bool needRefresh = false; //当pop到当前页面时需要refresh

class _ProblemListState extends State<ProblemList> {
  dynamic problistNum = ''; //问题单的个数
  String problistData = '';
  String textData = '';
  String state = '';
  String description = '';
  String analyse = '';
  String solution = '';
  String probTakenTime = '';
  String solveDdl = '';
  String department = ''; //部门0,1,2

  //String List，用来存放从数据库中获取的String
  List<String> stateList = [];
  List<String> descriptionList = [];
  List<String> analyseList = [];
  List<String> solutionList = [];
  List<String> nowDaysList = [];
  List<String> solveDdlList = [];
  List<String>  probTakenTimeList = [];

  @override
  void initState() {
    //初始化
    super.initState();
    getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments; //获取传入的参数
    Str2Map cvt = Str2Map(str: data.toString());
    department = cvt.getItemFromString('department')!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('问题单（${kDepartmentList[int.parse(department)]}）'),
      ),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.list),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.add_circle_outline, color: Colors.white),
              backgroundColor: Colors.blue,
              label: '新建问题单',
              onTap: () {
                Navigator.pushNamed(context, '/create_problist',
                    arguments: problistNum);
              }),
          SpeedDialChild(
              child: const Icon(Icons.search, color: Colors.white),
              backgroundColor: Colors.blue,
              label: '查找问题单',
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return SearchProblist();
                });
              }),
          SpeedDialChild(
              child: const Icon(Icons.cached, color: Colors.white),
              backgroundColor: Colors.blue,
              label: '刷新问题单',
              onTap: () {
                getProblistFromDB();
              }),
        ],
      ),
      body: (problistNum.runtimeType == int &&
              solveDdlList.length == problistNum)
          ? ListView.builder(
              itemCount: stateList.length,
              itemBuilder: (BuildContext context, int index) {
                return ProbListCard(
                  index: index + 1,
                  state: int.parse(stateList[index]),
                  department: int.parse(department),
                  description: descriptionList[index] != 'null'
                      ? descriptionList[index]
                      : '',
                  analyse:
                      analyseList[index] != 'null' ? analyseList[index] : '',
                  solveDdl: solveDdlList[index] != 'null'
                      ? int.parse(solveDdlList[index])
                      : 0,
                  nowDays: int.parse(nowDaysList[index]),
                  probTakenTime: probTakenTime,
                  solution:
                      solutionList[index] != 'null' ? solutionList[index] : '',
                  probImageUrl: '$probImageUrl${index + 1}',
                  solveImageUrl: '$solveImageUrl${index + 1}',
                );
              },
            )
          : null,
    );
  }

  Future<void> getPoblist(int index) async {
    final Dio dio = Dio();
    var response1 = await dio.get(
        'http://$hostName/webproject/get/get_problist.php', queryParameters: {
      'prob_id':index.toString()
    });
    var response2 = await dio.get(
        'http://$hostName/webproject/get/get_text.php', queryParameters: {
      'prob_id':index.toString()
    });

    if (response1.statusCode == 200 && response2.statusCode == 200) {
      problistData = response1.data;
      textData = response2.data;
      if (problistData != '') {
        Str2Map cvt1 = Str2Map(str: problistData);
        Str2Map cvt2 = Str2Map(str: textData);
        problistNum = cvt1.getItemFromString('problist_num');
        problistNum = int.parse(problistNum);
        print('problistNum=$problistNum');
        state = cvt1.getItemFromString('solve_state')!;
        description = cvt2.getItemFromString('description')!;
        analyse = cvt2.getItemFromString('analyse')!;
        solution = cvt2.getItemFromString('solution')!;
        probTakenTime = cvt1.getItemFromString('prob_taken_time')!;
        solveDdl = cvt1.getItemFromString('solve_ddl')!;
      }
    }
  }

  void getProblistFromDB() async {
    //点击刷新按钮，从数据库中获取数据并保存到本地
    //先将数组清空
    stateList = [];
    descriptionList = [];
    analyseList = [];
    solutionList = [];
    nowDaysList = [];
    solveDdlList = [];
    probTakenTimeList = [];
    final prefs = await SharedPreferences.getInstance();
    //先将本地保存的数据全部清楚
    await prefs.remove('stateList');
    await prefs.remove('descriptionList');
    await prefs.remove('analyseList');
    await prefs.remove('solutionList');
    await prefs.remove('nowDaysList');
    await prefs.remove('solveDdlList');
    await prefs.remove('probTakenTimeList');
    await prefs.remove('problistNum');
    //先访问网络api，获取problistNum
    await getPoblist(1);
    print('problistNum=$problistNum');
    for (int i = 1; i <= problistNum; i++) {
      //根据prob_id依次获取problist
      await getPoblist(i);
      //将数据暂存在String List中
      setState(() {
        stateList.add(state);
        descriptionList.add(description);
        analyseList.add(analyse);
        solutionList.add(solution);
        nowDaysList
            .add(getDays(probTakenTime)); //将获取得probTakenTime直接转化为当前问题单的解决时间
        solveDdlList.add(solveDdl);
        probTakenTimeList.add(probTakenTime);
      });
    }

    //将从数据库中获取的数据保存在本地
    await prefs.setInt('department', int.parse(department));
    await prefs.setStringList('stateList', stateList);
    await prefs.setStringList('descriptionList', descriptionList);
    await prefs.setStringList('analyseList', analyseList);
    await prefs.setStringList('solutionList', solutionList);
    await prefs.setStringList('nowDaysList', nowDaysList);
    await prefs.setStringList('solveDdlList', solveDdlList);
    await prefs.setStringList('probTakenTimeList', probTakenTimeList);
    await prefs.setInt('problistNum', problistNum);
  }

  void getLocalData() async {
    //从本地获取数据
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.getStringList('stateList') != null
          ? stateList = prefs.getStringList('stateList')!
          : [];
      prefs.getStringList('descriptionList') != null
          ? descriptionList = prefs.getStringList('descriptionList')!
          : [];
      prefs.getStringList('analyseList') != null
          ? analyseList = prefs.getStringList('analyseList')!
          : [];
      prefs.getStringList('solutionList') != null
          ? solutionList = prefs.getStringList('solutionList')!
          : [];
      prefs.getStringList('nowDaysList') != null
          ? nowDaysList = prefs.getStringList('nowDaysList')!
          : [];
      prefs.getStringList('solveDdlList') != null
          ? solveDdlList = prefs.getStringList('solveDdlList')!
          : [];
      problistNum = stateList.length;
      print('problistNum=$problistNum');
    });
  }

}
