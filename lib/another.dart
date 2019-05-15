import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAppAnother extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Flutter Post App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff543B7A),
      ),
      home: MyHomePage(title: 'Flutter Post',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key : key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {

          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: Text("Tech Post", style: TextStyle()),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.newspaper,
              size: 20.0,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot> (
        stream: Firestore.instance.collection('post').snapshots(),
        builder: (context,snapshot) {
          print('=== data ===: ${snapshot.data}');
          if (snapshot.data == null) { 
            return CircularProgressIndicator();
          }
          else if (!snapshot.hasData) {
            const Text('Loading..');
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot mypost =  snapshot.data.documents[index];
                return Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350.0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Material(
                          color: Colors.white,
                          elevation: 14.0,
                          shadowColor: Color(0x802196F3),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    child: Image.network(
                                      '${mypost['image']}',
                                      fit: BoxFit.fill
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text('${mypost['title']}',
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text('${mypost['subtitle']}',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                      ]),
                      Container(
                        alignment: Alignment.bottomLeft,
                        /*padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height *.47,
                          left: MediaQuery.of(context).size.height *.52,
                        ),*/
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF543B7A),
                            child: Icon(Icons.star, color: Colors.white, size: 20.0,),
                          ),
                        ),
                      ),
                    ],
                );
              },
            );
          }
        },
      ),
    );
  }
}