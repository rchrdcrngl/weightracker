import 'package:flutter/material.dart';

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