import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/donate.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';
import 'package:fluttertest/screen/donor/org_user_type.dart';

/// This page is to show all organizations
/// Author: Joyshree Chowdhury
/// All rights reserved

class OrganizationsMorePage extends StatefulWidget {
  const OrganizationsMorePage(
      {Key key, this.orgUserList, this.orgIdList, this.userId})
      : super(key: key);
  final List<OrgUserType> orgUserList;
  final List<String> orgIdList;
  final String userId;

  @override
  _OrganizationsMorePageState createState() => _OrganizationsMorePageState();
}

class _OrganizationsMorePageState extends State<OrganizationsMorePage> {
  var _fireStore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSorted = false;
  List<OrgUserType> orgUserList = [];

  @override
  void initState() {
    // Sort organizations by category
    sortOrganizations();
    super.initState();
  }

  // Sort organizations by category
  sortOrganizations() {
    orgUserList.clear();

    orgUserList.addAll(widget.orgUserList);
    orgUserList.sort((a, b) {
      return a.category.compareTo(b.category);
    });
    setState(() {
      isSorted = true;
    });
  }

  // Unsort urgent cases
  unsortOrganizations() {
    orgUserList.clear();

    orgUserList.addAll(widget.orgUserList);
    setState(() {
      isSorted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Charity organizations'),
        actions: [
          IconButton(
            onPressed: () {
              if (isSorted) {
                unsortOrganizations();
              } else {
                sortOrganizations();
              }
            },
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    var _width = MediaQuery.of(context).size.width;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orgUserList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
            width: _width,
            padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // Click donation
                    var eventTitle = orgUserList[index].name;
                    var category = orgUserList[index].category;
                    nextScreen(
                        context,
                        Donate(
                            widget.userId, null, eventTitle, category, null,null,null));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: _width / 7,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      color: Colors.pink[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                Container(
                  height: 70,
                  width: _width / 7 * 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orgUserList[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                color: Colors.pink[400]),
                            child: Text(
                              'Category: ${orgUserList[index].category}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setFavoriteItem(orgUserList[index]);
                            },
                            icon: Icon(
                              Icons.star_border,
                              size: 20,
                              color: orgUserList[index].favorite
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            'Make Favorite',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Set organization to favorite
  setFavoriteItem(OrgUserType out) async {
    await _fireStore.collection('UserType').doc(out.docId).set({
      'Category': out.category,
      'Name': out.name,
      'SelectedUser': out.selectedUser,
      'favorite': true,
      'Uid': out.uid,
    }).then((value) {
      out.favorite = true;
      setState(() {});
    });
  }
}
