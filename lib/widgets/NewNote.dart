import 'dart:io';
import 'package:leaflet/services/db_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note.dart';

class NewNote extends StatefulWidget {
  final Function? parentState;
  const NewNote({Key? key, this.parentState}) : super(key: key);

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _pickedImagePath;
  late DatabaseHandler _databaseHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    this._databaseHandler = DatabaseHandler();
    this._databaseHandler.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    _pickedImagePath = image!.path;
    print(image.path);
    setState(() {});
  }

  Future<void> _captureImage() async {
    if (_titleController.text != "") {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      final Directory? dir = await getExternalStorageDirectory();
      final path = dir!.path;
      File tmpFile = File(image!.path);
      tmpFile = await tmpFile.copy('$path/${_titleController.text}.jpg');
      print(tmpFile.path);
      _pickedImagePath = tmpFile.path;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).backgroundColor,
        ),
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Create a new note",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: InputDecoration(
                labelText: "Note Name",
              ),
              controller: _titleController,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 6,
              minLines: 1,
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: InputDecoration(
                labelText: "Description",
              ),
              controller: _descController,
              onTap: () {},
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Note Image: ",
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 17.0),
                  ),
                ),
                _pickedImagePath != null
                    ? Image(
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        image: FileImage(
                          File(_pickedImagePath!),
                        ),
                      )
                    : Text(
                        "No image selected",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0),
                      ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Select Image"),
                ),
                SizedBox(
                  width: 8.0,
                ),
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Text("Capture"),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text != '' && _descController.text != '') {
                  if (_pickedImagePath != null) {
                    Note note = Note(
                      title: _titleController.text,
                      body: _descController.text,
                      picture: _pickedImagePath,
                    );
                    await this._databaseHandler.createNote(note);
                  } else {
                    Note note = Note(
                      title: _titleController.text,
                      body: _descController.text,
                    );
                    await this._databaseHandler.createNote(note);
                  }
                  _titleController.clear();
                  _descController.clear();
                  _pickedImagePath = null;
                  widget.parentState!();
                }
              },
              child: Text("Add Note"),
            ),
          ],
        ),
      ),
    );
  }
}
