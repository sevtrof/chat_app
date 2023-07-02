import 'package:chat_app/domain/entities/chat.dart';
import 'package:chat_app/domain/entities/message.dart';
import 'package:chat_app/domain/usecases/get_chats_usecase.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/presentation/bloc/chat/chat_event.dart';
import 'package:chat_app/presentation/bloc/chat/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetChatsUsecase extends Mock implements GetChatsUsecase {}

class MockGetMessagesUsecase extends Mock implements GetMessagesUsecase {}

void main() {
  late MockGetChatsUsecase getChatsUsecase;
  late MockGetMessagesUsecase getMessagesUsecase;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    getChatsUsecase = MockGetChatsUsecase();
    getMessagesUsecase = MockGetMessagesUsecase();
  });

  test('emits [ChatLoading, ChatLoaded] when FetchChats is successful',
      () async {
    final mockChats = [
      Chat(
        id: "9991",
        lastMessage: "How about tomorrow then?",
        members: ["John", "Daniel", "Rachel"],
        topic: "pizza night",
        modifiedAt: 1599814026153,
      ),
      Chat(
        id: "9992",
        lastMessage: "I will send them to you asap",
        members: ["Raphael"],
        topic: "slides",
        modifiedAt: 1599000026153,
      ),
      Chat(
        id: "9993",
        lastMessage: "Can you please?",
        members: ["Mum", "Dad", "Bro"],
        topic: "pictures",
        modifiedAt: 1512814026153,
      ),
    ];

    when(() => getChatsUsecase.execute()).thenAnswer((_) async => mockChats);

    final bloc = ChatBloc(
      getChatsUsecase: getChatsUsecase,
      getMessagesUsecase: getMessagesUsecase,
    );

    final expectedResponse = [
      isA<ChatLoading>(),
      isA<ChatLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(FetchChats());
  });

  test('emits [ChatLoading, MessagesLoaded] when FetchMessages is successful',
      () async {
    final mockMessages = [
      Message(id: '1', message: 'Hi', modifiedAt: 1234567890, sender: 'John'),
      Message(
          id: '2', message: 'Hello', modifiedAt: 1234567891, sender: 'Jane'),
    ];

    when(() => getMessagesUsecase.execute(any()))
        .thenAnswer((_) async => mockMessages);

    final bloc = ChatBloc(
      getChatsUsecase: getChatsUsecase,
      getMessagesUsecase: getMessagesUsecase,
    );

    final expectedResponse = [
      isA<ChatLoading>(),
      isA<MessagesLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(FetchMessages('test_conversation_id'));
  });

  test('emits [ChatLoading, ChatError] when FetchChats throws an exception',
      () async {
    when(() => getChatsUsecase.execute())
        .thenThrow(Exception('Failed to fetch chats'));

    final bloc = ChatBloc(
      getChatsUsecase: getChatsUsecase,
      getMessagesUsecase: getMessagesUsecase,
    );

    final expectedResponse = [
      isA<ChatLoading>(),
      isA<ChatError>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(FetchChats());
  });

  test('emits [ChatLoading, ChatError] when FetchMessages throws an exception',
      () async {
    when(() => getMessagesUsecase.execute(any()))
        .thenThrow(Exception('Failed to fetch messages'));

    final bloc = ChatBloc(
      getChatsUsecase: getChatsUsecase,
      getMessagesUsecase: getMessagesUsecase,
    );

    final expectedResponse = [
      isA<ChatLoading>(),
      isA<ChatError>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedResponse));

    bloc.add(FetchMessages('test_conversation_id'));
  });
}
