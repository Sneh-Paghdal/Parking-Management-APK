import 'package:flutter/material.dart';
import 'package:parkingapk/screens/booking_screen.dart';
import 'package:parkingapk/screens/ev_screen.dart';
import 'package:parkingapk/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/Myhome_page': (context) => MyHomePage(selectedIndex: 0),
        '/map_screen': (context) => map_screen(),
        '/booking_screen': (context) => booking_screen(),
        '/ev_screen': (context) => ev_screen(),
      },
      home: MyHomePage(selectedIndex: 0,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  int selectedIndex = 0;
  MyHomePage({super.key, required this.selectedIndex});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> _widgetOptions = [
    map_screen(),
    booking_screen(),
    ev_screen()
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Parking Management",style: TextStyle(color: Colors.white),),
      ),
        bottomNavigationBar: Container(
          height: 70,
          child: BottomNavigationBar(
            backgroundColor: Color(0x24E6FFFFFF),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            // currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "Map",
              ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book_outlined),
                  label: "Booking",
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.ev_station_outlined),
                label: "EV",
              ),
            ],
            currentIndex: widget.selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _widgetOptions.elementAt(widget.selectedIndex),
          ],
        ),
      )
    );
  }
}
