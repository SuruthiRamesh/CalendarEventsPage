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

class UpdateDiary extends StatefulWidget {
  int updateid,updatesync,updateshared,updatecolor;
  String updatedescription,updateimages,updatestyle,updatebackground,updateuuid,updatecreatetime,updatedatetime;
  UpdateDiary(this.updateid,this.updatedatetime,this.updatedescription,this.updatebackground,this.updatecolor,this.updatecreatetime,this.updateimages,this.updateshared,this.updatestyle,this.updatesync,this.updateuuid);
  @override
  _UpdateDiaryState createState() => _UpdateDiaryState();
}

class _UpdateDiaryState extends State<UpdateDiary> {
  List<Events> eventList = [];
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
  TextEditingController updatedescriptioncontroller = TextEditingController();
  TextEditingController updatedateController = TextEditingController();
  TextEditingController updatefontscontroller = TextEditingController();
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
  void updatesEvents(){
    dataBaseHelper.update(Events(
      id: widget.updateid,
      shared: widget.updateshared,
      sync: widget.updatesync,
      style: widget.updatestyle,
      images: widget.updateimages,
      uuid: widget.updateuuid,
      createdAt: DateFormat('MMMM dd, yyyy').parse(widget.updatecreatetime),
      eventdate: DateFormat('MMMM dd, yyyy').parse(widget.updatedatetime),
      Color: widget.updatecolor,
      Description: widget.updatedescription,
      Background: widget.updatebackground
    ));
  }
  @override
  void initState(){
    super.initState();
    dataBaseHelper = DataBaseHelper();
    updatedescriptioncontroller = TextEditingController();
    updatedateController = TextEditingController();
    updatefontscontroller = TextEditingController();
    setState(() {
      updatefontscontroller.text = widget.updatestyle;
      updatedescriptioncontroller.text = widget.updatedescription;
      updatedateController.text = widget.updatedatetime;
    });
    colorcode = widget.updatecolor;
    _color = Color(widget.updatecolor);
    creation = DateTime.now();
    datetobeset = DateTime.now();
    imgPicker = ImagePicker();
    updatedateController.text = widget.updatedatetime;
    updatefontscontroller.text = widget.updatestyle;
    _storedImage = File(widget.updateimages);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:const Icon(Icons.arrow_back,color: Colors.indigo,size: 30),onPressed: (){
          Navigator.pop(context);
        },),
        title: Text('Update',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                              onChanged: (value){
                                widget.updatedescription = value;
                              },
                              controller: updatedescriptioncontroller,
                              maxLines: 20,
                              style: TextStyle(color: Color(widget.updatecolor),fontWeight: FontWeight.w400,fontFamily: widget.updatestyle,fontSize: 20),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: DecorationImage(fit: BoxFit.cover,
                                  image: AssetImage(widget.updatebackground),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.black
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Time & Date',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          TextField(
                            onChanged: (value){
                              widget.updatedatetime = value;
                            },
                              showCursor: false,
                              readOnly: true,
                              onTap: () => _selectDate(),
                              controller: updatedateController,
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
                                    widget.updatecolor = _color.value;
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
                                initialColor: Color(widget.updatecolor)),
                          ),
                          const SizedBox(height: 20),
                          const Text('Fonts',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),),
                          Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                    readOnly: true,
                                    controller: updatefontscontroller,
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
                                      widget.updatestyle = value;
                                    },
                                  )),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down,color: Colors.grey),
                                onSelected: (String value) {
                                  widget.updatestyle = value;
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
                                      updatefontscontroller.text ="Auto";
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
                                          widget.updatebackground = "assets/background1.jpg";
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
                                          widget.updatebackground = "assets/background2.jpg";
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
                                          widget.updatebackground = "assets/background3.png";
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
                                    'Update',
                                    style: TextStyle(color: Colors.white,fontSize: 20.0),),onPressed: (){
                                    updatesEvents();
                                    _savetofile();
                                    refreshList();
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context)=> ListPage()),
                                    );
                                  }),
                                ),
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
                  initialDateTime: DateFormat('MMMM dd, yyyy').parse(widget.updatedatetime),
                  maximumDate: DateTime.now(),
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
        widget.updatedatetime = DateFormat('MMMM dd, yyyy').format(pickedDate);
        updatedateController.text = DateFormat('MMMM dd, yyyy').format(pickedDate).toString();
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
  Future<void> refreshList() async {
    List<Events> x = await DataBaseHelper().getList();
    setState(() {
      eventList = x;
    });
  }
}
