import 'package:carparkapp/chat_components/messageBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    var dummyChats = [
      {"textMsg": "Hi I'm having some trouble with the booking.", "userId": 2},
      {
        "textMsg": "Good morning, which part of the process are you stuck at?",
        "userId": 1
      },
      {"textMsg": "Sorry but, how do you select the start time?", "userId": 2},
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: dummyChats.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(dummyChats[index]["textMsg"] as String,
                    dummyChats[index]["userId"] == 2);
              }),
        ),
      ],
    );
    // firebase playaround testing stuff
    // final user = FirebaseAuth.instance.currentUser;
    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection("firebase/link/thing")
    //       .orderBy("createdAt")
    //       .snapshots(),
    //   builder: (ctx, chatSnapshot) {
    //     if (chatSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     final chatDocs = chatSnapshot.data!.docs;
    //     return ListView.builder(
    //         itemCount: chatDocs.length,
    //         itemBuilder: (ctx, index) => MessageBubble(chatDocs[index]["text"],
    //             chatDocs[index]["userId"] == user!.uid));
    //   },
    // );
  }
}
