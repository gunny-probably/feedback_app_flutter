import 'package:cloud_firestore/cloud_firestore.dart';

import 'course.dart';
import 'objects.dart';
import 'exceptions.dart';


/* entry method */
dynamic read_db(String id, String subdir, {Map<String, List> db}) {
  if (db != null) {
    return db[subdir].where((elem) => elem.id == id).toList()[0];
  }
  return read_cloudfs(subdir, id);
}

dynamic read_cloudfs(String docpath, dynamic id) {
  final DocumentReference ref = Firestore.instance.document(
      docpath + id.toString());
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot snap = await tx.get(ref);
    if (!snap.exists) {
      throw new UserException(
          "Utils module read_cloudfs() --- Cloud firebase entry does not exist --- docpath: {docpath}, id: {id}");
    } else {
      if (docpath.compareTo('courses/') == 0)
        return Course.fromMap(snap.data);
      if (docpath.compareTo('rosters/') == 0)
        return Roster.fromMap(snap.data);
      else
        throw new NotImplementedException(
            "fromMap N/A for object described by" + docpath);
    }
  });
  throw new CloudFSException(
      'Utils module read_cloudfs() --- Transaction failed --- Trace');
}

/* entry method */
void write_db(dynamic obj, String subdir, {Map<String, List<dynamic>> db}) {
  if (db != null) {
    if (db[subdir] == null) db[subdir] = [];
    var idx = db[subdir].indexWhere((elem) => elem.id == obj.id);
    if (idx != -1) db[subdir].removeAt(idx);  // overwrite existing thing.
    db[subdir].add(obj);
    return;
  }
  write_cloudfs(subdir, obj.id, obj);
  return;
}

dynamic write_cloudfs(String docpath, dynamic id, Map<String, dynamic> obj) {
  final DocumentReference ref = Firestore.instance.document(
      docpath + id.toString());
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot snap = await tx.get(ref);
    if (!snap.exists) {
      tx.set(ref, obj);
    } else {
      tx.update(ref, obj);
    }
  });
  throw new CloudFSException(
      'Utils module write_cloudfs() --- Transaction failed --- Trace');
}

/* deprecated */
int get_new_id(String docpath) {
  final DocumentReference ref = Firestore.instance.document(docpath);
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot snap = await tx.get(ref);
    return snap.data.length;
  });
  throw new CloudFSException(
      'Utils module get_new_id() --- Transaction failed --- Trace');
}

/* deprecated */
void inc_roster_state(String roster_id) {
  final DocumentReference ref = Firestore.instance.document(
      "rosters/" + roster_id.toString());
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot snap = await tx.get(ref);
    tx.update(ref, {
      "roster_state": snap.data["roster_state"]++
    });
  });
  throw new CloudFSException(
      'Utils module inc_roster_state() --- Transaction failed --- Trace');
}
