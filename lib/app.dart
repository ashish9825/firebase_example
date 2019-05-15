import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'second_page.dart';
import 'custom_card.dart';
import 'main.dart';

class MyApp extends StatelessWidget {

  //This widget is the route of the screen
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Firebase Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: MyHomePage(title: 'Flutter Demo'),
      routes: <String, WidgetBuilder> {
        '/a': (BuildContext context) => SecondPage(title: "Page A")
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController taskTitleInputController;
  TextEditingController taskDescriptionController;

  @override
  void initState() {
    taskTitleInputController = TextEditingController();
    taskDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Zindabad"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot> (
            stream: Firestore.instance.collection('tasks').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
               return Text('Error : ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                 return Text('Loading...');
                default:
                 return ListView(
                   children: snapshot.data.documents
                   .map((DocumentSnapshot documentSnapshot) {
                     return CustomCard(
                       title: documentSnapshot['title'],
                       description: documentSnapshot['description']
                     );
                   }).toList(),
                 );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog() async {
    await showDialog(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Fill all details"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: "Task Title"),
                controller: taskTitleInputController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: "Task Description"),
                controller: taskDescriptionController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              if (taskDescriptionController.text.isNotEmpty &&
              taskTitleInputController.text.isNotEmpty) {
                Firestore.instance
                .collection('tasks')
                .add({"title": taskTitleInputController.text,
                "description": taskDescriptionController.text})
                .then((result) => {
                  Navigator.pop(context),
                  taskTitleInputController.clear(),
                  taskDescriptionController.clear(),
                })
                .catchError((err) => print(err));
              }
            },
          )
        ],
      )
    );
  }
}