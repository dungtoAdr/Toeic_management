import 'package:api/models/vocabulary.dart';
import 'package:api/providers/vocabulary_provider.dart';
import 'package:api/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocaPage extends StatefulWidget {
  final String id;

  const VocaPage({super.key, required this.id});

  @override
  State<VocaPage> createState() => _VocaPageState();
}

class _VocaPageState extends State<VocaPage> {
  AudioPlayer player = AudioPlayer();
  bool _isTimeout = false;
  String title_dialog = 'Them';
  final idController = TextEditingController();
  final wordController = TextEditingController();
  final pronunciationController = TextEditingController();
  final meaningController = TextEditingController();
  final audioPathController = TextEditingController();
  final topicIdController = TextEditingController();
  final _form_key = GlobalKey<FormState>();

  void playAudio(String url) async {
    await player.stop();
    await player.play(UrlSource(url));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VocabularyProvider>(
        context,
        listen: false,
      ).fetchVocabularies(widget.id.toString());
    });
    // Đặt timer sau 5s
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isTimeout = true;
        });
      }
    });
    topicIdController.text = widget.id.toString();
  }

  @override
  void dispose() {
    player.dispose();
    idController.dispose();
    wordController.dispose();
    pronunciationController.dispose();
    meaningController.dispose();
    audioPathController.dispose();
    topicIdController.dispose();
    super.dispose();
  }

  void openDialog({String? id, String? word, String? pronunciation, String? meaning, String? audio_path, String? topic_id}) {
    if (id != null && word != null) {
      title_dialog = 'Update Vocabulary';
      wordController.text = word;
      pronunciationController.text = pronunciation!;
      meaningController.text = meaning!;
      audioPathController.text = audio_path!;
      idController.text = id;
      topicIdController.text = topic_id!;
    }
    if (id != null && word == null) {
      title_dialog = 'Delete Vocabulary';
    }
    if (id == null && word == null) {
      title_dialog = 'Add Vocabulary';
    }
    showDialog(
      context: context,
      builder: (context) {
        final vocaProvider = Provider.of<VocabularyProvider>(context, listen: false);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(title_dialog),
          content: SizedBox(
            width: 300,
            child: Form(
              key: _form_key,
              child:
                  id != null && word == null
                      ? const Text("Are you sure to delete?")
                      : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            TextFormField(
                              controller: idController,
                              enabled: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ID',
                              ),
                            ),
                            TextFormField(
                              controller: wordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Word',
                              ),
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Please enter word';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: pronunciationController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Pronunciation',
                              ),
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Please enter pronunciation';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: meaningController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Meaning',
                              ),
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Please enter meaning';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: audioPathController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Audio Path',
                              ),
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Please enter audio path';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: topicIdController,
                              enabled: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Topic ID',
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (id == null && word == null) {
                  if (_form_key.currentState!.validate()) {
                    _form_key.currentState!.save();
                    bool success = await vocaProvider.addVocabulary(
                      Vocabulary(
                        word: wordController.text,
                        pronunciation: pronunciationController.text,
                        meaning: meaningController.text,
                        audio_path: audioPathController.text,
                        topic_id: topicIdController.text,
                      ),
                    );
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Add Voca success")),
                      );
                    }
                  }
                } if(id != null && word == null){
                  bool success = await vocaProvider.deleteVocabulary(id, topicIdController.text);
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Delete vocabulary success")),
                    );
                  }
                } if(id != null && word != null){
                  if (_form_key.currentState!.validate()) {
                    _form_key.currentState!.save();
                    bool success = await vocaProvider.updateVocabulary(
                      Vocabulary(
                        id: idController.text,
                        word: wordController.text,
                        pronunciation: pronunciationController.text,
                        meaning: meaningController.text,
                        audio_path: audioPathController.text,
                        topic_id: topicIdController.text,
                      ),
                    );
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Update topic success")),
                      );
                    }
                  }
                }
              },
              child: Text(title_dialog),
            ),
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel"))
          ],
        );
      },
    );
  }

  void showPopupMenu(Vocabulary voca, BuildContext context, Offset position) {
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
          openDialog(id: voca.id, word: voca.word, pronunciation: voca.pronunciation, meaning: voca.meaning, audio_path: voca.audio_path, topic_id: voca.topic_id);
        } else if (value == 'delete') {
          openDialog(id: voca.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Vocabulary"),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 30),
            onPressed: () {
              idController.clear();
              wordController.clear();
              pronunciationController.clear();
              audioPathController.clear();
              meaningController.clear();
              openDialog();
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Consumer<VocabularyProvider>(
        builder: (context, value, child) {
          return value.vocas.isEmpty
              ? Center(
                child:
                    _isTimeout
                        ? const Text(
                          "Không có dữ liệu",
                          style: TextStyle(fontSize: 18),
                        )
                        : const CircularProgressIndicator(),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: value.vocas.length,
                  itemBuilder: (context, index) {
                    final voca = value.vocas[index];
                    return GestureDetector(
                      onLongPressStart: (details) {
                        showPopupMenu(voca, context, details.globalPosition);
                      },
                      onTap: () {
                        playAudio(voca.audio_path);
                      },
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                voca.word,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                voca.pronunciation,
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                voca.meaning,
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
        },
      ),
    );
  }
}
