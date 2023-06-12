import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';
import 'package:twilio_chatgpt/chat/repository/chat_repository.dart';
import 'package:twilio_chatgpt/chat/screens/chat_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  ChatBloc? chatBloc;

  String? identity;

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Login As',
                      labelText: 'Name *',
                    ),
                    onSaved: (String? value) {
                      identity = value;
                    },
                    onChanged: (value) {
                      identity = value;
                    },
                    validator: (String? value) {
                      return (value != null && value.contains('@'))
                          ? 'Do not use the @ char.'
                          : null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.10),
                ElevatedButton(
                    onPressed: () {
                      print("onPressedd" + "-" + identity.toString());
                      chatBloc!.add(GenerateTokenEvent(credentials: {
                        "accountSid": "AC7dac7823ccc631c5121146db333132f4",
                        "apiKey": "SKf09f0de93c7a51e090f69df13a524ec5",
                        "apiSecret": "irAC6QfH9rsnnBC23ZDEcLGcUBb4mS5Z",
                        // "identity": "arati.pailwan@zingworks.in"
                        "identity": identity
                      }));
                    },
                    child: const Text("Login As")),
              ],
            ),
          );
        }, listener: (BuildContext context, ChatStates state) {
          if (state is GenerateTokenLoadingState) {}
          if (state is GenerateTokenLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) =>
                        ChatBloc(chatRepository: ChatRepositoryImpl()),
                    child: ChatScreen(identity: identity)),
              ),
            );
          }
        }));
  }
}
