//@dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formspage/Helper/DatabaseHelper.dart';
import 'package:formspage/Screens/AddEvents.dart';
import 'package:formspage/models/Event.dart';
import 'package:intl/intl.dart';
import 'UpdateEventPage.dart';


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Events> eventList = [];
  DataBaseHelper dataBaseHelper;
  File finalimage;
  int _id,_sync,_shared,_color;
  String _description,_images,_style,_background,_uuid,_createtime,_datetime;
  void deletetask(){
    DataBaseHelper().delete(_id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 0,
          title: Text('Diary List',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
        ),
        floatingActionButton:  FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            onPressed: () =>Navigator.push(
              context, MaterialPageRoute(
              builder: (_) =>MyDiary(
                events: Events(),
              ),
            ),
            ).then((value){
              refreshList();
            })
        ),
        body:ListView.builder(
            itemCount: eventList.length,
            itemBuilder: (context, index) {
              Events events = eventList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      _id = events.id;
                      _color = events.Color;
                      _description = events.Description;
                      _background = events.Background;
                      _createtime = DateFormat('MMMM dd, yyyy').format(events.createdAt).toString();
                      _datetime = DateFormat('MMMM dd, yyyy').format(events.eventdate).toString();
                      _images = events.images;
                      _shared = events.shared;
                      _sync = events.sync;
                      _uuid = events.uuid;
                      _style = events.style;
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: SizedBox(
                                width: double.maxFinite,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(_background)
                                    )
                                  ),
                                  child: ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Description:',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),),
                                            Expanded(
                                              child: Text(_description,style: TextStyle(
                                                fontFamily: _style,
                                                color: Color(_color),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                        deletetask();
                                        refreshList();
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: const Text('Delete'),
                                    ),
                                    TextButton(onPressed: (){
                                      setState(() {});
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>UpdateDiary(_id,_datetime,_description, _background, _color, _createtime, _images, _shared, _style, _sync,_uuid)
                                        ),
                                      );
                                    },
                                      child: const Text('Update'),),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child:  const Text('close')),
                                  ],
                                )
                              ],
                            );
                          });
                      setState(() {
                      });
                    },
                    child: Container(
                        height: 180,
                        width: 380,
                        child: Column(
                          children: [
                            Text(events.Description, style: TextStyle(
                                fontFamily: events.style,
                                fontWeight: FontWeight.w400,
                                color: Color(events.Color),
                                fontSize: 20),),
                            SizedBox(height: 10,width:50),
                            SizedBox(
                              child: events.images != null
                                  ? Image.file(
                                File(events.images),
                                width: 500.0,
                                height: 50.0,
                                fit: BoxFit.fitHeight,
                              )
                                  : Container(
                                child: IconButton(
                                    icon: Icon(Icons.add)),
                                decoration: BoxDecoration(
                                    color: Colors.grey),
                                width: 50,
                                height: 50,
                              ),
                            ),
                            SizedBox(height: 10,width: 50,),
                            Text('this was created at :${events.createdAt}'),
                            Text('this was set to date: ${events.eventdate}')
                          ],
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(fit: BoxFit.cover,
                              image: AssetImage(events.Background),
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)),
                            color: Colors.black
                        )
                    )
                ),
              );
            }
        )
    );
  }
  Future<void> refreshList() async {
    List<Events> x = await DataBaseHelper().getList();
    setState(() {
      eventList = x;
    });
  }
  @override
  void initState(){
    super.initState();
    refreshList();

  }
}