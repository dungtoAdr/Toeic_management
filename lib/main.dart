import 'package:api/providers/question_provider.dart';
import 'package:api/providers/session_provider.dart';
import 'package:api/providers/topic_provider.dart';
import 'package:api/providers/vocabulary_provider.dart';
import 'package:api/screens/auth_page.dart';
import 'package:api/screens/home_page.dart';
import 'package:api/screens/topic_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TopicProvider(),),
    ChangeNotifierProvider(create: (context) => VocabularyProvider(),),
    ChangeNotifierProvider(create: (context) => SessionProvider(),),
    ChangeNotifierProvider(create: (context) => QuestionProvider(),)
  ],
  child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return ScaffoldMessenger(child: CircularProgressIndicator());
        }
        if(snapshot.hasData){
          return HomePage();
        }
        return AuthPage();
      },),
      debugShowCheckedModeBanner: false,
    );
  }
}