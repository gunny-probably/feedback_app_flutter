import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'course.dart';
import 'objects.dart';
import 'exceptions.dart';


/* entry method */
List read_db_subdir(String subdir, {Map<String, List> db}) {
  if (db != null) {
    return db[subdir];
  }
  // TODO add cloud varriant
}

/* entry method */
dynamic read_db(String id, String subdir, {Map<String, List> db}) {
  if (db != null) {
    print("Trace read_db() --- db item id =" + db[subdir][0].id);
    print("Trace read_db() --- searched item id =" + id);
    var search_result = db[subdir].where((elem) => elem.id == id);
    if (search_result.length == 0) {
      return null;
    } else {
      return search_result.single;
    }
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
void write_db(dynamic obj, String subdir, {dynamic db}) {
  if (db.runtimeType is Map) {
    if (db[subdir] == null) db[subdir] = [];
    var idx = db[subdir].indexWhere((elem) => elem.id == obj.id);
    if (idx != -1) db[subdir].removeAt(idx);  // overwrite existing thing.
    db[subdir].add(obj);
    return;
  }
  if (db.runtimeType is Firestore) {
    write_cloudfs(subdir, obj.id, obj.toMap(), db);
  }
}

void write_cloudfs(String docpath, dynamic id, Map<String, dynamic> objMap, Firestore db) {
  final DocumentReference docRef = db.document(docpath + id.toString());
  print("Trace --- write_cloudfs() --- docRef = $docRef");
//  final DocumentReference docRef = colRef.document(id.toString());
//  print("Trace --- write_cloudfs() --- docRef = $docRef");
  db.runTransaction((Transaction tx) async {
    DocumentSnapshot snap = await tx.get(docRef);
    print("Trace --- write_cloudfs() --- runTransaction callback --- snap = $snap");
    if (!snap.exists) {
      await tx.set(docRef, objMap);
    } else {
      await tx.update(docRef, objMap);
    }
  });
//  throw new CloudFSException(
//      'Utils module write_cloudfs() --- Transaction failed --- Trace');
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
