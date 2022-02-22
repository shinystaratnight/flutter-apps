import 'package:badges/badges.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/screen/donor/catetories_more_page.dart';
import 'package:fluttertest/screen/donor/charity_category.dart';
import 'package:fluttertest/screen/donor/charity_category_page.dart';
import 'package:fluttertest/screen/donor/charity_item.dart';
import 'package:fluttertest/screen/donor/donate.dart';
import 'package:fluttertest/screen/donor/my_donation_page.dart';
import 'package:fluttertest/screen/donor/notification_page.dart';
import 'package:fluttertest/screen/donor/org_user_type.dart';
import 'package:fluttertest/screen/donor/organization_view_page.dart';
import 'package:fluttertest/screen/donor/organizations_more_page.dart';
import 'package:fluttertest/screen/donor/push_notification.dart';
import 'package:fluttertest/screen/donor/search_page.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';
import 'package:fluttertest/screen/donor/drawer.dart';
import 'package:fluttertest/screen/donor/urgent_more_page.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth.dart';

/// Donor home screen
/// Menu, Appbar(logout, search), Body(Charity categories, Urgent cases, Organizations)
/// Author: Joyshree Chowdhury
/// All rights reserved

class AdminHome extends StatefulWidget {
  String userId;
  AdminHome(this.userId);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  List<CharityCategory> charityCategories = [];
  var _fireStore = FirebaseFirestore.instance;

  // Edited by Joya
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<CharityItem> tempList = [];
  List<OrgUserType> orgUserList = [];
  List<String> orgIdList = [];
  List<String> orgCategory = ['Religion', 'Homeless', 'Education', 'Other'];
  List<CharityEvent> urgentCases = [];

  void updateGoal(int index, int newGoal) {
    setState(() {
      urgentCases[index].goal = newGoal;
    });
  }

  // Added by Joya
  List<PushNotification> notifications = [];
  FirebaseMessaging _messaging;
  int _totalNotifications = 0;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<CharityEvent> urgetnNotifications = [];

  // Register notification
  registerNotification() async {
    final SharedPreferences prefs = await _prefs;
    bool value = prefs.getBool('notification');

    if (value) {
      _messaging = FirebaseMessaging.instance;

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      // _messaging.sendMessage()

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print(
              'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

          // Parse the message received
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body'],
          );

          notifications.add(notification);
          setState(() {
            _totalNotifications++;
          });

          if (notifications.isNotEmpty) {
            notifications.forEach((element) {
              // For displaying the notification as an overlay
              showSimpleNotification(
                Text(element.title),
                subtitle: Text(element.body),
                background: Colors.red,
                duration: Duration(seconds: 3),
              );
            });
          }
        });
      } else {
        print('User declined or has not accepted permission');
      }
    }
    return value;
  }

  _handleNotification() {
    if (registerNotification()) {
      // For handling notification when the app is in background
      // but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        notifications.add(notification);
        setState(() {
          _totalNotifications++;
        });
      });
    }
  }

  @override
  void initState() {
    notifications.clear();
    // handle notification for background
    // _handleNotification();
    getNotifications();

    getCharityCategories();
    getCharityItems();
    getOrgUserType();
    getEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Added by Joya
      drawer: DrawerMenu(
        onResult: (result) {
          getOrgUserType();
          getNotifications();
        },
      ), // Open drawer menu page
      appBar: AppBar(
        backgroundColor: Colors.red,
        // drawer: DrawerMenu(),
        title: Text(
          'dashboard',
        ).tr(),
        leading: IconButton(
          onPressed: () {
            // Click menu icon
            scaffoldKey.currentState.openDrawer(); // Added by Joya
          },
          icon: Icon(
            Icons.menu,
            size: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              nextScreen(context, SearchPage()); // Added by Joya
            },
            icon: Icon(
              Icons.search,
              size: 25,
            ),
          ),
          _notificationBadge(),
          // Hide logout button by Joyshree
          // IconButton(
          //   onPressed: () async {
          //     //nextScreen(context, SearchPage()); // Added by Joya
          //     showLogoutAlert(context);
          //   },
          //   icon: Icon(
          //     Icons.logout,
          //     size: 25,
          //   ),
          // ),
        ],
      ),
      body: _body(),
    );
  }

  // Notification badge
  Widget _notificationBadge() {
    return _totalNotifications == 0
        ? IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // nextScreen(
              //   context,
              //   NotificationPage(
              //       notifications: urgetnNotifications, userId: widget.userId),
              // );
            },
          )
        : Badge(
            badgeColor: Colors.white,
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text(
              _totalNotifications.toString(),
              style: TextStyle(color: Colors.red),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () async {
                // Update notification page by Joyshree
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage(
                            notifications: urgetnNotifications,
                            userId: widget.userId)));
                if (result == true) {
                  getNotifications();
                  getEvents();
                }
              },
            ),
          );
  }

  // Body to show charity categories, urgent case and organizations
  _body() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      // physics: ScrollPhysics(),
      child: Column(
        children: [
          _charityCategoriesUI(),
          _urgentCases(),
          _charityOrganizations(),
        ],
      ),
    );
  }

  // Charity categories
  _charityCategoriesUI() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Charity Categories',
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const Spacer(),
              GestureDetector(
                child: Text('see more'),
                onTap: () {
                  nextScreen(context,
                      CategoriesMorePage(charityCategories: charityCategories));
                },
              ),
              const SizedBox(width: 5),
              Icon(FeatherIcons.chevronRight, color: Colors.grey, size: 15),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                // physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: charityCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/cat_$index.jpg'),
                                    scale: 1.0),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10),
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.pink[400],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  charityCategories[index].name,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        nextScreen(
                            context,
                            CharityCategoryPage(
                                cc: charityCategories[index],
                                userId: widget.userId));
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // Urgent cases UI & function
  _urgentCases() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Urgent cases',
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const Spacer(),
              GestureDetector(
                child: Text('see more'),
                onTap: () {
                  nextScreen(
                      context,
                      UrgentMorePage(
                          urgentCases: urgentCases, userId: widget.userId));
                },
              ),
              const SizedBox(width: 5),
              Icon(FeatherIcons.chevronRight, color: Colors.grey, size: 15),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: _fireStore.collection('Events').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    }
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No Data Found"),
                    );
                  }
                  return ListView.builder(
                      // physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          snapshot.data.docs.length, //urgentCases.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.data.docs[index]["status"]
                            ? Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: const EdgeInsets.all(8),
                                child: InkWell(
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    snapshot.data.docs[index]
                                                        ["name"],
                                                    //'${urgentCases[index].name}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    snapshot.data.docs[index]
                                                        ["description"],
                                                    // '${urgentCases[index].description}',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.pink[400]),
                                                  child: Text(
                                                    "Category: ${snapshot.data.docs[index]["category"]}",
                                                    // 'Category: ${urgentCases[index].category}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.amber),
                                                  child: Text(
                                                    "Goal: ${snapshot.data.docs[index]["goal"]}",
                                                    // 'Goal: ${urgentCases[index].goal}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Donate Button
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Donate(
                                                              widget.userId,
                                                              snapshot.data.docs[
                                                                      index][
                                                                  "description"],
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ["name"],
                                                              snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id,
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ["goal"],
                                                              updateGoal,
                                                              index)));
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                color: Colors.pink[400],
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.heart_fill,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  Text('Donate',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              )
                            : SizedBox();
                      });
                },
              )),
        ],
      ),
    );
  }

  // Charity organizations view on body(favorite function)
  _charityOrganizations() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'charity organization',
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ).tr(),
              const Spacer(),
              GestureDetector(
                child: Text('see more'),
                onTap: () {
                  nextScreen(
                      context,
                      OrganizationsMorePage(
                          orgUserList: orgUserList,
                          orgIdList: orgIdList,
                          userId: widget.userId));
                },
              ),
              const SizedBox(width: 5),
              Icon(FeatherIcons.chevronRight, color: Colors.grey, size: 15),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                // physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: orgUserList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${orgUserList[index].name}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.pink[400]),
                                    child: Text(
                                      'Category: ${orgUserList[index].category}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setFavoriteItem(orgUserList[index],
                                                orgIdList[index]);
                                          },
                                          child: Icon(
                                            Icons.star,
                                            size: 20,
                                            color: orgUserList[index].favorite
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          'Make Favorite',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Donate Button
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Donate(
                                              widget.userId,
                                              null,
                                              orgUserList[index].name,
                                              orgUserList[index].category,
                                              null,
                                              null,
                                              null)));
                                },
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[400],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        CupertinoIcons.heart_fill,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      Text('Donate',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // Show alert dialog to logout account
  showLogoutAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('confirm logout').tr(),
            content: Text('are you sure want to logout?').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: Text('yes').tr(),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  }
                  //nextScreenReplace(context, Wrapper());},
                  ),
            ],
          );
        });
  }

  // Get charity categories from organization event category
  getCharityCategories() async {
    var categories = await _fireStore.collection('EventCategory').get();
    categories.docs.forEach((element) {
      CharityCategory cc = CharityCategory(
        id: element.data()['id'],
        image: element.data()['image'],
        name: element.data()['name'],
      );
      charityCategories.add(cc);
    });

    setState(() {});
  }

  // temp for urgent cases and charity events
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
      tempList.add(ci);
    });

    setState(() {});
  }

  // Get usertype for organizations from firestore
  getOrgUserType() async {
    orgUserList.clear();
    orgIdList.clear();

    var categories = await _fireStore.collection('UserType').get();
    categories.docs.forEach((element) {
      int selectedUser = element.data()['SelectedUser'];
      if (selectedUser == 2) {
        bool f = element.data()['favorite'];
        if (f == null) {
          f = false;
        }
        OrgUserType out = OrgUserType(
          uid: element.data()['Uid'],
          selectedUser: element.data()['SelectedUser'],
          name: element.data()['Name'],
          category: element.data()['Category'],
          favorite: f,
        );
        orgUserList.add(out);
        orgIdList.add(element.id);
      }
    });

    setState(() {});
  }

  // Set organization to favorite
  setFavoriteItem(OrgUserType out, String uid) async {
    await _fireStore.collection('UserType').doc(uid).set({
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

  // Get urgent cases from every category
  getEvents() async {
    var ret = await _fireStore.collection('Events').get();
    ret.docs.forEach((element) {
      // if(element.data()["status"]){
      //   print("---------------------------------");
      //   print(element.data()['status'].toString());
      //   print("---------------------------------");
      // }
      String category = element.data()['category'];
      var f;
      if (element.data()['favorite'] == null) {
        f = false;
      } else {
        f = element.data()['favorite'];
      }

      //...Urgent case automatic status add on firebase, if admin approve will appear on ui
      //if(element.data()['status']){
      CharityEvent ce = CharityEvent(
        eventId: element.id,
        name: element.data()['name'],
        description: element.data()['description'],
        goal: element.data()['goal'],
        urgent: element.data()['urgent'],
        category: category,
        favorite: f,
      );
      if (ce.urgent == true) {
        urgentCases.add(ce);
      }
      //}
    });

    setState(() {});
  }

  // Get notifications
  getNotifications() async {
    urgetnNotifications.clear();
    _totalNotifications = urgetnNotifications.length;

    final SharedPreferences prefs = await _prefs;
    bool value = prefs.getBool('notification');
    print(value);
    if (value == null) {
      setState(() {});
      return;
    } else if (!value) {
      setState(() {});
      return;
    }

    var ret = await _fireStore.collection('Events').get();
    ret.docs.forEach((element) {
      String category = element.data()['category'];
      var f;
      if (element.data()['favorite'] == null) {
        f = false;
      } else {
        f = element.data()['favorite'];
      }
      //..

      CharityEvent ce = CharityEvent(
        eventId: element.id,
        name: element.data()['name'],
        description: element.data()['description'],
        goal: element.data()['goal'],
        urgent: element.data()['urgent'],
        category: category,
        favorite: f,
      );
      if (ce.urgent == true) {
        urgetnNotifications.add(ce);
      }
    });

    _totalNotifications = urgetnNotifications.length;
    setState(() {});
  }
}

/// Background handler for firebase messaging
/// Author: Joyshree Chowdhury
/// All rights reserved
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

/// Notification badge widget
/// Author: Joyshree Chowdhury
/// All rights reserved
class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.red, fontSize: 8),
          ),
        ),
      ),
    );
  }
}
