/// Model class of organization user type
/// organization user if selectedUser is 2, otherwise donor user(selectedUser is 1)
/// member: uid, selectedUser, name, category, favorite(option)

class OrgUserType {
  String uid;
  int selectedUser;
  String name;
  String category;
  bool favorite;
  String docId;

  OrgUserType(
      {this.uid, this.selectedUser, this.name, this.category, this.favorite});

  // Get OrgUsertype from json format
  factory OrgUserType.fromJson(dynamic d) {
    return OrgUserType(
      uid: d['Uid'],
      selectedUser: d['SelectedUser'],
      name: d['Name'],
      category: d['Category'],
      favorite: d['favorite'],
    );
  }
}
