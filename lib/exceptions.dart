class NotImplementedException implements Exception {
  final String base_msg = "Method not implemented! --- ";
  final String msg;

  const NotImplementedException(this.msg);

  @override
  String toString() => base_msg + msg;
}

class CloudFSException implements Exception {
  final String base_msg = "Cloud Firestore network problem encountered --- ";
  final String msg;

  const CloudFSException(this.msg);

  @override
  String toString() => base_msg + msg;
}

class UserException implements Exception {
  final String base_msg = "User input error --- ";
  final String msg;

  const UserException(this.msg);

  @override
  String toString() => base_msg + msg;
}

class TestException implements Exception {
  final String base_msg = "Test env does not method ---";
  final String msg;

  const TestException(this.msg);

  @override
  String toString() => base_msg + msg;
}