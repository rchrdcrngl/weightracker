import 'package:WeightTracker/components/ui_widgets.dart';
import 'package:flutter/material.dart';

import '../components/line_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String bmi = '--.-';
  String bmiDesc = 'No Data Available';
  String goalWeight = '--.-';
  String netWeight = '--.-';
  String peakWeight = '--.-';
  String troughWeight = '--.-';
  Icon trend = Icon(Icons.trending_up);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(title: 'Weight Overview'),
            // For list of weights
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80.0),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Container(
                                height: 200.0,
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    const Text('BMI'),
                                    Expanded(child: Center(child: Text(bmi, style: const TextStyle(fontFamily: 'FredokaOne', fontSize: 60.0),),)),
                                    Text(bmiDesc),
                                  ],
                                )),
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                                height: 200.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        title: Text('Goal Weight: $goalWeight'),
                                        leading: const Icon(Icons.monitor_weight_outlined),
                                      ),
                                      ListTile(
                                        title: Text('Net Weight: $netWeight'),
                                        leading: trend,
                                      ),
                                    ],
                                  ),
                                )
                            )
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      child: Container(
                        height: 250.0,
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const Text('Week Trend'),
                            const SizedBox(height: 10,),
                            Expanded(child: AspectRatio(aspectRatio:2, child: LNChart())),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        height: 220.0,
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Peaks and Troughs'),
                            const SizedBox(height: 5,),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient:  const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(240, 250, 252,1),
                                          Color.fromRGBO(232, 255, 232,1),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: circularContainer(bgcolor: Colors.green),
                                            child: const Icon(Icons.arrow_upward_rounded, color: Colors.white,),
                                        ),
                                        const SizedBox(height:5),
                                        Text('2022-09-8'),
                                        Text(peakWeight, style: const TextStyle(fontFamily: 'FredokaOne', fontSize: 60.0)),
                                      ],
                                    ),
                                  )),
                                  const SizedBox(width: 10.0,),
                                  Expanded(child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient:  const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(255, 241, 214,1),
                                          Color.fromRGBO(237, 250, 249,1),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: circularContainer(bgcolor: Colors.orange),
                                          child: const Icon(Icons.arrow_downward_rounded, color: Colors.white,),
                                        ),
                                        const SizedBox(height: 5,),
                                        Text('2022-09-8'),
                                        Text(peakWeight, style: const TextStyle(fontFamily: 'FredokaOne', fontSize: 60.0)),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        )),
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
