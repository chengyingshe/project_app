import 'package:flutter/material.dart';
import 'package:my_project/widgets/prob_list_card.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    Key? key,
    required this.department,
    required this.state,
    required this.probId,
    required this.leftDays,
    required this.haveRead,
    required this.onPressToRead,
    required this.onPressToDelete,
    required this.onPressToModify,
  }) : super(key: key);
  final int department;
  final int state;
  final int probId;
  final int leftDays;
  final bool haveRead;
  final VoidCallback onPressToRead;
  final VoidCallback onPressToDelete;
  final VoidCallback onPressToModify;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        ListTile(
          leading: ProblistLight(state: widget.state),
          title: Row(
            children: [
              Text('问题单${widget.probId}'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width - 165, 0, 0, 20),
                child: Icon(Icons.circle,
                    size: 8,
                    color: widget.haveRead ? Colors.transparent : Colors.red),
              )
            ],
          ),
          selectedColor: Colors.grey[100],
          subtitle: Text(widget.leftDays >= 0
              ? '距离问题单预期完成时间还剩 ${widget.leftDays} 天'
              : '问题单已逾期 ${-widget.leftDays} 天'),
          onTap: () {},
          onLongPress: () {
            showOnLongPress();
          },
        ),
        const Divider(height: 0),
      ],
    );
  }

  //点击删除按钮后出现的对话框
  Future<bool?> showOnLongPress() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            title: const Text("消息操作"),
            content: SizedBox(
              height: widget.department == 2 ? 150 : 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.department == 2
                      ? TextButton(
                          onPressed: widget.onPressToModify,
                          child: const Text('修改问题单'))
                      : const SizedBox(),
                  TextButton(
                      onPressed: widget.onPressToRead,
                      child: Text(widget.haveRead ? '标记消息未读' : '标记消息已读')),
                  TextButton(
                      onPressed: widget.onPressToDelete, child: const Text('删除当前消息')),
                ],
              ),
            ));
      },
    );
  }
}
