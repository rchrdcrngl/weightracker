import 'package:WeightTracker/components/WeightDBHelper.dart';
import 'package:WeightTracker/components/WeightData.dart';
import 'package:WeightTracker/components/ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/line_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeightDBHelper db = WeightDBHelper();
  late SharedPreferences pref;
  String bmiDesc = 'No Data Available';
  double? height = 0.0;
  double? goalWeight = 0.0;
  double? netWeight = 0.0;
  Icon trend = Icon(Icons.trending_up);
  WeightData latest = WeightData();
  WeightData peak = WeightData();
  WeightData trough = WeightData();
  List<WeightData> weekTrend = [];


  @override
  void initState(){
    getCachedData();
    loadData();
    super.initState();
  }

  Future<Null> loadData() async{
    print('load data');
    await db.fetchLatestWeight().then((value) {
      if(mounted){
        setState(() {
          latest = value;
          netWeight = (latest.getWeight - goalWeight!);
        });
      }}
    );
    await db.fetchPeakWeight().then((value) {
      if(mounted) {
        setState(() {
          peak = value;
        });
      }}
    );
    await db.fetchTroughWeight().then((value) {
      if(mounted){
        setState(() {
          trough = value;
        });
      }
      }
    );
    await db.fetchWeekWeights().then((value){
      if(mounted){
        setState(() {
          weekTrend = value;
        });
      }
    }
  );
  return null;
}

  void getCachedData()async{
    pref = await SharedPreferences.getInstance();
    height = pref.getDouble('height') ?? 1;
    goalWeight = pref.getDouble('goal_weight')??0;
  }


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
              child: RefreshIndicator(
                onRefresh: loadData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: BMICard(data: latest.getBMI(height: height??1)),
                          ),
                          Expanded(
                              child: SizedBox(
                                  height: 200.0,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          title: Text('Height: $height'),
                                          leading: const Icon(Icons.height),
                                        ),
                                        ListTile(
                                          title: Text('Goal Weight: ${goalWeight??'--.-'}'),
                                          leading: const Icon(Icons.monitor_weight_outlined),
                                        ),
                                        ListTile(
                                          title: Text('Net Weight: ${netWeight?.toStringAsFixed(2)}'),
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
                              Expanded(child: WeightLineChart(chartName: 'Week Trend', data: weekTrend)),
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
                                          Text(peak.getDate),
                                          Text(peak.getWeight.toString(), style: const TextStyle(fontFamily: 'FredokaOne', fontSize: 60.0)),
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
                                          Text(trough.getDate),
                                          Text(trough.getWeight.toString(), style: const TextStyle(fontFamily: 'FredokaOne', fontSize: 60.0)),
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
            ),
          ],
        ),
      ),
    );
  }
}
