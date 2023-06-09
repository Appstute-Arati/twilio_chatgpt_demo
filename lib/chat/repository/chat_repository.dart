import 'package:flutter/services.dart';

abstract class ChatRepository {
  init();
  generateToken(credentials);
  createConversation(conversationName);
  joinConversation();
  sendMessage();
  receiveMessage();
  addParticipant();
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<void> createConversation(conversationName) async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result = await platform.invokeMethod(
          'createConversation', {"conversationName": conversationName});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<void> generateToken(credentials) async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result = await platform.invokeMethod('generateToken', {
        "accountSid": credentials['accountSid'],
        "apiKey": credentials['apiKey'],
        "apiSecret": credentials['apiSecret'],
        "identity": credentials['identity']
      });
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<void> init() async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result =
          await platform.invokeMethod('init', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<void> joinConversation() async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result =
          await platform.invokeMethod('joinConversation', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<void> receiveMessage() async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result =
          await platform.invokeMethod('receiveMessage', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<void> sendMessage() async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result =
          await platform.invokeMethod('sendMessage', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }

  @override
  Future<void> addParticipant() async {
    String response;
    try {
      const platform = MethodChannel('twilio_chatgpt/twilio_sdk_connection');
      final String result =
          await platform.invokeMethod('addParticipant', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to get response";
    }
  }
}
