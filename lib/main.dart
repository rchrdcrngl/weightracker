import 'package:WeightTracker/pages/home.dart';
import 'package:WeightTracker/pages/settings.dart';
import 'package:WeightTracker/pages/weight_overview.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:WeightTracker/pages/add_weight.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            page: const WeightOverview(),
          ),
          FloatingNavBarItem(
            iconData: Icons.add,
            title: 'Add Weight',
            page: const AddWeight(),
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
