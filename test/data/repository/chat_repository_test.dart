import 'package:chat_app/data/models/chat/chat_model.dart';
import 'package:chat_app/data/models/message/message_model.dart';
import 'package:chat_app/data/repository/chat_repository_impl.dart';
import 'package:chat_app/data/services/api_chat_service.dart';
import 'package:chat_app/domain/entities/chat.dart';
import 'package:chat_app/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiChatService extends Mock implements ApiChatService {}

void main() {
  late ChatRepositoryImpl chatRepository;
  late MockApiChatService mockApiChatService;

  setUp(() {
    mockApiChatService = MockApiChatService();
    chatRepository = ChatRepositoryImpl(apiDataSource: mockApiChatService);
  });

  group('fetchChats', () {
    test('should return a list of Chat when successful', () async {
      final chatModels = [
        {
          "id": "9991",
          "last_message": "How about tomorrow then?",
          "members": ["John", "Daniel", "Rachel"],
          "topic": "pizza night",
          "modified_at": 1599814026153
        },
        {
          "id": "9992",
          "last_message": "I will send them to you asap",
          "members": ["Raphael"],
          "topic": "slides",
          "modified_at": 1599000026153
        },
        {
          "id": "9993",
          "last_message": "Can you please?",
          "members": ["Mum", "Dad", "Bro"],
          "topic": "pictures",
          "modified_at": 1512814026153
        },
      ].map((e) => ChatModel.fromJson(e)).toList();

      when(() => mockApiChatService.fetchConversations())
          .thenAnswer((_) async => chatModels);

      final result = await chatRepository.fetchChats();

      expect(result, isA<List<Chat>>());
      verify(() => mockApiChatService.fetchConversations()).called(1);
    });

    test('should throw an exception when unsuccessful', () async {
      when(() => mockApiChatService.fetchConversations())
          .thenThrow(Exception());

      expect(() async => await chatRepository.fetchChats(),
          throwsA(isA<Exception>()));
    });
  });

  group('fetchMessages', () {
    test('should return a list of Message when successful', () async {
      final messageModels = [
        {
          "id": "1003",
          "message": "How about tomorrow then?",
          "modified_at": 1599814026153,
          "sender": "John"
        },
        {
          "id": "1002",
          "message": "Sorry I can't today",
          "modified_at": 1599814006153,
          "sender": "Daniel"
        },
        {
          "id": "1001",
          "message": "Hei how about some pizza tonight?",
          "modified_at": 1599813006153,
          "sender": "John"
        }
      ].map((e) => MessageModel.fromJson(e)).toList();

      const conversationId = '9991';
      when(() => mockApiChatService.fetchMessages(conversationId))
          .thenAnswer((_) async => messageModels);

      final result = await chatRepository.fetchMessages(conversationId);

      expect(result, isA<List<Message>>());
      verify(() => mockApiChatService.fetchMessages(conversationId)).called(1);
    });

    test('should throw an exception when unsuccessful', () async {
      const conversationId = '9991';
      when(() => mockApiChatService.fetchMessages(conversationId))
          .thenThrow(Exception());

      expect(() async => await chatRepository.fetchMessages(conversationId),
          throwsA(isA<Exception>()));
    });
  });
}
