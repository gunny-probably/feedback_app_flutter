import 'dart:core';
import 'dart:collection';

class Course {
  String id;
  DateTime startdate;
  DateTime enddate;
  List<int> my_meetings;
  List<String> my_instrs = List<String>();
  List<String> my_stdnts = List<String>();
  Queue<int> my_rosters = Queue<int>();
  Queue<int> my_schedules = Queue<int>();
  int cur_roster = null;
  int cur_schedule = null;

  Course(this.id, this.startdate, this.enddate, String instr) {
    my_instrs.add(instr);
  }
}

class Meeting {
  int id;
  String course_id;
  int my_roster;
  int my_roster_state;
  List<String> my_stdnts = List<String>();
  List<int> my_rounds = List<int>();

  Meeting(this.id, this.course_id, this.my_roster, this.my_roster_state, this.my_stdnts, this.my_rounds);
}