import 'package:api/models/vocabulary.dart';
import 'package:api/providers/voca_provider.dart';
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
  List<Vocabulary> vocas = [];
  AudioPlayer player = AudioPlayer();
  bool _isTimeout = false;

  void playAudio(String url) async {
    await player.stop();
    await player.play(UrlSource(url));
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<VocaProvider>(context, listen: false).fetchVocas(widget.id.toString());
    });
    // Đặt timer sau 5s
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isTimeout = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vocabulary")),
      body:
          vocas.isEmpty
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
                  itemCount: vocas.length,
                  itemBuilder: (context, index) {
                    final voca = vocas[index];
                    return GestureDetector(
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
              ),
    );
  }
}
