import 'dart:core';
import 'dart:collection';

import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import 'db.dart';

final uuid = new Uuid();

String get_id() {
  return uuid.v1();
}

class Meeting {
  String id;
  int idx;
  String course_id;
  String my_roster;
  List my_stdnts;
  List<String> my_rounds;
  DateTime starttime;
  DateTime endtime;

  Meeting({this.id,
      this.idx,
      this.course_id,
      this.my_roster,
      this.my_stdnts,
      this.my_rounds,
      this.starttime,
      this.endtime,
      local_db}) {
    write_db(this, "meetings/", db: local_db);
  }

  Meeting.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.idx = fields['idx'];
    this.course_id = fields['course_id'];
    this.my_roster = fields['my_roster'];
    this.my_stdnts = fields['my_stdnts'];
    this.my_rounds = fields['my_rounds'];
    this.starttime = fields['starttime'];
    this.endtime = fields['endtime'];
  }
}

class Round {
  String id;
  String course_id;
  String meeting_id;
  Tuple2<int, int> perm;
  List<String> my_stdnts;
  String speaker;
  List<String> my_responses;
  Map complete;
  String parent_roster;
  int roster_state;

  Round({this.id,
      this.course_id,
      this.meeting_id,
      this.perm,
      this.my_stdnts,
      this.speaker,
      this.my_responses,
      this.complete,
      this.parent_roster,
      this.roster_state,
      local_db}) {
    write_db(this, "rounds/", db: local_db);
    for (String stdnt in my_stdnts) {
      if (stdnt.compareTo(this.speaker) == 0) continue;
      this.complete[stdnt] = false;
    }
  }

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
  List<DateTime> val;

  Schedule({this.id,
      this.course_id,
      this.val,
      local_db}) {
    write_db(this, "schedules/", db: local_db);
  }

  Schedule.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.val = fields['val'];
  }
}

class Roster {
  String id;
  String course_id;
  List<Map<String, String>> val;
  int roster_state;
  List roles;
  List rubs;
  int state_cnt;

  Roster({
      this.id,
      this.course_id,
      this.val,
      this.roster_state=0,
      this.roles,
      this.rubs,
      this.state_cnt,
      local_db}) {
    write_db(this, "rosters/", db: local_db);
  }

  Roster.fromMap(Map<String, dynamic> fields) {
    if (fields["id"] != null) this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.val = fields['val'];
    this.roster_state = fields['roster_state'];
    this.roles = fields['roles'];
    this.rubs = fields['rubs'];
    this.state_cnt = fields['state_cnt'];

  }
}

class Role {
  String id;
  String course_id;
  String roster_id;
  String val;

  Role({
      this.id,
      this.course_id,
      this.roster_id,
      this.val,
      local_db}) {
    write_db(this, "roles/", db: local_db);
  }

  Role.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.course_id = fields['course_id'];
    this.roster_id = fields['roster_id'];
    this.val = fields['val'];
  }
}

class Rubric {
  String id;
  String course_id;
  String roster_id;
  Map val;

  Rubric({
      this.id,
      this.course_id,
      this.roster_id,
      this.val,
      local_db}) {
    write_db(this, "rubrics/", db: local_db);
  }

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
  String meeting_id;
  String round_id;
  String stdnt_id;
  String roster_id;
  String rubric_id;
  String speaker;
  Map<String, String> val;

  Response({this.id,
      this.course_id,
      this.meeting_id,
      this.round_id,
      this.roster_id,
      this.rubric_id,
      this.stdnt_id,
      this.speaker,
      this.val,
      local_db}) {
    write_db(this, "responses/", db: local_db);
  }

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


