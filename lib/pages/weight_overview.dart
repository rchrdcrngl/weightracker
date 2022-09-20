import 'package:WeightTracker/components/ui_widgets.dart';
import 'package:WeightTracker/pages/edit_weight.dart';
import 'package:flutter/material.dart';
import '../components/WeightDBHelper.dart';
import '../components/WeightData.dart';
import '../components/line_chart.dart';


class WeightHistory extends StatefulWidget {
  const WeightHistory({Key? key}) : super(key: key);

  @override
  State<WeightHistory> createState() => _WeightHistoryState();
}

class _WeightHistoryState extends State<WeightHistory> {
  final WeightDBHelper db = WeightDBHelper();
  List<WeightData> data = [];

  @override
  void initState(){
    loadData();
    super.initState();
  }

  Future<Null> loadData() async {
    print('load_data');
    db.fetchAllWeights().then((value) {
      if(mounted){
        setState(() {
          data = value;
        });
      }
    });
    return null;
  }

  void deleteWeight({required int id}) async {
    db.deleteWeight(id);
    print('Data deleted');
    setState(() {
      loadData();
    });
  }

  List<Widget> weight_list(){
    List<Widget> list = [];
    for(WeightData wd in data){
      list.add(InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditWeight(id: wd.id!, weight: wd.getWeight, date: wd.getDate)),
          );
        },
        child: Card(
          child: Container(
            width: double.infinity,
              child: ListTile(
                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: ()=>deleteWeight(id:wd.id!),),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(wd.getWeight.toString(), style: const TextStyle(fontFamily: 'FredokaOne'),),
                    Text(wd.getDate, style: const TextStyle(fontSize: 13),),
                  ],
                ),
              ),
          ),
        ),
      ));
      list.add(const SizedBox(height: 5,));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(title: 'Weight History'),
            Container(
              height: 250.0,
              child: WeightLineChart(data: data, chartName: 'Weight History'),
            ),
            const SizedBox(height: 15.0,),
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  scrollDirection: Axis.vertical,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: weight_list(),
                    ),
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
