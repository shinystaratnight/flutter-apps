
// import '../../Users/member-organization/Desktop/donaid/DONAID_v3/lib/screen/user/createbeneficiary.dart';


// class OrganizationBeneficiaries extends StatelessWidget {
//   const OrganizationBeneficiaries ({Key key}) : super(key: key);

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class UnverifiedOrganizationBeneficiaries extends StatefulWidget {
  const UnverifiedOrganizationBeneficiaries({Key key}) : super(key: key);

  @override
  _UnverifiedOrganizationBeneficiaries createState() => _UnverifiedOrganizationBeneficiaries();
}

class _UnverifiedOrganizationBeneficiaries extends State<UnverifiedOrganizationBeneficiaries> {
  var _fireStore = FirebaseFirestore.instance;
  List<Beneficiary> beneficiaries = [];
  List<Categories> categories = [];

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
        ),
        body: Column(
          // to show contents tabbar view
          children: [
            _beneficiaryBody(),
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
                Text('Email: ${beneficiaries[index].email}'),
                SizedBox(height: 8),
                Text('Number: ${beneficiaries[index].number}'),
                SizedBox(height: 8),
                Text('address: ${beneficiaries[index].address}'),
              ],
            ),
          ),
        );
      },
    );
  }

  getBeneficiaries() async {
    var ret = await _fireStore.collection('beneficiary').get();
    ret.docs.forEach((element) {
      Beneficiary bf = Beneficiary(
        name: element.data()['name'],
        email: element.data()['email'],
        number: element.data()['number'],
        address: element.data()['address'],
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
  String email;
  String name;
  String number;
  String address;

  Beneficiary({this.email, this.name, this.number, this.address});
}
