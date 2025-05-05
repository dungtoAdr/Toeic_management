import 'package:api/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String? selectPart;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<QuestionProvider>(context, listen: false).getQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question"), backgroundColor: Colors.blue),
      body: Consumer<QuestionProvider>(
        builder: (context, value, child) {
          final part =
              value.questions.map((e) => e.category_id).toSet().toList();
          return Column(
            children: [
              DropdownButton<String>(
                hint: Text("Part"),
                value: selectPart,
                items: part.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) {
                  setState(() {
                    selectPart = value;
                  });
                },
              ),
              ListView.builder(
                itemCount: value.questions.length,
                itemBuilder: (context, index) {
                  final question = value.questions[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question.id),
                          Text(question.question_text.toString()),
                          question.image_path == null
                              ? SizedBox()
                              : Image.network(question.image_path.toString()),
                          Text('A ' + question.option_a.toString()),
                          Text('B ' + question.option_b.toString()),
                          Text('C ' + question.option_c.toString()),
                          Text('D ' + question.option_d.toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
