import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/database.dart';
import 'package:sortedmap/sortedmap.dart';
import '../util.dart';

class Habit {
  ///Habit Class containing all information for habits
  ///
  String _name;
  bool _repeating;
  List<bool> _repeats;
  int _goal;
  double _priority;
  int _completed;
  String _hid;
  int experienceIncrease;
//  Map completedHabitDates = new LinkedHashMap<String, bool>();
  SortedMap completedHabitDates = new SortedMap<String, bool>(Ordering.byKey());
  Database database;

  Habit(this._name, this._repeating, this._repeats, this._goal, this._priority) {
    _completed = 0;
    database = Database();
    int weeklyTrue = _repeats.where((item)  => item == true).length;
    String today = database.getTodayString();
    int i = 0;
    completedHabitDates[today] = false;
  }

  Habit.fromDb(this._name, this._repeating,
      this._repeats, this._goal, this._priority,
      this.completedHabitDates, this._completed){
  }

  Habit.fromDb1(DocumentSnapshot ds){
    this._hid = ds.documentID;
    this._goal = ds['goal'];
    this._name = ds['name'];
    this._priority = ds['priority'];
    this._repeating = ds['repeating'];
//    this._repeats = ds['repeats'];
    this._repeats = (ds['repeats'] as List)?.map((item) => item as bool)?.toList();

    Map dates = Map<String, bool>.from(ds['completedDates']);
    this.completedHabitDates = new SortedMap.from(dates, Ordering.byKey());
    this._completed = ds['completed'];
    this.experienceIncrease = calculateExperienceIncrease().toInt();
  }

  double calculateExperienceIncrease(){
    //TODO scale with streak, / times completed
    return 50.0;
  }


  bool habitRunsToday() {
    /// Whether or not the habit runs today
    int dayIndex = DateTime.now().weekday - 1;
    return _repeats[dayIndex];
  }

  List getPreviousDates(DateTime dt){
    ///
    /// Gets the previous dates from a datetime contained in the habit
    /// Returns a list of length 7.
    List<bool> list = [];
    String todayStr = Database().getDateString(dt);

    //If we have a habit for today, get all the habits that preceed it
    if(this.completedHabitDates.containsKey(todayStr)){
      String key = this.completedHabitDates.lastKeyBefore(todayStr);
      if (key==null){
        if(this.completedHabitDates[todayStr])
          list.insert(0,this.completedHabitDates[todayStr]);
        return list;
      }
      list.add(this.completedHabitDates[key]);
      int i = 0;
      while (i<10 && key!=null){
        key = this.completedHabitDates.lastKeyBefore(key);
        if(key!=null){
          list.add(this.completedHabitDates[key]);
        }
        i+=1;
      }
    }
    if(this.completedHabitDates.containsKey(todayStr))
      list.insert(0,this.completedHabitDates[todayStr]);

    return list;
  }

  List new_getPreviousDates(DateTime dt){

    String todayStr = Database().getDateString(dt);
    List<bool> list = [];
//    print(this.completedHabitDates);
    DateTime prevDate;

    int idx = this.completedHabitDates.length - 1;
    int i = 0;
//    print(dt.weekday);
//    print(this._repeats);

    /// Loop going backwards day by day
    while (i < 100 && list.length <= 7){
      /// If the habit should run on this day

      if(this._repeats[dt.weekday-1]){
        //TODO fix this to get the actual value, not just if it contains it
        if (this.completedHabitDates.containsKey(Database().getDateString(dt))){
          list.add(this.completedHabitDates[Database().getDateString(dt)]);
        }else{
          list.add(false);
        }
      }
      prevDate = DateTime(dt.year, dt.month, dt.day-1);
      i++;

      dt = prevDate;
    }
//    print(list);

    List out = List<bool>.filled(7, false);
    return list;

  }



  void completeHabit(DateTime dt) {
    /// Completes a habit on a specific date
    if(completedHabitDates.containsKey(dt)){
      completedHabitDates[dt] = true;
    }
  }


  bool isCompletedToday(){
    String key = Database().getTodayString();
    if(completedHabitDates.containsKey(key)){
      return completedHabitDates[key];
    }
    return false;
  }



  getDatabaseHabits(){

  }

  SortedMap<DateTime, bool> getCompletedHabitDates(){
    return this.completedHabitDates;
  }

  //getters and setters

  set completed(int value) {
    _completed = value;
  }

  int get completed => _completed;

  List<bool> get repeats => _repeats;

  set repeats(List<bool> value) {
    _repeats = value;
  }

  double get priority => _priority;

  int get goal => _goal;

  String get hid => _hid;

  bool get repeating => _repeating;

  String get name => _name;
}
