import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class crudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('testcrud').add(carData).catchError((e) {
        print("Error is ${e}");
      });
    } else {
      print("You need to be logged in");
    }
  }

  getData() async {
    return await Firestore.instance.collection('testcrud').snapshots();
  }

  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('testcrud')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) => print(e));
  }

  deleteData(selectedDoc) {
    Firestore.instance
        .collection('testcrud')
        .document(selectedDoc)
        .delete()
        .catchError((e) => print(e));
  }
}
