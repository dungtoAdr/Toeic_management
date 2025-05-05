import 'dart:convert';

import 'package:api/models/question.dart';
import 'package:api/models/session.dart';
import 'package:api/models/topic.dart';
import 'package:api/models/vocabulary.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.37/toeic_api";

  static Future<List<Topic>> fetchTopics() async {
    final response = await http.get(Uri.parse('$baseUrl/get_topics.php'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        List list = jsonData['data'];
        return list.map((e) => Topic.fromJson(e)).toList();
      } else {
        throw Exception("Loi Api ${jsonData['message']}");
      }
    } else {
      throw Exception("HTTP Error ${response.statusCode}");
    }
  }

  static Future<bool> addTopic(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_topic.php'),
      body: json.encode({'name': name}),
    );
    final jsonData = json.decode(response.body);
    return jsonData['success'] == true;
  }

  static Future<bool> updateTopic(String id, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_topic.php'),
      body: json.encode({'id': id, 'name': name}),
    );
    final jsonData = json.decode(response.body);
    return jsonData['success'] == true;
  }

  static Future<bool> deleteTopic(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_topic.php'),
      body: json.encode({'id': id}),
    );
    final jsonData = json.decode(response.body);
    return jsonData['success'] == true;
  }

  static Future<List<Vocabulary>> fetchVocas(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_vocabulary_by_topic.php?topic_id=$id'),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        List list = jsonData['data'];
        return list.map((e) => Vocabulary.fromJson(e)).toList();
      } else {
        throw Exception("Loi api ${jsonData['message']}");
      }
    } else {
      throw Exception("HTTP Error ${response.statusCode}");
    }
  }

  static Future<bool> addVoca(Vocabulary voca) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_voca.php'),
        body: jsonEncode(voca.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> deleteVoca(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_voca.php'),
      body: json.encode({'id': id}),
    );
    final jsonData = json.decode(response.body);
    return jsonData['success'] == true;
  }

  static Future<bool> updateVoca(Vocabulary voca) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_voca.php'),
        body: jsonEncode(voca.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  //sessions
  static Future<List<Session>> getSessions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/practice_sessions.php'),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        List list = jsonData['data'];
        return list.map((e) => Session.fromJson(e)).toList();
      } else {
        throw Exception('Loi ${jsonData['message']}');
      }
    } else {
      throw Exception('Loi ${response.statusCode}');
    }
  }

  //questions
  static Future<List<Question>> getQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/get_questions.php'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        List list = jsonData['data'];
        return list.map((e) => Question.fromJson(e)).toList();
      } else {
        throw Exception('Loi ${jsonData['message']}');
      }
    } else {
      throw Exception('Loi ${response.statusCode}');
    }
  }
}
