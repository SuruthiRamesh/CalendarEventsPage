//@dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'package:formspage/Color_Picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:formspage/Helper/DatabaseHelper.dart';
import 'package:formspage/models/Event.dart';
import 'package:formspage/Screens/ListPage.dart';

class MyDiary extends StatefulWidget {
  final Events events;

  // ignore: use_key_in_widget_constructors
  const MyDiary({this.events});
  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  DataBaseHelper dataBaseHelper;
  File _storedImage;
  File tempImage;
  String downloadpaths ='';
  String downloadfoldername ='';
  File imgFile;
  var openfileextension;
  var openimage;
  var imgPicker;
  // ignore: non_constant_identifier_names
  String pic = "assets/background1.jpg";
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController fontscontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Color _color;
  int colorcode;
  String fontName;
  String imageused;
  var items = ['Cursive', 'Fantasy', 'Auto','Cancel'];
  var uuid = Uuid().v4();
  var shared = 0;
  var sync =1;
  DateTime creation;
  DateTime datetobeset;
  bool loading = false,editmode = false;
  @override
  void initState() {
    super.initState();
    descriptioncontroller =TextEditingController();
    dateController = TextEditingController();
    fontscontroller = TextEditingController();
    creation = DateTime.now();
    datetobeset = DateTime.now();
    imgPicker = ImagePicker();
    dateController.text = DateFormat('MMM dd yyyy').format(datetobeset).toString();
    fontscontroller.text = 'Auto';
    if (widget.events.id != null){
      editmode = true;
      descriptioncontroller.text = widget.events.Description;
      fontscontroller.text = widget.events.style;
      colorcode = widget.events.Color;
      pic = widget.events.Background;
      uuid = widget.events.uuid;
      imageused = widget.events.images;
      shared = widget.events.shared;
      sync = widget.events.sync;
      creation =widget.events.createdAt;
      datetobeset = widget.events.eventdate;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:const Icon(Icons.arrow_back,color: Colors.indigo,size: 30),onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(
            builder: (_) =>ListPage(),
          ),
          );
        },),
        title: Text(editmode ? 'EDIT' : 'ADD',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
        child: Stack(
            children: [
              ListView(
                  children: [
                    Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30,),
                          const Text("Content",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          const SizedBox(height: 20,),
                          Container(
                            height: 180,
                            width: 380,
                            child: TextField(
                              controller: descriptioncontroller,
                              maxLines: 20,
                              style: TextStyle(color: _color,fontWeight: FontWeight.w400,fontFamily: fontName,fontSize: 20),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: DecorationImage(fit: BoxFit.cover,
                                  image: AssetImage(pic),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.black
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Time & Date',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          TextField(
                              showCursor: false,
                              readOnly: true,
                              onTap: () => _selectDate(),
                              controller: dateController,
                              style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              )
                          ),
                          const SizedBox(height: 20),
                          const Text('Text Color',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 30,
                            child: MyColorPicker(
                                onSelectColor: (values) {
                                  setState(() {
                                    _color = values;
                                    print(_color);
                                    colorcode = _color.value;
                                    print(colorcode);
                                  });
                                },
                                availableColors: [
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF673AB7),
                                  Color(0xFF76FF03),
                                  Color(0xFFFF9800),
                                  Color(0xFFD50000),
                                  Color(0xFF000000),
                                  Color(0xFF616161),
                                  Color(0xFFCFD8DC),
                                ],
                                initialColor: Color(0xFF1976D2)),
                          ),
                          const SizedBox(height: 20),
                          const Text('Fonts',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    controller: fontscontroller,
                                    style:const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    onChanged: (value){
                                      fontscontroller.text = value;
                                    },
                                  )),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down,color: Colors.grey),
                                onSelected: (String value) {
                                  fontscontroller.text = value;
                                  if(value == "Cursive"){
                                    setState(() {
                                      fontName = "CedarvilleCursive";
                                    });
                                  }
                                  else if(value == "Fantasy"){
                                    setState(() {
                                      fontName = "Oswald";
                                    });
                                  }
                                  else if(value == "Auto"){
                                    setState(() {
                                      fontName ="Roboto";
                                    });
                                  }
                                  else if(value == "Cancel"){
                                    setState(() {
                                      fontscontroller.text ="Auto";
                                      fontName = "";
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return items.map<PopupMenuItem<String>>((String value) {
                                    return  PopupMenuItem(child: Text(value), value: value);
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text('Page Texture',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          const SizedBox(height:10),
                          SizedBox(
                            height: 80,
                            width: 600,
                            child: ListView(
                              padding: const EdgeInsets.fromLTRB(2, 2, 2,2),
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: TextButton(
                                      onPressed: (){
                                        setState(() {
                                          pic = "assets/background1.jpg";
                                        });
                                      },
                                      child: Image.asset("assets/background1.jpg")),
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: TextButton(
                                      onPressed: (){
                                        setState(() {
                                          pic = "assets/background2.jpg";
                                        });
                                      },
                                      child: Image.asset("assets/background2.jpg")),
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: TextButton(
                                      onPressed: (){
                                        setState(() {
                                          pic = "assets/background3.png";
                                        });
                                      },
                                      child: Image.asset("assets/background3.png")),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Images',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          SizedBox(height: 10,),
                          SizedBox(
                            child: _storedImage != null
                                ? Image.file(
                              _storedImage,
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.fitHeight,
                            )
                                : Container(
                              child: IconButton(onPressed:(){
                                _takePicture();
                              },
                                  icon: Icon(Icons.add)),
                              decoration: BoxDecoration(
                                  color: Colors.grey),
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(height:20),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 60.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: TextButton(child: Text(
                                    editmode ? 'Update' : 'Add',
                                    style: TextStyle(color: Colors.white,fontSize: 20.0),),onPressed: (){
                                    add();
                                    _savetofile();
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (_) =>ListPage(),
                                    ),
                                    );
                                  }),
                                ),
                                editmode ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 60.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: TextButton(child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white,fontSize: 20.0),),onPressed: (){
                                    delete();
                                  }),
                                ) : SizedBox.shrink(),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ])
            ]
        ),
      ),
    );
  }
  _selectDate() async {
    DateTime pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = DateTime.now();
        return SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text('Done'),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedDate);
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != datetobeset) {
      setState(() {
        datetobeset = pickedDate;
        dateController.text = DateFormat('MMM dd yyyy').format(datetobeset).toString();
      });
    }
  }
  Future<void> _takePicture() async {
    XFile imageFile = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      openfileextension = path.extension(imageFile.path);
      _storedImage = File(imageFile.path);
      _savetofile();
    });
  }
  Future<void> _savetofile() async {
    DateTime datename = DateTime.now();
    String filename = DateFormat("yyyy-MM-dd-HHmmss").format(datename);
    const folderName = "Dairy";
    final Directory saveddirectory = await getApplicationDocumentsDirectory();
    print(saveddirectory);
    final String savedirpath = saveddirectory.path;
    final temppath = Directory('$savedirpath/$folderName');
    print(temppath);
    if((await temppath.exists())){
    }else{
      temppath.create();
    }
    final savedImage = await File(_storedImage.path).copy('${temppath.path}/$filename$openfileextension');
    imageused = savedImage.path;
    print("$imageused");
  }
  Future<void> add()async{
    DateTime creation = DateTime.now();
    if (descriptioncontroller != null) {
      widget.events.Description= descriptioncontroller.text;
      widget.events.style = fontscontroller.text;
      widget.events.Background = pic;
      widget.events.images = imageused;
      widget.events.createdAt = creation;
      widget.events.eventdate = datetobeset;
      widget.events.Color = colorcode;
      widget.events.uuid = uuid;
      widget.events.shared = shared;
      widget.events.sync = sync;
      if (editmode) await DataBaseHelper().update(widget.events);
      else await DataBaseHelper().Insert(widget.events);
    }
    Navigator.pop(context);
    setState(() => loading = false);
  }
  Future<void> delete() async{
    DataBaseHelper().delete(widget.events);
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }
}