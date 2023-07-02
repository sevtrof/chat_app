import 'package:chat_app/presentation/bloc/chat/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/presentation/bloc/message/dialog_bloc.dart';
import 'package:chat_app/presentation/screens/dialog_screen.dart';
import 'package:get_it/get_it.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final conversation = state.chats[index];
                final lastMessageTime = DateTime.fromMillisecondsSinceEpoch(
                    conversation.modifiedAt * 1000);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<DialogBloc>(
                          create: (context) => GetIt.I.get(),
                          child: DialogScreen(conversation.id),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.topic,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            conversation.lastMessage,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Members: ${conversation.members.join(", ")}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Last Message Time: ${lastMessageTime.toString()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
