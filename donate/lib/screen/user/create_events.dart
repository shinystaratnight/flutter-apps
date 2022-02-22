import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userHome.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key key}) : super(key: key);

  @override
  _CreateEventsState createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final _firestore = FirebaseFirestore.instance;
  String dropdownValue = 'Select';
  String name = '';
  String description = '';
  int goal = 0;
  bool isSwitched = false;
  String urgentStatus = '';
  String dateRange = '';
  DateRangePickerController _datePickerController = DateRangePickerController();
  String value = '';
  final dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // final nameController = TextEditingController();
  // final numController = TextEditingController();

  @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   nameController.dispose();
  //   numController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Form(
            key: _formKey,
            child: Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                    }
                    return null;
                    },
                    decoration: const InputDecoration(
                    icon: Icon(Icons.event),
                    hintText: 'Enter Event\'s name'),
                    onChanged: (value) {
                    name = value;
                    },
                    // controller: nameController,
                    ),
                    ),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
            if (value == null || value.isEmpty) {
            return 'Please enter some text';
            }
            return null;
            },
              decoration: const InputDecoration(
                  icon: Icon(Icons.text_fields),
                  hintText: 'Enter Event\'s Description'),
              onChanged: (value) {
                description = value;
              },
            // controller: nameController,
            ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range_outlined),
                    hintText: 'Pick your Date'
                ),
                onTap: () async {
                  var date =  await showDateRangePicker(
                      context: context,
                      currentDate:DateTime.now(),
                      firstDate:DateTime(1900),
                      lastDate: DateTime(2100));
                  dateController.text = date.toString();
                },

                // controller: nameController,
              ),
            ),

              Row(
                children: [
                  SizedBox(width: 20.0,),
                  Text("Toggle for urgency status"),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Switch(value: isSwitched, onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        isSwitched = value;
                        getUrgentStatus(isSwitched);

                      });
                      if (isSwitched == true) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Warning'),
                              content: const Text('Admin approval is required after submission'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                        Container(child: const Text(
                            'Create event', textAlign: TextAlign.right));
                        print("Hi");
                      }
                      else {
                        Container(child: const Text(
                            'Non-urgent event', textAlign: TextAlign.right));
                      }
                    },),
                  ),
                  SizedBox(width: 10.0,),
                  Container(child: Text(getUrgentStatus(urgentStatus)),)
                ],
              ),

                Row(
                  children: [
                    SizedBox(width: 20.0,),
                    Text("Select Event Category"),
                    SizedBox(width: 10.0,),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        'Select',
                        'Religion',
                        'Well Drilling',
                        'Treat a patient',
                        'Food'
                      ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState.validate()) {
                      // Changed Test1 to Events by Joyshree
                      _firestore.collection('Events').add({
                        'name': name,
                        'description': description,
                        'goal': goal,
                        'urgent': isSwitched,
                        'category': dropdownValue,
                        'date': dateController.text,
                        'status':false
                      });
                      _showToast(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                  child:const Text('Submit'),
                ),
              ),

              ],
            ),
            ),

            );
          }
      ),
    );


  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
    // print(value);
    // dateRange = args.toString();ca
    // print(args.value);
  }
  String getUrgentStatus (isSwitched) {
    if (isSwitched == true) {
      urgentStatus = "Urgent Event";
    }
    if (isSwitched == false) {
      urgentStatus = "non-Urgent event";
    }
    return urgentStatus;
  }
}
void _showToast(BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.red,
      content: const Text('Submitted Successfully'),
      action: SnackBarAction(
        label: 'hide',
        textColor: Colors.black,
        onPressed:scaffold.hideCurrentSnackBar,
      ),
    ),
  );
}



// import 'package:donaid_prototype_1/normal_events.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class MyCustomForm extends StatefulWidget {
//   const MyCustomForm({Key? key}) : super(key: key);
//
//   @override
//   _MyCustomFormState createState() => _MyCustomFormState();
// }
//
// class _MyCustomFormState extends State<MyCustomForm> {
//   // Create a text controller and use it to retrieve the current value
//   // of the TextField.
//   final myController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: Text('my donations'),
//           bottom: TabBar(
//             onTap: (index) {
//               print(index);
//             },
//             tabs: [
//               Tab(
//                 text: "organizations",
//               ),
//               Tab(
//                 text: "individuals",
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: myController,
//                     ),
//                   Text(myController.text),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
//
// //       ),
// //       body: Row(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         mainAxisSize: MainAxisSize.max,
// //         children: [
// //           Expanded(
// //             child: Column(children: [
// //
// //               ElevatedButton(
// //                   onPressed: () {  },
// //               child:
// //               Text('1st')),
// //             ],),
// //           ),
// //           // Expanded(
// //           //   child: ElevatedButton(onPressed: () {
// //           //     Navigator.push(
// //           //       context,
// //           //       MaterialPageRoute(
// //           //           builder: (context) => const NormalEvents()),
// //           //     );
// //           //   },
// //           //       child:
// //           //       Text('2nd')),
// //           // ),
// //
// //         ],
// //
// //         // child: ElevatedButton(
// //         //   onPressed: () {
// //         //     Navigator.pop(context);
// //         //   },
// //         //   child: const Text('Go back!'),
// //         // ),
// //       ),
// //     );
// //   }
// // }
