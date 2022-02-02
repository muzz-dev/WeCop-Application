import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class Demo extends StatefulWidget{
  @override
  DemoState createState()=> DemoState();

}

class DemoState extends State<Demo>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InkWell(
          onTap: () async{

              final List<DateTime> picked = await DateRangePicker.showDatePicker(
                  context: context,
                  initialFirstDate: new DateTime.now(),
                  initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
                  firstDate: new DateTime(2015),
                  lastDate: new DateTime(DateTime.now().year + 2));
              if (picked != null && picked.length == 2) {
                print(picked.last);
              }
          },
          child: Container(
            height: 50,
            width: 250,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

}