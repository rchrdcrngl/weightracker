
class WeightData{
  late double _weight;
  late String _date;

  WeightData({double? weight, String? date}){
    _weight = weight!;
    _date = date!;
  }
  double get weight => _weight;
  String get date => _date;
}