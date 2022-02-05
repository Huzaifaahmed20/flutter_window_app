import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List posts = [];

  void getPosts() async {
    try {
      final response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      setState(() {
        posts = response.data;
      });
    } catch (e) {
      print(e);
    }
  }

  void addPost({title, body}) async {
    try {
      final response =
          await Dio().post('https://jsonplaceholder.typicode.com/posts', data: {
        'title': title,
        'body': body,
        'userId': 1,
      });
      setState(() {
        posts = [response.data, ...posts];
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  Future showAddpostDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController),
            TextField(controller: bodyController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                addPost(title: titleController.text, body: bodyController.text),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddpostDialog(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Windows Posts"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            final post = posts[index];
            return Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(
                    post['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(post['body']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
