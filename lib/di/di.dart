import 'package:chat_app/data/repository/chat_repository_impl.dart';
import 'package:chat_app/data/services/api_chat_service.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/usecases/get_chats_usecase.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/presentation/bloc/message/dialog_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<ApiChatService>(() => ApiChatServiceImpl());

  getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(apiDataSource: getIt()));

  getIt.registerLazySingleton(() => GetChatsUsecase(getIt()));
  getIt.registerLazySingleton(() => GetMessagesUsecase(getIt()));
  getIt.registerLazySingleton(() => SendMessageUsecase());

  getIt.registerFactory(() => ChatBloc(
        getChatsUsecase: getIt(),
        getMessagesUsecase: getIt(),
      ));

  getIt.registerFactory(() => DialogBloc(
      getMessagesUsecase: getIt(), sendMessageUsecase: getIt()));
}
