
// import 'package:flutter/material.dart';
// import 'package:flutter_app/screens/habit_screen.dart';
// import 'package:flutter_app/screens/login.dart';
// import 'package:provider/provider.dart';
// import '../models/habit.dart';
// import '../services/database.dart';
// import '../progress_row.dart';
// import 'package:weekday_selector/weekday_selector.dart';
// import 'package:provider/provider.dart';
// import '../models/user.dart';
// import '../services/auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class TestState extends State<HabitScreen> {

//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showdialog(false, null),
//         child: Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         title: Text(
//           "Tasks",
//           style: TextStyle(
//             fontFamily: "tepeno",
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             onPressed: () =>
//                 signOutUser().then((value) {
//                   Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => HomePage()),
//                           (Route<dynamic> route) => false);
//                 }),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: taskcollections
//             .document(uid)
//             .collection('task')
//             .orderBy('time')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data.documents.length,
//               itemBuilder: (context, index) {
//                 DocumentSnapshot ds = snapshot.data.documents[index];
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.purple,
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(
//                       ds['task'],
//                       style: TextStyle(
//                         fontFamily: "tepeno",
//                         fontSize: 18.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                     onLongPress: () {
//                       // delete
//                       taskcollections
//                           .document(uid)
//                           .collection('task')
//                           .document(ds.documentID)
//                           .delete();
//                     },
//                     onTap: () {
//                       // == Update
//                       showdialog(true, ds);
//                     },
//                   ),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return CircularProgressIndicator();
//           } else {
//             return CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }