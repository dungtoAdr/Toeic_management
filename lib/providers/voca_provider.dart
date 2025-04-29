

import 'package:api/models/vocabulary.dart';
import 'package:api/services/api_service.dart';
import 'package:flutter/material.dart';

class VocaProvider extends ChangeNotifier{
  List<Vocabulary> _vocas =[];
  List<Vocabulary> get vocas => _vocas;
  
  
  Future<void> fetchVocas(String id) async {
    _vocas = [];
    notifyListeners();
    _vocas = await ApiService.fetchVocas(id);
    notifyListeners();
  }
  
  Future<bool> addVoca(Vocabulary voca) async {
    bool success =await ApiService.addVoca(voca);
    if (success) {
      await fetchVocas(voca.topic_id);
    }
    return success;
  }

  Future<bool> updateVoca(Vocabulary voca) async {
    bool success =await ApiService.updateVoca(voca);
    if (success) {
      await fetchVocas(voca.topic_id);
    }
    return success;
  }

  Future<bool> deleteVoca(String id,String topic_id) async {
    bool success = await ApiService.deleteVoca(id);
    if(success){
      await fetchVocas(topic_id);
    }
    return success;
  }
}