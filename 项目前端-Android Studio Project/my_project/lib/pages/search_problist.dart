import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constant.dart';
import 'package:my_project/widgets/prob_list_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

bool _fromDescription = true;
bool _fromAnalyse = false;
bool _fromSolution = false;
List<bool> fromWhere = [true, false, false]; //description  analyse  solution
TextEditingController keyword = TextEditingController();
List<String> stateList = [];
List<String> descriptionList = [];
List<String> analyseList = [];
List<String> solutionList = [];
List<String> nowDaysList = [];
List<String> solveDdlList = [];
List<String> probTakenTimeList = [];
int problistNum = 0;
int department = 0;
List<int>? probIdListInt = [];

class SearchProblist extends StatefulWidget {
  const SearchProblist({Key? key}) : super(key: key);

  @override
  State<SearchProblist> createState() => _SearchProblistState();
}

class _SearchProblistState extends State<SearchProblist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: const Text('问题单查询'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              maxLines: 1,
              autofocus: true,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              controller: keyword,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                focusColor: Colors.blue[300],
                prefixIcon: Icon(Icons.search, color: Colors.blue[300]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.settings),
                    color: Colors.blue[300],
                    onPressed: () {
                      showProblistSearchSetting();
                    }),
              ),
              onChanged: (text) async {
                await searchProblist(text);
                print(probIdListInt);
              },
            ),
          ),
          probIdListInt == null || probIdListInt!.isEmpty
              ? const SizedBox(height: 20)
              : SizedBox(
            height: MediaQuery.of(context).size.height-165,
                child: ListView.builder(
                    itemCount: probIdListInt!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProbListCard(
                        index: probIdListInt![index],
                        state: int.parse(stateList[probIdListInt![index] - 1]),
                        department: department,
                        description:
                            descriptionList[probIdListInt![index] - 1] != 'null'
                                ? descriptionList[probIdListInt![index] - 1]
                                : '',
                        analyse: analyseList[probIdListInt![index] - 1] != 'null'
                            ? analyseList[probIdListInt![index] - 1]
                            : '',
                        solveDdl: solveDdlList[probIdListInt![index] - 1] != 'null'
                            ? int.parse(solveDdlList[probIdListInt![index] - 1])
                            : 0,
                        nowDays: int.parse(nowDaysList[probIdListInt![index] - 1]),
                        probTakenTime: probTakenTimeList[probIdListInt![index] - 1],
                        solution: solutionList[probIdListInt![index] - 1] != 'null'
                            ? solutionList[probIdListInt![index] - 1]
                            : '',
                        probImageUrl: '$probImageUrl${probIdListInt![index]}',
                        solveImageUrl:
                            '$solveImageUrl${probIdListInt![index]}',
                      );
                    },
                  ),
              ),
        ],
      ),
    );
  }

  //点击设置后跳出对话框，显示查找类型（description、analyse、solution）
  Future<void> showProblistSearchSetting() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("查询设置"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('从问题描述中查询'),
                        Checkbox(
                            value: _fromDescription,
                            onChanged: (v) {
                              if (haveOneTrue(fromWhere)! && !v!) {
                                Toast.show('至少要选中一项', gravity: Toast.bottom);
                              } else {
                                //至少要选中一个
                                setState(() {
                                  _fromDescription = v!;
                                  fromWhere[0] = _fromDescription;
                                });
                              }
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('从问题分析中查询'),
                        Checkbox(
                            value: _fromAnalyse,
                            onChanged: (v) {
                              if (haveOneTrue(fromWhere)! && !v!) {
                                Toast.show('至少要选中一项', gravity: Toast.bottom);
                              } else {
                                //至少要选中一个
                                setState(() {
                                  _fromAnalyse = v!;
                                  fromWhere[1] = _fromAnalyse;
                                });
                              }
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('从解决方案中查询'),
                        Checkbox(
                            value: _fromSolution,
                            onChanged: (v) {
                              if (haveOneTrue(fromWhere)! && !v!) {
                                Toast.show('至少要选中一项', gravity: Toast.bottom);
                              } else {
                                //至少要选中一个
                                setState(() {
                                  _fromSolution = v!;
                                  fromWhere[2] = _fromSolution;
                                });
                              }
                            })
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool? haveOneTrue(List<bool> list) {
    int count = 0;
    bool l;
    for (l in list) {
      if (l) {
        count++;
      }
    }
    if (count == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> searchProblist(String key) async {
    final prefs = await SharedPreferences.getInstance();
    stateList = prefs.getStringList('stateList')!;
    descriptionList = prefs.getStringList('descriptionList')!;
    analyseList = prefs.getStringList('analyseList')!;
    solutionList = prefs.getStringList('solutionList')!;
    nowDaysList = prefs.getStringList('nowDaysList')!;
    solveDdlList = prefs.getStringList('solveDdlList')!;
    probTakenTimeList = prefs.getStringList('probTakenTimeList')!;
    problistNum = prefs.getInt('problistNum')!;
    department = prefs.getInt('department')!;
    List<String>? probIdList = [];
    Dio dio = Dio();
    Map<String, String> fromWhereMap = {};
    if (fromWhere[0]) {
      fromWhereMap['description'] = keyword.text;
    }
    if (fromWhere[1]) {
      fromWhereMap['analyse'] = keyword.text;
    }
    if (fromWhere[2]) {
      fromWhereMap['solution'] = keyword.text;
    }
    print('fromWhereMap=$fromWhereMap');
    var response = await dio.get(
        'http://$hostName/webproject/get/get_search_problist.php',
        queryParameters: fromWhereMap);
    if (response.statusCode == 200) {
      probIdList = response.data.toString().split('<br>');
      if (probIdList.isNotEmpty) probIdList.removeLast();
      probIdListInt = [];
      for (int i = 0; i < probIdList.length; i++) {
        setState(() {
          probIdListInt?.add(int.parse(probIdList![i]));
        });
      }
    }
  }
}
