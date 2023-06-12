import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';
import 'package:twilio_chatgpt/chat/common/dialog_with_edittext.dart';
import 'package:twilio_chatgpt/chat/repository/chat_repository.dart';
import 'package:twilio_chatgpt/chat/screens/chat_details_screen.dart';
import 'package:twilio_chatgpt/chat/screens/conversation_list_screen.dart';

class ChatScreen extends StatefulWidget {
  final String? identity;
  const ChatScreen({Key? key, required this.identity}) : super(key: key);

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
        body: BlocConsumer<ChatBloc, ChatStates>(
            builder: (BuildContext context, ChatStates state) {
          return Column(
            children: [
              // ElevatedButton(
              //     onPressed: () {
              //       print("onPressedd");
              //       chatBloc!.add(GenerateTokenEvent(credentials: const {
              //         "accountSid": "AC7dac7823ccc631c5121146db333132f4",
              //         "apiKey": "SKf09f0de93c7a51e090f69df13a524ec5",
              //         "apiSecret": "irAC6QfH9rsnnBC23ZDEcLGcUBb4mS5Z",
              //         // "identity": "arati.pailwan@zingworks.in"
              //         "identity": "newUser"
              //       }));
              //     },
              //     child: const Text("Generate Token")),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogWithEditText(
                          onPressed: (enteredText) {
                            chatBloc!.add(CreateConversionEvent(
                                conversationName: enteredText,
                                identity: widget.identity));
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                  child: const Text("Create Conversation")),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogWithEditText(
                          onPressed: (enteredText) {
                            chatBloc!.add(JoinConversionEvent(
                                conversationName: enteredText));
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                    //
                  },
                  child: const Text("Join Conversation")),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogWithEditText(
                          onPressed: (enteredText) {
                            chatBloc!.add(AddParticipantEvent(
                                participantName: enteredText,
                                conversationName: ""));
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                  child: const Text("Add Participant")),
              ElevatedButton(
                  onPressed: () {
                    chatBloc!.add(SeeMyConversationsEvent());
                  },
                  child: const Text("See My Conversations"))
            ],
          );
        }, listener: (BuildContext context, ChatStates state) {
          if (state is JoinConversionLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) =>
                        ChatBloc(chatRepository: ChatRepositoryImpl()),
                    child: const ChatDetailsScreen(
                        conversationName: '', conversationSid: '')),
              ),
            );
          }
          if (state is SeeMyConversationsLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) =>
                        ChatBloc(chatRepository: ChatRepositoryImpl()),
                    child: ConversationListScreen(
                        conversationList: state.conversationList)),
              ),
            );
          }
        }));
  }
}
