import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

/// Organization view screen (temp, will delete later)
/// Author: Joyshree Chowdhury
/// All rights reserved
class OrganizationViewPage extends StatefulWidget {
  const OrganizationViewPage({Key key}) : super(key: key);

  @override
  _OrganizationViewPageState createState() => _OrganizationViewPageState();
}

class _OrganizationViewPageState extends State<OrganizationViewPage> {
  var _fireStore = FirebaseFirestore.instance;
  List<Beneficiary> beneficiaries = [];
  List<CharityEvent> events = [];

  @override
  void initState() {
    getBeneficiaries();
    getEvents();

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
          title: Text('Organization information'.tr()),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              // tab names
              Tab(
                text: "Beneficiary".tr(),
              ),
              Tab(
                text: "Events".tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          // to show contents tabbar view
          children: [
            _beneficiaryBody(),
            _eventBody(),
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

  _eventBody() {
    return ListView.builder(
      itemCount: events.length,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: ListTile(
            title: Text(events[index].name),
            subtitle: Text(events[index].description),
            trailing: Text(events[index].goal.toString()),
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

  getEvents() async {
    var ret = await _fireStore.collection('Events').get();
    ret.docs.forEach((element) {
      var category = element.data()['category'];
      CharityEvent ce = CharityEvent(
          name: element.data()['name'],
          description: element.data()['description'],
          goal: element.data()['goal'],
          urgent: element.data()['urgent'],
          category: element.data()['category']);
      events.add(ce);
    });

    setState(() {});
  }
}

class CharityEvent {
  String eventId;
  String name;
  String description;
  int goal;
  bool urgent;
  String category;
  bool favorite;

  CharityEvent(
      {this.eventId,
      this.name,
      this.description,
      this.goal,
      this.urgent,
      this.category,
      this.favorite});
}

class Beneficiary {
  String uid;
  String email;
  String name;
  String number;
  String address;
  String category;
  bool favorite;

  Beneficiary({
    this.uid,
    this.email,
    this.name,
    this.number,
    this.address,
    this.category,
    this.favorite,
  });
}
