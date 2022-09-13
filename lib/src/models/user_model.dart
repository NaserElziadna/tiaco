import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? name, photoUrl, uid;

  const UserModel({this.name, this.photoUrl, this.uid});

  factory UserModel.fromDoc(DocumentSnapshot doc) => UserModel(
      uid: doc.id, name: doc['name'], photoUrl: doc['photoUrl']);

  factory UserModel.fromFirebase(User firebaseUser) => UserModel(
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      uid: firebaseUser.uid);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'uid': uid,
        'name': name,
        'photoUrl': photoUrl,
      };
}