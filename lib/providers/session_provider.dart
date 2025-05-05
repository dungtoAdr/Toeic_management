

import 'package:api/models/session.dart';
import 'package:api/services/api_service.dart';
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  List<Session> _session = [];
  List<Session> get sessions => _session;
  
  Future<void> getSessions() async{
    _session = await ApiService.getSessions();
    notifyListeners();
  }
}