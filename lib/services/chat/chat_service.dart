import 'package:chatapp/model/message.dart/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Send a message

  Future<void> sendMessage(String reciverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        reciverId: reciverId,
        message: message,
        timestamp: timestamp);
    //construct chat room id from current id and reciver id (sorted to ensure uniquness)

    List<String> ids = [currentUserId, reciverId];
    ids.sort(); //sort the ids(this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join(
        '_'); //combine the ids into a single string to use as a chatroomID

    //add new messages to the database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
    //Get Messages
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from users ids(sorted to ensure it matches the id used when sending the message)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
