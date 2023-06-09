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
  CreateConversionEvent({required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversion
class JoinConversionEvent extends ChatEvents {
  final Map inputMap;
  JoinConversionEvent({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class SendMessageEvent extends ChatEvents {
  final Map inputMap;
  SendMessageEvent({required this.inputMap});

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
  final Map inputMap;
  AddParticipantEvent({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}
