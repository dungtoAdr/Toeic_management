// lib/providers/topic_provider.dart
import 'package:flutter/material.dart';
import 'package:api/models/topic.dart';
import 'package:api/services/api_service.dart';

class TopicProvider extends ChangeNotifier {
  List<Topic> _topics = [];

  List<Topic> get topics => _topics;


  Future<void> fetchTopics() async {
    _topics = await ApiService.fetchTopics();
    notifyListeners();
  }


  Future<bool> addTopic(String name) async {
    bool success = await ApiService.addTopic(name);
    if (success) {
      await fetchTopics();
    }
    return success;
  }

  Future<bool> updateTopic(String id, String name) async {
    bool success = await ApiService.updateTopic(id, name);
    if (success) {
      await fetchTopics();
    }
    return success;
  }

  Future<bool> deleteTopic(String id) async {
    bool success = await ApiService.deleteTopic(id);
    if (success) {
      await fetchTopics();
    }
    return success;
  }
}
