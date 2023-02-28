import '../chat_components/messages.dart';
import '../chat_components/new_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Live Chat"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            //----Today---- thing
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Color(0xff737373),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Today",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Color(0xff737373),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
