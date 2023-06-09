import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_events.dart';
import 'package:twilio_chatgpt/chat/bloc/chat_states.dart';
import 'package:twilio_chatgpt/chat/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  ChatRepository chatRepository;

  ChatStates get initialState => ChatInitialState();

  ChatBloc({required this.chatRepository}) : super(ChatInitialState()) {
    on<GenerateTokenEvent>((event, emit) async {
      emit(GenerateTokenLoadingState());
      try {
        Map result = chatRepository.generateToken(event.credentials);
        emit(GenerateTokenLoadedState(inputMap: result));
      } catch (e) {
        emit(GenerateTokenErrorState(message: e.toString()));
      }
    });
    on<CreateConversionEvent>((event, emit) async {
      emit(CreateConversionLoadingState());
      try {
        Map result = chatRepository.createConversation(event.conversationName);
        emit(CreateConversionLoadedState(inputMap: result));
      } catch (e) {
        emit(CreateConversionErrorState(message: e.toString()));
      }
    });
  }
}
