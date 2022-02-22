
// import '../../Users/Anas/Desktop/donaid/DONAID_v3/lib/screen/user/createbeneficiary.dart';


// class OrganizationBeneficiaries extends StatelessWidget {
//   const OrganizationBeneficiaries ({Key key}) : super(key: key);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/user/create_events.dart';

class OrganizationEvents extends StatefulWidget {
  const OrganizationEvents({Key key}) : super(key: key);

  @override
  _OrganizationEvents createState() => _OrganizationEvents();
}

class _OrganizationEvents extends State<OrganizationEvents> {
  var _fireStore = FirebaseFirestore.instance;
  List<CharityEvent> events = [];

  @override
  void initState() {
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
          title: Text('Events'),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              // tab names
              Tab(
                text: "Events",
              ),
              Tab(
                text: "Create Event",
              ),
            ],
          ),
        ),
        body: TabBarView(
          // to show contents tabbar view
          children: [
            _eventBody(),
            CreateEvents(),
          ],
        ),
      ),
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
            trailing: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(5)),
                  color: Colors.amber[400]),
              child: Column(
                children: [
                  Text("Goal"),
                  Text(events[index].goal.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  getEvents() async {
    var ret = await _fireStore.collection('Events').get();
    ret.docs.forEach((element) {
      CharityEvent ce = CharityEvent(
        name: element.data()['name'],
        description: element.data()['description'],
        goal: element.data()['goal'],
        urgent: element.data()['urgent'],
      );
      events.add(ce);
    });

    setState(() {});
  }
}

class CharityEvent {
  String name;
  String description;
  int goal;
  bool urgent;

  CharityEvent({this.name, this.description, this.goal, this.urgent});
}
