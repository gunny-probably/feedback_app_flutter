import 'dart:core';
import 'dart:collection';

import 'package:tuple/tuple.dart';

class Meeting {
  String id;
  String course_id;
  int my_roster;
  int my_roster_state;
  List<String> my_stdnts;
  List<int> my_rounds;

  Meeting(this.id, this.course_id, this.my_roster, this.my_roster_state, this.my_stdnts, this.my_rounds);

  Meeting.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.my_roster = fields['my_roster'];
    this.my_roster_state = fields['my_roster_state'];
    this.my_stdnts = fields['my_stdnts'];
    this.my_rounds = fields['my_rounds'];
  }
}

class Round {
  String id;
  int course_id;
  int meeting_id;
  Tuple2<int, int> perm;
  List<String> my_stdnts;
  String speaker;
  List<String> my_responses;
  bool complete;

  Round(this.id, this.course_id, this.meeting_id, this.my_stdnts, this.speaker, this.my_responses, this.complete);

  Round.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.meeting_id = fields['meeting_id'];
    this.perm = fields['perm'];
    this.my_stdnts = fields['my_stdnts'];
    this.speaker = fields['speaker'];
    this.my_responses = fields['my_responses'];
    this.complete = fields['complete'];
  }
}

class Schedule {
  String id;
  String course_id;
  List<Tuple3<String, String, String>> val;

  Schedule(this.id, this.course_id, this.val);

  Schedule.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.val = fields['val'];
  }
}

class Roster {
  String id;
  String course_id;
  Map<String, Map<String, int>> val;
  int roster_state;

  Roster(this.id, this.course_id, this.val, this.roster_state);

  Roster.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.val = fields['val'];
    this.roster_state = fields['roster_state'];
  }
}

class Role {
  String id;
  String course_id;
  int roster_id;
  String stdnt_id;
  String val;

  Role(this.id, this.course_id, this.roster_id, this.stdnt_id, this.val);

  Role.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.roster_id = fields['roster_id'];
    this.stdnt_id = fields['stdnt_id'];
    this.val = fields['val'];
  }
}

class Rubric {
  String id;
  int course_id;
  int roster_id;
  Map val;

  Rubric(this.id, this.course_id, this.roster_id, this.val);

  Rubric.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.roster_id = fields['roster_id'];
    this.val = fields['val'];
  }
}

class Response {
  String id;
  String course_id;
  int meeting_id;
  int round_id;
  String stdnt_id;
  int roster_id;
  int rubric_id;
  String speaker;
  Map<String, String> val;

  Response(this.id, this.course_id, this.meeting_id, this.round_id, this.roster_id, this.rubric_id, this.stdnt_id, this.speaker, this.val);

  Response.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.meeting_id = fields['meeting_id'];
    this.round_id = fields['round_id'];
    this.stdnt_id = fields['stdnt_id'];
    this.roster_id = fields['roster_id'];
    this.rubric_id = fields['rubric_id'];
    this.speaker = fields['speaker'];
    this.val = fields['val'];
  }
}


