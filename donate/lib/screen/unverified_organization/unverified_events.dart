import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnverifiedOrganizationEvents extends StatefulWidget {
  const UnverifiedOrganizationEvents({Key key}) : super(key: key);

  @override
  _UnverifiedOrganizationEvents createState() => _UnverifiedOrganizationEvents();
}

class _UnverifiedOrganizationEvents extends State<UnverifiedOrganizationEvents> {
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // Appbar
          backgroundColor: Colors.red,
          title: Text('Events'),
        ),
          body: Column(
          // to show contents tabbar view
          children: [
            _eventBody(),
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
            trailing: Text(events[index].goal.toString()),
          ),
        );
      },
    );
  }


  getEvents() async {
    var ret = await _fireStore.collection('events').get();
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

