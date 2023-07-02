import 'package:chat_app/domain/entities/message.dart';
import 'package:chat_app/presentation/bloc/message/dialog_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/presentation/bloc/message/dialog_bloc.dart';
import 'package:chat_app/presentation/screens/dialog_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockDialogBloc extends Mock implements DialogBloc {}

void main() {
  late MockDialogBloc mockDialogBloc;

  setUp(() {
    mockDialogBloc = MockDialogBloc();
  });

  testWidgets('Testing DialogScreen with DialogLoading state', (WidgetTester tester) async {
    when(() => mockDialogBloc.stream).thenAnswer((_) => Stream.fromIterable([DialogLoading()]));

    when(() => mockDialogBloc.state).thenReturn(DialogLoading());

    await tester.pumpWidget(
      BlocProvider<DialogBloc>.value(
        value: mockDialogBloc,
        child: const MaterialApp(home: DialogScreen("test_chat_id")),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Testing DialogScreen with DialogLoaded state', (WidgetTester tester) async {
    final messages = [Message(id: '12345', sender: "user1", message: "hello", modifiedAt: 1627070000)];

    when(() => mockDialogBloc.stream).thenAnswer((_) => Stream.fromIterable([DialogLoaded(messages: messages)]));

    when(() => mockDialogBloc.state).thenReturn(DialogLoaded(messages: messages));

    await tester.pumpWidget(
      BlocProvider<DialogBloc>.value(
        value: mockDialogBloc,
        child: const MaterialApp(home: DialogScreen("test_chat_id")),
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('Testing DialogScreen with DialogError state', (WidgetTester tester) async {
    when(() => mockDialogBloc.stream).thenAnswer((_) => Stream.fromIterable([DialogError(message: "An error occurred")]));

    when(() => mockDialogBloc.state).thenReturn(DialogError(message: "An error occurred"));

    await tester.pumpWidget(
      BlocProvider<DialogBloc>.value(
        value: mockDialogBloc,
        child: const MaterialApp(home: DialogScreen("test_chat_id")),
      ),
    );

    expect(find.text("An error occurred"), findsOneWidget);
  });
}

