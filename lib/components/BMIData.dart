import 'dart:math';

class BMIData{
  double bmi;
  String desc;

  BMIData({required this.bmi, required this.desc});
  
  factory BMIData.calculate({required double height, required double weight}){
    var _bmi = weight/pow(height, 2);
    return BMIData(bmi: double.tryParse((_bmi.toStringAsFixed(2)))!, desc: BMIData.getDesc(_bmi));
  }
  
  String get description => desc;

  static String getDesc(double bmi){
    String desc = '';
    if(bmi==null) return 'No Data Available';
    if(bmi==0) return 'No Data Available';
    if(bmi<18.5){
      desc = 'Underweight';
    } else if(bmi>=18.5 && bmi<25){
      desc = 'Normal Weight';
    }
    else if(bmi>=25 && bmi<30){
      desc = 'Overweight';
    }
    else if(bmi>=30 && bmi<35){
      desc = 'Obese';
    }else if(bmi>=35){
      desc = 'Morbidly Obese';
    } else{
      desc = 'No Data Available';
    }
    return desc;
  }
}