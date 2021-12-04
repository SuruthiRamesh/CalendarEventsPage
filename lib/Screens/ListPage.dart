//@dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formspage/Helper/DatabaseHelper.dart';
import 'package:formspage/Screens/AddEvents.dart';
import 'package:formspage/models/Event.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Events> eventList;
  bool loading = true;
  File finalimage;
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
      body: loading ? Center(child: CircularProgressIndicator())
          :ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          Events events = eventList[index];
          return InkWell(
              onTap: () {
                setState(() {
                  loading = true;
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      MyDiary(
                        events: events,
                      ))).then((value) {
                    refreshList();
                  });
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
          );
        }
        )
    );
  }
  Future<void> refreshList() async {
    eventList = await DataBaseHelper().getList();
    setState(() => loading = false);
  }
  @override
  void initState(){
    super.initState();
    refreshList();
  }
}
