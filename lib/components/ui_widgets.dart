import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'BMIData.dart';

Widget header({required String title}){
  return Column(
    children: [
      const SizedBox(
        height: 20.0,
      ),
      Text(
        title,
        textAlign: TextAlign.start,
        style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
            fontSize: 18),
      ),
      const SizedBox(
        height: 20.0,
      ),
    ],
  );
}

Widget OutlineCard({Widget? child, Color outlineColor=Colors.black}){
  return Card(
    elevation: 0,
    color: Colors.transparent,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: outlineColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child:child,
  );
}

BoxDecoration circularContainer({Color bgcolor=Colors.white60, Color borderColor=Colors.transparent, double borderRadius=1.0, LinearGradient? gradient}){
  return BoxDecoration(
      shape: BoxShape.circle,
      color: bgcolor,
      border: Border.all(color: borderColor, width: borderRadius),
      gradient: gradient,
  );
}

BoxDecoration gradientBackground({required List<Color> gradientColors}){
  return BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors:gradientColors),
  );
}

Widget BMICard({required BMIData data}){
  Color cardColor = Colors.blueGrey;;
  Color txtColor = Colors.white;
  var bmi = data.bmi;
  if(bmi<18.5){
    cardColor = Colors.blueGrey;
    txtColor = Colors.white;
  } else if(bmi>=18.5 && bmi<25){
    cardColor = Colors.green;
    txtColor = Colors.white;
  }
  else if(bmi>=25 && bmi<30){
    cardColor = Colors.yellowAccent;
    txtColor = Colors.black;
  }
  else if(bmi>=30 && bmi<35){
    cardColor = Colors.orangeAccent;
    txtColor = Colors.black;
  }else if(bmi>=35){
    cardColor = Colors.redAccent;
    txtColor = Colors.white;
  }

  return Card(
    color: cardColor,
    child: Container(
        height: 200.0,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text('BMI', style: TextStyle(color: txtColor)),
            Expanded(child: Center(child: Text(data.bmi.toString(), style: TextStyle(fontFamily: 'FredokaOne', fontSize: 60.0, color: txtColor),),)),
            Text(data.description, style: TextStyle(color: txtColor)),
          ],
        )),
  );
}

List<TextInputFormatter> formatInput(){
  return <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[1-9]\d*[,.]?[0-9]?')),
    TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
        text: newValue.text.replaceAll(',', '.'),
      ),
    ),
  ];
}

