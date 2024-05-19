import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/constant.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/display_image.dart';
import 'package:my_project/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../widgets/prob_list_card.dart';

class ModifyProblist extends StatefulWidget {
  const ModifyProblist({
    Key? key,
    this.index,
    this.nowDays,
    this.description,
    this.analyse,
    this.solution,
    this.probImageUrl,
    this.solveImageUrl,
  }) : super(key: key);
  final int? index;
  final int? nowDays;
  final String? description;
  final String? analyse;
  final String? solution;
  final String? probImageUrl;
  final String? solveImageUrl;

  @override
  State<ModifyProblist> createState() => _ModifyProblistState();
}

ImagePicker picker = ImagePicker();
File? _userImage;
XFile? imageXFile;
String probTakenTime = '';
TextEditingController _solveDdlCtr = TextEditingController();
List<int> stateAndDdl = [0, 0];
List<String> probTakenTimeList = [];
int? _state;
int? _solveDdl;

class _ModifyProblistState extends State<ModifyProblist> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _analyse = TextEditingController();
  final TextEditingController _solution = TextEditingController();

  bool solveImageIsDisplayed = true;
  bool solveImageIsFile = false;

  @override
  void initState() {
    //页面初始化时填入表单
    // TODO: implement initState
    super.initState();
    getDataFromLocal();
    _description.text = widget.description!;
    _analyse.text = widget.analyse!;
    _solution.text = widget.solution!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('修改问题单：${widget.index}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('问题状态：', style: redTitleTextStyle),
                Button(
                    child: const Text('修改状态'),
                    onPressed: () {
                      _showMultiChoiceModalBottomSheet(
                          context, ['问题状态', '问题提出时间']);
                    }),
                const SizedBox(width: 10),
                Button(
                    child: const Text('保存问题单'),
                    onPressed: () {
                      uploadProblist();
                    }),
              ],
            ),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  setState((){
                    _state = stateAndDdl[0];
                    _solveDdl = stateAndDdl[1];
                  });
              return ProbStateCard(
                state: _state!,
                nowDays: widget.nowDays,
                solveDdl: _solveDdl,
              );
            }),

            const SizedBox(height: 20),
            const Text('问题描述：', style: redTitleTextStyle),
            MyTextFiledGrayBackground(
              controller: _description,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            const Text('问题分析：', style: redTitleTextStyle),
            MyTextFiledGrayBackground(
              controller: _analyse,
              readOnly: false,
            ),
            const SizedBox(height: 20),
            const Text('问题图片：', style: redTitleTextStyle),
            DisplayLargeImageFromUrl(imageUrl: widget.probImageUrl!),
            const SizedBox(height: 20),
            const Text('解决方案：', style: redTitleTextStyle),
            MyTextFiledGrayBackground(
              controller: _solution,
              readOnly: false,
            ),
            // Text(widget.solution!, style: blackNormalTextStyle),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('解决图片：', style: redTitleTextStyle),
                Button(
                    child: Text('选择图片'),
                    onPressed: () {
                      selectImage();
                    }),
              ],
            ),
            DisplaySmallImage(
              imageIsDisplayed: solveImageIsDisplayed,
              isFile: solveImageIsFile,
              imageFile: _userImage,
              deleteButtonOnPressed: _deleteImage,
              url: widget.solveImageUrl!,
              imageOnPressed: () {
                selectImage();
              },
            ),
          ],
        ),
      ), //ProbListView();
    );
  }

  //点击删除图标
  void _deleteImage() {
    setState(() {
      solveImageIsDisplayed = false;
    });
  }

  Future<void> selectImage() async {
    //点击相册返回0，点击相机返回1
    int? select = await _bottomChoseSheet(context);
    if (select != null) {
      solveImageIsDisplayed = true;
      if (select == 0) {
        _getImage();
      } else if (select == 1) {
        _getCameraImage();
      }
    }
  }

  Future<void> _getCameraImage() async {
    final XFile? imagePicker =
        await picker.pickImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        //拍摄照片不为空
        if (imagePicker != null) {
          _userImage = File(imagePicker.path);
          print('你选择的路径是：${_userImage.toString()}');
          solveImageIsFile = true;
        }
      });
    }
  }

  Future<void> _getImage() async {
    //选择相册
    final XFile? pickerImages =
        await picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        if (pickerImages != null) {
          _userImage = File(pickerImages.path);
          print('你选择的本地路径是：${_userImage.toString()}');
          solveImageIsFile = true;
        }
      });
    }
  }

  //底部弹窗，点击选择图片的按钮后弹出
  Future<int?> _bottomChoseSheet(context) async {
    return showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          height: 180,
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Stack(
                textDirection: TextDirection.rtl,
                children: [
                  const Center(
                    child: Text('选择方式',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0)),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            const Divider(height: 1.0),
            Expanded(
                child: Column(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('从相册中选择'),
                    onTap: () {
                      Navigator.of(context).pop(0);
                    }),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('使用相机拍摄'),
                    onTap: () {
                      Navigator.of(context).pop(1);
                    }),
              ],
            )),
          ]),
        );
      },
    );
  }

  //点击修改状态，弹出底部窗口修改状态
  Future<List<int>?> _showMultiChoiceModalBottomSheet(
      BuildContext context, List<String> options) async {
    return showModalBottomSheet<List<int>>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context1, setState) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '修改问题单状态',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        setState(() {
                          stateAndDdl[1] = int.parse(_solveDdlCtr.text);
                        });
                        print(stateAndDdl);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
              Divider(height: 1.0),
              ListTile(
                leading: Text('问题单创建时间：', style: TextStyle(fontSize: 16)),
                trailing: Text('${probTakenTimeList[widget.index! - 1]}'),
              ),
              Divider(height: 1.0),
              ListTile(
                leading: Text('问题单预计完成时间：', style: TextStyle(fontSize: 16)),
                trailing: SizedBox(
                  width: 60,
                  height: 30,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                        height: 30,
                        child: TextFormField(
                          controller: _solveDdlCtr,
                          maxLength: 3,
                          decoration: InputDecoration(
                            counterText: '',
                          ),
                        ),
                      ),
                      Text('天', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.0),
              ListTile(
                leading: SizedBox(
                    width: 200,
                    child: Row(
                      children: [
                        Text('问题状态：', style: TextStyle(fontSize: 16)),
                        Text('${kProbStateText[stateAndDdl[0]]}',
                            style: TextStyle(
                                fontSize: 16,
                                color: kProbStateColor[stateAndDdl[0]])),
                      ],
                    )),
                trailing: SizedBox(
                  width: 90,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (stateAndDdl[0] != 0) {
                              setState(() {
                                stateAndDdl[0] = 0;
                              });
                            }
                          },
                          child: Icon(
                              stateAndDdl[0] == 0
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              size: 30,
                              color: stateAndDdl[0] == 0
                                  ? kProbStateColor[0]
                                  : Colors.grey)),
                      GestureDetector(
                          onTap: () {
                            if (stateAndDdl[0] != 1) {
                              setState(() {
                                stateAndDdl[0] = 1;
                              });
                            }
                          },
                          child: Icon(
                              stateAndDdl[0] == 1
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              size: 30,
                              color: stateAndDdl[0] == 1
                                  ? kProbStateColor[1]
                                  : Colors.grey)),
                      GestureDetector(
                          onTap: () {
                            if (stateAndDdl[0] != 2) {
                              setState(() {
                                stateAndDdl[0] = 2;
                              });
                            }
                          },
                          child: Icon(
                              stateAndDdl[0] == 2
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              size: 30,
                              color: stateAndDdl[0] == 2
                                  ? kProbStateColor[2]
                                  : Colors.grey)),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.0),
            ]),
          );
        });
      },
    );
  }

  Future<void> getDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    probTakenTimeList = prefs.getStringList('probTakenTimeList')!;
    List<String> solveDdlList = prefs.getStringList('solveDdlList')!;
    List<String> stateList = prefs.getStringList('stateList')!;
    dynamic ddl = solveDdlList[widget.index! - 1];
    print('ddlAndState=$stateAndDdl');
    stateAndDdl[0] = int.parse(stateList[widget.index! - 1]);
    if (ddl != null) {
      //当已设置solveDdl时，设置输入框默认文本
      stateAndDdl[1] = int.parse(ddl);
      _solveDdlCtr.text = stateAndDdl[1].toString();
    }
    print(stateAndDdl);
  }

  Future<void> uploadProblist() async {
    //发起网络api请求
    Dio dio = Dio();
    FormData problist = FormData.fromMap({
      'prob_id': widget.index,
      'analyse': _analyse.text,
      'solution': _solution.text,
      'solve_state': stateAndDdl[0].toString(),
      'solve_ddl': stateAndDdl[1].toString(),
    });

    if (solveImageIsDisplayed && _userImage != null) {
      problist.files.add(MapEntry(
        'solve_image',
        await MultipartFile.fromFile(_userImage!.path),
      ));
    }
    var response = await dio.post(
        'http://$hostName/webproject/post/post_modify_problist.php',
        data: problist);

    if (response.statusCode == 200) {
      Toast.show('问题单修改成功', gravity: Toast.bottom);
      // print(response.data);
      Future.delayed(Duration(milliseconds: 500))
          .then((value) => Navigator.of(context)
            ..pop()
            ..pop());
    } else {
      Toast.show('网络异常', gravity: Toast.bottom);
    }
  }
}
