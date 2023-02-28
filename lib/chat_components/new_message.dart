import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = "";

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    _controller.clear();
  }

  //firebase testing
  // void _sendMessage() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance
  //       .collection("firebase/chat/link")
  //       .add({
  //     "text": _enteredMessage,
  //     'createdAt': Timestamp.now(),
  //     "userId": user!.uid,
  //   });
  //   FocusScope.of(context).unfocus();
  //   _controller.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "New message",
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              isDense: true,
            ),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Color(0xFF7F56D9),
          ),
        ],
      ),
    );
  }
}
