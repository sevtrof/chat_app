import 'package:chat_app/domain/entities/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/presentation/screens/chat_screen.dart';
import 'package:chat_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/presentation/bloc/chat/chat_state.dart';
import 'package:mocktail/mocktail.dart';

class MockChatBloc extends Mock implements ChatBloc {}

void main() {
  late MockChatBloc mockChatBloc;

  setUp(() {
    mockChatBloc = MockChatBloc();
  });

  testWidgets('Testing ChatScreen with ChatLoading state',
      (WidgetTester tester) async {
    when(() => mockChatBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([ChatLoading()]));

    when(() => mockChatBloc.state).thenReturn(ChatLoading());

    await tester.pumpWidget(
      BlocProvider<ChatBloc>.value(
        value: mockChatBloc,
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Testing ChatScreen with ChatLoaded state',
      (WidgetTester tester) async {
    final chats = [
      Chat(
          id: "1",
          topic: "topic1",
          lastMessage: "hello",
          modifiedAt: 1627070000,
          members: ["user1", "user2"])
    ];

    when(() => mockChatBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([ChatLoaded(chats: chats)]));

    when(() => mockChatBloc.state).thenReturn(ChatLoaded(chats: chats));

    await tester.pumpWidget(
      BlocProvider<ChatBloc>.value(
        value: mockChatBloc,
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('Testing ChatScreen with ChatError state',
      (WidgetTester tester) async {
    when(() => mockChatBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([ChatError(message: "An error occurred")]));

    when(() => mockChatBloc.state).thenReturn(ChatError(message: "An error occurred"));

    await tester.pumpWidget(
      BlocProvider<ChatBloc>.value(
        value: mockChatBloc,
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    expect(find.text("An error occurred"), findsOneWidget);
  });
}
