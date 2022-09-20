import 'package:WeightTracker/pages/home.dart';
import 'package:WeightTracker/pages/settings.dart';
import 'package:WeightTracker/pages/weight_overview.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:WeightTracker/pages/add_weight.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MainApp());
  });
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  void changeIndex({required int index}){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: FloatingNavBar(
        resizeToAvoidBottomInset: false,
        index: _selectedIndex,
        color: Colors.green,
        items: [
          FloatingNavBarItem(
            iconData: Icons.home,
            title: 'Home',
            page: HomePage(),
          ),
          FloatingNavBarItem(
            iconData: Icons.line_weight_sharp,
            title: 'Weight History',
            page: WeightHistory(),
          ),
          FloatingNavBarItem(
            iconData: Icons.add,
            title: 'Add Weight',
            page: AddWeight(goToPage: changeIndex,),
          ),
          FloatingNavBarItem(
            iconData: Icons.settings,
            title: 'Settings',
            page: const SettingsPage(),
          ),
        ],
        selectedIconColor: Colors.white,
        hapticFeedback: true,
        horizontalPadding: 40,
      ),
    );
  }
}
