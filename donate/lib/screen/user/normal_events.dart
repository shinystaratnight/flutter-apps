import 'package:flutter/material.dart';
import 'userHome.dart';

class NormalEvents extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<NormalEvents> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Tutorial - googleflutter.com'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              // RaisedButton(
              //   textColor: Colors.white,
              //   color: Colors.blue,
              //   child: Text('Login'),
              //   onPressed: (){
              //     print(nameController.text);
              //     print(passwordController.text);
              //   },
              // )
            ],
          )
      ),
      drawer: const OrganizationDrawer(),
    );
  }
}
















// import 'home.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class NormalEvents extends StatelessWidget {
//   const NormalEvents ({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         title: const Text("Events"),
//     ),);
//   }}
//
// class FavouritePage extends StatefulWidget {
//   const FavouritePage({Key? key}) : super(key: key);
//
//   @override
//   _FavouritePageState createState() => _FavouritePageState();
// }
//
// class _FavouritePageState extends State<FavouritePage> {
//   @override
//   Widget build(BuildContext context) {
//     var _width = MediaQuery.of(context).size.width;
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: const Text('my favorite'),
//           bottom: TabBar(
//             onTap: (index) {
//               print(index);
//             },
//             tabs: [
//               Tab(
//                 text: "organizations",
//               ),
//               Tab(
//                 text: "individuals",
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             SizedBox(
//               width: _width,
//               child: ListView.builder(
//                 // itemCount: orgList.length,
//                 shrinkWrap: true,
//                 padding: EdgeInsets.all(8),
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     margin: EdgeInsets.all(8),
//                     elevation: 2,
//                     child: ListTile(
//                       onTap: () {},
//                     //   leading: CircleAvatar(
//                     //       radius: 30,
//                     //       // backgroundImage:
//                     //       // Image.asset(orgList[index].image).image),
//                     //   title: Text(
//                     //     orgList[index].name,
//                     //     maxLines: 1,
//                     //     overflow: TextOverflow.ellipsis,
//                     //   ),
//                     //   subtitle: Container(
//                     //     margin: EdgeInsets.only(top: 4),
//                     //     child: Text(orgList[index].value),
//                     //   ),
//                     //   // trailing: Container(
//                     //   //   padding: EdgeInsets.only(right: 4),
//                     //   //   child: Icon(Icons.chevron_right, color: appStore.iconColor),
//                     //   // ),
//                     // ),
//                   ));
//                 },
//               ),
//             ),
//             SizedBox(
//               width: _width,
//               child: ListView.builder(
//                 // itemCount: indList.length,
//                 shrinkWrap: true,
//                 padding: EdgeInsets.all(8),
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     margin: EdgeInsets.all(8),
//                     elevation: 2,
//                     // child: ListTile(
//                     //   onTap: () {},
//                     //   leading: CircleAvatar(
//                     //       radius: 30,
//                     //       backgroundImage:
//                     //       Image.asset(indList[index].image).image),
//                     //   title: Text(
//                     //     indList[index].name,
//                     //     maxLines: 1,
//                     //     overflow: TextOverflow.ellipsis,
//                     //   ),
//                     //   subtitle: Container(
//                     //     margin: EdgeInsets.only(top: 4),
//                     //     child: Text(indList[index].value),
//                     //   ),
//                     //   // trailing: Container(
//                     //   //   padding: EdgeInsets.only(right: 4),
//                     //   //   child: Icon(Icons.chevron_right, color: appStore.iconColor),
//                     //   // ),
//                     // ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
