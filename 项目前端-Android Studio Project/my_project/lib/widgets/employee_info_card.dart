import 'package:flutter/material.dart';

class EmployeeInfoCard extends StatefulWidget {
  const EmployeeInfoCard(
      {Key? key,
      required this.name,
      required this.id,
      required this.pwd,
      required this.onPressForDetails})
      : super(key: key);

  final String name;
  final String id;
  final String pwd;
  final VoidCallback onPressForDetails;

  @override
  State<EmployeeInfoCard> createState() => _EmployeeInfoCardState();
}

bool pwdIsShown = false;

class _EmployeeInfoCardState extends State<EmployeeInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        const SizedBox(height: 5),
        ListTile(
          title: Text('姓名：${widget.name}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('工号：${widget.id}'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  children: [
                    Text('密码：${pwdIsShown ? widget.pwd : '******'}'),
                    const SizedBox(width: 20),
                    GestureDetector(
                        child: Icon(Icons.remove_red_eye_outlined,
                            size: 23,
                            color: pwdIsShown ? Colors.blue : Colors.grey),
                        onTap: () {
                          setState(() {
                            pwdIsShown = !pwdIsShown;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          trailing: TextButton(
              child: const Text('查看详细信息'), onPressed: widget.onPressForDetails),
        ),
        const Divider(height: 0)
      ],
    );
  }
}
