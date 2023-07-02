import 'package:chat_app/domain/entities/message.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/message/dialog_event.dart';
import 'package:chat_app/presentation/bloc/message/dialog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  final GetMessagesUsecase getMessagesUsecase;
  final SendMessageUsecase sendMessageUsecase;

  DialogBloc({
    required this.getMessagesUsecase,
    required this.sendMessageUsecase,
  }) : super(DialogInitial()) {
    on<FetchDialog>(_mapFetchDialogToState);
    on<SendDialogMessage>(_mapSendDialogMessageToState);
  }

  Future<void> _mapFetchDialogToState(
    FetchDialog event,
    Emitter<DialogState> emit,
  ) async {
    emit(DialogLoading());
    try {
      final messages =
          (await getMessagesUsecase.execute(event.chatId)).cast<Message>();
      if (messages.isNotEmpty) {
        emit(DialogLoaded(messages: messages));
      } else {
        emit(DialogEmpty());
      }
    } catch (e) {
      emit(DialogError(message: e.toString()));
    }
  }

  Future<void> _mapSendDialogMessageToState(
    SendDialogMessage event,
    Emitter<DialogState> emit,
  ) async {
    try {
      final sentMessage =
          await sendMessageUsecase.execute(event.chatId, event.message);

      // This simulates a message sending delay.
      await Future.delayed(const Duration(seconds: 1));

      final currentState = state as DialogLoaded;
      final List<Message> updatedMessages = List.from(currentState.messages)
        ..add(sentMessage);
      emit(DialogLoaded(messages: updatedMessages));
    } catch (e) {
      emit(DialogError(message: e.toString()));
    }
  }
}
