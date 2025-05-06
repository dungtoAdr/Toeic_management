import 'package:api/models/question.dart';
import 'package:api/providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddQuestionPage extends StatefulWidget {
  final String? category_id;
  final Question? question;

  const AddQuestionPage({super.key, this.category_id, this.question});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController(),
      questionTextController = TextEditingController(),
      optionAController = TextEditingController(),
      optionBController = TextEditingController(),
      optionCController = TextEditingController(),
      optionDController = TextEditingController(),
      correctOptionController = TextEditingController(),
      categoryIdController = TextEditingController(),
      imagePathController = TextEditingController(),
      audioPathController = TextEditingController(),
      paragraphPathController = TextEditingController(),
      transcriptController = TextEditingController();

  TextFormField customTextForm(TextEditingController controller,
      String label,
      bool validatorEnabled,
      bool enabled,) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
      ),
      validator: (value) {
        if (validatorEnabled) {
          if (value == null || value.isEmpty) {
            return 'Enter $label';
          }
        }
        return null;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.category_id != null) {
      categoryIdController.text = widget.category_id.toString();
    } else {
      categoryIdController.text = widget.question!.category_id;
      idController.text = widget.question!.id;
  }
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(
        context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(
          widget.category_id != null ? "Add Question" : "Update Question"),
          backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                customTextForm(idController, "ID", false, false),
                categoryIdController.text == '1' || categoryIdController.text == '2' || categoryIdController.text == '6' ?
                customTextForm(
                  questionTextController,
                  "Question Text",
                  false,
                  false,
                ):
                customTextForm(
                  questionTextController,
                  "Question Text",
                  false,
                  true,
                ),
                customTextForm(optionAController, "Option A", true, true),
                customTextForm(optionBController, "Option B", true, true),
                customTextForm(optionCController, "Option C", true, true),
                categoryIdController.text == '2' ?
                customTextForm(optionDController, "Option D", false, false):
                customTextForm(optionDController, "Option D", false, true),

                customTextForm(
                  correctOptionController,
                  "Correct Option",
                  true,
                  true,
                ),

                customTextForm(
                    categoryIdController, "Category ID", false, false),
                categoryIdController.text == '2' || categoryIdController.text == '5' || categoryIdController.text == '6' ?
                customTextForm(imagePathController, "Image Path", false, false):
                customTextForm(imagePathController, "Image Path", false, true),
                categoryIdController.text == '5' || categoryIdController.text == '6' || categoryIdController.text == "7" ?
                customTextForm(audioPathController, "Audio Path", false, false):
                customTextForm(audioPathController, "Audio Path", false, true),
                categoryIdController.text == '6' || categoryIdController.text =='7'?
                customTextForm(
                  paragraphPathController,
                  "Paragraph Path",
                  false,
                  true,
                ):customTextForm(
                  paragraphPathController,
                  "Paragraph Path",
                  false,
                  false,
                ),
                customTextForm(transcriptController, "Transcript", false, true),
                ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("sucessful")));
                      widget.category_id != null ?
                       await questionProvider.addQuestion(Question(
                          id: idController.text,
                          question_text: questionTextController.text,
                          option_a: optionAController.text,
                          option_b: optionBController.text,
                          option_c: optionCController.text,
                          option_d: optionDController.text,
                          correct_option: correctOptionController.text,
                          category_id: categoryIdController.text,
                          image_path: imagePathController.text,
                          audio_path: audioPathController.text,
                          paragraph_path: paragraphPathController.text,
                          transcript: transcriptController.text)) :
                      await questionProvider.updateQuestion(Question(
                          id: idController.text,
                          question_text: questionTextController.text,
                          option_a: optionAController.text,
                          option_b: optionBController.text,
                          option_c: optionCController.text,
                          option_d: optionDController.text,
                          correct_option: correctOptionController.text,
                          category_id: categoryIdController.text,
                          image_path: imagePathController.text,
                          audio_path: audioPathController.text,
                          paragraph_path: paragraphPathController.text,
                          transcript: transcriptController.text));
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(widget.category_id != null ? "Add" : "Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
