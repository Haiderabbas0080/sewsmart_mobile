import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/app_models.dart';

class RiderNotificationsScreen extends StatefulWidget {
  const RiderNotificationsScreen({super.key});

  @override
  State<RiderNotificationsScreen> createState() =>
      _RiderNotificationsScreenState();
}

class _RiderNotificationsScreenState extends State<RiderNotificationsScreen> {
  bool _loading = true;

  late List<NotificationModel> _notifications;

  final List<NotificationModel> _riderNotifications = [
    NotificationModel(
      id: 'RN001',
      title: 'Pickup Assigned',
      body: 'New pickup assigned: Bridal Lehenga from Sana\'s Couture. Please pick up today between 10 AM - 12 PM.',
      type: 'pickup_assigned',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    NotificationModel(
      id: 'RN002',
      title: 'Delivery Confirmed',
      body: 'Ayesha Khan confirmed delivery for order ORD001. Payment of Rs 300 credited.',
      type: 'delivery_confirmed',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'RN003',
      title: 'Payment Received',
      body: 'Rs 1,200 has been transferred to your account for 4 deliveries this week.',
      type: 'payment',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    NotificationModel(
      id: 'RN004',
      title: 'Issue Resolved',
      body: 'Your reported issue for order ORD003 has been resolved by the admin team.',
      type: 'issue_resolved',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'RN005',
      title: 'Pickup Assigned',
      body: 'New pickup assigned: Lawn Suit from Mehak Boutique. Schedule for tomorrow 2-4 PM.',
      type: 'pickup_assigned',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'RN006',
      title: 'Delivery Confirmed',
      body: 'Sara Ahmed confirmed delivery for Formal Shirt. Great job!',
      type: 'delivery_confirmed',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _notifications = List.from(_riderNotifications);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  Color _notifColor(String type) {
    switch (type) {
      case 'pickup_assigned':
        return AppColors.riderColor;
      case 'delivery_confirmed':
        return AppColors.success;
      case 'payment':
        return AppColors.gold;
      case 'issue_resolved':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _notifIcon(String type) {
    switch (type) {
      case 'pickup_assigned':
        return Icons.storefront_rounded;
      case 'delivery_confirmed':
        return Icons.check_circle_rounded;
      case 'payment':
        return Icons.payments_rounded;
      case 'issue_resolved':
        return Icons.support_agent_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => NotificationModel(
                id: n.id,
                title: n.title,
                body: n.body,
                type: n.type,
                isRead: true,
                createdAt: n.createdAt,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.orangeOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(unread),
              if (_loading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.riderColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (_notifications.isEmpty)
                const Expanded(
                  child: EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications',
                    subtitle: 'You are all caught up!',
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    itemCount: _notifications.length,
                    itemBuilder: (_, i) {
                      final n = _notifications[i];
                      return _NotifCard(
                        notification: n,
                        color: _notifColor(n.type),
                        icon: _notifIcon(n.type),
                        timeStr: _timeAgo(n.createdAt),
                        onTap: () {
                          setState(() {
                            _notifications[i] = NotificationModel(
                              id: n.id,
                              title: n.title,
                              body: n.body,
                              type: n.type,
                              isRead: true,
                              createdAt: n.createdAt,
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(int unread) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                if (unread > 0)
                  Text(
                    '$unread unread',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 11),
                  ),
              ],
            ),
          ),
          if (unread > 0)
            GestureDetector(
              onTap: _markAllRead,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.riderColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.riderColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Mark all read',
                  style: GoogleFonts.poppins(
                    color: AppColors.riderColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationModel notification;
  final Color color;
  final IconData icon;
  final String timeStr;
  final VoidCallback onTap;

  const _NotifCard({
    required this.notification,
    required this.color,
    required this.icon,
    required this.timeStr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.card
              : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? AppColors.divider
                : color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    timeStr,
                    style: GoogleFonts.poppins(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
