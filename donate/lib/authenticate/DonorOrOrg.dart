import 'package:flutter/material.dart';
import 'package:fluttertest/authenticate/OrgRegister.dart';
import 'package:fluttertest/authenticate/donorRegister.dart';
import 'package:fluttertest/provider/userTypeProvider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
class DonorOrOrg extends StatefulWidget {
  String registerWith;
  final Function toggleView;
  DonorOrOrg({this.toggleView, this.registerWith});

  @override
  _DonorOrOrgState createState() => _DonorOrOrgState();
}

class _DonorOrOrgState extends State<DonorOrOrg> {
  int selectedButton = 0;
  bool isChecked = false;
  bool showError = false;
  List<bool> isSelected = List.generate(1, (_) => false);
  @override
  Widget build(BuildContext context) {
    final pUserType = Provider.of<PUserType>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: GestureDetector(
            onTap: () {
              widget.toggleView();
            },
            child: Icon(Icons.arrow_back)),
        title: Text('Choose Type'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedButton = 1;
                      showError = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedButton == 1 ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 1.5)),
                    height: 20,
                    width: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Donor',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedButton = 2;
                      showError = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedButton == 2 ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 1.5)),
                    height: 20,
                    width: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Organization',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            showError == true
                ? SizedBox(
                    height: 10,
                  )
                : SizedBox(),
            showError == true
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select an Option',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (selectedButton == 0) {
                      setState(() {
                        showError = true;
                      });
                    } else {
                      setState(() {
                        showError = false;
                      });
                      if (selectedButton == 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider.value(
                                          value: pUserType),
                                    ],
                                    child: DonorRegister(
                                        selectedButton: selectedButton,
                                        toggleView: widget.toggleView),
                                  )),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider.value(
                                          value: pUserType),
                                    ],
                                    child: OrgRegister(
                                      selectedButton: selectedButton,
                                      toggleView: widget.toggleView,
                                    ),
                                  )),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Submit User Type',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
