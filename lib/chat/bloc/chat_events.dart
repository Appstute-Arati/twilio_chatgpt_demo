import 'package:equatable/equatable.dart';

abstract class ChatEvents extends Equatable {}

class GenerateTokenEvent extends ChatEvents {
  final Map credentials;
  GenerateTokenEvent({required this.credentials});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversion
class CreateConversionEvent extends ChatEvents {
  final String conversationName;
  final String? identity;
  CreateConversionEvent(
      {required this.conversationName, required this.identity});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversion
class JoinConversionEvent extends ChatEvents {
  final String conversationName;
  JoinConversionEvent({required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class SendMessageEvent extends ChatEvents {
  final String? enteredMessage;
  final String? conversationName;
  SendMessageEvent(
      {required this.enteredMessage, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class ReceiveMessageEvent extends ChatEvents {
  final Map inputMap;
  ReceiveMessageEvent({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//AddParticipant
class AddParticipantEvent extends ChatEvents {
  final String participantName;
  final String conversationName;
  AddParticipantEvent(
      {required this.participantName, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//AddParticipant
class SeeMyConversationsEvent extends ChatEvents {
  SeeMyConversationsEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}
