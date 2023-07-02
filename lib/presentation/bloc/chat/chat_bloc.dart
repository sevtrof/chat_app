import 'package:chat_app/domain/usecases/get_chats_usecase.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/presentation/bloc/chat/chat_event.dart';
import 'package:chat_app/presentation/bloc/chat/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUsecase getChatsUsecase;
  final GetMessagesUsecase getMessagesUsecase;

  ChatBloc({
    required this.getChatsUsecase,
    required this.getMessagesUsecase,
  }) : super(ChatInitial()) {
    on<FetchChats>((event, emit) async {
      await _mapFetchChatsToState(emit);
    });
    on<FetchMessages>((event, emit) async {
      await _mapFetchMessagesToState(event, emit);
    });
  }

  Future<void> _mapFetchChatsToState(Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chats = await getChatsUsecase.execute();
      emit(ChatLoaded(chats: chats));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _mapFetchMessagesToState(
    FetchMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await getMessagesUsecase.execute(event.conversationId);
      emit(MessagesLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }
}
