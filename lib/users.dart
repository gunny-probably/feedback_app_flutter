class Stdnt {
  String id;
  String first_name;
  String last_name;
  String netid;

  Stdnt(this.id, this.first_name, this.last_name, this.netid);

  // json, map cons
  Stdnt.fromJson(Map<String, dynamic> fields) {
    this.id = fields['id'];
    this.first_name = fields['first_name'];
    this.last_name = fields['last_name'];
    this.netid = fields['netid'];
  }
}

class Instr extends Stdnt {
  int instr_id;

  Instr(id, first_name, last_name, netid, instr_id) : super(id, first_name, last_name, netid) {
    this.instr_id = instr_id;
  }

  Instr.fromJson(Map<String, dynamic> fields) : super(fields['id'], fields['first_name'], fields['last_name'], fields['netid']) {
    this.instr_id = fields['instr_id'];
  }

}