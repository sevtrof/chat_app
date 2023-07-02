import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/presentation/bloc/message/dialog_bloc.dart';
import 'package:chat_app/presentation/bloc/message/dialog_event.dart';
import 'package:chat_app/presentation/bloc/message/dialog_state.dart';

class DialogScreen extends StatefulWidget {
  final String chatId;

  const DialogScreen(this.chatId, {Key? key}) : super(key: key);

  @override
  DialogScreenState createState() => DialogScreenState();
}

class DialogScreenState extends State<DialogScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DialogBloc>().add(FetchDialog(chatId: widget.chatId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      context
          .read<DialogBloc>()
          .add(SendDialogMessage(chatId: widget.chatId, message: message));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<DialogBloc, DialogState>(
              builder: (context, state) {
                if (state is DialogLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DialogLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final time = DateTime.fromMillisecondsSinceEpoch(
                              message.modifiedAt * 1000)
                          .toLocal()
                          .toString()
                          .substring(0, 17);

                      bool isCurrentUser = message.sender == 'user';

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue[200]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                isCurrentUser
                                    ? Container()
                                    : Text(message.sender,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                Text(message.message),
                                Text(time,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is DialogError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
