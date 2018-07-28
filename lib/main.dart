import 'package:flutter/material.dart';

import 'course.dart';
import 'objects.dart';
import 'db.dart';
import 'users.dart';
import 'simple.dart';
import 'defs.dart';


void main() => runApp(new MyApp());

void makeMockData(Map ids, Map local_db) {
  Stdnt stdnt_1 = Stdnt(
      id: ids["stdnt_1"],
      first_name: "Demetrie",
      last_name: "Luke",
      netid: "dl112",
      my_courses: [],
      my_meetings: [],
      my_rounds: [],
      local_db: local_db);
  Stdnt stdnt_2 = Stdnt(
      id: ids["stdnt_2"],
      first_name: "Ben",
      last_name: "Herndon-Miller",
      netid: "bhm4",
      my_courses: [],
      my_meetings: [],
      my_rounds: [],
      local_db: local_db);
  Course course = Course(id: ids["course"], startdate: DateTimeSimple(2018, 8, 12), enddate: DateTimeSimple(2018, 9, 12),
      name: "BUSI 296", my_meetings: [], my_instrs: [ids["instr"]], my_rosters: [ids["ros_1"]], my_schedules: [], my_stdnts: [ids["stdnt_1"], ids["stdnt_2"]],
      cur_roster: ids["ros_1"], local_db: local_db);
  Instr instr = Instr(id: ids["instr"], first_name: "Benito", last_name: "Aranda-Comer", my_courses: [ids["course"]], netid: 'bad180', local_db: local_db);
  Roster ros_1 = Roster(
      id: ids["ros_1"],
      course_id: ids["course"],
      val: [{
        ids["role_1"]: ids["rub_1"],
        ids["role_2"]: ids["rub_2"]},
      {
        ids["role_1"]: ids["rub_2"],
        ids["role_2"]: ids["rub_1"]}],
      local_db: local_db);
  Role role_1 = Role(
      id: ids["role_1"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      local_db: local_db
  );
  Role role_2 = Role(
      id: ids["role_2"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      local_db: local_db
  );
  Rubric rub_1 = Rubric(
      id: ids["rub_1"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      val: {
        "rating": [1, 2, 3],
        "comments": "input"},
      local_db: local_db);
  Rubric rub_2 = Rubric(
      id: ids["rub_2"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      val: {
        "rating": [8, 9, 10],
        "remarks": "input"},
      local_db: local_db
  );
  course.cur_roster = ids["ros_1"];
  course.my_stdnts_roles[course.cur_roster] = course.assign_roles([ids["role_1"], ids["role_2"]], [ids["stdnt_1"], ids["stdnt_2"]]);
  course.generate_meeting({
    "id": ids["meeting"],
    "starttime": DateTime.now().add(new Duration(hours: 10)),
    "endtime": DateTime.now().add(new Duration(hours: 11))
  }, local_db: local_db);
  write_db(course, "courses/", db: local_db);
}

class MyApp extends StatelessWidget {
  Map<String, List<dynamic>> local_db;
  String stdnt_1_id;
  String stdnt_2_id;
  String role_1_id;
  String role_2_id;
  String rub_1_id;
  String rub_2_id;
  String ros_1_id;
  String sch_id;
  String course_id;
  String instr_id;
  String meeting_id;

  MyApp() {
    print("Trace --- Constructing MyApp");
    local_db = {};
    this.stdnt_1_id = get_id();
    this.stdnt_2_id = get_id();
    this.role_1_id = get_id();
    this.role_2_id = get_id();
    this.rub_1_id = get_id();
    this.rub_2_id = get_id();
    this.ros_1_id = get_id();
    this.sch_id = get_id();
    this.course_id = get_id();
    this.instr_id = get_id();
    this.meeting_id = get_id();
    Map kwargs = {
      "stdnt_1": this.stdnt_1_id,
      "stdnt_2": this.stdnt_2_id,
      "role_1": this.role_1_id,
      "role_2": this.role_2_id,
      "rub_1": this.rub_1_id,
      "rub_2": this.rub_2_id,
      "ros_1": this.ros_1_id,
      "sch": this.sch_id,
      "course": this.course_id,
      "instr": this.instr_id,
      "meeting": this.meeting_id
    };
    makeMockData(kwargs, local_db);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Trace --- MyApp --- instr_id = $instr_id");
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.

        primaryColor: pri,
        primaryColorLight: pri_r1,
        accentColor: pri_r2,
        cardColor: Colors.white,
        buttonColor: right,
      ),
      home: new MyHomePage(title: 'Feedback Alpha', db: local_db, user_id: instr_id, fake_user_id: stdnt_1_id),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.db, this.user_id, this.fake_user_id}) : super(key: key) {
    print("Trace --- MyHomePage cons entry");
    print("Trace --- this.user_id = ${this.user_id}");

  }
  // This widget is the home page of your application. It is stateful, meaning

  // This class is the configuration for the state. It holds the values (in this

  final String title;

  Map<String, List<dynamic>> db;
  String user_id;
  String fake_user_id;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".
// that it has a State object (defined below) that contains fields that affect
// how it looks.

class _MyHomePageState extends State<MyHomePage> {
  List<Card> course_cards;
  List<Card> meeting_cards;
  List<Card> round_cards;
  String cur_course;
  String cur_meeting;
  String cur_round;

  final String spoke_yes = "You are the speaker for this round. ";
  final String spoke_no = "You are assigned to grade this round. ";
  final String role_yes = "Your role is ";

  @override
  Widget build(BuildContext context) {
    /* convenience function */
    Card makeRoundCard(Round round) {
      print("Trace --- makeRoundCard() --- cur_round id = $cur_round");
      Course cur_course_full = read_db(cur_course, "courses/", db: super.widget.db);
      print("Trace --- makeRoundCard() --- cur_course_full = $cur_course_full");
      Meeting cur_meeting_full = read_db(cur_meeting, "meetings/", db: super.widget.db);
      return new Card(
        elevation: cardElevation2,
        child: Column(
          children: <Widget>[
            new ListTile(
              // TODO idx param for meeting class
              title: Text(
                "Speaker: "+round.speaker,
                style: TextStyle(
                    color: Theme.of(context).primaryColor),),
              subtitle: Text(  // TODO fuser_id for fake stdnt in this namespace
                round.speaker.compareTo(super.widget.fake_user_id) == 0 ?
                  spoke_yes : spoke_no + role_yes +
                    cur_course_full.my_stdnts_roles[cur_course_full.cur_roster]
                      [super.widget.fake_user_id],
                style: TextStyle(color: Theme.of(context).primaryColor),),
              leading: Icon(Icons.android, color: Theme.of(context).primaryColor,),
              onTap: () {
                this.setState(() {
                  this.cur_round = round.id;
                });
//                if (round.complete[super.widget.fake_user_id]) {
//                  // TODO add snackbar support for this. Tell people that you can't access this form anymore.
//                }
                Course course_full = read_db(
                    this.cur_course, "courses/", db: super.widget.db);
                String fake_role = course_full.my_stdnts_roles[round
                    .parent_roster][super.widget.fake_user_id];
                print("Trace --- _MyHomePageState class --- round card button --- fake_role = $fake_role");
                Roster ros_full = read_db(
                    round.parent_roster, "rosters/", db: super.widget.db);
                print("Trace --- _MyHomePageState class --- round card button --- round.roster_state = ${round.roster_state}");
                String designated_rubric = ros_full.val[round
                    .roster_state][fake_role];
                print("Trace --- _MyHomePageState class --- round card button --- designated_rubric = $designated_rubric");
                Rubric designated_rubric_full = read_db(
                    designated_rubric, "rubrics/", db: super.widget.db);
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => RubricForm(
                        val: designated_rubric_full.val,
                        course_id: this.cur_course,
                        meeting_id: cur_meeting,
                        round_id: cur_round,
                        ros_id: round.parent_roster,
                        rub_id: designated_rubric,
                        fake_user_id: super.widget.fake_user_id,
                        speaker: round.speaker,
                        db: super.widget.db
                    )
                  )
                );
                // TODO go to the rubric/response tab
              },
            ),
            new Container(
              padding: EdgeInsets.all(inset1),
              child: Column(
                children: round.my_stdnts.map(
                  (s_id) => read_db(s_id, "stdnts/", db: widget.db)).map(
                    (s_full) => ListTile(
                      title: Text(s_full.first_name + " " + s_full.last_name),
                      subtitle: Text(round.speaker == s_full.id ? "Speaker" : "Grader"),
                      leading: Icon(Icons.android),
                    )).toList()
              )
            )
          ],
        ),
      );
    }

    /* convenience function */
    Card makeMeetingCard(Meeting meeting) {
      print("Trace --- makeMeetingCard() --- cur_course id = " + cur_course);
      Course cur_course_full = read_db(cur_course, "courses/", db: super.widget.db);
      if (cur_course_full == null) return null;  // NOTE hotfix to return null instead of breaking app.

      return new Card(child: Column(
        children: <Widget>[
          new ListTile(
            // TODO idx param for meeting class
            title: Text(meeting.idx.toString(), style: TextStyle(color: Theme.of(context).primaryColor),),
            subtitle: Text(cur_course_full.name, style: TextStyle(color: Theme.of(context).primaryColor),),
            leading: Icon(Icons.people, color: Theme.of(context).primaryColor,),
            onTap: () {this.setState(() {this.cur_meeting = meeting.id;});}
          ),
          new ListTile(
              title: Text(meeting.starttime.toString()),
              subtitle: Text(meeting.endtime.toString()),
              leading: Icon(Icons.access_time))
        ],
      ),);
    }

    /* convenience function */
    Card makeCourseCard(Course course) {
      print("Trace --- makeCourseCard() --- Building card for ${course.id}");
      return new Card(
        elevation: cardElevation1,
        child: Column(
        children: <Widget>[
          new ListTile(
            title: Text(course.name),
            subtitle: Text("Rice University", style: TextStyle(color: Theme.of(context).primaryColor),),
            leading: Icon(Icons.class_, color: Theme.of(context).primaryColor,),
            onTap: () {this.setState(() {
              print("Trace --- onTap Course Card --- Setting cur_course to ${course.id}");
              this.cur_course = course.id;});}
            ),
          new ListTile(
            title: Text(read_db(course.my_instrs[0], "instrs/", db: widget.db).first_name + " " + read_db(course.my_instrs[0], "instrs/", db: widget.db).last_name, style: TextStyle(color: Colors.black)),
            subtitle: Text("Instructor", style: TextStyle(color: Theme.of(context).primaryColor)),
            leading: Icon(Icons.assignment_ind, color: Theme.of(context).primaryColor)),
          new ListTile(
            title: Text("Start Date: "+course.startdate.toString()+"\nEnd Date: "+course.enddate.toString()),
            subtitle: Text("Fall 2018", style: TextStyle(color: Theme.of(context).primaryColor),),
            leading: Icon(Icons.access_time,color: Theme.of(context).primaryColor,))
        ],
      ),);
    }

    course_cards = <Card>[];
    meeting_cards = <Card>[];
    round_cards = <Card>[];

    List all_courses = read_db_subdir("courses/", db: widget.db);
    print("Trace --- MyHomePageState --- all_courses = $all_courses");
    for (Course course_full in all_courses) {
      print("Trace --- MyHomePageState --- building Course cards");
      print("Trace --- MyHomePageState --- course instrs = ${course_full.my_instrs}");
      print("Trace --- MyHomePageState --- widget user id = ${widget.user_id}");
      if (course_full.my_instrs.contains(widget.user_id)) course_cards.add(makeCourseCard(course_full));
    }
    List all_meetings = read_db_subdir("meetings/", db: widget.db);
    if (cur_course != null) {
      print(cur_course);
      print(all_courses[0].id);
      assert(cur_course == all_courses[0].id);
      print("Trace --- MyHomePageState --- building Meeting cards");
      for (Meeting meeting_full in all_meetings) {
        //if (meeting_full.my_instrs.contains(widget.user_id))
        // TODO meeting and round should also support instr lookup
        meeting_cards.add(makeMeetingCard(meeting_full));
      }
    }
    List all_rounds = read_db_subdir("rounds/", db: widget.db);
    if (cur_course != null && cur_meeting != null) {
      print("Trace --- MyHomePageState build() --- building Round cards");
      print("Trace --- MyHomePageState build() --- size of all_rounds = ${all_rounds.length}");
      for (Round round_full in all_rounds) {
        print("Trace --- MyHomePageState build() --- building Round cards --- fake stdnt user id = ${super.widget.fake_user_id}");
        // TODO only display rounds relevant to meeting, actually
        if (round_full.my_stdnts.contains(super.widget.fake_user_id)) {
          print("Trace --- MyHomePageState build() --- building ${round_full.id} due to match");
          round_cards.add(makeRoundCard(round_full));
        }
      }
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new DefaultTabController(
      length: 3,  // TODO parameterize
      child: new Scaffold(
        appBar: new AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.school)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.notifications))
            ]
          ),
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: new TabBarView(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            new ListView(children: course_cards,),
            new ListView(children: meeting_cards),
            new ListView(children: round_cards)
          ]
        ),
    ));
  }
}

class RubricForm extends StatefulWidget {
  Map val;
  String course_id;
  String meeting_id;
  String round_id;
  String ros_id;
  String rub_id;
  String fake_user_id;
  String speaker;
  Map db;

  RubricForm({
      this.val,
      this.course_id,
      this.meeting_id,
      this.round_id,
      this.ros_id,
      this.rub_id,
      this.fake_user_id,
      this.speaker,
      this.db});

  @override
  _rfState createState() {
    print("Trace --- RubricForm class --- createState() call");
    return _rfState();
  }
}

class _rfState extends State<RubricForm> {
  static String resp_id = get_id();
  Map reply_builder = {};
  final String textPrompt = "Fill me in";
  final String listPrompt = "Choose one";
  final String errorPrompt = "This field is required.";
  final String noRubPrompt = "Oops! No meeting round selected.";
  final _formKey = GlobalKey<FormState>();
  String selectedOption;

  @override
  Widget build(BuildContext context) {
    print("Trace --- _rfState class --- build() call");

    List<Widget> buildFields() {  // build a list of rows
      var fields_coll = <Widget>[];
      print("Trace --- _rfState class --- build() call --- form length = ${super.widget.val.entries.length}");
      for (MapEntry kv in super.widget.val.entries) {
        print("Trace --- _rfState class --- build() call --- kv = $kv");
        if (kv.value is List) {
          print("Trace --- _rfState class --- build() call --- building List val");

          List<DropdownMenuItem> options = <DropdownMenuItem>[];
          for (var option in kv.value) {
            options.add(DropdownMenuItem(child: Text(option.toString()),));
          }
          fields_coll.add(
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(kv.key.toUpperCase().toString()),]
                  )
                ),
                FormField(
                  builder: (ffState) {
                    return DropdownButton(
                      value: selectedOption,
                      hint: Text(listPrompt),
                      items: options,
                      onChanged: (choiceOption) {
                        selectedOption = choiceOption;
                        ffState.setState(() {
                          ffState.setValue(choiceOption);
                        });
                      },
                      elevation: buttonElevation1,
                    );},
                  onSaved: (choiceOption) {reply_builder[kv.key] = choiceOption;},
                  validator: (choiceOption) => choiceOption == null ? errorPrompt : null,
                )
              ]
            )
          );
        } else if (kv.value is String) {
          print("Trace --- _rfState class --- build() call --- building String val");
          fields_coll.add(TextFormField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: kv.key.toUpperCase(),
              hintText: textPrompt,
            ),
            initialValue: "",
            onSaved: (inputText) {reply_builder[kv.key] = inputText;},
            validator: (inputText) => inputText.compareTo("") == 0 ? errorPrompt : null,
          ));
        } else {
          continue;
        }
      }
      Container submitButton = Container(
        //width: screenSize.width,
        child: RaisedButton(
          child: Text(
            "SUBMIT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold2,
            ),
          ),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              this._formKey.currentState.save();
              Response(id: resp_id,
                  course_id: super.widget.course_id,
                  meeting_id: super.widget.meeting_id,
                  round_id: super.widget.round_id,
                  roster_id: super.widget.ros_id,
                  rubric_id: super.widget.rub_id,
                  stdnt_id: super.widget.fake_user_id,
                  speaker: super.widget.speaker,
                  val: reply_builder,
                  local_db: super.widget.db);
              print("Trace _rfState --- submit hit --- Saving response");
              Navigator.pop(context);
            }
          },
          color: pri,
        ),
        margin: EdgeInsets.only(
          top: inset1,
          bottom: inset1
        ),
      );
      fields_coll.add(submitButton);
      return fields_coll;
    }

    Widget buildNA() {
      return Center(
        child: Text(noRubPrompt,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: bold1,
            fontSize: h4),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text("Feedback Form"),),  // TODO parameterize text
        body: Container(
          padding: EdgeInsets.all(inset1),
          child: super.widget.val != null ? Form(

            key: this._formKey,
            child: ListView(
              children: buildFields(),
            ),
          ) : buildNA()
      )
    );
  }
}
