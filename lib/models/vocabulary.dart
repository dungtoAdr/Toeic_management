class Vocabulary {
  final String? id;
  final String word;
  final String pronunciation;
  final String meaning;
  final String audio_path;
  final String topic_id;

  Vocabulary({
    this.id,
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.audio_path,
    required this.topic_id,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json){
    return Vocabulary(id: json['id'],
        word: json['word'],
        pronunciation: json['pronunciation'].toString(),
        meaning: json['meaning'],
        audio_path: json['audio_path'].toString(),
        topic_id: json['topic_id']);
  }

  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'word': word,
      'pronunciation': pronunciation.toString(),
      'meaning': meaning,
      'audio_path': audio_path.toString(),
      'topic_id' : topic_id
    };
  }

}