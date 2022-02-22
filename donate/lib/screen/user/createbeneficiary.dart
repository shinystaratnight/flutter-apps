// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'userHome.dart';
//
// class CreateBeneficiary extends StatefulWidget {
//   const CreateBeneficiary({Key key}) : super(key: key);
//
//   @override
//   _CreateBeneficiaryState createState() => _CreateBeneficiaryState();
// }
//
// class _CreateBeneficiaryState extends State<CreateBeneficiary> {
//   final _fireStore = FirebaseFirestore.instance;
//   List<Beneficiary> beneficiaries = [];
//   String name = '';
//   String number = '';
//   String email = '';
//   String address = '';
//   // final nameController = TextEditingController();
//   // final numController = TextEditingController();
//
//   @override
//   // void dispose() {
//   //   // Clean up the controller when the widget is disposed.
//   //   nameController.dispose();
//   //   numController.dispose();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Create Beneficiary'),
//           backgroundColor: Colors.red,
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       icon: Icon(Icons.people),
//                       hintText: 'Enter Beneficiary name'),
//                   onChanged: (value) {
//                     name = value;
//                   },
//                   // controller: nameController,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       icon: Icon(Icons.phone),
//                       hintText: 'Enter Beneficiary Phone Number'),
//                   onChanged: (value) {
//                     number = value;
//                   },
//                   // controller: numController,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       icon: Icon(Icons.email),
//                       hintText: 'Enter Beneficiary Email'),
//                   onChanged: (value) {
//                     email = value;
//                   },
//                   // controller: numController,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       icon: Icon(Icons.location_city),
//                       hintText: 'Enter Beneficiary Address'),
//                   onChanged: (value) {
//                     address = value;
//                   },
//                   // controller: numController,
//                 ),
//               ),
//               RaisedButton(
//                   color: Colors.pinkAccent,
//                   child: const Text("Save to Database"),
//                   onPressed: () {
//                     _fireStore.collection('beneficiary').add({'name': name, 'number': number, 'email': email, 'address': address});
//
//                     //call method flutter upload
//                   })
//             ],
//           ),
//         ),
//         drawer: const OrganizationDrawer());
//   }
//
//   getBeneficiaries() async {
//     var ret = await _fireStore.collection('beneficiary').get();
//     ret.docs.forEach((element) {
//       Beneficiary bf = Beneficiary(
//         name: element.data()['name'],
//         email: element.data()['email'],
//         number: element.data()['number'],
//         address: element.data()['address'],
//       );
//       beneficiaries.add(bf);
//     });
//
//     setState(() {});
//   }
// }
//
// class Beneficiary {
//   String email;
//   String name;
//   String number;
//   String address;
//
//   Beneficiary({this.email, this.name, this.number, this.address});
// }