import 'objects.dart';
import 'course.dart';
import 'db.dart';

class Stdnt {
  String id;  // not natural
  String first_name;
  String last_name;
  String netid;
  List my_courses; // = [];
  List my_meetings; // = [];
  List my_rounds; // = [];
  List made_responses; // = [];
  List received_responses; // = [];

  Stdnt({this.id,
      this.first_name,
      this.last_name,
      this.netid,
      this.my_courses,
      this.my_meetings,
      this.my_rounds,
      this.made_responses,
      this.received_responses,
      local_db}) {
    write_db(this, "stdnts/", db: local_db);
  }

  // json, map cons
  Stdnt.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.first_name = fields['first_name'];
    this.last_name = fields['last_name'];
    this.netid = fields['netid'];
    this.my_courses = fields['my_courses'];
    this.my_meetings = fields['my_meetings'];
    this.my_rounds = fields['my_rounds'];
    this.made_responses = fields['made_responses'];
    this.received_responses = fields["received_responses"];
  }

  void create_response(Map<String, String> ans,
      String rubric_id,
      String course_id,
      String meeting_id,
      String round_id,
      String speaker_id,
      {Map local_db}) {
    assert(speaker_id != this.id);
    Rubric rub = read_db(rubric_id, "rubrics/",
        db: local_db); // assert that ans schema matches rubric
    Course course = read_db(course_id, "courses/", db: local_db);
    String resp_id = get_id();
    write_db(Response.fromMap({
      "id": resp_id,
      "course_id": course_id,
      "meeting_id": meeting_id,
      "round_id": round_id,
      "stdnt_id": this.id,
      "roster_id": course.cur_roster,
      "rubric_id": rubric_id,
      "speaker": speaker_id,
      "val": ans}), "responses/", db: local_db);
    made_responses.add(resp_id);
    Stdnt speaker = read_db(speaker_id, "stdnts/", db: local_db);
    speaker.received_responses.add(resp_id);
    write_db(speaker, "stdnts/", db: local_db);
  }
}

class Instr {
  String id;  // not natural
  String first_name;
  String last_name;
  String netid;
  List my_courses=[];

  Instr({this.id,
      this.first_name,
      this.last_name,
      this.netid,
      this.my_courses,
      local_db}) {
    write_db(this, "instrs/", db: local_db);
  }

  Instr.fromMap(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.first_name = fields['first_name'];
    this.last_name = fields['last_name'];
    this.netid = fields['netid'];
    this.my_courses = fields['my_courses'];
  }

}