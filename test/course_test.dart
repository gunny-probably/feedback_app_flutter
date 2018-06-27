import 'package:test/test.dart';

import '../lib/Course.dart';

void main() {
  group("Course class", () {
    test("cons", ()
    {
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
}