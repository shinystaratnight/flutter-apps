
// import '../../Users/Anas/Desktop/donaid/DONAID_v3/lib/screen/user/createbeneficiary.dart';


// class OrganizationBeneficiaries extends StatelessWidget {
//   const OrganizationBeneficiaries ({Key key}) : super(key: key);

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class OrganizationBeneficiaries extends StatefulWidget {
  const OrganizationBeneficiaries({Key key}) : super(key: key);

  @override
  _OrganizationBeneficiaries createState() => _OrganizationBeneficiaries();
}

class _OrganizationBeneficiaries extends State<OrganizationBeneficiaries> {
  var _fireStore = FirebaseFirestore.instance;
  String name = '';
  String number = '';
  String description = '';
  String address = '';
  List<Beneficiary> beneficiaries = [];
  List<Categories> categories = [];
  String dropdownValue = 'Select';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getBeneficiaries();
    getCatagories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Tabbar controller
      length: 2, // tabs count of tabbar
      child: Scaffold(
        appBar: AppBar(
          // Appbar
          backgroundColor: Colors.red,
          title: Text('Organization information'),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              // tab names
              Tab(
                text: "Beneficiary",
              ),
              Tab(
                text: "Create Beneficiary",
              ),
            ],
          ),
        ),
        body: TabBarView(
          // to show contents tabbar view
          children: [
            _beneficiaryBody(),
            _createBeneficiary(),
          ],
        ),
      ),
    );
  }

  _beneficiaryBody() {
    return ListView.builder(
      itemCount: beneficiaries.length,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text('Name: ${beneficiaries[index].name}'),
                SizedBox(height: 8),
                Text('Description: ${beneficiaries[index].description}'),
                SizedBox(height: 8),
                // Text('Number: ${beneficiaries[index].number}'),
                // SizedBox(height: 8),
                // Text('address: ${beneficiaries[index].address}'),
              ],
            ),
          ),
        );
      },
    );
  }

  _createBeneficiary() {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        return Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person_outlined),
                        hintText: 'Enter Beneficiary name'),
                        onChanged: (value) {
                        name = value;
                      },
                      // controller: nameController,
                    ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.text_fields_outlined),
                        hintText: 'Enter Beneficiary Description'),
                        onChanged: (value) {
                          description = value;
                    },
                    // controller: numController,
                  ),
                ),
                Row(
                  children: [
                      SizedBox(width: 20.0,),
                      Text("Select Category", style: TextStyle(fontWeight: FontWeight.bold),),
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
                        items: <String>['Select', 'Religion', 'Well Drilling', 'Treat a patient', 'Food']
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
                        _fireStore.collection('beneficiary').add({'name': name, 'description': description, 'category': dropdownValue});
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        _showToast(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
  getBeneficiaries() async {
    var ret = await _fireStore.collection('beneficiary').get();
    ret.docs.forEach((element) {
      Beneficiary bf = Beneficiary(
        name: element.data()['name'],
        description: element.data()['description'],
      );
      beneficiaries.add(bf);
    });

    setState(() {});
  }

  getCatagories() async {
    var ret = await _fireStore.collection('EventCategory').get();
    ret.docs.forEach((element) {
      Categories ce = Categories(
          name: element.data()['name'],
          id  : element.data()['ID']
      );
      categories.add(ce);
    });

    setState(() {});
  }
}

class Categories {
  String name;
  int id;

  Categories({this.name, this.id});
}

class Beneficiary {
  String description;
  String name;
  String number;
  String address;

  Beneficiary({this.description, this.name, this.number, this.address});
}
