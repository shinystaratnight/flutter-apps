import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/org_user_type.dart';
import 'package:fluttertest/screen/donor/organization_view_page.dart';
import 'package:fluttertest/screen/donor/snacbar.dart';

import 'charity_item.dart';

/**
 * This class search titles and contents of my favorite, history, org, individuals etc
 */
/// Search screen to search information of organization, individuals, events
/// Author: Joyshree Chowdhury
/// All rights reserved
class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  var _fireStore = FirebaseFirestore.instance;
  List<CharityItem> charityItems = [];
  List<CharityItem> searchedItems = [];

  List<CharityEvent> eventList = [];
  List<Beneficiary> individualList = [];
  List<OrgUserType> organizationList = [];

  List<CharityEvent> searchedEvents = [];
  List<Beneficiary> searchedIndividuals = [];
  List<OrgUserType> searchedOrganizations = [];

  @override
  void initState() {
    getEvents();
    getOrgUserType();
    getIndividuals();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: Column(
            children: [
              _searchBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      searchedEvents.isEmpty ? Container() : _eventBody(),
                      searchedOrganizations.isEmpty
                          ? Container()
                          : _organizationBody(),
                      searchedIndividuals.isEmpty ? Container() : _individualBody(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /** This function is UI of search bar
      it used widget of Card, TextFormField, IconButton
   * */
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: TextFormField(
          autofocus: true,
          controller: controller,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "search...".tr(),
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor),
            prefixIcon: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                if (controller.text.length >= 3) {
                  _searchClear();
                } else if (controller.text.length > 0 &&
                    controller.text.length < 3) {
                  openSnacbar(scaffoldKey, "Please input at least 3 letters");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // This function clear letters to search
  _searchClear() {
    searchedEvents.clear();
    searchedIndividuals.clear();
    searchedOrganizations.clear();

    // search event and urgent
    for (var item in eventList) {
      if (item.name.toLowerCase().contains(controller.text.toLowerCase()) ||
          item.description
              .toLowerCase()
              .contains(controller.text.toLowerCase())) {
        searchedEvents.add(item);
      }
    }
    // search individual
    for (var item in individualList) {
      if (item.name.toLowerCase().contains(controller.text.toLowerCase())) {
        searchedIndividuals.add(item);
      }
    }
    // search organization
    for (var item in organizationList) {
      if (item.name.toLowerCase().contains(controller.text.toLowerCase())) {
        searchedOrganizations.add(item);
      }
    }

    setState(() {
      controller.clear();
    });
  }

  /** Body to display events from category
   *
   */
  _eventBody() {
    return ListView.builder(
      itemCount: searchedEvents.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: ListTile(
            onTap: () {},
            leading: GestureDetector(
              // Donate button
              child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  decoration: BoxDecoration(
                    color: searchedEvents[index].urgent
                        ? Colors.deepOrange[400]
                        : Colors.purple[400],
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(searchedEvents[index].urgent ? 'Urgent' : 'Event',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(searchedEvents[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            subtitle: Text(
              '${searchedEvents[index].description}',
              style: TextStyle(fontSize: 10),
            ),
            trailing: Container(
              alignment: Alignment.center,
              width: 70,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.pink[400]),
              child: Text(
                'Category: ${searchedEvents[index].category}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  /** Body to display individuals from category
   *
   */
  _individualBody() {
    return ListView.builder(
      itemCount: searchedIndividuals.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: ListTile(
            onTap: () {},
            leading: GestureDetector(
              // Donate button
              child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text('Individuals',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(searchedIndividuals[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            subtitle: Text(''),
            trailing: Container(
              alignment: Alignment.center,
              width: 70,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.pink[400]),
              child: Text(
                'Category: ${searchedIndividuals[index].category}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  /** Body to display organization from category
   *
   */
  _organizationBody() {
    return ListView.builder(
      itemCount: searchedOrganizations.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, int index) {
        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: ListTile(
            onTap: () {},
            leading: GestureDetector(
              // Donate button
              child: Container(
                  alignment: Alignment.center,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.cyan[400],
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text('Organization',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(searchedOrganizations[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            subtitle: Text(''),
            trailing: Container(
              alignment: Alignment.center,
              width: 70,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.pink[400]),
              child: Text(
                'Category: ${searchedOrganizations[index].category}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  // Get urgent cases from every category
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

      CharityEvent ce = CharityEvent(
        eventId: element.id,
        name: element.data()['name'],
        description: element.data()['description'],
        goal: element.data()['goal'],
        urgent: element.data()['urgent'],
        category: category,
        favorite: f,
      );
      eventList.add(ce);
    });

    setState(() {});
  }

  // Get usertype for organizations from firestore
  getOrgUserType() async {
    organizationList.clear();

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
        organizationList.add(out);
      }
    });

    setState(() {});
  }

  /** Get individuals from firestore
   *
   */
  getIndividuals() async {
    individualList.clear();

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
          name: element.data()['name'],
          address: element.data()['address'],
          email: element.data()['email'],
          number: element.data()['number'],
          category: category,
          // category: category,
          favorite: f);
      individualList.add(ce);
    });

    setState(() {});
  }
}
