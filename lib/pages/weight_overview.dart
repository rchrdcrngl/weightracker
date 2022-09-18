import 'package:WeightTracker/components/ui_widgets.dart';
import 'package:flutter/material.dart';

class WeightOverview extends StatelessWidget {
  const WeightOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(title: 'Weight History'),
            Expanded(
              child: SingleChildScrollView(
                padding:EdgeInsets.only(bottom: 80.0),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Colors.blue,
                      child: Container(
                          height: 200.0,
                          padding: EdgeInsets.all(15.0),
                          child: Text('text')),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Card(
                      color: Colors.green,
                      child: Container(
                          height: 200.0,
                          padding: EdgeInsets.all(15.0),
                          child: Text('text')),
                    ),
                    Card(
                      color: Colors.red,
                      child: Container(
                          height: 200.0,
                          padding: EdgeInsets.all(15.0),
                          child: Text('text')),
                    ),
                    Card(
                      color: Colors.green,
                      child: Container(
                          height: 200.0,
                          padding: EdgeInsets.all(15.0),
                          child: Text('text')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
