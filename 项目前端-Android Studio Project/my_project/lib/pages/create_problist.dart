import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/constant.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/display_image.dart';
import 'package:my_project/widgets/text_field.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class CreateProblist extends StatefulWidget {
  const CreateProblist({Key? key}) : super(key: key);

  @override
  State<CreateProblist> createState() => _CreateProblistState();
}

//实例化选择图片
final ImagePicker picker = ImagePicker();
//用户本地图片
File? _userImage; //存放获取到的本地路径
bool imageIsDisplayed = false;
int problistNum = 0;

class _CreateProblistState extends State<CreateProblist> {
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    problistNum = int.parse(
        ModalRoute.of(context)!.settings.arguments.toString()); //获取传入的参数
    return Scaffold(
      appBar: AppBar(
        title: const Text('新建问题单'),
        backgroundColor: kAppBarColor,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const Text('问题描述：', style: redTitleTextStyle),
              MyTextFiledGrayBackground(
                controller: _description,
                readOnly: false,
              ),
              Row(
                children: [
                  const Text('问题图片：', style: redTitleTextStyle),
                  Button(
                      child: const Text('选择图片',
                          style: TextStyle(color: Colors.white)),
                      onPressed: selectImage),
                  const SizedBox(width: 10),
                  Button(
                      child: const Text('上传问题单',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (_description.text.isEmpty ||
                            _description.text.trim().isEmpty ||
                            !imageIsDisplayed) {
                          Toast.show('问题描述和问题图片不能为空', gravity: Toast.bottom);
                        } else {
                          print(problistNum);
                          //根据description向表中插入新行
                          uploadProblist(problistNum + 1, _userImage!);
                        }
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: DisplaySmallImage(
                  imageIsDisplayed: imageIsDisplayed,
                  imageFile: _userImage,
                  deleteButtonOnPressed: _deleteImage,
                  isFile: true,
                  imageOnPressed: selectImage,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //点击删除图标
  void _deleteImage() {
    setState(() {
      imageIsDisplayed = false;
      // print(imageIsDisplayed);
    });
  }

  Future<void> selectImage() async {
    //点击相册返回0，点击相机返回1
    int? select = await _bottomChoseSheet(context);
    if (select != null) {
      imageIsDisplayed = true;
      if (select == 0) {
        _getImage();
      } else if (select == 1) {
        _getCameraImage();
      }
    }
  }

  Future<void> _getCameraImage() async {
    final cameraImageXFile = await picker.pickImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        //拍摄照片不为空
        if (cameraImageXFile != null) {
          _userImage = File(cameraImageXFile.path);
          print('你选择的路径是：${_userImage.toString()}');
        }
      });
    }
  }

  Future<void> _getImage() async {
    //选择相册
    final imageXFile = await picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        if (imageXFile != null) {
          _userImage = File(imageXFile.path);
          print('你选择的本地路径是：${_userImage.toString()}');
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
                    child: Text(
                      '选择方式',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
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

  //点击上传问题单，发起api访问
  void uploadProblist(int probId, File image) async {
    String imagePath = image.path;
    List<String> imagePathList = imagePath.split('/');
    String imageName = imagePathList[imagePathList.length - 1];
    final Dio dio = Dio();
    var response = await dio.post(
        'http://$hostName/webproject/post/post_create_problist.php',
        data: FormData.fromMap({
          'prob_id': probId.toString(),
          'description': _description.text,
          'prob_image':
              await MultipartFile.fromFile(imagePath)
        }));
    if (response.statusCode == 200) {
      Toast.show('问题单添加成功，需要刷新问题单重新获取', gravity: Toast.bottom);
      setState(() {
        imageIsDisplayed = false;
        _description.text = '';
        Future.delayed(const Duration(milliseconds: 500))
            .then((value) => Navigator.of(context).pop());
      });
    }
  }
}
