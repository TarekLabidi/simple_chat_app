import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserID;
  const ChatPage({
    Key? key,
    required this.receiverUserName,
    required this.receiverUserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build messages list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        // Reverse the order of the messages
        List<DocumentSnapshot> reversedMessages =
            List.from(snapshot.data!.docs.reversed);

        return ListView(
          // Reverse the list of messages
          children: reversedMessages
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to right if it's the current user
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM d, hh:mm a').format(DateTime.now().toLocal()),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? Colors.blue
                    : Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['message'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 20),
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter a message',
              obscureText: false,
            ),
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
