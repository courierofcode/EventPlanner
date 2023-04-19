import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
 
class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
 
  const AddEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.selectedDate})
      : super(key: key);
 
  @override
  State<AddEvent> createState() => _AddEventState();
}
 
class _AddEventState extends State<AddEvent> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
 
  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    _timeController.text = "12:00";
  }
 
  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 12, minute: 00));
 
    if (time != null) {
      setState(() {
        _timeController.text =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      });
    }
  }
 
  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
 
    if (date != null) {
      setState(() {
        _dateController.text = date.toLocal().toString().split(" ")[0];
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Event")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                      labelText: 'Date', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(
                height: 5,
                width: 5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () => displayDatePicker(context),
                child: const Text("Pick Date"),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                      labelText: 'Time', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(
                height: 5,
                width: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: const Size(100, 50),
                  ),
                  onPressed: () => displayTimePicker(context),
                  child: const Text("Pick Time")),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              minimumSize: const Size(50, 50),
            ),
            onPressed: () {
              _addEvent();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
 
  void _addEvent() async {
    final time = _timeController.text;
    final title = _titleController.text;
    final description = _descController.text;
    final date = _dateController;
    if (title.isEmpty) {
      debugPrint('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance.collection('events').add({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(DateTime.parse(date.text)),
      "time": time,
      "user": FirebaseAuth.instance.currentUser?.uid,
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
