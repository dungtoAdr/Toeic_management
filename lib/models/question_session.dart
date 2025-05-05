class QuestionSession {
  final String id;
  final String session_id;
  final String question_id;
  final String user_answer;
  final String is_correct;

  QuestionSession({
    required this.id,
    required this.session_id,
    required this.question_id,
    required this.user_answer,
    required this.is_correct,
  });

  factory QuestionSession.fromJson(Map<String, dynamic> json) {
    return QuestionSession(
      id: json['id'],
      session_id: json['session_id'],
      question_id: json['question_id'],
      user_answer: json['user_answer'],
      is_correct: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' :id,
      'session_id' :session_id,
      'question_id' :question_id,
      'user_answer' :user_answer,
      'is_correct' :is_correct,
    };
  }
}
