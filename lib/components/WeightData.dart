import 'BMIData.dart';
import 'package:intl/intl.dart';

class WeightData{
  final int? id;
  final double? weight;
  final String? date;

  WeightData({this.id, this.weight, this.date});

  double get getWeight => weight??0;
  String get getDate => DateFormat('yyyy-MM-dd').format(getDateTime()).toString();

  DateTime getDateTime() {
    return date!=null? DateTime.parse(date!): DateTime.now();
  }

  BMIData getBMI({required double height}){
    return BMIData.calculate(height: height, weight: weight??0);
  }

  factory WeightData.fromMap(Map<String, dynamic> map){
    return WeightData(id: map['id'], weight: map['weight'], date: map['date']);
  }

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id" : id,
      "weight" : weight,
      "date" : date,
    };
  }

  Map<String,dynamic> toUpdateMap(){
    return <String,dynamic>{
      "weight" : weight,
      "date" : date,
    };
  }
}