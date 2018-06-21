import 'dart:core';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'users.dart';

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

  void set_stdnt(String new_stdnt) {
    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (courseSnapshot.exists) {
        await tx.update(courseRef, {
          'my_stdnts': courseSnapshot.data[my_stdnts].append(new_stdnt),
        });
        return;
      }
      throw new Exception('Course set_stdnt --- Transaction failed --- Trace');
    });
  }

  Stdnt get_stdnt(String targ_stdnt) {
    final DocumentReference courseRef = Firestore.instance.document('courses/' + id);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot courseSnapshot = await tx.get(courseRef);
      if (courseSnapshot.exists) {
        if (courseSnapshot.data[my_stdnts].contains(targ_stdnt)) {
          final DocumentReference stdntRef = Firestore.instance.document('stdnts/' + targ_stdnt);
          Firestore.instance.runTransaction((Transaction tx) async {
            DocumentSnapshot stdntSnapshot = await tx.get(stdntRef);
            return Stdnt.fromJson(stdntSnapshot.data);
          });
        }
      }
      throw new Exception('Course get_stdnt --- Transaction failed --- Trace');
    });
  }
}