import 'dart:async';

import 'package:firebase_example/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app.dart';
import 'another.dart';
import 'dashboard.dart';

void main() => runApp(FireBaseEx());

class FireBaseEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Crud(),
    );
  }
}

class Crud extends StatefulWidget {

  @override
  CrudState createState() => CrudState();
}

class CrudState extends State<Crud> {
  
  String myText;
  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      Firestore.instance.document("myData/dummy");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('User Name : ${user.displayName}');
    return user;
  }

  void _signOut() {

    googleSignIn.signOut();
    print("User Signed Out");
  }

  void _add() {
    Map<String, String> data = <String, String> {
      "name": "Ashish Panjwani",
      "desc": "Flutter Developer"
    };
    documentReference.setData(data).whenComplete(() {
      print('Document Added !');
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print('Deleted Successfully !');
      setState(() {
        
      });
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String> {
      "name": "Ashish Panjwani Updated",
      "desc": "Flutter Developer Updated"
    };
    documentReference.updateData(data).whenComplete(() {
      print('Document Updated !');
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnaphot) {
      if (datasnaphot.exists) {
        setState(() {
         myText = datasnaphot.data['name']; 
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Firebase Demo"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new RaisedButton(
              onPressed: () => _signIn()
                  .then((FirebaseUser user) => print(user))
                  .catchError((e) => print(e)),
              child: new Text("Sign In"),
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            RaisedButton(
              onPressed: _signOut,
              child: new Text("Sign Out"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: _add,
              child: new Text("Add"),
              color: Colors.cyan,
            ),
            RaisedButton(
              onPressed: _delete,
              child: new Text("Delete"),
              color: Colors.deepOrange,
            ),
            RaisedButton(
              onPressed: _update,
              child: new Text("Update"),
              color: Colors.lime,
            ),
            RaisedButton(
              onPressed: _fetch,
              child: new Text("Fetch"),
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            myText == null
            ? Container()
            : Text(
              myText,
              style: TextStyle(fontSize: 20.0),
            ),
            RaisedButton(
              onPressed: () {
                navigateToSubPage(context);
              },
              child: new Text("Firestore"),
              color: Colors.indigoAccent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToSubPage(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Future navigateToSubPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FireStorage()));
  }
}
