//@dart=2.9
class EventDTO {
  int id;
  String eventName;
  String eventDescription;
  String dateTime;
  String todateTime;


  EventDTO({this.id, this.eventName, this.eventDescription, this.dateTime, this.todateTime});

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
