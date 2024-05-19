import 'package:my_project/widgets/problem_list_details.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

class ProbListCard extends StatelessWidget {
  //显示问题单的小卡片，需要传入index（问题单号）、description、analyse、prob_state
  final int index;
  final int state;
  final int department;
  final String? description;
  final String? analyse;
  final int? solveDdl;
  final int? nowDays;
  final String? probTakenTime;
  final String? solution;
  final String? probImageUrl;
  final String? solveImageUrl;

  const ProbListCard(
      {Key? key,
      required this.index,
      required this.state,
      required this.department,
      this.description,
      this.analyse,
      this.solveDdl,
      this.probTakenTime,
      this.nowDays,
      this.solution,
      this.probImageUrl,
      this.solveImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ProbListDetails(
              index: index,
              state: state,
              department: department,
              description: description,
              analyse: analyse,
              solution: solution,
              probImageUrl: probImageUrl,
              solveImageUrl: solveImageUrl,
              solveDdl: solveDdl,
              nowDays: nowDays,
            );
          }));
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$index',
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '问题描述：\n$description',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Text('问题分析：\n$analyse',
                                maxLines: 3, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Icon(Icons.fiber_manual_record,
                          size: 50, color: kProbStateColor[state]),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class ProbStateCard extends StatefulWidget {
  final int state;
  final int? nowDays;
  final int? solveDdl;

  const ProbStateCard(
      {Key? key, required this.state, this.nowDays, this.solveDdl})
      : super(key: key);


  @override
  State<ProbStateCard> createState() => _ProbStateCardState();
}

class _ProbStateCardState extends State<ProbStateCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProblistLight(state: widget.state),
        Text(
          kProbStateText[widget.state],
          style: TextStyle(
            color: kProbStateColor[widget.state],
            fontSize: 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
          child: Text(
            //显示当前问题单待解决时间
            '时间：\n' +
                (widget.solveDdl == 0
                    ? '?/?'
                    : widget.nowDays.toString() +
                        '/' +
                        widget.solveDdl.toString()),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

//问题单状态，传入int state，0=>未解决（红色），1=>正在解决（黄色），2=>已解决（绿色）
class ProblistLight extends StatelessWidget {
  const ProblistLight({Key? key, required this.state}) : super(key: key);
  final int state;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.fiber_manual_record,
      size: 50,
      color: kProbStateColor[state], //设置问题单状态
    );
  }
}
