import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'userHome.dart';


class OrganizationDonors extends StatefulWidget {
  const OrganizationDonors({Key key}) : super(key: key);

  @override
  _OrganizationDonors createState() => _OrganizationDonors();
}

class _OrganizationDonors extends State<OrganizationDonors> {

  var _fireStore = FirebaseFirestore.instance;
  List<CharityEvent> events = [];

  @override
  void initState() {
    // getBeneficiaries();
    getEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: Colors.red,
      ),
      body: ListView(

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _eventBody(),
            ],
          ),
        ],
      ),
    );
  }

  _eventBody() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      itemCount: events.length,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        return Card(
          shadowColor: Colors.redAccent,
          elevation: 5.0,

          // color: Colors.red,
          child: ExpandablePanel(
            header: Text(events[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0), ),
            collapsed: Text("Expand for Description", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
            expanded: Text(events[index].description, softWrap: true,),
          ),
        );
        //   Card(
        //   margin: const EdgeInsets.all(8),
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //   elevation: 3,
        //   child: ListTile(
        //     title: Text(events[index].name),
        //     // subtitle: Text(events[index].image),
        //   ),
        // );
      },
    );
  }


  getEvents() async {
    var ret = await _fireStore.collection('EventCategory').get();
    ret.docs.forEach((element) {
      CharityEvent ce = CharityEvent(
          name: element.data()['name'],
          description: element.data()['description']


        // image: element.data()['description'],


      );
      events.add(ce);
    });

    setState(() {});
  }
}


class CharityEvent {
  String name;
  String description;
  // String image;


  CharityEvent({this.name, /*this.image,*/ this.description});
}