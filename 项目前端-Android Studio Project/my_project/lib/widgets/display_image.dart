import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/constant.dart';
import 'package:my_project/pages/create_problist.dart';

class DisplaySmallImage extends StatelessWidget {
  const DisplaySmallImage(
      {Key? key,
      required this.imageIsDisplayed,
      required this.isFile,
      this.imageFile,
      required this.deleteButtonOnPressed,
      required this.imageOnPressed,
      this.url})
      : super(key: key);
  final bool imageIsDisplayed;
  final File? imageFile;
  final VoidCallback deleteButtonOnPressed;
  final bool isFile;
  final String? url; //当传入的是url时isFile=false，此时需要传入url
  final VoidCallback imageOnPressed;

  @override
  Widget build(BuildContext context) {
    late bool haveImage = true;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: !imageIsDisplayed
              ? const SizedBox(height: 20)
              : Stack(children: [
                  isFile
                      ? GestureDetector(
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                          onTap: imageOnPressed,
                        )
                      : GestureDetector(
                          child: Image.network(url!, errorBuilder: (a, b, c) {
                            haveImage = false;
                            return const SizedBox(height: 20);
                          }),
                          onTap: haveImage
                              ? imageOnPressed
                              : () {}, //有图片时才能调用onPressed点击函数
                        ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: deleteButtonOnPressed,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Theme.of(context).canvasColor.withOpacity(0.8),
                        ),
                        child: const Icon(Icons.close, size: 25.0),
                      ),
                    ),
                  ),
                ]),
        ),
      ],
    );
  }
}

class DisplayLargeImageFromUrl extends StatelessWidget {
  const DisplayLargeImageFromUrl({Key? key, required this.imageUrl})
      : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(imageUrl,
          errorBuilder: (a, b, c) => const SizedBox(height: 20),
          width: MediaQuery.of(context).size.width - 20),
    );
  }
}
