import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String roomId;
  final int grade;
  final int classNumber;
  final String roomName;
  final String subject;
  final String inviteCode;
  final String teacherDeviceId;
  final DateTime createdAt;

  Room({
    required this.roomId,
    required this.grade,
    required this.classNumber,
    required this.roomName,
    required this.subject,
    required this.inviteCode,
    required this.teacherDeviceId,
    required this.createdAt,
  });

  String get displayName => '$grade학년 $classNumber반 - $roomName';

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'grade': grade,
      'classNumber': classNumber,
      'roomName': roomName,
      'subject': subject,
      'inviteCode': inviteCode,
      'teacherDeviceId': teacherDeviceId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Room.fromMap(Map<String, dynamic> map, String id) {
    return Room(
      roomId: id,
      grade: map['grade'] ?? 1,
      classNumber: map['classNumber'] ?? 1,
      roomName: map['roomName'] ?? '',
      subject: map['subject'] ?? '',
      inviteCode: map['inviteCode'] ?? '',
      teacherDeviceId: map['teacherDeviceId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

class Question {
  final String questionId;
  final String text;
  final List<String> images;
  final int points;
  final bool equivalentFractionAllowed;

  Question({
    required this.questionId,
    required this.text,
    this.images = const [],
    this.points = 10,
    this.equivalentFractionAllowed = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'text': text,
      'images': images,
      'points': points,
      'equivalentFractionAllowed': equivalentFractionAllowed,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['questionId'] ?? '',
      text: map['text'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      points: map['points'] ?? 10,
      equivalentFractionAllowed: map['equivalentFractionAllowed'] ?? true,
    );
  }
}

class Assignment {
  final String assignmentId;
  final String roomId;
  final String name;
  final String description;
  final List<Question> questions;
  final DateTime startTime;
  final DateTime deadline;
  final String status;
  final bool shuffleQuestions;
  final int passScore;

  Assignment({
    required this.assignmentId,
    required this.roomId,
    required this.name,
    required this.description,
    required this.questions,
    required this.startTime,
    required this.deadline,
    required this.status,
    required this.shuffleQuestions,
    required this.passScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'assignmentId': assignmentId,
      'roomId': roomId,
      'name': name,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
      'startTime': Timestamp.fromDate(startTime),
      'deadline': Timestamp.fromDate(deadline),
      'status': status,
      'shuffleQuestions': shuffleQuestions,
      'passScore': passScore,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map, String id) {
    return Assignment(
      assignmentId: id,
      roomId: map['roomId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      questions: (map['questions'] as List<dynamic>? ?? [])
          .map((q) => Question.fromMap(q))
          .toList(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      deadline: (map['deadline'] as Timestamp).toDate(),
      status: map['status'] ?? 'draft',
      shuffleQuestions: map['shuffleQuestions'] ?? false,
      passScore: map['passScore'] ?? 80,
    );
  }
}

class Submission {
  final String submissionId;
  final String assignmentId;
  final String deviceId;
  final String nickname;
  final Map<String, String> answers;
  final DateTime submittedAt;
  final int score;
  final String status;

  Submission({
    required this.submissionId,
    required this.assignmentId,
    required this.deviceId,
    required this.nickname,
    required this.answers,
    required this.submittedAt,
    required this.score,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'submissionId': submissionId,
      'assignmentId': assignmentId,
      'deviceId': deviceId,
      'nickname': nickname,
      'answers': answers,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'score': score,
      'status': status,
    };
  }

  factory Submission.fromMap(Map<String, dynamic> map, String id) {
    return Submission(
      submissionId: id,
      assignmentId: map['assignmentId'] ?? '',
      deviceId: map['deviceId'] ?? '',
      nickname: map['nickname'] ?? '',
      answers: Map<String, String>.from(map['answers'] ?? {}),
      submittedAt: (map['submittedAt'] as Timestamp).toDate(),
      score: map['score'] ?? 0,
      status: map['status'] ?? 'in_progress',
    );
  }
}
