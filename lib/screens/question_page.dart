import 'package:api/models/question.dart';
import 'package:api/providers/question_provider.dart';
import 'package:api/screens/add_question_page.dart';
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

  void showPopupMenu(Question question, BuildContext context, Offset position) {
    final screenSize = MediaQuery.of(context).size;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        screenSize.width - position.dx,
        screenSize.height - position.dy,
      ),
      items: [
        PopupMenuItem(value: 'edit', child: Text('Sửa')),
        PopupMenuItem(value: 'delete', child: Text('Xóa')),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        if (value == 'edit') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => AddQuestionPage(
                    question: question,
                  ),
            ),
          );
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Xoa"),
                content: Text("Ban co chac chan muon xoa"),
                actions: [
                  ElevatedButton(
                    onPressed: () async{
                      final questionProvider = Provider.of<QuestionProvider>(
                        context,
                        listen: false,
                      );
                      bool success = await questionProvider.deleteQuestion(question.id);
                      if(success){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Xac nhan"),
                  ),
                ],
              );
            },
          );
        }
      }
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
          final filteredQuestions =
              selectPart == null
                  ? []
                  : value.questions
                      .where((element) => element.category_id == selectPart)
                      .toList();
          if (selectPart == null && part.isNotEmpty){
            selectPart = part[0];
          }
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    hint: Text("Part"),
                    value: selectPart,
                    items:
                        part
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectPart = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: ListView.builder(
                  itemCount: filteredQuestions.length,
                  itemBuilder: (context, index) {
                    final question = filteredQuestions[index];
                    return GestureDetector(
                      onLongPressStart: (details) => showPopupMenu(question, context, details.globalPosition),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(question.id),
                              Text(question.question_text.toString()),
                              question.image_path == null ||
                                      question.image_path.isEmpty
                                  ? SizedBox()
                                  : Image.network(question.image_path.toString()),
                              Text('A ' + question.option_a.toString()),
                              Text('B ' + question.option_b.toString()),
                              Text('C ' + question.option_c.toString()),
                              Text('D ' + question.option_d.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 10.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        AddQuestionPage(category_id: selectPart.toString()),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
