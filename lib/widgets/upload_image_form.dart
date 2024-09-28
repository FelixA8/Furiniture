import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageForm extends StatefulWidget {
  final File? image;
  final Function pickImage;
  final bool showImage;
  const UploadImageForm(
      {super.key,
      required this.image,
      required this.pickImage,
      required this.showImage});

  @override
  State<UploadImageForm> createState() => _UploadImageFormState();
}

class _UploadImageFormState extends State<UploadImageForm> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => widget.pickImage(),
          child: widget.showImage
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.grey.shade300),
                  height: 300,
                  child: Center(
                    child: widget.image != null
                        ? Image.file(widget.image!)
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text(
                                'Insert Product Image',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                  ),
                )
              : Container(
                  height: 40,
                  color: Colors.grey.shade300,
                  child: widget.image != null
                      ? Center(
                          child: Text(
                              "Image/${widget.image!.path.hashCode.toString()} inserted"))
                      : const Center(child: Text('Select Store Image')),
                ),
        ),
      ],
    );
  }
}
