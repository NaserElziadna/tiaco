import 'package:cloud_firestore/cloud_firestore.dart';

class PendingGameModel {
  final String? id, secondID;
  final int? status;

  const PendingGameModel({this.id, this.secondID, this.status});

  factory PendingGameModel.fromDoc(DocumentSnapshot doc) => PendingGameModel(
        id: doc.get('id'),
        secondID: doc.get('secondID'),
        status: doc.get('status'),
      );
}
