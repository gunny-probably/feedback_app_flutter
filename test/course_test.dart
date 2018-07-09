import 'dart:core';

import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';
import 'package:english_words/english_words.dart';

import '../lib/course.dart';
import '../lib/exceptions.dart';
import '../lib/objects.dart';
import '../lib/users.dart';
import '../lib/db.dart';

void main() {
  group("cons", () {
    test("cons easy", () {
      Course c = Course.fromMap({
        'startdate': "2019-06-25",
        'enddate': "2019-06-25",
        'my_meetings': [],
        'my_instrs': [],
        'my_stdnts': [],
        'my_rosters': [],
        'my_schedules': [],
        'cur_roster': null,
        'cur_schedule': null,
        'env': "test"
      });
      DateTime now = new DateTime.now();
      expect(c.startdate.isAfter(now), isTrue);
      expect(c.enddate.isAfter(now), isTrue);
      expect(c.enddate.isAtSameMomentAs(c.startdate), isTrue);
    });
  });

  group("student field", () {
    test("easy", () {
      Course c = Course.fromMap({
        'startdate': "2019-06-25",
        'enddate': "2019-06-25",
        'my_meetings': [],
        'my_instrs': [],
        'my_stdnts': [],
        'my_rosters': [],
        'my_schedules': [],
        'cur_roster': null,
        'cur_schedule': null,
        'env': "test"
      });
      c.add_stdnt("jl134");
      expect(c.my_stdnts.contains("jl134"), isTrue);
      expect(c.my_stdnts.length == 1, isTrue);
      expect(c.get_stdnt("jl134") == "jl134", isTrue);
      try {
        c.get_stdnt("jhp4");
      } catch (DataException) {
        print("DataException caught --- cannot get jhp4");
      }
    });
  });

  group("*_roster()", () {
    test("easy", () {
      Course c = Course.fromMap({
        'startdate': "2019-06-25",
        'enddate': "2019-06-25",
        'my_meetings': [],
        'my_instrs': [],
        'my_stdnts': [],
        'my_rosters': [],
        'my_schedules': [],
        'cur_roster': null,
        'cur_schedule': null,
        'env': "test"
      });
      c.set_roster("roster_rand");
      expect(c.cur_roster.compareTo("roster_rand") == 0, isTrue);
    });
  });

  group("*_schedule()", () {
    test("easy", () {
      Course c = Course.fromMap({
        'startdate': "2019-06-25",
        'enddate': "2019-06-25",
        'my_meetings': [],
        'my_instrs': [],
        'my_stdnts': [],
        'my_rosters': [],
        'my_schedules': [],
        'cur_roster': null,
        'cur_schedule': null,
        'env': "test"
      });
      c.set_schedule("schedule_rand");
      expect(c.cur_schedule.compareTo("schedule_rand") == 0, isTrue);
    });
  });

  group("generate_rounds", () {
    test("easy", () {
      Map local_db = {};
      var mock_groups = [
        [
          "ben",
          "demetrie",
          "benito"
        ],
        [
          "ani",
          "tian"
        ]
      ];
      var meeting_id = get_id();
      Course c = Course(
        startdate: DateTime.parse("2019-06-25"),
        enddate: DateTime.parse("2019-06-25"),
        my_meetings: [],
        my_instrs: [],
        my_stdnts: [],
        my_rosters: [],
        my_schedules: [],
      );
      List<Round> rounds = c.generate_rounds(mock_groups, meeting_id, null).map((elem) {
        read_db(elem, "rounds/", db: local_db);
      }).toList();
      assert(rounds[0].speaker.compareTo("ben") == 0);
      assert(rounds[0].perm == Tuple2(0, 0));
      assert(rounds[1].speaker.compareTo("demetrie") == 0);
      assert(rounds[1].perm == Tuple2(0, 1));
      assert(rounds[2].speaker.compareTo("benito") == 0);
      assert(rounds[2].perm == Tuple2(0, 2));
      assert(rounds[3].speaker.compareTo("ani") == 0);
      assert(rounds[3].perm == Tuple2(1, 0));
      assert(rounds[4].speaker.compareTo("tian") == 0);
      assert(rounds[4].perm == Tuple2(1, 1));
      for (int i = 0; i < 3; i++) {
        assert(rounds[i].my_stdnts.contains("ben"));
        assert(rounds[i].my_stdnts.contains("demetrie"));
        assert(rounds[i].my_stdnts.contains("benito"));
      }
      for (int i = 3; i < 5; i++) {
        assert(rounds[i].my_stdnts.contains("ani"));
        assert(rounds[i].my_stdnts.contains("tian"));
      }
    });
  });
  
  group("assign roles and generate groups", ()
  {
    test("easy", () {
      Map local_db = {};
      /* get a 5 states by 5 roles roster -> needs 5 rubrics.
         apply this to fake class of 100 students */
      Course c = Course();
      const STDNTS_CNT = 100;
      const ROLES_CNT = 5;
      const RUBS_CNT = 5;
      const STATES_CNT = 5;
      for (int i = 0; i < STDNTS_CNT; i++) {
        String new_id = get_id();
        Stdnt(id: new_id, local_db: local_db);
        c.my_stdnts.add(new_id);
      }
      List<String> roles = [];
      for (int i = 0; i < ROLES_CNT; i++) {
        String new_id = get_id();
        roles.add(new_id);
        Role(id: new_id, val: "role_$i", local_db: local_db);
      }
      List<String> rubs = [];
      for (int i = 0; i < RUBS_CNT; i++) {
        String new_id = get_id();
        rubs.add(new_id);
        Rubric(id: new_id, val: {"rating": i, "comments": null}, local_db: local_db);
      }
      List<Map<String, String>> _ros = [];
      for (int i = 0; i < STATES_CNT; i++) { // states
        Map<String, String> row = {};
        for (int j = 0; j < ROLES_CNT; j++) { // roles
          row.addAll({roles[j]: rubs[(j + i) % 5]});
        }
        _ros.add(row);
      }
      String ros_id = get_id();
      Roster(id: ros_id, val: _ros, roles: roles, rubs: rubs, state_cnt: STATES_CNT);
      c.my_rosters.add(ros_id);
      c.cur_roster = ros_id;
      c.my_stdnts_roles.addAll({ros_id: c.assign_roles(roles, c.my_stdnts)});
      //var group_coll = c.generate_groups(c.my_stdnts, ros.id, ros);
      for (var stdnt in c.my_stdnts) {
        expect(c.my_stdnts_roles[ros_id].containsKey(stdnt), isTrue);
      }
      c.my_stdnts_roles[ros_id].forEach((k, v) {
        expect(v, isNotNull);
      });
      Roster ros = read_db(c.cur_roster, "rosters/", db: local_db);
      for (var role in ros.roles) {
        var cnt = 0;
        for (var m_role in c.my_stdnts_roles[ros_id].values) {
          if (role.compareTo(m_role) == 0) cnt++;
        }
        expect(cnt == 20, isTrue);
      }
      print("Trace --- before generate_groups()");
      // generate round
      List<List<String>> group_coll = c.generate_groups(c.my_stdnts, c.cur_roster, local_db: local_db);
      var i = 0;
      while (i < group_coll.length) {
        expect(group_coll[i].length == 5, isTrue);
        for (var role in ros.roles) {
          bool role_filled = group_coll[i].any((stdnt) =>
            c.my_stdnts_roles[c.cur_roster][stdnt].compareTo(role) == 0);
          expect(role_filled, isTrue);
        }
        i++;
      }
    });
  });

  group("ops", () {
    test("easy", ()
    {
      Map<String, List<dynamic>> local_db = {};
      String course_id = get_id();
      String stdnt_1_id = get_id();
      String stdnt_2_id = get_id();
      String role_1_id = get_id();
      String role_2_id = get_id();
      String rub_1_id = get_id();
      String rub_2_id = get_id();
      String ros_1_id = get_id();
      String sch_id = get_id();
      Course c = Course(
        id: course_id,
        startdate: DateTime.parse("2019-08-17"),
        enddate: DateTime.parse("2019-08-17"),
        my_meetings: [],
        my_instrs: [],
        my_stdnts: [],
        my_rosters: [],
        my_schedules: [],
        local_db: local_db);
      Roster ros_1 = Roster(
        id: ros_1_id,
        course_id: c.id,
        val: [{
            role_1_id: rub_1_id,
            role_2_id: rub_2_id},
          {
            role_1_id: rub_2_id,
            role_2_id: rub_1_id}],
        local_db: local_db);
      Role role_1 = Role(
        id: role_1_id,
        course_id: c.id,
        roster_id: ros_1.id,
        local_db: local_db
      );
      Role role_2 = Role(
        id: role_2_id,
        course_id: c.id,
        roster_id: ros_1.id,
        local_db: local_db
      );
      Rubric rub_1 = Rubric(
        id: rub_1_id,
        course_id: c.id,
        roster_id: ros_1.id,
        val: {
          "rating": {
            1: false,
            2: false,
            3: false},
          "comments": null},
        local_db: local_db);
      Rubric rub_2 = Rubric(
        id: rub_2_id,
        course_id: c.id,
        roster_id: ros_1.id,
        val: {
          "rating": {
            8: false,
            9: false,
            10: false},
          "remarks": null},
        local_db: local_db
      );
      Stdnt stdnt_1 = Stdnt(
        id: stdnt_1_id,
        first_name: "Demetrie",
        last_name: "Luke",
        netid: "dl112",
        local_db: local_db);
      Stdnt stdnt_2 = Stdnt(
        id: stdnt_2_id,
        first_name: "Ben",
        last_name: "Herndon-Miller",
        netid: "bhm4",
        local_db: local_db);
      c.my_stdnts.add(stdnt_1_id);
      c.my_stdnts.add(stdnt_2_id);
      c.my_rosters.add(ros_1.id);
      c.cur_roster = ros_1.id;
      c.my_stdnts_roles[ros_1.id] = {
        stdnt_1_id: role_1_id,
        stdnt_2_id: role_2_id};
      Schedule sch_1 = Schedule(
        id: sch_id,
        course_id: c.id,
        val: [DateTime.now().add(new Duration(hours: 10))],
        local_db: local_db);
      c.my_schedules.add(sch_1);
      c.cur_schedule = sch_1.id;
      String instr_1_id = get_id();
      Instr instr_1 = Instr(
        id: instr_1_id,
        first_name: "benito",
        last_name: "aranda-comer",
        netid: "bac14",
        local_db: local_db
      );
      c.my_instrs.add(instr_1_id);
      String meeting_id = get_id();
      print(local_db["rosters/"][0].id);
      c.generate_meeting({
        "id": meeting_id,
        "starttime": DateTime.now().add(new Duration(hours: 10)),
        "endtime": DateTime.now().add(new Duration(hours: 11))
      }, local_db: local_db);
      var meeting_obj = read_db(meeting_id, "meetings/", db: local_db);
      expect(meeting_obj.id == meeting_id, isTrue);
      expect(meeting_obj.my_rounds.length == 2, isTrue);
    });
    
    test("medium stress", ()  // see chicago sunday test design
    {
      Map<String, List> local_db = {};
      String course_id = get_id();
      Course c = Course(
          id: course_id,
          startdate: DateTime.parse("2019-08-17"),
          enddate: DateTime.parse("2019-08-17"),
          my_meetings: [],
          my_instrs: [],
          my_stdnts: [],
          my_rosters: [],
          my_schedules: [],
          local_db: local_db);
      for (var i = 0; i < 100; i++) {
        String stdnt_id = get_id();
        var wordPair = generateWordPairs().take(
            1); // first, last names are not necessarily unioque
        Stdnt new_stdnt = Stdnt(id: stdnt_id,
            first_name: wordPair.first.first,
            last_name: wordPair.first.second,
            netid: get_id(),
            my_courses: [c],
            my_meetings: [],
            my_rounds: [],
            made_responses: [],
            received_responses: [],
            local_db: local_db);
        c.my_stdnts.add(stdnt_id);
      }
      String ros_id = get_id();
      List<String> role_ids = [];
      for (var i = 0; i < 5; i++) {
        String role_id = get_id();
        var wordPair = generateWordPairs().take(1);
        Role role = Role(id: role_id,
            course_id: c.id,
            roster_id: ros_id,
            val: wordPair.first.first,
            local_db: local_db);
        role_ids.add(role_id);
      }
      List<String> rub_ids = [];
      for (var i = 0; i < 5; i++) {
        String rub_id = get_id();
        var wordPair = generateWordPairs().take(1);
        Rubric rub = Rubric(id: rub_id,
            course_id: c.id,
            roster_id: ros_id,
            val: {wordPair.first.first: wordPair.first.second},
            local_db: local_db);
        rub_ids.add(rub_id);
      }
      List<Map<String, String>> ros_val = [];
      for (var i = 0; i < 5; i++) {
        Map<String, String> _row = {role_ids[0]: rub_ids[i],
          role_ids[1]: rub_ids[(i - 1) % 5],
          role_ids[2]: rub_ids[(i - 2) % 5],
          role_ids[3]: rub_ids[(i - 3) % 5],
          role_ids[4]: rub_ids[(i - 4) % 5]};
        ros_val.add(_row);
      }
      Roster ros = Roster(id: ros_id,
          course_id: c.id,
          val: ros_val,
          roles: role_ids,
          rubs: rub_ids,
          state_cnt: 5,
          local_db: local_db);
      String instr_id = get_id();
      var wordPair = generateWordPairs().take(1);
      Instr instr = Instr(id: instr_id,
          first_name: wordPair.first.first,
          last_name: wordPair.first.second,
          netid: get_id(),
          my_courses: [c.id],
          local_db: local_db);
      c.my_stdnts_roles[ros.id] = c.assign_roles(role_ids.map((id) => read_db(id, "roles/", db:local_db)).toList(), c.my_stdnts);
      c.cur_roster = ros.id;
      for (var i = 0; i < 5; i++) {
        String meeting_id = get_id();
        c.generate_meeting({
          "id": meeting_id,
          "starttime": DateTime.now().add(new Duration(hours: i+1)),
          "endtime": DateTime.now().add(new Duration(hours: i+2))
        }, local_db: local_db);
        c.my_meetings.add(meeting_id);
      }
      // create all mock responses
      Roster ros_grab = read_db(c.cur_roster, "rosters/", db: local_db);
      for (String meeting_id in c.my_meetings) {
        Meeting meeting = read_db(meeting_id, "meetings/", db: local_db);
        for (String round_id in meeting.my_rounds) {
          Round round = read_db(round_id, "rounds/", db: local_db);
          for (String stdnt_id in round.my_stdnts) {
            String correct_role = c.my_stdnts_roles[c.cur_roster][stdnt_id];
            if (stdnt_id != round.speaker) {
              String correct_rub;
              for (var kv in ros_grab.val[(round.roster_state)].entries) {
                if (kv.key == correct_role) {
                  correct_rub = kv.value;
                }
              }
              Stdnt grader = read_db(stdnt_id, "stdnts/", db: local_db);
              Rubric rub = read_db(correct_rub, "rubrics/", db: local_db);
              var ans = <String, String>{};
              for (var kv in rub.val.entries) {
                var wordPair = generateWordPairs().take(1);
                ans[kv.key] = wordPair.first.first; // random answer for survey
              }
              grader.create_response(
                  ans, rub.id, c.id, meeting.id, round.id, round.speaker, local_db: local_db);
            }
          }
        }
      }
      expect(local_db["responses/"].length == 2000, isTrue);
      for (var stdnt_grab in local_db["stdnts/"]) {
        expect(stdnt_grab.made_responses.length == 4 * 5, isTrue);
        expect(stdnt_grab.received_responses.length == 4 * 5, isTrue);
      }
      for (var rubric_grab in local_db["rubrics/"]) {
        var cnt = 0;
        for (var resp_grab in local_db["responses/"]) {
          if (resp_grab.rubric_id == rubric_grab.id) cnt++;
        }
        expect(cnt == 400, isTrue);
      }
    });
  });
}