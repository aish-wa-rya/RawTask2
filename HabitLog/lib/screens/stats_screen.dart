import 'package:flutter/material.dart';
import '../services/database.dart';

class StatsScreen extends StatelessWidget {
  StatsScreen() {}
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 2,
        children:[
          ProgressBlock(),
          Container(
            child: ElevatedButton(
              child: Text("Completed habits"),
              onPressed: ()=>{
                //db.updateAllHabits()
              },
            ),
          ),
          Container(child: Text(db.user.experience.toString()),),

        ]
      ),
    );
  }

  Widget ProgressBlock(){
    ///Returns a block widget showing the months progress
    return Container(height: 10,);
  }


}
