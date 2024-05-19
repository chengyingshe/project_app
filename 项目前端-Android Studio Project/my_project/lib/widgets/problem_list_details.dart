import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constant.dart';
import 'package:my_project/pages/modify_problist.dart';
import 'package:my_project/widgets/prob_list_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'display_image.dart';

class ProbListDetails extends StatefulWidget {
  //点击问题单小卡片后跳转到问题单具体页面，其中有详细的description、analyse、prob_image、
  //solve_image（null）、solve_time|第几周、
  final int index;
  final int state;
  final int department;
  final String? description;
  final String? analyse;
  final String? solution;
  final int? solveDdl;
  final int? nowDays;
  final String? probImageUrl;
  final String? solveImageUrl;

  const ProbListDetails({
    Key? key,
    required this.state,
    required this.index,
    required this.department,
    this.description,
    this.analyse,
    this.solution,
    this.solveDdl,
    this.nowDays,
    this.probImageUrl,
    this.solveImageUrl,
  }) : super(key: key);

  @override
  State<ProbListDetails> createState() => _ProbListDetailsState();
}

class _ProbListDetailsState extends State<ProbListDetails> {
  @override
  Widget build(BuildContext context) {
    const List<String> items = <String>['修改', '删除'];
    return Scaffold(
      appBar: AppBar(
        title: Text('问题单：${widget.index}'),
        backgroundColor: kAppBarColor,
        actions: widget.department == 2
            ? [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 0, 10),
                  child: DropdownButton(
                    icon: const Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(5),
                    iconSize: 30,
                    onChanged: (String? newValue) async {
                      if (newValue == '修改') {
                        print('修改');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModifyProblist(
                                    index: widget.index,
                                    nowDays: widget.nowDays!,
                                    description: widget.description!,
                                    analyse: widget.analyse!,
                                    solution: widget.solution!,
                                    probImageUrl: widget.probImageUrl!,
                                    solveImageUrl: widget.solveImageUrl!)));
                      } else if (newValue == '删除') {
                        print('删除');
                        bool? confirm = await showDeleteConfirmDialog();
                        if (confirm!) {
                          Future.delayed(const Duration(milliseconds: 500))
                              .then((value) => Navigator.pop(context));
                        }
                      }
                    },
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('问题状态：', style: redTitleTextStyle),
            ProbStateCard(
              state: widget.state,
              nowDays: widget.nowDays,
              solveDdl: widget.solveDdl,
            ),
            const SizedBox(height: 20),
            const Text('问题描述：', style: redTitleTextStyle),
            Text(widget.description!, style: blackNormalTextStyle),
            const SizedBox(height: 20),
            const Text('问题分析：', style: redTitleTextStyle),
            Text(widget.analyse!, style: blackNormalTextStyle),
            const SizedBox(height: 20),
            const Text('问题图片：', style: redTitleTextStyle),
            DisplayLargeImageFromUrl(imageUrl: widget.probImageUrl!),
            const SizedBox(height: 20),
            const Text('解决方案：', style: redTitleTextStyle),
            Text(widget.solution!, style: blackNormalTextStyle),
            const SizedBox(height: 20),
            const Text('解决图片：', style: redTitleTextStyle),
            DisplayLargeImageFromUrl(imageUrl: widget.solveImageUrl!),
          ],
        ),
      ),
    );
  }

  //点击删除按钮后出现的对话框
  Future<bool?> showDeleteConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("删除问题单"),
          content: const Text("您确定要删除当前问题单吗?"),
          actions: <Widget>[
            TextButton(
                child: const Text("确认"),
                onPressed: () {
                  deleteProblist();
                  Navigator.of(context).pop(true);
                }), // 关闭对话框
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProblist() async {
    //点击删除问题单
    Dio dio = Dio();
    var response = await dio.post(
        'http://$hostName/webproject/post/post_delete_problist.php',
        data: FormData.fromMap({'prob_id': widget.index}));
    final prefs = await SharedPreferences.getInstance();
    int? problistNum = prefs.getInt('problistNum');
    print('prob_id=${widget.index}, problistNum=$problistNum');
    if (response.statusCode == 200) {
      if (widget.index != problistNum) {
        //当删除的问题单是中间的问题单时，为了使问题单连续，需要重新排序问题单
        var response2 = await dio
            .post('http://$hostName/webproject/post/post_reorder_problist.php');
        if (response2.statusCode == 200) {
          print('data=${response2.data}');
        }
      }
      Toast.show('问题单删除成功', gravity: Toast.bottom);
    } else {
      Toast.show('网络异常，删除失败', gravity: Toast.bottom);
    }
  }
}
