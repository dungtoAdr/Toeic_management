

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
}