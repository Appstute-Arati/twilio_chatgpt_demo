import 'package:flutter/services.dart';
import 'package:twilio_chatgpt/chat/common/api/api_provider.dart';
import 'package:twilio_chatgpt/chat/common/models/chat_model.dart';

abstract class ChatRepository {
  init();
  Future<String> generateToken(credentials);
  Future<String> createConversation(conversationName, identity);
  Future<String> joinConversation(conversationName);
  Future<String> sendMessage(enteredMessage, conversationName, isFromGhatGpt);
  receiveMessage();
  addParticipant(participantName, conversationName);
  Future<List> seeMyConversations();
  Future<List> getMessages(conversationName);
  Future<List<ChatModel>> sendMessageToChatGpt(
      modelsProvider, chatProvider, typeMessage);
}

class ChatRepositoryImpl implements ChatRepository {
  final platform = const MethodChannel('twilio_chatgpt/twilio_sdk_connection');
  final ApiProvider _apiProvider = ApiProvider();

  @override
  Future<String> createConversation(conversationName, identity) async {
    String response;
    try {
      final String result = await platform.invokeMethod('createConversation',
          {"conversationName": conversationName, "identity": identity});

      response = result;
      return response;
    } on PlatformException catch (e) {
      response = "Failed to get response";
      return response;
    }
  }

  @override
  Future<String> generateToken(credentials) async {
    String response;
    try {
      final String result = await platform.invokeMethod('generateToken', {
        "accountSid": credentials['accountSid'],
        "apiKey": credentials['apiKey'],
        "apiSecret": credentials['apiSecret'],
        "identity": credentials['identity']
      });
      response = result;
      print("result--$response");
      return response;
    } on PlatformException catch (e) {
      response = "Failed to get response";
      return response;
    }
  }

  @override
  Future<void> init() async {
    String response;
    try {
      final String result =
          await platform.invokeMethod('init', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<String> joinConversation(conversationName) async {
    String response;
    try {
      final String result = await platform.invokeMethod(
          'joinConversation', {"conversationName": conversationName});
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = "Failed to get response";
      return response;
    }
  }

  @override
  Future<void> receiveMessage() async {
    String response;
    try {
      final String result =
          await platform.invokeMethod('receiveMessage', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<String> sendMessage(
      enteredMessage, conversationName, isFromChatGpt) async {
    String response;
    try {
      final String result = await platform.invokeMethod('sendMessage', {
        "enteredMessage": enteredMessage,
        "conversationName": conversationName,
        "isFromChatGpt": isFromChatGpt
      });
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = "Failed to get response";
      return response;
    }
  }

  @override
  Future<String> addParticipant(participantName, conversationName) async {
    String response;
    try {
      final String result = await platform.invokeMethod('addParticipant', {
        "participantName": participantName,
        "conversationName": conversationName
      });
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = "Failed to get response";
      return response;
    }
  }

  @override
  Future<List> seeMyConversations() async {
    List response;
    try {
      final List result = await platform
          .invokeMethod('seeMyConversations', {"mobileNumber": ""});
      print("seeMyConversations");
      print(result.length.toString());
      response = result;

      return response;
    } on PlatformException catch (e) {
      //response = "Failed to get response";
      return [];
    }
  }

  @override
  Future<List> getMessages(conversationName) async {
    List response;
    try {
      final List result = await platform
          .invokeMethod('getMessages', {"conversationName": conversationName});
      print("seeMyConversations");
      print(result.length.toString());
      response = result;

      return response;
    } on PlatformException catch (e) {
      //response = "Failed to get response";
      return [];
    }
  }

  @override
  Future<List<ChatModel>> sendMessageToChatGpt(
      modelsProvider, chatProvider, typeMessage) async {
    chatProvider.addUserMessage(msg: typeMessage);
    await chatProvider.sendMessageAndGetAnswers(
        msg: typeMessage, chosenModelId: modelsProvider.getCurrentModel);
    return chatProvider.getChatList;
  }
}
