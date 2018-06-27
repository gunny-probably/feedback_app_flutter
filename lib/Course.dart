import 'dart:core';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

import 'users.dart';
import 'objects.dart';
import 'Firebase.dart';

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
  List<Map<String, int>> my_stdnts_roles = [];

  Course(this.id, this.startdate, this.enddate, String instr) {
    my_instrs.add(instr);

    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (!courseSnapshot.exists) {
        await tx.set(courseRef, {
          'id': id,
          'startdate': startdate,
          'enddate': enddate,
          'my_meetings': my_meetings,
          'my_instrs': my_instrs,
          'my_stdnts': my_stdnts,
          'my_rosters': my_rosters,
          'my_schedules': my_schedules,
          'cur_roster': cur_roster,
          'cur_schedule': cur_schedule
        });
        return;
      }
      throw new Exception('Course cons --- Transaction failed --- Trace');
    });
  }

  Course.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.startdate = DateTime.parse(fields['startdate']);
    this.enddate = DateTime.parse(fields['enddate']);
    this.my_meetings = fields['my_meetings'];
    this.my_instrs = fields['my_instrs'];
    this.my_stdnts = fields['my_stdnts'];
    this.my_rosters = fields['my_rosters'];
    this.my_schedules = fields['my_schedules'];
    this.cur_roster = fields['cur_roster'];
    this.cur_schedule = fields['cur_schedule'];
  }

  void add_stdnt(String new_stdnt) {
    my_stdnts.add(new_stdnt);

    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (courseSnapshot.exists) {
        await tx.update(courseRef, {
          'my_stdnts': courseSnapshot.data[my_stdnts].append(new_stdnt),
        });
        return;
      }
    });
    throw new Exception('Course set_stdnt --- Transaction failed --- Trace');
  }

  Stdnt get_stdnt(String targ_stdnt) {
    /*
     Don't need to go into db
     */
    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (courseSnapshot.exists) {
        if (courseSnapshot.data[my_stdnts].contains(targ_stdnt)) {
          final DocumentReference stdntRef = Firestore.instance.document('stdnts/' + targ_stdnt);
          Firestore.instance.runTransaction((Transaction tx) async {
            DocumentSnapshot stdntSnapshot = await tx.get(stdntRef);
            return Stdnt.fromMap(stdntSnapshot.data);
          });
        }
      }
    });
    throw new Exception('Course get_stdnt --- Transaction failed --- Trace');
  }

  void set_roster(int new_roster) {
    cur_roster = new_roster;

    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (courseSnapshot.exists) {
        await tx.update(courseRef, {
          'cur_roster': new_roster,
        });
        return;
      }
    });

    throw new Exception('Course method set_roster --- Transaction failed --- Trace');
  }

  int get_roster() => cur_roster;

  void set_schedule(int new_schedule) {
    cur_schedule = new_schedule;

    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (courseSnapshot.exists) {
        await tx.update(courseRef, {
          'cur_schedule': new_schedule,
        });
        return;
      }
    });
    throw new Exception('Course set_schedule --- Transaction failed --- Trace');
  }

  int get_schedule() => cur_schedule;

  int generate_meeting(Map<String, dynamic> meeting_cons) {
    final meeting_id = get_new_id('meetings');  // not imp
    final DateTime now = new DateTime.now();
    assert(DateTime.parse(meeting_cons['starttime']).isAfter(now));
    assert(DateTime.parse(meeting_cons['endtime']).isAfter(now));
    assert(DateTime.parse(meeting_cons['starttime']).isAfter(DateTime.parse(meeting_cons['endtime'])));
    List<List<String>> disjoint_groups = generate_groups(this.my_stdnts, this.cur_roster);  // not imp
    List<int> rounds = generate_rounds(disjoint_groups, meeting_id);
    meeting_cons.addAll({
      'id' : meeting_id,
      'course_id': this.id,
      'my_roster': this.cur_roster,
      'my_stdnts': this.my_stdnts,
      'my_rounds': rounds,
    });
    final meeting = Meeting.fromMap(meeting_cons);  // dumped to db. not imp
    inc_roster_state(this.cur_roster);  // not imp
    return meeting_id;
  }

  List<List<String>> generate_groups(List<String> stdnts, int roster_id) {
    final Roster roster = read_cloudfs('rosters/', roster_id);
    List<List<String>> group_collection = [];
    while (stdnts.isNotEmpty) {
      List<String> new_group = [];
      for (var kv in roster.val.values.toList()) {  // group assignment is unbroken and continuous
        if (stdnts.isEmpty) break;
        new_group.add(stdnts.firstWhere((elem) => my_stdnts_roles[cur_roster][elem] == kv.keys.first));
      }
      group_collection.add(new_group);
    }
    return group_collection;
  }

  List<int> generate_rounds(List<List<String>> groups, int meeting_id) {
    List<int> round_collection = [];
    for (int i = 0; i < groups.length; i++) {
      for (int j = 0; j < groups[i].length; j++) {
        final int round_id = get_new_id('rounds/');
        round_collection.add(round_id);
        Round.fromMap({
          'id': round_id,
          'course_id': this.id,
          'meeting_id': meeting_id,
          'perm': Tuple2<int, int>(i, j),
          'my_stdnts': groups[i],
          'speaker': groups[i][j],  // varies each j
          'responses': [],
          'complete': false
        });
      }
    }
    return round_collection;
  }


}