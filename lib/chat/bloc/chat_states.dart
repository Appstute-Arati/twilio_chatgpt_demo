import 'package:equatable/equatable.dart';

abstract class ChatStates extends Equatable {}

class ChatInitialState extends ChatStates {
  @override
  List<Object?> get props => throw UnimplementedError();
}

// GenerateTokenLoadingState
class GenerateTokenLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// GenerateTokenLoadedState
class GenerateTokenLoadedState extends ChatStates {
  final Map inputMap;
  GenerateTokenLoadedState({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversionErrorState
class GenerateTokenErrorState extends ChatStates {
  final String message;
  GenerateTokenErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversionLoadingState
class CreateConversionLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// CreateConversionLoadedState
class CreateConversionLoadedState extends ChatStates {
  final Map inputMap;
  CreateConversionLoadedState({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversionErrorState
class CreateConversionErrorState extends ChatStates {
  final String message;
  CreateConversionErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversionLoadingState
class JoinConversionLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// JoinConversionLoadedState
class JoinConversionLoadedState extends ChatStates {
  final Map inputMap;
  JoinConversionLoadedState({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversionErrorState
class JoinConversionErrorState extends ChatStates {
  final String message;
  JoinConversionErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SendMessageLoadingState
class SendMessageLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// SendMessageLoadedState
class SendMessageLoadedState extends ChatStates {
  final Map inputMap;
  SendMessageLoadedState({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SendMessageErrorState
class SendMessageErrorState extends ChatStates {
  final String message;
  SendMessageErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// ReceiveMessageLoadingState
class ReceiveMessageLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// ReceiveMessageLoadedState
class ReceiveMessageLoadedState extends ChatStates {
  final Map inputMap;
  ReceiveMessageLoadedState({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// ReceiveMessageErrorState
class ReceiveMessageErrorState extends ChatStates {
  final String message;
  ReceiveMessageErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// AddParticipantLoadingState
class AddParticipantLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// AddParticipantLoadedState
class AddParticipantLoadedState extends ChatStates {
  final Map inputMap;
  AddParticipantLoadedState({required this.inputMap});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// AddParticipantErrorState
class AddParticipantErrorState extends ChatStates {
  final String message;
  AddParticipantErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}
