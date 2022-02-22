import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/charity_item.dart';

import 'org_user_type.dart';
import 'organization_view_page.dart';

/// Favorite screen to show charity organizations and individuals(2 tabs)
/// Author: Joyshree Chowdhury
/// All rights reserved
class FavouritePage extends StatefulWidget {
  const FavouritePage({Key key}) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  var _fireStore = FirebaseFirestore.instance;
  List<CharityEvent> events = [];
  List<String> eventIdList = [];
  List<OrgUserType> orgList = [];
  List<String> orgIdList = [];
  List<Beneficiary> indList = [];
  List<String> indIdList = [];

  @override
  void initState() {
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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back)),
          title: const Text('my favorite').tr(),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              // tab names
              Tab(
                text: "organizations".tr(),
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
            _organizationBody(_width),
            _individualsBody(),
            // _organizationBody2(_width),
          ],
        ),
      ),
    );
  }

  /** Body to display individuals from category
   *
   */
  _individualsBody() {
    return indList.isEmpty
        ? Center(
      child: Text('There is no favorite individuals'),
    )
        : ListView.builder(
      itemCount: indList.length,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: ListTile(
            onTap: () {
              setUnFavoriteIndividuals(indList[index], indIdList[index]);
            },
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
                Text(
                  'Make unfavorite',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(indList[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
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
            leading: GestureDetector(
              // Donate button
              onTap: () {},
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
                      CupertinoIcons.heart_fill,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text('Donate',
                        style:
                        TextStyle(color: Colors.white, fontSize: 12))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /** Body to show organization
   *
   */
  _organizationBody(_width) {
    return orgList.isEmpty
        ? Center(
      child: Text('There is no favorite organizations'),
    )
        : SizedBox(
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              leading: GestureDetector(
                // Donate button
                onTap: () {},
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
                        CupertinoIcons.heart_fill,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text('Donate',
                          style: TextStyle(
                              color: Colors.white, fontSize: 12))
                    ],
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('${orgList[index].name}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              subtitle: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5)),
                        color: Colors.pink[400]),
                    child: Text(
                      'Category: ${orgList[index].category}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    color: Colors.amber,
                  ),
                  Text(
                    'Make unfavorite',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              onTap: () {
                setUnFavoriteOrg(orgList[index], orgIdList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  // Set unfavorite events
  setUnFavoriteItem(CharityEvent ce, String uid) async {
    await _fireStore.collection('Events').doc(uid).set({
      'category': ce.category,
      'description': ce.description,
      'goal': ce.goal,
      'favorite': false,
      'name': ce.name,
      'urgent': ce.urgent,
    }).then((value) {
      events.remove(ce);
      eventIdList.remove(uid);
      setState(() {});
    });
  }

  /** Set unfavorite org to favorite
   *
   */
  setUnFavoriteOrg(OrgUserType out, String uid) async {
    await _fireStore.collection('UserType').doc(uid).set({
      'Category': out.category,
      'Name': out.name,
      'SelectedUser': out.selectedUser,
      'favorite': false,
      'Uid': out.uid,
    }).then((value) {
      orgList.remove(out);
      orgIdList.remove(uid);
      setState(() {});
    });
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

      if (f) {
        CharityEvent ce = CharityEvent(
          name: element.data()['name'],
          description: element.data()['description'],
          goal: element.data()['goal'],
          urgent: element.data()['urgent'],
          category: category,
          favorite: f,
        );
        eventIdList.add(element.id);
        events.add(ce);
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
      var f;
      if (element.data()['favorite'] == null) {
        f = false;
      } else {
        f = element.data()['favorite'];
      }
      int selectedUser = element.data()['SelectedUser'];
      if (selectedUser == 2 && f == true) {
        OrgUserType out = OrgUserType(
          uid: element.data()['Uid'],
          selectedUser: element.data()['SelectedUser'],
          name: element.data()['Name'],
          category: element.data()['Category'],
          favorite: f,
        );
        orgList.add(out);
        orgIdList.add(element.id);
      }
    });

    setState(() {});
  }

  /** Get individuals from firestore
   *
   */
  getIndividuals() async {
    var ret = await _fireStore.collection('beneficiary').get();
    ret.docs.forEach((element) {
      String category = element.data()['category'];
      var f;
      if (element.data()['favorite'] == null) {
        f = false;
      } else {
        f = element.data()['favorite'];
      }
      if (category == null) {
        category = '';
      }
      if (f == true) {
        Beneficiary ce = Beneficiary(
          name: element.data()['name'],
          address: element.data()['address'],
          email: element.data()['email'],
          number: element.data()['number'],
          category: category,
          favorite: f,
        );
        indList.add(ce);
        indIdList.add(element.id);
      }
    });

    setState(() {});
  }

  /** Set un favorite individuals
   *
   */

  setUnFavoriteIndividuals(Beneficiary out, String uid) async {
    await _fireStore.collection('beneficiary').doc(uid).set({
      'address': out.address,
      'category': out.category,
      'email': out.email,
      'favorite': false,
      'name': out.name,
      'number': out.number,
    }).then((value) {
      indList.remove(out);
      indIdList.remove(uid);
      setState(() {});
    });
  }
}
