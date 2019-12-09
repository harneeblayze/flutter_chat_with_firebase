import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/conversationScreen.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String _currentUserEmail;
  String _currentUserId;

  @override
  void initState() {
    _getEmail();

    _getCurrentUserId();
    super.initState();
  }

  void _getCurrentUserId() {
    FirebaseAuth.instance.currentUser().then((user) {
      _currentUserId = user.uid;
    });
  }

  void _getEmail() {
    FirebaseAuth.instance.currentUser().then((user) {
      _currentUserEmail = user.email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    buildUser(context, snapshot.data.documents[index]),

              );
            }
          },
        ),
      ),
    );
  }

  Widget buildUser(BuildContext context, DocumentSnapshot document) {
    if (document['email'] == _currentUserEmail) {
      return SizedBox();
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                        otherUserId: document.documentID,
                        currentUserid: _currentUserId,
                      )));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue.shade100,
                    child: Center(
                      child: Text(
                        document['username'].toString().substring(0, 1),
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                      child: Text(document['username'],
                          style: TextStyle(color: Colors.black, fontSize: 25)))
                ],
              ),
            ),
            Divider(
              height: 1,
            )
          ],
        ),
      );
    }
  }
}
