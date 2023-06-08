import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class booking_screen extends StatefulWidget {
  const booking_screen({Key? key}) : super(key: key);

  @override
  State<booking_screen> createState() => _booking_screenState();
}

class _booking_screenState extends State<booking_screen> {

  @override
  void initState() {
    getParkingModel();
    super.initState();
  }

  List<dynamic> parkingBoxList = [];
  int colNum = 0;
  bool isDataLoading = true;
  String fromDate = "";
  String toDate = "";

  getParkingModel() async {
    setState(() {
      isDataLoading = true;
    });
    final url =Uri.parse('https://script.google.com/macros/s/AKfycbyViwDqODHgk-5A4A4KsnnBdF4AsYpO-u8io5fRQSrBBjOP87DsAjVC7t7TYgSgHpU/exec');
    final response = await http.get(url);
    if(response.statusCode == 200){
      var json = jsonDecode(response.body);
      parkingBoxList = json['values'];
      colNum = json['columns'];
      print(parkingBoxList);
    }
    setState(() {
      isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      (isDataLoading == true)
          ?
      Container(
        height: MediaQuery.of(context).size.height - 70,
        width: double.infinity,
        child: Center(
          child: Container(
            width: 20,height: 20,child: CircularProgressIndicator(),
          ),
        ),
      )
      :
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: colNum, mainAxisExtent: 100, crossAxisSpacing: 10),
                itemCount: parkingBoxList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      onTabBottomSheet(context ,index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: (parkingBoxList[index]['value'] == "NB") ? Colors.green.shade100 : Colors.red.shade100,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 0.5,
                                blurRadius: 8)
                          ],
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (parkingBoxList[index]['value'] == "NB") ? Colors.green : Colors.red, // Set the border color here
                          width: 0.5, // Set the border width (optional)
                        ),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Center(
                        child: Text((parkingBoxList[index]['value'] == "NB") ? "${parkingBoxList[index]['boxId']}" : "Booked"),
                      ),
                    ),
                  );
                }),
          )
    ;
  }

  void onTabBottomSheet(BuildContext context , index) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Do you want to book this slot ?",style: TextStyle(fontWeight: FontWeight.w500),),
                  Row(
                    children: [
                      Text("Date : ",style: TextStyle(fontWeight: FontWeight.w500),),
                      Text("${DateFormat('dd MMMM yyyy').format(DateTime.now())}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Time : ",style: TextStyle(fontWeight: FontWeight.w500),),
                      InkWell(
                        onTap: () async {
                          final selectedTime = await showTimePickerDialog(context);
                          setState(() {
                            fromDate = selectedTime;
                          });
                        },
                        child: Text((fromDate == "") ? "From " : fromDate),
                      ),
                      InkWell(
                        onTap: () async {
                          final selectedTime = await showTimePickerDialog(context);
                          setState(() {
                            toDate = selectedTime;
                          });
                        },
                        child: Text((toDate == "") ? "  To " : toDate),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 15),
                    width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(child: Text("Book The Slot",style: TextStyle(color: Colors.white),))),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // showTimePicker(BuildContext context) async {
  //   final DateTime now = DateTime.now();
  //   final DateTime today = DateTime(now.year, now.month, now.day);
  //
  //   DateTime selectedTime = now;
  //
  //   await showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 300,
  //         child: CupertinoDatePicker(
  //           mode: CupertinoDatePickerMode.time,
  //           initialDateTime: now,
  //           minimumDate: today,
  //           maximumDate: today.add(Duration(days: 1)),
  //           onDateTimeChanged: (DateTime newDateTime) {
  //             selectedTime = newDateTime;
  //           },
  //         ),
  //       );
  //     },
  //   );
  //
  //   final formattedTime = DateFormat('h:mm a').format(selectedTime);
  //   print('Selected Time: $formattedTime');
  //   return formattedTime;
  // }

  Future<String> showTimePickerDialog(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    DateTime selectedTime = now;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time'),
          content: Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: now,
              minimumDate: today,
              maximumDate: today.add(Duration(days: 1)),
              onDateTimeChanged: (DateTime newDateTime) {
                selectedTime = newDateTime;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );

    final formattedTime = DateFormat('h:mm a').format(selectedTime);
    print('Selected Time: $formattedTime');
    return formattedTime;
  }

  void showToast(BuildContext context,message,bool isBottomsheet,Color color,int height) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        duration: Duration(seconds: 1),
        // margin: EdgeInsets.only(top: 100),
        // margin: EdgeInsets.only(bottom: isBottomsheet == true ? MediaQuery.of(context).size.height-height : 20,left: 10,right: 10),
        backgroundColor: color,
        content: Text(message,style: TextStyle(color: Colors.white),),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}
