class ChatMessage {
  final String messageId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
    };
  }
}

class ChatRoom {
  final String chatId;
  final String patientId;
  final String patientName;
  final String providerId;
  final String providerName;
  final String providerType;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isActive;

  ChatRoom({
    required this.chatId,
    required this.patientId,
    required this.patientName,
    required this.providerId,
    required this.providerName,
    required this.providerType,
    this.lastMessage = '',
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isActive = true,
  });

  factory ChatRoom.fromMap(Map<dynamic, dynamic> map) {
    return ChatRoom(
      chatId: map['chatId'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      providerType: map['providerType'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: DateTime.tryParse(map['lastMessageTime'] ?? '') ?? DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'patientId': patientId,
      'patientName': patientName,
      'providerId': providerId,
      'providerName': providerName,
      'providerType': providerType,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isActive': isActive,
    };
  }
}
