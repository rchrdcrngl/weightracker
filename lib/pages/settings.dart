import 'dart:convert';
import 'dart:io';
import 'package:WeightTracker/components/ui_widgets.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/WeightDBHelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:WeightTracker/components/WeightData.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final WeightDBHelper db = WeightDBHelper();
  List<bool> _selectedWeightColumn = [];
  List<bool> _selectedDateColumn = [];
  List<Widget> _columnValue = [];

  Future<void> _displayParseDialog({required List<String> rows}) async {
    for(String rw in rows){
      _columnValue.add(Text(rw));
      _selectedWeightColumn.add(false);
      _selectedDateColumn.add(false);
    }
    if(rows.length>=2){
      _selectedWeightColumn[0] = true;
      _selectedDateColumn[1] = true;
    }
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context,setState){
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(15.0),
                title: const Text('Select Data Mapping'),
                children: [
                  const Text('Weight Column Index: '),
                  const SizedBox(height: 5,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedWeightColumn.length; i++) {
                            print(_selectedWeightColumn[i]);
                            _selectedWeightColumn[i] = (i == index);
                            print(i == index);
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.purple[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.purple[200],
                      color: Colors.purple[400],
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _selectedWeightColumn,
                      children: _columnValue,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Text('Date Column Index: '),
                  const SizedBox(height: 5,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedDateColumn.length; i++) {
                            _selectedDateColumn[i] = (i == index);
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.blueGrey[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.blueGrey[200],
                      color: Colors.blueGrey[400],
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _selectedDateColumn,
                      children: _columnValue,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  SimpleDialogOption(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Map Data'),
                  ),
                ],
              );
            },
          );
        });
  }



  Future<void> openFile() async{
    int idxDate = 0;
    int idxWeight = 1;
    //Get path to CSV file
    String? filePath = r'/storage/emulated/0/';
    FilePickerResult? res = await FilePicker.platform.pickFiles(dialogTitle:'Select CSV file', type: FileType.custom, allowedExtensions: ['csv'],);
    if(res==null) return;
    filePath = res.files.single.path;
    //Read CSV file
    final input = File(filePath!).openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
    //Check if CSV has less than two fields
    if(fields.length<2) return;
    //Map CSV data to correct fields from DB
    await _displayParseDialog(rows: fields[0].map((e) => e.toString()).toList());
    //Find selected indices
    for(int i=0; i<fields[0].length; i++){
      if(_selectedWeightColumn[i]==true) idxWeight=i;
      if(_selectedDateColumn[i]==true) idxDate=i;
    }
    //Add data to DB
    print('${fields[0][idxDate]} - ${fields[0][idxWeight]}');
    try{
      for(int i=1; i<fields.length; i++){
        db.addWeight(WeightData(date: DateTime.tryParse(fields[i][idxDate])?.toLocal().toString(), weight:fields[i][idxWeight]));
      }
    } catch(e){
      print('error adding data');
    }
    _selectedDateColumn.clear();
    _selectedWeightColumn.clear();
    _columnValue.clear();
    print('finished inserting data');
  }

  void clearData() async {
    WeightDBHelper db = WeightDBHelper();
    db.clearData();
    print('Data Cleared');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(title: 'Settings'),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      ProfileForm(),
                      const SizedBox(height: 8,),
                      InkWell(
                        onTap: clearData,
                        child: Card(
                          child: Container(
                            width: 300,
                            height: 60,
                            padding: EdgeInsets.all(10),
                            child: Center(child: Text('Clear Data')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      InkWell(
                        onTap: openFile,
                        child: Card(
                          child: Container(
                            width: 300,
                            height: 60,
                            padding: EdgeInsets.all(10),
                            child: Center(child: Text('Import Data from CSV')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      InkWell(
                        //onTap: clearData,
                        child: Card(
                          child: Container(
                            width: 300,
                            height: 60,
                            padding: EdgeInsets.all(10),
                            child: Center(child: Text('Backup Data to CSV')),
                          ),
                        ),
                      ),
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


class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController controllerHeight = TextEditingController();
  final TextEditingController controllerGoal = TextEditingController();
  late SharedPreferences pref;
  String editSaveBtnName = 'Edit';
  Icon editSaveBtnIcon = const Icon(Icons.edit);
  bool editSaveBtnEnabled = false;

  void _editSave(){
    var height = controllerHeight.text;
    var goal = controllerGoal.text;

    if(editSaveBtnEnabled){
      //To edit
      if(height!=null&&goal!=null) saveData(height: double.parse(height), goal: double.parse(goal));
      setState(() {
        editSaveBtnName = 'Edit';
        editSaveBtnIcon = const Icon(Icons.edit);
        editSaveBtnEnabled = !editSaveBtnEnabled;
      });
    }else {
      //To Save
      setState(() {
        editSaveBtnName = 'Save';
        editSaveBtnIcon = const Icon(Icons.save);
        editSaveBtnEnabled = !editSaveBtnEnabled;
      });
    }
  }

  @override
  void initState() {
    loadData();
  }


  void saveData({required double height,required double goal}) async{
    pref = await SharedPreferences.getInstance();
    pref.setDouble('height', height);
    pref.setDouble('goal_weight', goal);
    print('$height - $goal');
  }

  void loadData() async {
    pref = await SharedPreferences.getInstance();
    var height = pref.getDouble('height')??0;
    var goal = pref.getDouble('goal_weight')??0;

    setState(() {
      controllerHeight.text = height.toStringAsFixed(2);
      controllerGoal.text = goal.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlineCard(
      outlineColor: Colors.purple,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: controllerHeight,
              readOnly: !editSaveBtnEnabled,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: 'Height: ',
                suffixText: 'm',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {}
                return null;
              },
            ),
            const SizedBox(height:8),
            TextFormField(
              controller: controllerGoal,
              readOnly: !editSaveBtnEnabled,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: 'Goal Weight: ',
                suffixText: 'kg',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {}
                return null;
              },
            ),
            const SizedBox(height:5),
            ElevatedButton.icon(
                onPressed: _editSave,
                label: Text(editSaveBtnName),
                icon: editSaveBtnIcon,
            ),
          ],
        ),
      )
    );
  }
}

