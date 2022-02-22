import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/donate.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';
import 'package:fluttertest/screen/donor/organization_view_page.dart';
import 'package:fluttertest/screen/donor/push_notification.dart';
import 'package:fluttertest/screen/donor/snacbar.dart';
/**
 *  All rights reserved . author: Joyshree Chowdhury
 */

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key, this.notifications, this.userId})
      : super(key: key);
  final List<CharityEvent> notifications;
  final String userId;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<CharityEvent> notifications = [];

  var _fireStore = FirebaseFirestore.instance;

  bool isDeleted = false;

  @override
  void initState() {
    notifications.addAll(widget.notifications);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, isDeleted);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.red,
        title: Text('Notifications'),
      ),
      body: _body(),
    );
  }

  _body() {
    var _width = MediaQuery.of(context).size.width;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          // Dismiss notification
          key: ObjectKey(notifications[index]),
          onDismissed: (direction) {
            deleteNotification(notifications[index].eventId);
          },
          child: Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              width: _width,
              padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Click donation
                      var description = notifications[index].description;
                      var eventTitle = notifications[index].name;
                      var docId = notifications[index].eventId;
                      var goal = notifications[index].goal;
                      nextScreen(
                          context,
                          Donate(widget.userId, description, eventTitle, docId,
                              goal, null, null));
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))
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
                        Text(notifications[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(notifications[index].description,
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
                                notifications[index].category,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                                'Goal: ${notifications[index].goal}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
          ),
        );
      },
    );
  }

  // Delete urgent case notification
  deleteNotification(String docId) async {
    print(docId);
    var ret =
        await _fireStore.collection('Events').doc(docId).delete().then((value) {
      isDeleted = true;
      openSnacbar(scaffoldKey, 'Successfully deleted!.');
    });
  }
}
