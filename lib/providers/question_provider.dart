

import 'package:api/models/question.dart';
import 'package:api/services/api_service.dart';
import 'package:flutter/material.dart';

class QuestionProvider extends ChangeNotifier {
  List<Question> _questions = [];
  List<Question> get questions => _questions;


  Future<void> getQuestions() async {
    _questions = await ApiService.getQuestions();
    notifyListeners();
  }

  Future<bool> addQuestion(Question question) async {
    bool success = await ApiService.addQuestion(question);
    if (success) {
      await getQuestions();
    }
    return success;
  }

  Future<bool> updateQuestion(Question question) async {
    bool success = await ApiService.updateQuestion(question);
    if (success) {
      await getQuestions();
    }
    return success;
  }

  Future<bool> deleteQuestion(String id) async {
    bool success = await ApiService.deleteQuestion(id);
    if(success){
      await getQuestions();
    }
    return success;
  }

}