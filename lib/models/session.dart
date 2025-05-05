import 'package:api/models/question_session.dart';

class Session {
  final String id;
  final String user_id;
  final String part;
  final String total_questions;
  final String correct_answers;
  final List<QuestionSession> questions;

  Session({
    required this.id,
    required this.user_id,
    required this.part,
    required this.total_questions,
    required this.correct_answers,
    required this.questions,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      user_id: json['user_id'],
      part: json['part'],
      total_questions: json['total_questions'],
      correct_answers: json['correct_answers'],
      questions: List<QuestionSession>.from(
        json['questions'].map((q) => QuestionSession.fromJson(q)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'part': part,
      'total_questions': total_questions,
      'correct_answers': correct_answers,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
