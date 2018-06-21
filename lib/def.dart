import 'dart:core';
import 'dart:collection';

import 'package:tuple/tuple.dart';

class Meeting {
  int id;
  String course_id;
  int my_roster;
  int my_roster_state;
  List<String> my_stdnts;
  List<int> my_rounds;

  Meeting(this.id, this.course_id, this.my_roster, this.my_roster_state, this.my_stdnts, this.my_rounds);
}

class Round {
  Tuple2<int, int> id;
  int course_id;
  int meeting_id;
  List<String> my_stdnts;
  String speaker;
  List<String> my_responses;
  bool complete;

  Round(this.id, this.course_id, this.meeting_id, this.my_stdnts, this.speaker, this.my_responses, this.complete);
}

class Schedule {
  int id;
  String course_id;
  List<Tuple3<String, String, String>> val;

  Schedule(this.id, this.course_id, this.val);
}

class Roster {
  int id;
  String course_id;
  Map<String, Map<String, int>> val;
  int roster_state;

  Roster(this.id, this.course_id, this.val, this.roster_state);
}

class Role {
  String course_id;
  int roster_id;
  String stdnt_id;
  String val;

  Role(this.course_id, this.roster_id, this.stdnt_id, this.val);
}

class Rubric {
  int id;
  int course_id;
  int roster_id;
  Map val;

  Rubric(this.id, this.course_id, this.roster_id, this.val);
}

class Response {
  String id;
  String course_id;
  int meeting_id;
  int round_id;
  String student_id;
  int roster_id;
  int rubric_id;
  String speaker;
  Map<String, String> val;

  Response(this.id, this.course_id, this.meeting_id, this.round_id, this.roster_id, this.rubric_id, this.student_id, this.speaker, this.val);
}


