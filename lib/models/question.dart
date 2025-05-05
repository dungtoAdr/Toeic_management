class Question {
  final String id;
  final String? question_text;
  final String option_a;
  final String option_b;
  final String option_c;
  final String? option_d;
  final String correct_option;
  final String category_id;
  final String? image_path;
  final String? audio_path;
  final String? paragraph_path;
  final String? transcript;

  Question({
    required this.id,
    this.question_text,
    required this.option_a,
    required this.option_b,
    required this.option_c,
    this.option_d,
    required this.correct_option,
    required this.category_id,
    this.image_path,
    this.audio_path,
    this.paragraph_path,
    this.transcript,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question_text: json['question_text'],
      option_a: json['option_a'],
      option_b: json['option_b'],
      option_c: json['option_c'],
      option_d: json['option_d'],
      correct_option: json['correct_option'],
      category_id: json['category_id'],
      image_path: json['image_path'],
      audio_path: json['audio_path'],
      paragraph_path: json['paragraph_path'],
      transcript: json['transcript'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_text': question_text,
      'option_a': option_a,
      'option_b': option_b,
      'option_c': option_c,
      'option_d': option_d,
      'correct_option': correct_option,
      'category_id': category_id,
      'image_path': image_path,
      'audio_path': audio_path,
      'paragraph_path': paragraph_path,
      'transcript': transcript,
    };
  }
}
