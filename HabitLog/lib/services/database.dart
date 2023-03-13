import 'package:flutter/widgets.dart';

import '../models/habit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart';
import 'package:intl/intl.dart';


class Database {

  /// File for any database work
  /// is a singleton containing the User class and any other static information

  static final Database _database = Database._internal();
  bool first = true;
  User user;
  var userCollection;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  Map<int, Habit> selectedHabits = {};
  List<Habit> cachedHabits = [];
  List<Habit> habits = [];

  factory Database() {
    return _database;
  }

  initFirebaseUser(){
    /**
     * Initializes the
     */
  }

  void databaseConstructor() {
    if (_database.first) {
      _database.first = false;
      var date = new DateTime.now();
    }
  }

  void databaseDestructor(){
    first = true;
    selectedHabits = {};
    cachedHabits = [];
    habits = [];
  }

  void deleteSelectedHabits(){
    for (Habit habit in this.selectedHabits.values){
      this.userCollection.document(this.user.uid).collection('habits').document(habit.hid).delete();
    }
    this.selectedHabits = Map();
  }

  void updateAllHabits() async{
    QuerySnapshot querySnapshot = await this.userCollection.document(this.user.uid).collection('habits').getDocuments();
    var list = querySnapshot.documents;
    for (var ds in list.toList()){
      this.cachedHabits.add(Habit.fromDb1(ds));
    }
//    print(cachedHabits.length);
  }

  void createHabitCollection(String uid, Habit habit){
    /**
     * Creates a collection
     */
    this.userCollection.document(uid).collection('habits').add({
      'name': habit.name,
      'repeating': habit.repeating,
      'repeats':habit.repeats,
      'goal':habit.goal,
      'completed':habit.completed,
      'priority':habit.priority,
      'time': DateTime.now(),
      'completedDates':habit.completedHabitDates,
      'isCompleted':false,
    });
  }

  Future setLocalUser(String uid) async {
    /// Gets the user info
    int completed;
    int experience;
    int daysMissed;
    int daysUsed;
    int maxLevel;
    ///Create a user
    this.setupUserCollection();
    DocumentSnapshot doc = await this.userCollection.document(uid).get();

    experience = doc['experience'];
    daysMissed = doc['daysMissed'];
    completed = doc['completed'];
    daysUsed = doc['daysUsed'];
    maxLevel = doc['maxLevel'];

    //Need to force a single instance of the user

    this.user = User(uid, completed, experience, daysMissed, daysUsed, maxLevel);
    print("[L] Setting local user " + uid);
  }

  User getLocalUser(){
    return this.user;
  }

  String getUid(){
    return this.user.uid;
  }

  void setupUserCollection(){
    this.userCollection = Firestore.instance.collection("users");
  }

  void generateFirebaseUserInfo(String uid){
    /// Instantiates the user in the db
    /// This only occurs once, when the user is first added
    this.setupUserCollection();
    userCollection.document(uid).setData(
      {
        "completed":0,
        "experience":0,
        "daysUsed":0,
        "daysMissed": 0,
        "maxLevel":0
      },
    );
  }

  void updateCompletedToday(String uid, Habit habit, bool val){
    /// Updates the completed state of a habit in the database
    /// uid - user id
    /// Habit habit
    /// val from the switch -> completed or not
    bool isCompleted = false;
    if(habit.completed >= habit.goal){
      isCompleted = true;
    }

    int level = getLocalUser().getUserLevel();

    habit.completedHabitDates[Database().getTodayString()] = val;
    this.userCollection.document(uid).collection('habits').document(habit.hid).updateData({
      "completedDates." + Database().getTodayString() : val,
      "completed" : habit.completed,
      "isCompleted" : isCompleted,
    });
    this.userCollection.document(uid).updateData({
      "completedDates." + Database().getTodayString() : val,
    });
    // If the user completes a habit today,
    
    if(val){
      this.user.addExperience(habit.calculateExperienceIncrease().toInt());
      this.userCollection.document(uid).updateData({
      "experience":this.user.experience,
      });
    }else{
      this.user.addExperience(-habit.calculateExperienceIncrease().toInt());
      this.userCollection.document(uid).updateData({
      "experience":this.user.experience,
      });
    }

    if (level > getLocalUser().maxLevel){
      this.userCollection.document(uid).updateData({
        "maxLevel":level,
      });
    }


  }

  Database._internal();

  void printDatabaseHabit(){

  }

  Future getTodaysHabits(String uid) async {
    QuerySnapshot querySnapshot = await this.userCollection.document(uid).collection('habits').getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
    }
  }

  Stream<QuerySnapshot> getFrontPageSnapshot(User user){
    /**
     * Gets the snapshot for the front page habit list, only returns
     * habits which are not completed
     */
    return database.userCollection.document(user.uid).collection('habits').where('isCompleted', isEqualTo: false).snapshots();
  }

  Habit addHabit(Habit habit) {
    habits.add(habit);
    return habit;
  }

  DateTime getToday(){
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  String getTodayString(){
    DateTime today = DateTime.now();
    return this.getDateString(DateTime(today.year, today.month, today.day));
  }

  List<Habit> getHabits() {
    return this.habits;
  }

  String getDateString(DateTime dt) {
    return dateFormat.format(dt);
  }

  DateTime getDateTimeFromStr(String dt){
    return dateFormat.parse(dt);
  }

  static Database get database => _database;
}
