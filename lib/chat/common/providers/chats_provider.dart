import 'package:flutter/cupertino.dart';
import 'package:twilio_chatgpt/chat/common/api/api_provider.dart';

import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    print("chosenModelId-${chosenModelId}msg-$msg");
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiProvider.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiProvider.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
