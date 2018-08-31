import 'dart:core';

import 'package:test/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../lib/course.dart';
import '../lib/db.dart';
import '../lib/objects.dart';
import '../lib/users.dart';
import '../lib/simple.dart';

void makeMockDataCloud(Map ids, Firestore db) {
  Stdnt stdnt_1 = Stdnt(
      id: ids["stdnt_1"],
      first_name: "Demetrie",
      last_name: "Luke",
      netid: "dl112",
      my_courses: [],
      my_meetings: [],
      my_rounds: [],
      db: db);
  Stdnt stdnt_2 = Stdnt(
      id: ids["stdnt_2"],
      first_name: "Ben",
      last_name: "Herndon-Miller",
      netid: "bhm4",
      my_courses: [],
      my_meetings: [],
      my_rounds: [],
      db: db);
  Course course = Course(id: ids["course"], startdate: DateTimeSimple(2018, 8, 12), enddate: DateTimeSimple(2018, 9, 12),
      name: "BUSI 296", my_meetings: [], my_instrs: [ids["instr"]], my_rosters: [ids["ros_1"]], my_schedules: [], my_stdnts: [ids["stdnt_1"], ids["stdnt_2"]],
      cur_roster: ids["ros_1"]);
  Instr instr = Instr(id: ids["instr"], first_name: "Benito", last_name: "Aranda-Comer", my_courses: [ids["course"]], netid: 'bad180');
  Roster ros_1 = Roster(
      id: ids["ros_1"],
      course_id: ids["course"],
      val: [{
        ids["role_1"]: ids["rub_1"],
        ids["role_2"]: ids["rub_2"]},
      {
        ids["role_1"]: ids["rub_2"],
        ids["role_2"]: ids["rub_1"]}]);
  Role role_1 = Role(
      id: ids["role_1"],
      course_id: ids["course"],
      roster_id: ids["ros_1"]);
  Role role_2 = Role(
      id: ids["role_2"],
      course_id: ids["course"],
      roster_id: ids["ros_1"]);
  Rubric rub_1 = Rubric(
      id: ids["rub_1"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      val: {
        "rating": [1, 2, 3],
        "comments": "input"});
  Rubric rub_2 = Rubric(
      id: ids["rub_2"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      val: {
        "rating": [8, 9, 10],
        "remarks": "input"});
  course.cur_roster = ids["ros_1"];
  course.my_stdnts_roles[course.cur_roster] = course.assign_roles([ids["role_1"], ids["role_2"]], [ids["stdnt_1"], ids["stdnt_2"]]);
  course.generate_meeting({
    "id": ids["meeting"],
    "starttime": DateTime.now().add(new Duration(hours: 10)),
    "endtime": DateTime.now().add(new Duration(hours: 11))
  });
  write_db(course, "courses/");
}

void main() {
  group("write", () {
    test("test_wdata_easy", () async {
      final FirebaseApp app = await FirebaseApp.configure(
        name: 'test',
        options: const FirebaseOptions(
          googleAppID: '1:816235742025:android:05c0b70e29f1222e',
          gcmSenderID: '816235742025',
          apiKey: 'AIzaSyBRsYw63TVM7zmJVR8WepZyTe5WgcvO47w',
          projectID: 'feedback-app-cloud',
        ),
      );
      final Firestore firestore = new Firestore(app: app);

      String stdnt_1_id = get_id();
      String stdnt_2_id = get_id();
      String role_1_id = get_id();
      String role_2_id = get_id();
      String rub_1_id = get_id();
      String rub_2_id = get_id();
      String ros_1_id = get_id();
      String sch_id = get_id();
      String course_id = get_id();
      String instr_id = get_id();
      String meeting_id = get_id();
      Map kwargs = {
        "stdnt_1": stdnt_1_id,
        "stdnt_2": stdnt_2_id,
        "role_1": role_1_id,
        "role_2": role_2_id,
        "rub_1": rub_1_id,
        "rub_2": rub_2_id,
        "ros_1": ros_1_id,
        "sch": sch_id,
        "course": course_id,
        "instr": instr_id,
        "meeting": meeting_id
      };
      makeMockDataCloud(kwargs, firestore);

    });
  });
}