import 'package:flutter/material.dart';
import 'dart:io';

class NoteWidget extends StatelessWidget {
  final String title;
  final String? desc;
  final String? image;
  final String? audio;
  NoteWidget({Key? key, required this.title, this.desc, this.image, this.audio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        width: MediaQuery.of(context).size.width - 26,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            image != null
                ? SizedBox(
                    height: 8.0,
                  )
                : SizedBox(),
            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width - 26,
                      image: FileImage(File(image!)),
                    ),
                  )
                : SizedBox(),
            desc != null
                ? SizedBox(
                    height: 8.0,
                  )
                : SizedBox(),
            desc != null
                ? Container(
                    width: MediaQuery.of(context).size.width - 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Theme.of(context).primaryColorDark,
                    ),
                    padding: EdgeInsets.all(15.0),
                    child: Text(desc!),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
