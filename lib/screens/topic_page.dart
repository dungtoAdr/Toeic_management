import 'package:api/screens/voca_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api/providers/topic_provider.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String titleDialog = 'Add new Topic';

  Future<void> _refreshData() async {
    final topicProvider = Provider.of<TopicProvider>(context, listen: false);
    await topicProvider.fetchTopics();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopicProvider>(context, listen: false).fetchTopics();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void openDialog({String? id, String? name}) {
    if (id == null && name == null) {
      titleDialog = "Add new Topic";
      _idController.clear();
      _nameController.clear();
    } else if (id != null && name != null) {
      titleDialog = "Update Topic";
      _idController.text = id;
      _nameController.text = name;
    } else if (id != null && name == null) {
      titleDialog = "Delete Topic";
      _idController.text = id;
      _nameController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        final topicProvider = Provider.of<TopicProvider>(context, listen: false);
        return AlertDialog(
          title: Text(titleDialog),
          content: Form(
            key: _formKey,
            child: id != null && name == null
                ? const Text("Are you sure to delete?")
                : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _idController,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "ID",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a topic name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (id == null && name == null) {
                  if (_formKey.currentState!.validate()) {
                    bool success = await topicProvider.addTopic(_nameController.text);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Add topic success")));
                    }
                  }
                } else if (id != null && name != null) {
                  if (_formKey.currentState!.validate()) {
                    bool success = await topicProvider.updateTopic(_idController.text, _nameController.text);
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Update topic success")));
                    }
                  }
                } else if (id != null && name == null) {
                  bool success = await topicProvider.deleteTopic(id);
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Delete topic success")));
                  }
                }
              },
              child: Text(titleDialog),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Topic")),
      body: Consumer<TopicProvider>(
        builder: (context, topicProvider, _) {
          final topics = topicProvider.topics;
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VocaPage(id: topic.id.toString()),));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(topic.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.auto_fix_normal),
                            onPressed: () => openDialog(id: topic.id, name: topic.name),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => openDialog(id: topic.id, name: null),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => openDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
