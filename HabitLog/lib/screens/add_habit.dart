import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class AddHabitScreenWidget extends StatefulWidget {
  @override
  AddHabitScreen createState() {
    return AddHabitScreen();
  }
}

class AddHabitScreen extends State<AddHabitScreenWidget> {
  final _formKey = GlobalKey<FormState>();

  //Form variables
  String name;
  bool repeatValue = true;
  bool useGoalCount = true;
  double sliderValue = 1;
  int goal = 30;
  double priority = 1.0;

  Widget weekdaySelector;
  Widget dateContainer = Container();
  Widget setRepeatBar;
  List<bool> weekdayValues = List.filled(7, true);

  User user;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
//      print(arguments['User']);
    }

    weekdaySelector = _getWeekdaySelector(this.repeatValue);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Create Habit"),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    this._getNameField(),
                    this._getRepeatCheckbox(),
                    this._getWeekdaySelector(this.repeatValue),
                    this._getGoalCheckbox(),
                    this._getGoalAmount(this.useGoalCount),
                    this._getPrioritySlider(),
                    this._getSubmitButton(context),
                  ],
                ))));
  }

  Container _getNameField() {
    return Container(
      child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.chevron_right),
            hintText: "Name",
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter text';
            }
            this.name = value;
            return null;
          }),
    );
  }

  Container _getRepeatCheckbox() {
    return new Container(
      child: CheckboxListTile(
          title: Text("Repeat"),
          value: repeatValue,
          onChanged: (value) {
            setState(() {
              repeatValue = value;
            });
          }),
    );
  }

  Container _getGoalCheckbox() {
    return new Container(
      child: CheckboxListTile(
          title: Text("Goal"),
          value: useGoalCount,
          onChanged: (value) {
            setState(() {
              this.useGoalCount = value;
            });
          }),
    );
  }

  Container _getSubmitButton(BuildContext context) {
    return new Container(
      child: ElevatedButton(
        onPressed: () {
          // Navigate back to the first screen by popping the current route
          // off the stack.
          if (_formKey.currentState.validate()) {
            //NOTE this is due to the week starting at sunday
            List<bool> repeatsClone = []..addAll(this.weekdayValues);
            repeatsClone.add(this.weekdayValues[0]);
            repeatsClone.removeAt(0);
            Navigator.pop(
                context,
                new Habit(this.name, this.repeatValue, repeatsClone, this.goal,
                    this.priority));
          }
        },
        child: Text('Submit'),
      ),
    );
  }

  Container _getGoalAmount(bool useGoalCount) {
    if (!useGoalCount) return Container();
    return Container(
      child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(Icons.chevron_right),
            hintText: "Goal Count",
          ),
          validator: (value) {
            if (value.isEmpty || int.tryParse(value) == null) {
              int val = int.tryParse(value);

              return 'Please enter a number';
            }
            this.goal = int.tryParse(value);
            return null;
          }),
    );
  }

  Container selectIcon() {
    return new Container();
  }

  Container dateSelector() {
    return new Container();
  }

  Container _getPrioritySlider() {
    return new Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Priority"),
      Slider(
        label: this.sliderValue.toString(),
        min: 1,
        max: 5,
        divisions: 4,
        value: this.sliderValue,
        onChanged: (double value) {
          setState(() {
            this.sliderValue = value;
          });
        },
      )
    ]));
  }

  Container _getWeekdaySelector(bool show) {
    if (!show) return Container();

    return Container(
        child: WeekdaySelector(
      firstDayOfWeek: 1,
      selectedElevation: 5.5,
      onChanged: (int day) {
        setState(() {
          final index = (day % 7);
//          print(day);

          // Use module % 7 as Sunday's index in the array is 0 and
          // DateTime.sunday constant integer value is 7.
          this.weekdayValues[index] = !this.weekdayValues[index];
//          print(this.weekdayValues);
        });
      },
      values: this.weekdayValues,
    ));
  }
}
