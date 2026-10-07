// ─── Chat Service ─────────────────────────────────────────────────────────────
// One conversation per order, between its customer and its tailor.
// Shared by the customer and tailor apps. Uses mock data for now.

import '../models/app_models.dart';
import '../data/mock_data.dart';
import 'auth_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._();
  factory ChatService() => _instance;
  ChatService._();

  // The real API reads the user from the token.
  String get _me => AuthService().currentUser?.id ?? '';

  // TODO: GET /api/conversations
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final me = _me;
    final conversations = <ConversationModel>[];
    for (final order in MockData.orders) {
      final isCustomer = order.customerId == me;
      if (!isCustomer && order.tailorId != me) continue;
      final thread = MockData.messages[order.id] ?? const <MessageModel>[];
      conversations.add(ConversationModel(
        orderId: order.id,
        garmentType: order.garmentType,
        otherUserId: isCustomer ? order.tailorId : order.customerId,
        otherUserName: isCustomer ? order.tailorName : order.customerName,
        lastMessage: thread.isEmpty ? '' : thread.last.text,
        lastMessageAt: thread.isEmpty ? null : thread.last.time,
        unreadCount: thread.where((m) => m.receiverId == me && !m.isRead).length,
      ));
    }
    return conversations;
  }

  // TODO: GET /api/orders/:id/messages
  Future<List<MessageModel>> getMessages(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<MessageModel>.from(MockData.messages[orderId] ?? const <MessageModel>[]);
  }

  // TODO: POST /api/orders/:id/messages
  Future<MessageModel?> sendMessage(String orderId, String text, {MessageType type = MessageType.text}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final body = text.trim();
    final idx = MockData.orders.indexWhere((o) => o.id == orderId);
    if (body.isEmpty || idx == -1) return null;
    final order = MockData.orders[idx];
    final me = _me;
    final message = MessageModel(
      id: 'MSG${DateTime.now().millisecondsSinceEpoch}',
      senderId: me,
      receiverId: order.customerId == me ? order.tailorId : order.customerId,
      text: body,
      type: type,
      time: DateTime.now(),
    );
    MockData.messages.putIfAbsent(orderId, () => <MessageModel>[]).add(message);
    return message;
  }

  // TODO: PUT /api/orders/:id/messages/read
  Future<bool> markMessagesRead(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final thread = MockData.messages[orderId];
    if (thread == null) return false;
    final me = _me;
    for (var i = 0; i < thread.length; i++) {
      final m = thread[i];
      if (m.receiverId == me && !m.isRead) {
        thread[i] = MessageModel(
          id: m.id, senderId: m.senderId, receiverId: m.receiverId,
          text: m.text, type: m.type, time: m.time, isRead: true,
        );
      }
    }
    return true;
  }
}
