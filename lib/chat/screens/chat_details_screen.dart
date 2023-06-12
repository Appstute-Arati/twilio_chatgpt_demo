import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';
import 'package:twilio_chatgpt/chat/common/providers/chats_provider.dart';
import 'package:twilio_chatgpt/chat/common/providers/models_provider.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String conversationName;
  final String conversationSid;
  final String? identity;
  const ChatDetailsScreen(
      {Key? key,
      required this.conversationName,
      required this.conversationSid,
      required this.identity})
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
    chatBloc!
        .add(ReceiveMessageEvent(conversationName: widget.conversationSid));
    print("identity");
    print(widget.identity);
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversations'),
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<ChatBloc, ChatStates>(
            builder: (BuildContext context, ChatStates state) {
          if (state is ReceiveMessageLoadedState) {
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      //reverse: true, // Display messages from bottom to top
                      itemCount: state.messagesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final message = state.messagesList[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                              (message['author'] == widget.identity)
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            // ListTile(
                            //   title: Text(message['author']),
                            //   subtitle: Text(message['body']),
                            // )
                            Padding(
                              padding: const EdgeInsets.all(0.5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: (message['author'] == widget.identity)
                                    ? Colors.lightBlue
                                    : Colors.grey,
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          padding: const EdgeInsets.all(0.5),
                                          child: Text(message['author'],
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Container(
                                          padding: const EdgeInsets.all(0.5),
                                          child: Text(message['body'],
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.normal)))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            )
                          ],
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
                          onPressed: () async {
                            List<String>? substrings = typeMessage?.split(",");
                            if (substrings![0].contains("ChatGPT")) {
                              chatBloc!.add(SendMessageToChatGptEvent(
                                  modelsProvider: modelsProvider,
                                  chatProvider: chatProvider,
                                  typeMessage: typeMessage!));
                            } else {
                              chatBloc!.add(SendMessageEvent(
                                  enteredMessage: typeMessage,
                                  conversationName: widget.conversationSid));
                            }
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
          } else {
            return Container();
          }
        }, listener: (BuildContext context, ChatStates state) {
          if (state is SendMessageToChatGptLoadingState) {
            // ProgressBar.show(context);
          }
          if (state is SendMessageLoadedState) {
            chatBloc!.add(
                ReceiveMessageEvent(conversationName: widget.conversationSid));
          }
          if (state is ReceiveMessageLoadedState) {
            // ProgressBar.dismiss(context);
          }
          if (state is SendMessageToChatGptLoadedState) {
            //ProgressBar.dismiss(context);
            print("state.chatGptListList[0].msg");
            print(state.chatGptListList[1].msg);
            chatBloc!.add(SendMessageEvent(
                enteredMessage: state.chatGptListList[1].msg,
                conversationName: widget.conversationSid));
          }
        }));
  }
}
