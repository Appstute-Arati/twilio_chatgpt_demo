import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';
import 'package:twilio_chatgpt/chat/common/widgets/common_text_button_widget.dart';
import 'package:twilio_chatgpt/chat/common/widgets/common_textfield.dart';
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
  final TextEditingController _phoneController = TextEditingController();

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
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child:
                        SvgPicture.asset("assets/images/twilio_logo_red.svg")),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.16,
                ),
                const Text(
                  "Enter the user which you want to login",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.visible,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.050,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: TextInputField(
                      icon: const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.none,
                      hintText: "",
                      maxLength: 10,
                      textInputFormatter: const [],
                      keyboardType: TextInputType.text,
                      width: MediaQuery.of(context).size.width * 0.90,
                      color: Colors.white,
                      borderColor: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.31),
                          blurRadius: 15,
                          offset: const Offset(-5, 5),
                        )
                      ],
                      controller: _phoneController,
                      textStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.visible,
                        decoration: TextDecoration.none,
                      ),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CommonTextButtonWidget(
                  isIcon: false,
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.82,
                  title: "Login As",
                  titleFontSize: 14.0,
                  titleFontWeight: FontWeight.w600,
                  onPressed: () {
                    identity == _phoneController.text;
                    chatBloc!.add(GenerateTokenEvent(credentials: {
                      "accountSid": "AC7dac7823ccc631c5121146db333132f4",
                      "apiKey": "SKf09f0de93c7a51e090f69df13a524ec5",
                      "apiSecret": "irAC6QfH9rsnnBC23ZDEcLGcUBb4mS5Z",
                      // "identity": "arati.pailwan@zingworks.in"
                      "identity": _phoneController.text
                    }));
                  },
                ),
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
                    child: ChatScreen(identity: _phoneController.text)),
              ),
            );
          }
        }));
  }
}
