import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('Users');
final roomRef = FirebaseFirestore.instance.collection('Rooms');
final pendingRef = FirebaseFirestore.instance.collection('Pending Rooms');
