import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String conversationName;
  final String conversationSid;
  const ChatDetailsScreen(
      {Key? key, required this.conversationName, required this.conversationSid})
      : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  ChatBloc? chatBloc;

  String? typeMessage;

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
        body: BlocConsumer<ChatBloc, ChatStates>(
            builder: (BuildContext context, ChatStates state) {
              return Center(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true, // Display messages from bottom to top
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message = messages[index];
                          return ListTile(
                            title: Text(message.author),
                            subtitle: Text(message.text),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                typeMessage = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Type a message',
                              ),
                              // Handle user input
                              // You can store the input in a variable or send it to the server
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              print(
                                  "conversationSid-" + widget.conversationSid);
                              chatBloc!.add(SendMessageEvent(
                                  enteredMessage: typeMessage,
                                  conversationName: widget.conversationSid));
                              // Handle send button press
                              // You can send the message to the server or add it to the UI
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, ChatStates state) {}));
  }
}

class Message {
  final String author;
  final String text;

  Message(this.author, this.text);
}

List<Message> messages = [
  Message('dummyUser', 'DummyText'),
  Message('dummyUser1', 'dummyUser1'),
];
