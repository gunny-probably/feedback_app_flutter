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
      name: "BUSI 296", my_meetings: [], my_instrs: [ids["instr"]], my_rosters: [ids["ros_1"]], my_schedules: [], my_stdnts: [ids["stdnt_1"], ids["stdnt_2"]],  local_db: local_db);
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
        "rating": {
          1: false,
          2: false,
          3: false},
        "comments": null},
      local_db: local_db);
  Rubric rub_2 = Rubric(
      id: ids["rub_2"],
      course_id: ids["course"],
      roster_id: ids["ros_1"],
      val: {
        "rating": {
          8: false,
          9: false,
          10: false},
        "remarks": null},
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    local_db = {};
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
    makeMockData(kwargs, local_db);

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
        primarySwatch: pri,
      ),
      home: new MyHomePage(title: 'Feedback Alpha', db: local_db, user_id: instr_id),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.db, this.user_id}) : super(key: key) {

  }
  // This widget is the home page of your application. It is stateful, meaning

  // This class is the configuration for the state. It holds the values (in this

  final String title;

  Map<String, List<dynamic>> db;
  String user_id;
  String fake_user_id;
  bool instr;

  @override
  _MyHomePageState createState() => new _MyHomePageState();

  // TODO add trigger to rebuild state whenever cur_course get reassigned

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
    Course cur_course_full = read_db(cur_course, "courses/", db: super.widget.db);

    Form makeRubricForm(Rubric rub) {

    }

    /* convenience function */
    Card makeRoundCard(Round round) {
      return new Card(child: Column(
        children: <Widget>[
          new ListTile(
            // TODO idx param for meeting class
            title: Text("Speaker: "+round.speaker, style: TextStyle(color: Theme.of(context).primaryColor),),
            subtitle: Text(  // TODO fuser_id for fake stdnt in this namespace
              round.speaker.compareTo(super.widget.fake_user_id) == 0 ? spoke_yes : spoke_no + role_yes + cur_course_full.my_stdnts_roles[cur_course_full.cur_roster][super.widget.fake_user_id],
              style: TextStyle(color: Theme.of(context).primaryColor),),
            leading: Icon(Icons.android, color: Theme.of(context).primaryColor,),
            onTap: () {
              this.setState(() {this.cur_round = round.id;});
              // TODO go to the rubric/response tab
              },),
          new ListView(
            children: round.my_stdnts.map(
              (s_id) => read_db(s_id, "stdnts/", db: widget.db)).map(
                (s_full) => Text(s_full.first_name + " " + s_full.last_name)).toList())
        ],
      ),);
    }

    /* convenience function */
    Card makeMeetingCard(Meeting meeting) {
      return new Card(child: Column(
        children: <Widget>[
          new ListTile(
            // TODO idx param for meeting class
            title: Text(meeting.idx.toString(), style: TextStyle(color: Theme.of(context).primaryColor),),
            subtitle: Text("placeholder", style: TextStyle(color: Theme.of(context).primaryColor),),
            leading: Icon(Icons.people, color: Theme.of(context).primaryColor,),),
          new ListTile(
              title: Text(meeting.starttime.toString()),
              subtitle: Text(meeting.endtime.toString()),
              leading: Icon(Icons.access_time))
        ],
      ),);
    }

    /* convenience function */
    Card makeCourseCard(Course course) {
      return new Card(child: Column(
        children: <Widget>[
          new ListTile(
            title: Text(course.name),
            subtitle: Text("Rice University", style: TextStyle(color: Theme.of(context).primaryColor),),
            leading: Icon(Icons.class_, color: Theme.of(context).primaryColor,),
            onTap: () {this.setState(() {this.cur_course = course.id;});}
            /*
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => new MyMeetingPage(
                        user_id: widget.user_id,
                        db: widget.db,
                        parent_course: course.id,)));

            }
            */
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
    print("Trace --- MyHomePageState --- building Course cards");
    for (Course course_full in all_courses) {
      if (course_full.my_instrs.contains(widget.user_id)) course_cards.add(makeCourseCard(course_full));
    }
    List all_meetings = read_db_subdir("meetings/", db: widget.db);
    print("Trace --- MyHomePageState --- building Meeting cards");
    for (Meeting meeting_full in all_meetings) {
      //if (meeting_full.my_instrs.contains(widget.user_id))
      // TODO meeting and round should also support instr lookup
      meeting_cards.add(makeMeetingCard(meeting_full));
    }
    List all_rounds = read_db_subdir("rounds/", db: widget.db);
    for (Round round_full in all_rounds) {
      // TODO switch to fake user
      if (round_full.my_stdnts.contains(widget.fake_user_id)) round_cards.add(makeRoundCard(round_full));
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

  RubricForm(
      this.val,
      this.course_id,
      this.meeting_id,
      this.round_id,
      this.ros_id,
      this.rub_id,
      this.fake_user_id,
      this.speaker,
      this.db);

  @override
  _rfState createState() {
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    List<Widget> buildFields() {  // build a list of rows
      var fields_coll = <Widget>[];
      for (MapEntry kv in super.widget.val.entries) {
        if (kv.value is List) {
          List<DropdownMenuItem> options = kv.value.map((option) =>
              DropdownMenuItem(child: Text(option),));  // TODO val param?
          fields_coll.add(
              FormField(
                builder: (ffState) {
                  return DropdownButton(
                    items: options,
                    onChanged: (choiceOption) {
                      ffState.setState(() {
                        ffState.setValue(choiceOption);
                      })
                    },
                    elevation: 9,
                  );},
                onSaved: (choiceOption) {reply_builder[kv.key] = choiceOption;},
                validator: (choiceOption) => choiceOption == null ? errorPrompt : null,
              )
          );
        } else if (kv.value is String) {
          fields_coll.add(TextFormField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              labelText: kv.key,
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
        width: screenSize.width,
        child: RaisedButton(
          child: Text(
            "Submit Feedback",
            style: TextStyle(
              color: pri_r2,
              fontWeight: bold2,
              fontSize: h2
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

    return Container(
        padding: EdgeInsets.all(inset1),
        child: super.widget.val != null ? Form(
          key: this._formKey,
          child: ListView(
            children: buildFields(),
          ),
        ) : buildNA()
    );
  }
}
