import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';

enum ChatType { single, group, channel }

class ChatsList {
  static const List<ChatsEntity> chats = [
    ChatsEntity(
      chatId: 'chat_001',
      chatName: 'Alice',
      participantDetails: ['user_001', 'user_002'],
      lastMessage: 'See you soon!',
      lastMessageTime: '10:15 AM',
      chatType: ChatType.single,
      isRead: true,
    ),
    ChatsEntity(
      chatId: 'chat_002',
      chatName: 'Work Team',
      participantDetails: ['user_001', 'user_003', 'user_004'],
      lastMessage: 'Meeting at 3 PM.',
      lastMessageTime: '09:30 AM',
      chatType: ChatType.group,
      isRead: false,
    ),
    ChatsEntity(
      chatId: 'chat_003',
      chatName: 'Bob',
      participantDetails: ['user_001', 'user_005'],
      lastMessage: 'Let me know.',
      lastMessageTime: '7:30 PM',
      chatType: ChatType.single,
      isRead: true,
    ),
    ChatsEntity(
      chatId: 'chat_004',
      chatName: 'Family Group',
      participantDetails: ['user_001', 'user_002', 'user_006', 'user_007'],
      lastMessage: 'Dinner is ready!',
      lastMessageTime: '8:00 PM',
      chatType: ChatType.group,
      isRead: false,
    ),
    ChatsEntity(
      chatId: 'chat_005',
      chatName: 'John',
      participantDetails: ['user_001', 'user_008'],
      lastMessage: 'Check this out!',
      lastMessageTime: '12:45 PM',
      chatType: ChatType.single,
      isRead: true,
    ),
    ChatsEntity(
      chatId: 'chat_006',
      chatName: 'Developers Chat',
      participantDetails: ['user_001', 'user_009', 'user_010'],
      lastMessage: 'PR #123 has been merged.',
      lastMessageTime: '3:45 PM',
      chatType: ChatType.group,
      isRead: true,
    ),
    ChatsEntity(
      chatId: 'chat_007',
      chatName: 'Emily',
      participantDetails: ['user_001', 'user_011'],
      lastMessage: 'Can we talk later?',
      lastMessageTime: '7:30 PM',
      chatType: ChatType.single,
      isRead: false,
    ),
    ChatsEntity(
      chatId: 'chat_008',
      chatName: 'Basketball Buddies',
      participantDetails: ['user_001', 'user_002', 'user_003'],
      lastMessage: 'See you at the court!',
      lastMessageTime: '7:30 PM',
      chatType: ChatType.group,
      isRead: true,
    ),
    ChatsEntity(
      chatId: 'chat_009',
      chatName: 'Anna',
      participantDetails: ['user_001', 'user_012'],
      lastMessage: 'Thanks for the help!',
      lastMessageTime: '1:15 PM',
      chatType: ChatType.single,
      isRead: false,
    ),
    ChatsEntity(
      chatId: 'chat_010',
      chatName: 'Office Announcements',
      participantDetails: ['user_001', 'user_013', 'user_014'],
      lastMessage: 'Office will be closed on Friday.',
      lastMessageTime: 'Yesterday, 11:00 AM',
      chatType: ChatType.group,
      isRead: true,
    ),
  ];
}

class ChatDetailList {
  static List<SingleChatEntity> chatSamples = [
    SingleChatEntity(
      messageId: 'msg_001',
      message: 'Hey, how are you?',
      dataType: 'text',
      dataUrl: null,
      senderId: 'user_001',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)).toString(),
    ),
    SingleChatEntity(
      messageId: 'msg_002',
      message: 'Check out this image!',
      dataType: 'image',
      dataUrl:
          "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
      senderId: 'user_002',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)).toString(),
    ),
    SingleChatEntity(
        messageId: 'msg_003',
        message: 'Sure, I’ll get back to you shortly.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 30))
            .toString()),
    SingleChatEntity(
        messageId: 'msg_004',
        message: 'Look at this ....',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1)).toString()),
    SingleChatEntity(
        messageId: 'msg_005',
        message: 'Are you coming to the meeting?',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 10)).toString()),
    SingleChatEntity(
        messageId: 'msg_006',
        message: 'Good morning!',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 10)).toString()),
    SingleChatEntity(
        messageId: 'msg_007',
        message: 'Here is the presentation slide.',
        dataType: 'image',
        dataUrl:
            "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2)).toString()),
    SingleChatEntity(
        messageId: 'msg_008',
        message: 'Let’s catch up later.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 3)).toString()),
    SingleChatEntity(
        messageId: 'msg_009',
        message: 'What’s the update?',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 3)).toString()),
    SingleChatEntity(
        messageId: 'msg_010',
        message: 'Let’s have lunch together.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 5)).toString()),
    SingleChatEntity(
      messageId: 'msg_001',
      message: 'Hey, how are you?',
      dataType: 'text',
      dataUrl: null,
      senderId: 'user_001',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)).toString(),
    ),
    SingleChatEntity(
      messageId: 'msg_002',
      message: 'Check out this image!',
      dataType: 'image',
      dataUrl:
          "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
      senderId: 'user_002',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)).toString(),
    ),
    SingleChatEntity(
        messageId: 'msg_003',
        message: 'Sure, I’ll get back to you shortly.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 30))
            .toString()),
    SingleChatEntity(
        messageId: 'msg_004',
        message: 'Look at this ....',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1)).toString()),
    SingleChatEntity(
        messageId: 'msg_005',
        message: 'Are you coming to the meeting?',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 10)).toString()),
    SingleChatEntity(
        messageId: 'msg_006',
        message: 'Good morning!',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 10)).toString()),
    SingleChatEntity(
        messageId: 'msg_007',
        message: 'Here is the presentation slide.',
        dataType: 'image',
        dataUrl:
            "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2)).toString()),
    SingleChatEntity(
        messageId: 'msg_008',
        message: 'Let’s catch up later.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 3)).toString()),
    SingleChatEntity(
        messageId: 'msg_009',
        message: 'What’s the update?',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 3)).toString()),
    SingleChatEntity(
        messageId: 'msg_010',
        message: 'Let’s have lunch together.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 5)).toString()),
    SingleChatEntity(
      messageId: 'msg_001',
      message: 'Hey, how are you?',
      dataType: 'text',
      dataUrl: null,
      senderId: 'user_001',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)).toString(),
    ),
    SingleChatEntity(
      messageId: 'msg_002',
      message: 'Check out this image!',
      dataType: 'image',
      dataUrl:
          "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
      senderId: 'user_002',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)).toString(),
    ),
    SingleChatEntity(
        messageId: 'msg_003',
        message: 'Sure, I’ll get back to you shortly.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 30))
            .toString()),
    SingleChatEntity(
        messageId: 'msg_004',
        message: 'Look at this ....',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1)).toString()),
    SingleChatEntity(
        messageId: 'msg_005',
        message: 'Are you coming to the meeting?',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 10)).toString()),
    SingleChatEntity(
        messageId: 'msg_006',
        message: 'Good morning!',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 10)).toString()),
    SingleChatEntity(
        messageId: 'msg_007',
        message: 'Here is the presentation slide.',
        dataType: 'image',
        dataUrl:
            "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 2)).toString()),
    SingleChatEntity(
        messageId: 'msg_008',
        message: 'Let’s catch up later.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_002',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 3)).toString()),
    SingleChatEntity(
        messageId: 'msg_009',
        message: 'What’s the update?',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 3)).toString()),
    SingleChatEntity(
        messageId: 'msg_010',
        message: 'Let’s have lunch together.',
        dataType: 'text',
        dataUrl: null,
        senderId: 'user_001',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 5)).toString()),
  ];
}
