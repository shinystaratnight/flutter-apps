import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/donate.dart';
import 'package:fluttertest/screen/donor/donation.dart';
import 'package:fluttertest/screen/donor/org_user_type.dart';
import 'package:fluttertest/screen/donor/organization_view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * My history donation (Organizations, Urgent cases, Events and Individuals)
 * This class include appbar, tabbar(2 tabs)
 * design is same as the my  favorite page
 */

/// Author: Joyshree Chowdhury
/// All rights reserved
class MyDonationPage extends StatefulWidget {
  const MyDonationPage({Key key}) : super(key: key);

  @override
  _MyDonationPageState createState() => _MyDonationPageState();
}

class _MyDonationPageState extends State<MyDonationPage> {
  var _fireStore = FirebaseFirestore.instance;

  List<Donation> donationList = [];
  List<Donation> donationOneList = [];
  List<Donation> donationTwoList = [];

  List<OrgUserType> orgUserList = [];
  List<CharityEvent> events = [];
  List<Beneficiary> individuals = [];

  bool isLoadedDonation = false;
  bool isLoadedOrg = false;
  bool isLoadedEvent = false;
  bool isLoadedInd = false;

  bool isFetched = false;

  @override
  void initState() {
    getDonations();
    getOrgUserType();
    getEvents();
    getIndividuals();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;

    // Fetch donations from firestore..
    if (isLoadedDonation &&
        isLoadedEvent &&
        isLoadedInd &&
        isLoadedOrg &&
        !isFetched) {
      fetchDonations();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('my donations').tr(),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              Tab(
                text: "organizations".tr(),
              ),
              Tab(
                text: "individuals".tr(),
              ),
            ],
          ),
        ),
        body:
        !isLoadedDonation || !isLoadedEvent || !isLoadedInd || !isLoadedOrg
            ? const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.pink,
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : !isFetched
            ? const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.pink,
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : TabBarView(
          children: [
            // Tab view for organization, urgent cases, charity events
            _tabBody(donationOneList),
            // Tab view for individuals
            _tabBody(donationTwoList),
          ],
        ),
      ),
    );
  }

  // Tab body for donation information(Organizations, Urgent cases, Charity events, Individuals)
  _tabBody(List<Donation> ds) {
    var _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width,
      child: ds.isEmpty
          ? Container()
          : ListView.builder(
        itemCount: ds.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            child: Container(
              height: 150,
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Stack(
                children: [
                  // Category
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.pink),
                      child: Text(
                        'Category: ${ds[index].category}',
                        style:
                        TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                  // Amount of donation
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 5, right: 8),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.amber),
                      child: Text(
                        "Amount: ${ds[index].amount}",
                        style:
                        TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                  // Name, Description, Type and Datetime
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: _width * 0.7,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name of donation
                          Text(
                            'Name: ${ds[index].name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          // Type
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.purple[400]),
                            child: Text(
                              ds[index].type,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ),
                          // Description of donation
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Description: ${ds[index].description}',
                              style: TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                          // Date and Time of donation
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Date: ${_getDate(ds[index].createdAt)}    Time: ${_getTime(ds[index].createdAt)}',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Donation again
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      // Donate again
                      onTap: () {
                        _donateAgain(ds[index]);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(5)),
                          color: Colors.pink[400],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(height: 5),
                            Text('Donate again',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))
                          ],
                        ),
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

  // Get date from datetime
  _getDate(String dt) {
    return dt.split(' ')[0];
  }

  // Get time from date time
  _getTime(String dt) {
    return dt.split(' ')[1];
  }

  /// Donate again
  _donateAgain(Donation donation) async {
    var goal;
    if (donation.type == 'Urgent case' || donation.type == 'Event') {
      goal = int.parse(donation.amount);
    }

    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Donate(
              donation.userId,
              donation.description == null ? null : donation.description,
              donation.name,
              donation.docId,
              goal, null,null
            )));

    // loading page again
    isLoadedDonation = false;
    isLoadedEvent = false;
    isLoadedInd = false;
    isLoadedOrg = false;
    isFetched = false;

    getDonations();
    getOrgUserType();
    getEvents();
    getIndividuals();
  }

  /// Get all donations from firestore
  getDonations() async {
    var donations = await _fireStore.collection('donations').get();
    String uid = await getUidFromSp();
    print(uid);

    donationList.clear();
    donationOneList.clear();
    donationTwoList.clear();

    donations.docs.forEach((donation) async {
      if (donation.data()['donatedAt'] != null) {
        Donation d = Donation.fromJson(donation);
        // print(d.userId);
        if (d.userId == uid) {
          donationList.add(Donation.fromJson(donation));
        }
      }
    });

    isLoadedDonation = true;
    setState(() {});
  }

  // Get usertype for organizations from firestore
  getOrgUserType() async {
    var userTypes = await _fireStore.collection('UserType').get();
    orgUserList.clear();
    userTypes.docs.forEach((element) {
      int selectedUser = element.data()['SelectedUser'];
      if (selectedUser == 2) {
        bool f = element.data()['favorite'];
        if (f == null) {
          f = false;
        }
        OrgUserType out = OrgUserType(
          uid: element.id,
          selectedUser: element.data()['SelectedUser'],
          name: element.data()['Name'],
          category: element.data()['Category'],
          favorite: f,
        );
        orgUserList.add(out);
      }
    });

    isLoadedOrg = true;
    setState(() {});
  }

  // Get urgent cases from every category
  getEvents() async {
    events.clear();
    var ret = await _fireStore.collection('Events').get();
    ret.docs.forEach((element) {
      String category = element.data()['category'];
      var f;
      if (element.data()['favorite'] == null) {
        f = false;
      } else {
        f = element.data()['favorite'];
      }

      CharityEvent ce = CharityEvent(
        eventId: element.id,
        name: element.data()['name'],
        description: element.data()['description'],
        goal: element.data()['goal'],
        urgent: element.data()['urgent'],
        category: category,
        favorite: f,
      );
      events.add(ce);
    });

    isLoadedEvent = true;
    setState(() {});
  }

  // Get individuals from firestore
  getIndividuals() async {
    individuals.clear();
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
      Beneficiary ce = Beneficiary(
          uid: element.id,
          name: element.data()['name'],
          address: element.data()['address'],
          email: element.data()['email'],
          number: element.data()['number'],
          category: category,
          // category: category,
          favorite: f);
      individuals.add(ce);
    });

    isLoadedInd = true;
    setState(() {});
  }

  fetchDonations() {
    for (var d in donationList) {
      // Get org
      orgUserList.forEach((element) {
        if (element.name == d.name) {
          d.category = element.category;
          d.type = 'Organization';
          d.docId = element.uid;
          donationOneList.add(d);
        }
      });
      // Get Event
      events.forEach((element) {
        if (element.name == d.name) {
          d.category = element.category;
          d.description = element.description;
          if (element.urgent == true) {
            d.type = 'Urgent case';
          } else {
            d.type = 'Event';
          }
          d.docId = element.eventId;
          donationOneList.add(d);
        }
      });
      // Get individuals
      individuals.forEach((element) {
        if (element.name == d.name) {
          d.category = element.category;
          d.type = 'Individuals';
          d.docId = element.uid;
          donationTwoList.add(d);
        }
      });
    }
    isFetched = true;
  }

  /** Get uid from saved sharedpreference
   *
   */
  Future getUidFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('uid');
  }
}
