

import 'package:api/models/vocabulary.dart';
import 'package:api/services/api_service.dart';
import 'package:flutter/material.dart';

class VocabularyProvider extends ChangeNotifier{
  List<Vocabulary> _vocas =[];
  List<Vocabulary> get vocas => _vocas;
  
  
  Future<void> fetchVocabularies(String id) async {
    _vocas = [];
    notifyListeners();
    _vocas = await ApiService.fetchVocas(id);
    notifyListeners();
  }
  
  Future<bool> addVocabulary(Vocabulary voca) async {
    bool success =await ApiService.addVoca(voca);
    if (success) {
      await fetchVocabularies(voca.topic_id);
    }
    return success;
  }

  Future<bool> updateVocabulary(Vocabulary voca) async {
    bool success =await ApiService.updateVoca(voca);
    if (success) {
      await fetchVocabularies(voca.topic_id);
    }
    return success;
  }

  Future<bool> deleteVocabulary(String id,String topic_id) async {
    bool success = await ApiService.deleteVoca(id);
    if(success){
      await fetchVocabularies(topic_id);
    }
    return success;
  }
}