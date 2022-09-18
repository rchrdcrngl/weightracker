import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({Key? key}) : super(key: key);

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String lblWeight = 'Enter Weight';
  final TextEditingController controllerDate = new TextEditingController();
  Color txtColor = Color.fromRGBO(53, 115, 79,1);
  Color shdColor = Color.fromRGBO(60, 97, 76,1);
  @override
  void initState(){
    controllerDate.text = selectedDate.toLocal().toString().split(' ')[0];
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

  void addWeight(){
    if(_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('VALID DATA')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: /*Colors.transparent*/Color.fromRGBO(115, 57, 50,1),
        body: Form(
          key: _formKey,
          child: Container(
            /*
            decoration: const BoxDecoration(
              gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [
                  Colors.white,
                  Color.fromRGBO(255,0,0,500),
                ],
              ),
            ),*/
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
                      color: /*Color.fromRGBO(204, 102, 92,1)*/ Colors.white60,
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
                          textAlign: TextAlign.center,
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
                                txtColor = Color.fromRGBO(255, 12, 12, 100);
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
                              txtColor = Color.fromRGBO(53, 115, 79,1);
                              shdColor = Color.fromRGBO(60, 97, 76,1);
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
                                txtColor = Color.fromRGBO(255, 12, 12, 100);
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
                      onPressed: addWeight,
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(60, 97, 76,1),
                        onPrimary: Colors.white,
                      ),
                      label: const Text('Add Weight'),
                      icon: const Icon(Icons.add_circle_outlined),
                    ),
                  ],
                ),),
              ],
            ),
          ),
        )
    );
  }
}
