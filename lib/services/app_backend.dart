import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class AppBackend {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 방 생성
  Future<void> createRoom(Room room) async {
    await _db.collection('rooms').doc(room.roomId).set(room.toMap());
  }

  // 선생님별 방 목록 조회
  Stream<List<Room>> getTeacherRooms(String teacherDeviceId) {
    return _db
        .collection('rooms')
        .where('teacherDeviceId', isEqualTo: teacherDeviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Room.fromMap(doc.data(), doc.id))
            .toList());
  }

  // 초대 코드로 방 찾기
  Future<Room?> getRoomByInviteCode(String code) async {
    final query = await _db
        .collection('rooms')
        .where('inviteCode', isEqualTo: code)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return Room.fromMap(query.docs.first.data(), query.docs.first.id);
  }

  // 과제 생성
  Future<void> createAssignment(Assignment assignment) async {
    await _db
        .collection('assignments')
        .doc(assignment.assignmentId)
        .set(assignment.toMap());
  }

  // 방별 과제 목록 조회
  Stream<List<Assignment>> getAssignments(String roomId) {
    return _db
        .collection('assignments')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Assignment.fromMap(doc.data(), doc.id))
            .toList());
  }

  // 학생 답안 제출
  Future<void> submitAnswer(Submission submission) async {
    await _db
        .collection('submissions')
        .doc(submission.submissionId)
        .set(submission.toMap());
  }

  // 과제별 제출 내역 조회
  Stream<List<Submission>> getSubmissions(String assignmentId) {
    return _db
        .collection('submissions')
        .where('assignmentId', isEqualTo: assignmentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Submission.fromMap(doc.data(), doc.id))
            .toList());
  }
}
