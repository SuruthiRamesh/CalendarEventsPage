//@dart=2.9
import 'package:flutter/cupertino.dart';

class Events {
  final int id;
  final String eventName;
  final String eventDescription;
  final DateTime dateTime;
  final DateTime todateTime;


  Events(
      {this.id, this.eventName, this.eventDescription, this.dateTime, this.todateTime});

  factory Events.fromMap(Map data) {
    return Events(
        id: data['id'],
        eventName: data['eventName'],
        eventDescription: data['eventDescription'],
        dateTime: DateTime.parse(data['dateTime']),
      todateTime: DateTime.parse(data['todateTime'])
        );
  }

  factory Events.fromJson(int id, Map<String, dynamic> data) {
    return Events(
        id: id,
        eventName: data['eventName'],
        eventDescription: data['eventDescription'],
        dateTime: data['dateTime'].toDate(),
      todateTime: data['todateTime'].toDate()
        );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "eventName": eventName,
      "eventDescription": eventDescription,
      "dateTime": dateTime,
      "todateTime":todateTime
      };
  }
}
