import 'package:WeightTracker/components/WeightDBHelper.dart';
import 'package:WeightTracker/components/WeightData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/const_colors.dart';
import '../components/ui_widgets.dart';

class EditWeight extends StatefulWidget {
  const EditWeight({Key? key, required this.id, required this.weight, required this.date, required this.refreshData}) : super(key: key);
  final int id;
  final double weight;
  final String date;
  final Future<Null> Function() refreshData;

  @override
  State<EditWeight> createState() => _EditWeightState();
}

class _EditWeightState extends State<EditWeight> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerDate =  TextEditingController();
  final TextEditingController controllerWeight = TextEditingController();
  final WeightDBHelper db = WeightDBHelper();
  final FocusNode weightFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  String lblWeight = 'Enter Weight';
  Color txtColor = green;
  Color shdColor = darkGreen;

  @override
  void initState(){
    controllerDate.text = widget.date;
    controllerWeight.text = widget.weight.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controllerDate.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<int> EditWeight() async {
    int success = -1;
    if(_formKey.currentState!.validate()){
      weightFocus.unfocus();
      db.updateWeight(widget.id, WeightData(weight: double.tryParse(controllerWeight.text), date: controllerDate.text)).then((value) => success = value);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Weight edited successfully"),
      ));
    }
    Navigator.pop(context);
    widget.refreshData();
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: /*Colors.transparent*/Color.fromRGBO(115, 57, 50,1),
      appBar: AppBar(title: header(title: 'Edit Weight'),),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white60,
                        boxShadow: [
                          BoxShadow(
                              color: shdColor,
                              blurRadius: 100,
                              spreadRadius: 5,
                              offset: const Offset(2,6)// Shadow position
                          ),
                        ],
                        //border: Border.all(color:Color.fromRGBO(255,255,255,450), width:3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            lblWeight,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'FredokaOne',
                              color: txtColor,
                            ),
                          ),
                          TextFormField(
                            controller: controllerWeight,
                            textAlign: TextAlign.center,
                            focusNode: weightFocus,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                              border: InputBorder.none,
                              hintText: '00.0',
                              hintStyle: TextStyle(color:shdColor),
                              errorStyle: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[1-9]\d*[,.]?[0-9]?')),
                              TextInputFormatter.withFunction(
                                    (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.replaceAll(',', '.'),
                                ),
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 100.0,
                              height: 1,
                              fontFamily: 'FredokaOne',
                              color: shdColor,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  txtColor = red;
                                  shdColor = Colors.red;
                                });
                                return '';
                              }
                              double? weight = double.tryParse(value);
                              if (weight == null){
                                setState(() {
                                  txtColor = Color.fromRGBO(255, 12, 12, 100);
                                  shdColor = Colors.red;
                                  lblWeight = 'Enter Valid Weight';
                                });
                                return '';
                              }
                              setState(() {
                                lblWeight = 'Enter Weight';
                                txtColor = green;
                                shdColor = darkGreen;
                              });
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Column(
                    children: [
                      const SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: TextFormField(
                            onTap: ()=>_selectDate(context),
                            textAlign: TextAlign.center,
                            controller: controllerDate,
                            readOnly: true,
                            style: TextStyle(
                              color: txtColor,
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefix: Icon(Icons.calendar_today, color: shdColor, size: 16,),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  txtColor = red;
                                  shdColor = Colors.red;
                                });
                                return null;
                              }
                              DateTime? date = DateTime.tryParse(value);
                              if (date == null){
                                return 'Please enter valid date in yyyy-mm-dd format';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton.icon(
                        onPressed: EditWeight,
                        style: ElevatedButton.styleFrom(
                          primary: darkGreen,
                          onPrimary: Colors.white,
                        ),
                        label: const Text('Edit Weight'),
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),),
                ],
              ),
            ),
          ),
        )
    );
  }
}
