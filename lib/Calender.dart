//@dart=2.9
import 'package:date_format/date_format.dart';

import 'DataBaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Events.dart';

const headingColor = const Color(0xFF565d91);

class CalenderScreen extends StatefulWidget {
  final Events event;

  const CalenderScreen({this.event});
  @override
  Calender createState() => Calender();
}

class Calender extends State<CalenderScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptioncontroller= new TextEditingController();
  TextEditingController updatenameController = new TextEditingController();
  TextEditingController updatedescriptioncontroller= new TextEditingController();
  DataBaseHelper dataBaseHelper;
  List<Events> eventsList = [];
  List<Events> alleventsList = [];
  String name ='';
  DateTime Setdate;
  DateTime toSetdate;
  String disc = '';
  bool isEnabled = false;
  bool valueFromAddEvent = false;
  int _id;
  String _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _notesText = '';
  final formkey = GlobalKey<FormState>();

  void addEvents(){
    String date = DateFormat("MMM dd, yyyy").format(Setdate);
    dataBaseHelper.insertEvents(Events(
      eventName: nameController.text,
      eventDescription: descriptioncontroller.text,
      dateTime: Setdate,
      todateTime: toSetdate,
    ));
    dataBaseHelper.retrieveEvents(date).then((value) => {
      setState(() {
        eventsList = value;
      })
    });
    dataBaseHelper.retrieveAllData().then((value) => {
      setState(() {
        alleventsList = value;
      })
    });
  }
  void updateTask(){
    String date = DateFormat("MMM dd, yyyy").format(Setdate);
    dataBaseHelper.updateTask(Events(
            id: _id,
            eventName: updatenameController.text,
            eventDescription: updatedescriptioncontroller.text,
            dateTime: Setdate,
            todateTime: toSetdate));

    dataBaseHelper.retrieveEvents(date).then((value) => {
      setState(() {
        eventsList = value;
      })
    });
    dataBaseHelper.retrieveAllData().then((value) => {
      setState(() {
        alleventsList = value;
      })
    });
    Navigator.of(context).pop();
  }
  void deleteTask(){
    String date = DateFormat("MMM dd, yyyy").format(Setdate);
    dataBaseHelper.deleteTask(_id);
    dataBaseHelper.retrieveEvents(date).then((value) => {
      setState(() {
        eventsList = value;
      })
    });
    dataBaseHelper.retrieveAllData().then((value) => {
      setState(() {
        alleventsList = value;
      })
    });
    Navigator.of(context).pop();
  }
  updatePopup(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: StatefulBuilder(builder: (context, setState) {
                return Form(
                  onChanged: () =>setState(() {
                    isEnabled = formkey.currentState.validate();
                  }),
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: updatenameController,
                        decoration: const InputDecoration(
                            hintText: 'name'
                        ),
                        validator: (value){
                          String patttern = r'(^[a-zA-Z ]*$)';
                          RegExp regExp = new RegExp(patttern);
                          if (value.length == 0) {
                            return "Event Title is Required";
                          }else if (!regExp.hasMatch(value)) {
                            return "Event Title must be a-z and A-Z";
                          }
                          return null;
                        },
                        onChanged: (value){
                          name = value;
                        },
                      ),
                      SizedBox(height: 5,),
                      ListTile(
                        title: Text("Date"),
                        subtitle: Text("${Setdate.year} - ${Setdate.month} - ${Setdate.day}"),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1800),
                              lastDate: DateTime(2100));
                          if (picked != null) {
                            setState(() {
                              Setdate = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 5,),
                      ListTile(
                        title: Text("To Date"),
                        subtitle: Text("${toSetdate.year} - ${toSetdate.month} - ${toSetdate.day}"),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1800),
                              lastDate: DateTime(2100));
                          if (picked != null) {
                            setState(() {
                              toSetdate = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 5,),
                      TextFormField(
                        controller: updatedescriptioncontroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 1500,
                        decoration: const InputDecoration(
                          hintText: 'Plan To Dinner',
                        ),
                        validator: (value){
                          String patttern = r'(^[a-zA-Z ]*$)';
                          RegExp regExp = new RegExp(patttern);
                          if (value.length == 0) {
                            return "Description is Required";
                          }else if (!regExp.hasMatch(value)) {
                            return "Description must be a-z and A-Z";
                          }
                          return null;
                        },
                        onChanged: (value){
                          disc = value;
                        },
                      ),
                      SizedBox(height:5),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Builder(
                                builder: (context) =>
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40.0)
                                        ),
                                        width: 250,
                                        height: 50,
                                        margin: EdgeInsets.all(25),
                                        child: RaisedButton(
                                          shape:  RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40.0),
                                              side: BorderSide(width: 0)),
                                          onPressed: isEnabled ? (){
                                            updateTask();
                                            Setdate = DateTime.now();
                                            toSetdate = DateTime.now();
                                            Navigator.pop(context);
                                          } : null,
                                          color: Colors.pinkAccent[100],
                                          textColor: Colors.white,
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Text('Update'),
                                        ),
                                      ),
                                    )
                            ),
                          ]
                      )
                    ],
                  ),
                );
              }));
        });
  }
  showPopup(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: StatefulBuilder(builder: (context, setState) {
                return Form(
                  onChanged: () =>setState(() {
                    isEnabled = formkey.currentState.validate();
                  }),
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: 'name'
                        ),
                        validator: (value){
                          String patttern = r'(^[a-zA-Z ]*$)';
                          RegExp regExp = new RegExp(patttern);
                          if (value.length == 0) {
                            return "Event Title is Required";
                          }else if (!regExp.hasMatch(value)) {
                            return "Event Title must be a-z and A-Z";
                          }
                          return null;
                        },
                        onChanged: (value){
                          name = value;
                        },
                      ),
                      SizedBox(height: 5,),
                      ListTile(
                        title: Text("Date"),
                        subtitle: Text("${Setdate.year} - ${Setdate.month} - ${Setdate.day}"),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1800),
                              lastDate: DateTime(2100));
                          if (picked != null) {
                            setState(() {
                              Setdate = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 5,),
                      ListTile(
                        title: Text("To Date"),
                        subtitle: Text("${toSetdate.year} - ${toSetdate.month} - ${toSetdate.day}"),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1800),
                              lastDate: DateTime(2100));
                          if (picked != null) {
                            setState(() {
                              toSetdate = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 5,),
                      TextFormField(
                        controller: descriptioncontroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 1500,
                        decoration: const InputDecoration(
                          hintText: 'Plan To Dinner',
                        ),
                        validator: (value){
                          String patttern = r'(^[a-zA-Z ]*$)';
                          RegExp regExp = new RegExp(patttern);
                          if (value.length == 0) {
                            return "Description is Required";
                          }else if (!regExp.hasMatch(value)) {
                            return "Description must be a-z and A-Z";
                          }
                          return null;
                        },
                        onChanged: (value){
                          disc = value;
                        },
                      ),
                      SizedBox(height:5),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Builder(
                                builder: (context) =>
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40.0)
                                        ),
                                        width: 250,
                                        height: 50,
                                        margin: EdgeInsets.all(25),
                                        child: RaisedButton(
                                          shape:  RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40.0),
                                              side: BorderSide(width: 0)),
                                          onPressed: isEnabled ? (){
                                            addEvents();
                                            nameController.clear();
                                            descriptioncontroller.clear();
                                            Setdate = DateTime.now();
                                            toSetdate = DateTime.now();
                                            Navigator.pop(context);
                                          } : null,
                                          color: Colors.pinkAccent[100],
                                          textColor: Colors.white,
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Text('Add'),
                                        ),
                                      ),
                                    )
                            ),
                          ]
                      )
                    ],
                  ),
                );
              }));
        });
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    for (int j = 0; j < alleventsList.length; j++) {
      DateTime dateTime = alleventsList[j].dateTime;
      appointments.add(Appointment(
        id: alleventsList[j].id,
        startTime: alleventsList[j].dateTime,
        endTime: alleventsList[j].todateTime,
        subject: alleventsList[j].eventName,
        color: Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
        notes: alleventsList[j].eventDescription,
      ));
    }
    return _AppointmentDataSource(appointments);
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.header) {
    } else if (details.targetElement == CalendarElement.viewHeader) {
    } else if (details.targetElement == CalendarElement.calendarCell) {
      Setdate = new DateFormat('MMM dd, yyyy').parse(DateFormat("MMM dd, yyyy").format(details.date));
            dataBaseHelper.retrieveEvents(DateFormat("MMM dd, yyyy").format(Setdate)).then((value) => {
        setState(() {
          eventsList = value;
        }),
      });
      dataBaseHelper.retrieveAllData().then((value) => {
        setState(() {
          alleventsList = value;
        })
      });
    }if(details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda){
      for (int i = 0; i < details.appointments.length; i++) {
        final Appointment appointmentDetails = details.appointments[i];
        _id = appointmentDetails.id;
        _subjectText = appointmentDetails.subject;
        _notesText = appointmentDetails.notes;
        _dateText = DateFormat('MMMM dd, yyyy').format(appointmentDetails.startTime).toString();
        _startTimeText = DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
        _endTimeText = DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
        setState(() {
          updatenameController.text = _subjectText;
          updatedescriptioncontroller.text= _notesText;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Container(
                      child: new Text('$_subjectText',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),)),
                ),
                content: Container(
                  height: 300,
                  width: 400,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Column(children: [
                            Text('$_id',style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),)
                          ],),
                          Column(
                            children: <Widget>[
                              Text('$_notesText',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),),
                              Column(
                                children: [
                                  Text(
                                    '$_dateText',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('$_startTimeText : $_endTimeText',style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: (){
                      setState(() {});
                      return deleteTask();
                    },
                    child: new Text('Delete'),
                  ),
                  new FlatButton(onPressed: (){
                    setState(() {});
                    return updatePopup(context);
                  },
                    child: new Text('Update'),),
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text('close')),
                ],
              );
            });
      }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Container(
                    child: SfCalendar(
                      view: CalendarView.month,
                      onTap: calendarTapped,
                      dataSource: _getCalendarDataSource(),
                      monthViewSettings: MonthViewSettings(
                          showAgenda: true,
                          agendaViewHeight: 380,
                          agendaItemHeight: 70
                      ),
                      showDatePickerButton: true,
                    )),
              ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showPopup(context);
              },
              child: Icon(Icons.add),
            ),
          ));
    });
  }

  @override
  void initState() {
    super.initState();
    dataBaseHelper = DataBaseHelper();
    nameController = TextEditingController();
    descriptioncontroller = TextEditingController();
    updatenameController = TextEditingController();
    updatedescriptioncontroller = TextEditingController();
    Setdate = DateTime.now();
    toSetdate = DateTime.now();
  }
}
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
