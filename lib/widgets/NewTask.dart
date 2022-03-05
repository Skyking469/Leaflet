import 'package:flutter/material.dart';
import '../services/db_handler.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class NewTask extends StatefulWidget {
  final Function? parentState;
  const NewTask({Key? key, this.parentState}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  DateTime _test = DateTime.now();
  final _taskController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  late DatabaseHandler _databaseHandler;
  loc.Location location = loc.Location();
  loc.LocationData? _currentPosition;

  @override
  void initState() {
    super.initState();
    this._databaseHandler = DatabaseHandler();
    this._databaseHandler.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  getLoc() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _locationController.text = "Locating...";
    });
    _currentPosition = await location.getLocation();
    setState(() {
      _getAddress(_currentPosition!.latitude!, _currentPosition!.longitude!)
          .then((value) {
        setState(() {
          _locationController.text = value.locality!;
        });
      });
    });
  }

  Future<Placemark> _getAddress(double lat, double lng) async {
    List<Placemark> add = await placemarkFromCoordinates(lat, lng);
    return add[0];
  }

  void _presentDatePicker(BuildContext ctx) {
    showDatePicker(
            context: ctx,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(3000))
        .then((pickedDate) {
      _test = pickedDate ?? DateTime.now();
      _dateController.text = DateFormat.yMd().format(_test);
    });
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Create a new task",
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
                labelText: "Task Name",
              ),
              controller: _taskController,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: InputDecoration(
                labelText: "Date",
              ),
              controller: _dateController,
              readOnly: true,
              onTap: () => _presentDatePicker(context),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: InputDecoration(
                  labelText: "Location",
                  suffixIcon: InkWell(
                    onTap: getLoc,
                    child: Icon(
                      Icons.my_location_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
              controller: _locationController,
              readOnly: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_taskController.text != '' && _dateController.text != '') {
                  Task task = Task(
                      title: _taskController.text,
                      date: _dateController.text,
                      location: _locationController.text,
                      isDone: 0);
                  await this._databaseHandler.createTask(task);
                  _locationController.clear();
                  _taskController.clear();
                  _dateController.clear();
                  widget.parentState!();
                }
              },
              child: Text("Add Task"),
            )
          ],
        ),
      ),
    );
  }
}
