import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/charity_category.dart';
import 'package:fluttertest/screen/donor/charity_item.dart';

import 'package:fluttertest/screen/donor/org_user_type.dart';
import 'organization_view_page.dart';

/// Screen to show organization and individuals
/// Author: Joyshree Chowdhury
/// All rights reserved

class CharityCategoryPage extends StatefulWidget {
  const CharityCategoryPage({Key key, this.cc, this.userId}) : super(key: key);
  final CharityCategory cc;
  final String userId;

  @override
  _CharityCategoryPageState createState() => _CharityCategoryPageState();
}

class _CharityCategoryPageState extends State<CharityCategoryPage> {
  var _fireStore = FirebaseFirestore.instance;
  List<CharityItem> organizationList = [];
  List<CharityItem> individualList = [];
  List<CharityEvent> events = [];
  List<String> eventIdList = [];
  List<OrgUserType> orgList = [];
  List<Beneficiary> indList = [];
  List<String> indIdList = [];

  void updateGoal(int index,int newGoal){
    setState(() {
      events[index].goal = newGoal;
    });
  }

  @override
  void initState() {
    // getCharityItems();
    getEvents();
    getOrgUserType();
    getIndividuals();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      // Tabbar controller
      length: 2, // tabs count of tabbar
      child: Scaffold(
        appBar: AppBar(
          // Appbar
          backgroundColor: Colors.red,
          title: Text(widget.cc.name),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              // tab names
              Tab(
                // text: "organizations".tr(),
                text: "events".tr(),
              ),
              Tab(
                text: "individuals".tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          // to show contents tabbar view
          children: [
            _eventBody(),
            _individualBody(_width),
            // _organizationBody(_width),
          ],
        ),
      ),
    );
  }


  /** Body to display events from category
   *
   */
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
            leading: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.pink[400],
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.group_solid,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text('Event',
                        style: TextStyle(color: Colors.white, fontSize: 12))
                  ],
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(events[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            subtitle: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.pink[400]),
                  child: Text(
                    'Category: ${events[index].category}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            trailing: Text('Goal: ${events[index].goal.toString()}'),
          ),
        );
      },
    );
  }

  /**
   *  Body to show organization
   */
  _organizationBody(_width) {
    return SizedBox(
      width: _width,
      child: ListView.builder(
        // listview builder of individuals tab
        itemCount: orgList.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 3,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              title: Text('Organization: ${orgList[index].name}'),
              subtitle:
              Text('Organization category: ${orgList[index].category}'),
              trailing: Icon(
                Icons.star_border,
                color: Colors.amber,
              ),
            ),
          );
        },
      ),
    );
  }

  // Body to show individual beneficiaries
  _individualBody(_width) {
    return SizedBox(
      width: _width,
      child: ListView.builder(
        // listview builder of individuals tab
        itemCount: indList.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 3,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              leading: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.pink[400],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topRight: Radius.circular(12)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.person_fill,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text('Beneficiary',
                          style: TextStyle(color: Colors.white, fontSize: 12))
                    ],
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(indList[index].name,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              subtitle: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.pink[400]),
                    child: Text(
                      'Category: ${indList[index].category}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getCharityItems() async {
    var categories = await _fireStore.collection('CharityItem').get();
    categories.docs.forEach((element) {
      CharityItem ci = CharityItem(
          id: element.data()['id'],
          categoryId: element.data()['category_id'],
          image: element.data()['image'],
          title: element.data()['title'],
          content: element.data()['content'],
          favorite: element.data()['favorite'],
          type: element.data()['type']);
      if (ci.categoryId == widget.cc.id) {
        if (ci.type == 1) {
          organizationList.add(ci);
        } else {
          individualList.add(ci);
        }
      }
    });

    setState(() {});
  }



  /** Get events from every category
   *
   */
  getEvents() async {
    var ret = await _fireStore.collection('Events').get();
    ret.docs.forEach((element) {
      String category = element.data()['category'];
      var f;
      if (element.data()['favorite'] == null) {
        f = false;
      } else {
        f = element.data()['favorite'];
      }

      if (widget.cc.name.toLowerCase() == category.toLowerCase()) {
        CharityEvent ce = CharityEvent(
          eventId: element.id,
          name: element.data()['name'],
          description: element.data()['description'],
          goal: element.data()['goal'],
          urgent: element.data()['urgent'],
          category: category,
          favorite: f,
        );
        if (!ce.urgent) {
          eventIdList.add(element.id);
          events.add(ce);
        }
      }
    });

    setState(() {});
  }

  /** Get usertype for organizations from firestore
   *
   */
  getOrgUserType() async {
    var categories = await _fireStore.collection('UserType').get();
    categories.docs.forEach((element) {
      int selectedUser = element.data()['SelectedUser'];
      String category = element.data()['Category'];
      if (selectedUser == 2 && category == 'Non-Profit') {
        OrgUserType out = OrgUserType.fromJson(element.data());
        orgList.add(out);
      }
    });

    setState(() {});
  }

  /** Get individuals from firestore
   *
   */
  getIndividuals() async {
    indList.clear();
    indIdList.clear();

    var ret = await _fireStore.collection('beneficiary').get();
    ret.docs.forEach((element) {
      String category = element.data()['category'];
      if (category == null) {
        category = '';
      }
      bool f = element.data()['favorite'];
      if (f == null) {
        f = false;
      }
      if (widget.cc.name.toLowerCase() == category.toLowerCase()) {
        Beneficiary ce = Beneficiary(
            name: element.data()['name'],
            address: element.data()['address'],
            email: element.data()['email'],
            number: element.data()['number'],
            category: category,
            // category: category,
            favorite: f);
        indList.add(ce);
        indIdList.add(element.id);
      }
    });

    setState(() {});
  }
}
