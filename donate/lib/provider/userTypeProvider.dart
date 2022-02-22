import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertest/models/UserType.dart';

class PUserType extends ChangeNotifier {
  var firestoreInstance = FirebaseFirestore.instance;
  bool emailVarified = true;
  bool loading = false;
  List<UserType> lUserType = [];
  getUserType(context) async {
    print('getUserTypeCalled');
    loading = true;
    notifyListeners();
    var a = await firestoreInstance.collection('UserType').get();
    a.docs.forEach((element) {
      lUserType.add(UserType(
          uid: element.data()['Uid'],
          userType: element.data()['SelectedUser'].toString()));
    });
    loading = false;
    print(' list is $lUserType');
    print('getUserTypeCalled end');
    notifyListeners();
  }
}
