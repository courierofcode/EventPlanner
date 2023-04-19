
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:event_planner/models/events.dart';
 
class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
 
  final Event event;
 
  const EditEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.event})
      : super(key: key);
 
  @override
  State<EditEvent> createState() => _EditEventState();
}
 
class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
 
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.event.date));
    _timeController = TextEditingController(text: widget.event.time);
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
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
      initialDate: widget.event.date,
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
      appBar: AppBar(title: const Text("Edit Event")),
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
              _editEvent();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
 
  void _editEvent() async {
    final time = _timeController.text;
    final title = _titleController.text;
    final description = _descController.text;
    final date = _dateController;
    if (title.isEmpty) {
      debugPrint('title cannot be empty');
      return;
    }
    debugPrint('$_selectedDate');
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(DateTime.parse(date.text)),
      "time": time,
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
