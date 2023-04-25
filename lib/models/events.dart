import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String time;
  final String? description;
  final String user;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.user,
    this.description,
  });

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Event(
      date: data['date'].toDate(),
      time: data['time'],
      title: data['title'],
      description: data['description'],
      user: data["user"],
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "time": time,
      "title": title,
      "description": description,
      "user": user,
    };
  }
}

class EventItem extends StatelessWidget {
  final Event event;
  final Function() onDelete;
  final Function()? onTap;
  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        event.title,
      ),
      subtitle: Text(
        event.time,
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
