import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get instance auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signOut() {
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Lista dial el Rojla',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        )),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  //build a list of users except of the one using the app
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loadingg');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              title: Text(
                data['name'],
                style: const TextStyle(fontSize: 22, color: Colors.blue),
              ),
              onTap: () {
                //pass the clicked user's UID to the chat page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserName: data['name'],
                      receiverUserID: data['uid'],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(
            thickness: 1,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
