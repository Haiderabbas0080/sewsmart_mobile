// ─── Notification Service ─────────────────────────────────────────────────────
// Shared by the customer, tailor and rider apps. Uses mock data for now.
// The real API reads the user from the token, so no user id is passed.

import '../models/app_models.dart';
import '../data/mock_data.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  // TODO: GET /api/notifications
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<NotificationModel>.from(MockData.notifications);
  }

  // TODO: PUT /api/notifications/:id/read
  Future<bool> markRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = MockData.notifications.indexWhere((n) => n.id == id);
    if (idx == -1) return false;
    MockData.notifications[idx] = _asRead(MockData.notifications[idx]);
    return true;
  }

  // TODO: PUT /api/notifications/read-all
  Future<bool> markAllRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.notifications = MockData.notifications.map(_asRead).toList();
    return true;
  }

  NotificationModel _asRead(NotificationModel n) => NotificationModel(
    id: n.id, title: n.title, body: n.body,
    type: n.type, isRead: true, createdAt: n.createdAt,
  );
}
