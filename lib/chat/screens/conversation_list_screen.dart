import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';
import 'package:twilio_chatgpt/chat/common/dialog_with_edittext.dart';
import 'package:twilio_chatgpt/chat/common/toast_utility.dart';
import 'package:twilio_chatgpt/chat/repository/chat_repository.dart';
import 'package:twilio_chatgpt/chat/screens/chat_details_screen.dart';

class ConversationListScreen extends StatefulWidget {
  final List conversationList;
  final String? identity;
  const ConversationListScreen(
      {Key? key, required this.conversationList, required this.identity})
      : super(key: key);

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  ChatBloc? chatBloc;

  String? identity;

  var conversationName = "";

  var conversationSid = "";

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
            child: ListView.builder(
              itemCount: widget.conversationList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xffADB6D8),
                      elevation: 10,
                      child: ListTile(
                        title: Text(
                          widget.conversationList[index]["conversationName"],
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          widget.conversationList[index]["sid"],
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogWithEditText(
                                        onPressed: (enteredText) {
                                          conversationName =
                                              widget.conversationList[index]
                                                  ["conversationName"];
                                          conversationSid = widget
                                              .conversationList[index]["sid"];
                                          chatBloc!.add(AddParticipantEvent(
                                              participantName: enteredText,
                                              conversationName:
                                                  widget.conversationList[index]
                                                      ["sid"]));
                                          Navigator.of(context).pop();
                                        },
                                        dialogTitle: "Add Participant",
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                )),
                            IconButton(
                                onPressed: () {
                                  chatBloc!.add(JoinConversionEvent(
                                      conversationName: widget
                                          .conversationList[index]["sid"]));
                                },
                                icon: const Icon(Icons.join_full)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }, listener: (BuildContext context, ChatStates state) {
          if (state is AddParticipantLoadedState) {
            ToastUtility.showToastAtBottom(state.addedStatus);
          }
          if (state is JoinConversionLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) =>
                        ChatBloc(chatRepository: ChatRepositoryImpl()),
                    child: ChatDetailsScreen(
                      conversationName: state.result,
                      conversationSid: state.result,
                      identity: widget.identity,
                    )),
              ),
            );
          }
          if (state is GenerateTokenLoadedState) {}
        }));
  }
}
