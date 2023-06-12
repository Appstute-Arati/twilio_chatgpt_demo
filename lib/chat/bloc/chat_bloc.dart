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
        String result = await chatRepository.generateToken(event.credentials);
        emit(GenerateTokenLoadedState(token: result));
      } catch (e) {
        emit(GenerateTokenErrorState(message: e.toString()));
      }
    });
    on<CreateConversionEvent>((event, emit) async {
      emit(CreateConversionLoadingState());
      try {
        Map result = chatRepository.createConversation(
            event.conversationName, event.identity);
        emit(CreateConversionLoadedState(inputMap: result));
      } catch (e) {
        emit(CreateConversionErrorState(message: e.toString()));
      }
    });

    on<SeeMyConversationsEvent>((event, emit) async {
      emit(SeeMyConversationsLoadingState());
      try {
        List result = await chatRepository.seeMyConversations();
        print("result");
        print(result);
        emit(SeeMyConversationsLoadedState(conversationList: result));
      } catch (e) {
        emit(CreateConversionErrorState(message: e.toString()));
      }
    });

    on<JoinConversionEvent>((event, emit) async {
      emit(JoinConversionLoadingState());
      try {
        String result =
            await chatRepository.joinConversation(event.conversationName);
        emit(JoinConversionLoadedState(result: result));
      } catch (e) {
        emit(JoinConversionErrorState(message: e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      emit(SendMessageLoadingState());
      try {
        String result = await chatRepository.sendMessage(
            event.enteredMessage, event.conversationName);
        emit(SendMessageLoadedState(status: result));
      } catch (e) {
        emit(SendMessageErrorState(message: e.toString()));
      }
    });

    on<AddParticipantEvent>((event, emit) async {
      emit(AddParticipantLoadingState());
      try {
        String result = await chatRepository.addParticipant(
            event.participantName, event.conversationName);
        emit(AddParticipantLoadedState(addedStatus: result));
      } catch (e) {
        emit(AddParticipantErrorState(message: e.toString()));
      }
    });
  }
}
