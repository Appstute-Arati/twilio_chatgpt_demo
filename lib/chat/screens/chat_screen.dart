import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatBloc? chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversations'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  chatBloc!.add(GenerateTokenEvent(credentials: const {
                    "accountSid": "ACc07c533b07c318ce57365724b5a31ac2",
                    "apiKey": "SK34983e66d486b142d0431ea65b8d0407",
                    "apiSecret": "QAvQe0TuXtsfLpODHx1hJbWs6QMBupYo",
                    "identity": "arati.pailwan@zingworks.in"
                  }));
                },
                child: const Text("Generate Token")),
            ElevatedButton(
                onPressed: () {
                  chatBloc!.add(
                      CreateConversionEvent(conversationName: "conversation1"));
                },
                child: const Text("Create Conversation")),
            ElevatedButton(
                onPressed: () {}, child: const Text("Join Conversation")),
            ElevatedButton(
                onPressed: () {}, child: const Text("Add Participant"))
          ],
        ));
  }
}
