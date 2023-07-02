import 'package:chat_app/presentation/bloc/chat/chat_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/di/di.dart' as di;
import 'package:chat_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/presentation/screens/chat_screen.dart';

void main() {
  di.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => di.getIt<ChatBloc>()..add(FetchChats()),
        child: const ChatScreen(),
      ),
    );
  }
}
