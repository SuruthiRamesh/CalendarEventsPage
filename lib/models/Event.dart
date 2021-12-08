//@dart=2.9
class Events {
  int id;
  String uuid;
  String Description;
  String images;
  String Background;
  int Color;
  String style;
  int shared;
  int sync;
  DateTime createdAt;
  DateTime eventdate;


  Events({this.eventdate,this.style,this.uuid,this.sync,this.shared,this.images,this.createdAt,this.Background,this.Description,this.Color,this.id});

  Events.fromMap(Map<String, dynamic> json){
    id= json["id"];
    uuid= json["uuid"];
    Description= json["Description"];
    images= json["images"];
    Background= json["Background"];
    Color= json["Color"];
    style= json["style"];
    shared= json["shared"];
    sync= json['sync'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int);
    eventdate = DateTime.fromMillisecondsSinceEpoch(json['eventdate'] as int);
  }
  toMap(){
    return {
      "id": id,
      "uuid": uuid,
      "Description": Description,
      "images": images,
      "Background":Background,
      "Color":Color,
      "style":style,
      "shared": shared,
      "sync": sync,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "eventdate": eventdate.millisecondsSinceEpoch
    };
  }
}