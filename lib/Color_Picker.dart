//@dart=2.9
import 'package:flutter/material.dart';

class MyColorPicker extends StatefulWidget {
  final Function onSelectColor;
  final List<Color> availableColors;
  final Color initialColor;
  final bool circleItem;

  // ignore: use_key_in_widget_constructors
  const MyColorPicker(
      {@required this.onSelectColor,
        @required this.availableColors,
        @required this.initialColor,
        this.circleItem = true});

  @override
  _MyColorPickerState createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  // This variable used to determine where the checkmark will be
  Color _pickedColor;

  @override
  void initState() {
    _pickedColor = widget.initialColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 40,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 0.09,
            mainAxisSpacing: 5),
        itemCount: widget.availableColors.length,
        itemBuilder: (context, index) {
          final itemColor = widget.availableColors[index];
          return InkWell(
            onTap: () {
              widget.onSelectColor(itemColor);
              setState(() {
                _pickedColor = itemColor;
              });
            },
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                  color: itemColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 9,color: Colors.white)),
              child: itemColor == _pickedColor
                  ? const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              )
                  : Container(),
            ),
          );
        },
      ),
    );
  }
}