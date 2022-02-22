import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertest/screen/donor/donate.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';
import 'package:fluttertest/screen/donor/organization_view_page.dart';

/// This page is to show all urgent cases
/// Author: Joyshree Chowdhury
/// All rights reserved

class UrgentMorePage extends StatefulWidget {
  const UrgentMorePage({Key key, this.urgentCases, this.userId})
      : super(key: key);
  final List<CharityEvent> urgentCases;
  final String userId;

  @override
  _UrgentMorePageState createState() => _UrgentMorePageState();
}

class _UrgentMorePageState extends State<UrgentMorePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<CharityEvent> urgentCases = [];
  bool isSorted = false;

  @override
  void initState() {
    // Sort urgent by category
    sortUrgentCase();

    super.initState();
  }

  // Sort urgent cases by category
  sortUrgentCase() {
    urgentCases.clear();

    urgentCases.addAll(widget.urgentCases);
    urgentCases.sort((a, b) {
      return a.category.compareTo(b.category);
    });
    setState(() {
      isSorted = true;
    });
  }

  // unsort urgent cases
  unsortUrgentCase() {
    urgentCases.clear();

    urgentCases.addAll(widget.urgentCases);
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
        title: Text('Urgent cases'),
        actions: [
          IconButton(
            onPressed: () {
              if (isSorted) {
                unsortUrgentCase();
              } else {
                sortUrgentCase();
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
      itemCount: urgentCases.length,
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
                    var description = urgentCases[index].description;
                    var eventTitle = urgentCases[index].name;
                    var docId = urgentCases[index].eventId;
                    var goal = urgentCases[index].goal;
                    nextScreen(
                        context,
                        Donate(widget.userId, description, eventTitle, docId,
                            goal,null,null));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
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
                  height: 100,
                  width: _width / 7 * 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(urgentCases[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(urgentCases[index].description,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            )),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                color: Colors.pink[400]),
                            child: Text(
                              'Category: ${urgentCases[index].category}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                color: Colors.amber[400]),
                            child: Text(
                              'Goal: ${urgentCases[index].goal}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      )
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
}
