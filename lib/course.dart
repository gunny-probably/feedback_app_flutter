import 'dart:core';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import 'users.dart';
import 'objects.dart';
import 'db.dart';
import 'exceptions.dart';
import 'simple.dart';

final uuid = new Uuid();

class Course {
  String id;
  String name;
  DateTimeSimple startdate;
  DateTimeSimple enddate;
  List my_meetings;// = [];
  List my_instrs;// = [];
  List my_stdnts;// = [];
  List my_rosters;// = [];
  List my_schedules;// = [];
  String cur_roster;
  String cur_schedule;
  Map<String, Map<String, String>> my_stdnts_roles ={};

  Course({this.id,
      this.name,
      this.startdate,
      this.enddate,
      this.my_meetings,
      this.my_instrs,
      this.my_stdnts,
      this.my_rosters,
      this.my_schedules,
      this.cur_roster,
      this.cur_schedule,
      local_db}) {
    write_db(this, "courses/", db: local_db);
    for (var stdnt_id in my_stdnts) {
      Stdnt course_stdnt = read_db(stdnt_id, "stdnts/", db: local_db);
      course_stdnt.my_courses.add(this.id);
      write_db(course_stdnt, "stdnts/", db: local_db);
    }
  }

  Course.fromMap(Map<String, dynamic> fields) {
    // TODO this should never accept corrupt data. refactor after main cos is done
    this.id = fields["id"];
    this.name = fields["name"];
    this.startdate = DateTime.parse(fields['startdate']);
    this.enddate = DateTime.parse(fields['enddate']);
    this.my_meetings = fields['my_meetings'];
    this.my_instrs = fields['my_instrs'];
    this.my_stdnts = fields['my_stdnts'];
    this.my_rosters = fields['my_rosters'];
    this.my_schedules = fields['my_schedules'];
    this.cur_roster = fields['cur_roster'];
    this.cur_schedule = fields['cur_schedule'];
    this.my_stdnts_roles = fields['my_stdnts_roles'];
  }

  void add_stdnt(String new_stdnt) {
    my_stdnts.add(new_stdnt);
  }

  String get_stdnt(String targ_stdnt) {
    /*
     Don't need to go into db
     */
    if (this.my_stdnts.contains(targ_stdnt)) {
      return targ_stdnt;
    }
    throw new DataException(targ_stdnt + " is missing");
  }

  void set_roster(String new_roster) {
    this.cur_roster = new_roster;
  }

  void set_schedule(String new_schedule) {
    cur_schedule = new_schedule;
  }

  String get_schedule() => cur_schedule;

  dynamic generate_meeting(Map<String, dynamic> meeting_cons, {local_db}) {
    final DateTime now = new DateTime.now();
    assert(meeting_cons['starttime'].isAfter(now));
    assert(meeting_cons['endtime'].isAfter(now));
    assert(meeting_cons['starttime'].isBefore(meeting_cons['endtime']));
    for (var stndt_id in my_stdnts) {
      Stdnt stdnt_grab = read_db(stndt_id, "stdnts/", db: local_db);
      stdnt_grab.my_meetings.add(meeting_cons["id"]);
      write_db(stdnt_grab, "stdnts/", db: local_db);
    }
    List<List<String>> disjoint_groups = generate_groups(this.my_stdnts, this.cur_roster, local_db: local_db);
    Roster ros = read_db(this.cur_roster, "rosters/", db: local_db);
    List<dynamic> rounds = generate_rounds(disjoint_groups, meeting_cons['id'], ros.roster_state, local_db: local_db);
    ros.roster_state++;
    write_db(ros, "rosters/", db: local_db);
    meeting_cons.addAll({
      'course_id': this.id,
      'my_roster': this.cur_roster,
      'my_stdnts': this.my_stdnts,
      'my_rounds': rounds,
      'idx': 0,
    });
    final meeting = Meeting.fromMap(meeting_cons);
    write_db(meeting, "meetings/", db: local_db);
    return meeting.id;
  }

  List<List<String>> generate_groups(List stdnts, String roster_id,
      {local_db}) {
    final Roster roster = read_db(roster_id, "rosters/", db: local_db);
    List<List<String>> group_collection = [];
    List stdnts_cpy = [];
    for (var stdnt in stdnts) stdnts_cpy.add(stdnt);
    stdnts_cpy.shuffle();
    while (stdnts_cpy.isNotEmpty) {
      List<String> new_group = [];
      for (var kv in roster.val[roster.roster_state].entries) {  // group assignment is unbroken and continuous
        if (stdnts_cpy.isEmpty) break;
        var targ_stdnt = stdnts_cpy.firstWhere((elem) => this.my_stdnts_roles[cur_roster][elem] == kv.key);
        new_group.add(targ_stdnt);
        stdnts_cpy.remove(targ_stdnt);
      }
      group_collection.add(new_group);
    }
    return group_collection;
  }

  List<String> generate_rounds(List<List<String>> groups, String meeting_id, int cur_roster_state, {local_db}) {
    List<String> round_collection = [];
    for (int i = 0; i < groups.length; i++) {
      for (int j = 0; j < groups[i].length; j++) {
        final String round_id = get_id();
        Round round = Round(
          id: round_id,
          course_id: this.id,
          meeting_id: meeting_id,
          perm: Tuple2<int, int>(i, j),
          my_stdnts: groups[i],
          speaker: groups[i][j],  // varies each j
          my_responses: [],
          complete: {},
          parent_roster: this.cur_roster, roster_state: cur_roster_state,
          local_db: local_db
        );
        round_collection.add(round_id);
        for (var stdnt_id in groups[i]) {
          Stdnt stdnt = read_db(stdnt_id, "stdnts/", db: local_db);
          stdnt.my_rounds.add(round_id);
          write_db(stdnt, "stdnts/", db: local_db);
        }
      }
    }
    return round_collection;
  }

  Map<String, String> assign_roles(List roles, List stndts) {
    /*
     Unit assignment function. List of roles
     */
    Map<String, String> assigned = {};
    var i = 0;
    stndts.shuffle();
    for (var stdnt in stndts) {
      assigned.addAll({stdnt: roles[i]});
      i = (i + 1) % roles.length;
    }
    return assigned;
  }
}