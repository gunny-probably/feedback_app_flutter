import 'package:test/test.dart';

import '../lib/course.dart';
import '../lib/utils.dart';

void main() {
  group("Course class unit testing", () {
    test("Course cons", ()
    {
      Course c = Course.fromMap({
      'id': get_new_id("courses/"),
      'startdate': "06/26/2018",
      'enddate': "06/26/2018",
      'my_meetings': [],
      'my_instrs': [],
      'my_stdnts': [],
      'my_rosters': [],
      'my_schedules': [],
      'cur_roster': [],
      'cur_schedule': []
      });
      Course c_copy = read_cloudfs("courses/", 0);
      expect(c_copy.id, equals(0));
      expect(c_copy.startdate, equals("06/26/2018"));
      expect(c_copy.enddate, equals("06/26/2018"));
    });
  });
}