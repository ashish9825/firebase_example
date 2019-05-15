import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FireStorage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FireStorageState();
  }
}

class FireStorageState extends State<FireStorage> {
  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text('Select an Image') : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(
            sampleImage,
            height: 300.0,
            width: 300.0,
          ),
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              final StorageReference storageReference =
                  FirebaseStorage.instance.ref().child('myImage.jpg');
              final StorageUploadTask task =
                  storageReference.putFile(sampleImage);
            },
          )
        ],
      ),
    );
  }
}
