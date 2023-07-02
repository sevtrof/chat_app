import 'package:chat_app/domain/entities/message.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/message/dialog_bloc.dart';
import 'package:chat_app/presentation/bloc/message/dialog_event.dart';
import 'package:chat_app/presentation/bloc/message/dialog_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMessagesUsecase extends Mock implements GetMessagesUsecase {}

class MockSendMessageUsecase extends Mock implements SendMessageUsecase {}

void main() {
  late MockGetMessagesUsecase getMessagesUsecase;
  late MockSendMessageUsecase sendMessageUsecase;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    getMessagesUsecase = MockGetMessagesUsecase();
    sendMessageUsecase = MockSendMessageUsecase();
  });

  test('emits [DialogLoading, DialogLoaded] when FetchDialog is successful',
      () async {
    final mockMessages = [
      Message(
        id: "1003",
        message: "How about tomorrow then?",
        modifiedAt: 1599814026153,
        sender: "John",
      ),
      Message(
        id: "1002",
        message: "Sorry I can't today",
        modifiedAt: 1599814006153,
        sender: "Daniel",
      ),
      Message(
        id: "1001",
        message: "Hei how about some pizza tonight?",
        modifiedAt: 1599813006153,
        sender: "John",
      ),
    ];

    when(() => getMessagesUsecase.execute(any()))
        .thenAnswer((_) async => mockMessages);

    final bloc = DialogBloc(
      getMessagesUsecase: getMessagesUsecase,
      sendMessageUsecase: sendMessageUsecase,
    );

    final expectedResponse = [
      isA<DialogLoading>(),
      isA<DialogLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(FetchDialog(chatId: 'test_chat_id'));
  });

  test(
      'emits [DialogLoading, DialogError] when FetchDialog throws an exception',
      () async {
    when(() => getMessagesUsecase.execute(any()))
        .thenThrow(Exception('Failed to fetch messages'));

    final bloc = DialogBloc(
      getMessagesUsecase: getMessagesUsecase,
      sendMessageUsecase: sendMessageUsecase,
    );

    final expectedResponse = [
      isA<DialogLoading>(),
      isA<DialogError>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(FetchDialog(chatId: 'test_chat_id'));
  });

  test(
      'emits [DialogLoading, DialogError] when SendMessage throws an exception',
      () async {
    when(() => sendMessageUsecase.execute(
          any(),
          any(),
          any(),
        )).thenThrow(Exception('Failed to send message'));

    final bloc = DialogBloc(
      getMessagesUsecase: getMessagesUsecase,
      sendMessageUsecase: sendMessageUsecase,
    );

    final expectedResponse = [
      isA<DialogError>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(SendDialogMessage(chatId: 'test_chat_id', message: "Hello"));
  });
}
