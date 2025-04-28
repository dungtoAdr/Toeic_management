class Topic {
  final String? id;
  final String name;

  Topic({this.id, required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'name': name,
    };
  }
}
