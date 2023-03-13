import '../models/habit.dart';

class User {
  /**
   * User class which contains user info and user statistics about
   *  their habit usage.
   */
  String uid;
  int completed;
  int experience;
  int daysMissed;

  ///List outlining the exp boundaries for each level
  List<int> levelBoundaries;
  int level;
  double percentNextLevel;
  bool shouldCelebrate=false;
  int daysUsed;

  /// the maximum level achieved by the user
  int maxLevel;


  User(String uid, int completed, int experience, int daysMissed, int daysUsed, int maxLevel){
    this.uid = uid;
    this.completed = completed;
    this.experience = experience;
    this.daysMissed = daysMissed;
    this.levelBoundaries = calculateLevelBoundaries();
    this.level = getUserLevel();
    this.percentNextLevel = getPercentNextLevel();
    this.daysUsed = daysUsed;
    this.maxLevel = maxLevel;
  }

  List<int> calculateLevelBoundaries(){
    /// Generate the boundaries for the levels
    /// Return a list of ints at which the user
    /// levels up based on experience (exp func)
    List<int> levelBoundaries = [];
    double multiplier = 1.05;
    int currentExp = 100;
    int sum = 0;

    for (int i = 1; i <= 100; i++){
      currentExp = (currentExp*multiplier).ceil().toInt();
      sum+=currentExp;
      levelBoundaries.add(sum);
    }
//    print(levelBoundaries);
    return levelBoundaries;
  }

  double getPercentNextLevel(){
    /// Gets the percentage towards the next level

    //Should the user celebrate? i.e. did we just level up

    if(this.experience==0){
      return 0;
    }

    this.level = this.getUserLevel();

    int expReq;
    int levelExp;
    if(this.level == 0){
      expReq = this.levelBoundaries[this.level];
      levelExp = this.experience;
    }
    else {
      expReq = this.levelBoundaries[this.level] -
          this.levelBoundaries[this.level-1];
      levelExp = this.experience - this.levelBoundaries[this.level-1];
    }
    return levelExp/expReq;
  }

  void printUser(){
    print("\nPRINTING USER");
    print(this.uid);
    print(this.completed);
    print(this.experience);
    print(this.level);
    print(this.daysMissed);
    print("\n");
  }


  bool getShouldCelebrate(){
//    print(this.experience);
//    print(this.level);
//    print(this.levelBoundaries[level]);
    return true;
  }

  int getUserLevel(){
    for (int i = 0; i < this.levelBoundaries.length; i++){
      if (this.experience < this.levelBoundaries[i]){
        return i;
      }
    }
    return 100;
  }

  int getNextLevelBoundary(){
    ///Gets the next experience boundary
    return this.levelBoundaries[level];
  }

  int getPrevLevelBoundary(){
    ///gets the previous level boundary
    if(level==0){
      return 0;
    }
    return this.levelBoundaries[level-1];
  }
  
  void addExperience(int val){
    this.experience+=val;
  }


  @override
  String toString() {
    return 'User{uid: $uid, completed: $completed, experience: $experience, daysMissed: $daysMissed, level: $level}';
  }

  int getExperience(){
    return this.experience;
  }

  int getMaxLevel(){
    /// returns the max level achieved by the user

    return this.maxLevel;
  }

}