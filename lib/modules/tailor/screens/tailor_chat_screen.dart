import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  const _ChatMessage({required this.text, required this.isMe, required this.time});
}

class TailorChatScreen extends StatefulWidget {
  final String customerName;
  final String orderId;
  const TailorChatScreen({
    super.key,
    required this.customerName,
    required this.orderId,
  });

  @override
  State<TailorChatScreen> createState() => _TailorChatScreenState();
}

class _TailorChatScreenState extends State<TailorChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  late List<_ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _messages = [
      _ChatMessage(
        text: 'Hello! I wanted to check on my order ${widget.orderId}.',
        isMe: false,
        time: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      _ChatMessage(
        text: 'Hi! Yes, I have started working on your ${widget.orderId}. The fabric is cut and initial stitching is done.',
        isMe: true,
        time: now.subtract(const Duration(hours: 2, minutes: 20)),
      ),
      _ChatMessage(
        text: 'That sounds great! When do you think it will be ready?',
        isMe: false,
        time: now.subtract(const Duration(hours: 2)),
      ),
      _ChatMessage(
        text: 'I estimate 3-4 more days. I will send you pictures once the main fitting is done.',
        isMe: true,
        time: now.subtract(const Duration(hours: 1, minutes: 50)),
      ),
      _ChatMessage(
        text: 'Perfect, thank you so much!',
        isMe: false,
        time: now.subtract(const Duration(hours: 1, minutes: 45)),
      ),
    ];
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isMe: true, time: DateTime.now()));
      _msgCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AuroraBackground(
        orb1: AppColors.tealOrb,
        orb2: AppColors.purpleOrb,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildMessageList()),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
            ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.teal]),
            ),
            child: Center(
              child: Text(
                widget.customerName.isNotEmpty ? widget.customerName[0].toUpperCase() : 'C',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customerName,
                  style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Order: ${widget.orderId}',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _MessageBubble(
        message: _messages[i],
        timeStr: _formatTime(_messages[i].time),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.attach_file_rounded, color: AppColors.textMuted, size: 18),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: _msgCtrl,
                style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13),
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final String timeStr;
  const _MessageBubble({required this.message, required this.timeStr});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.teal]),
              ),
              child: Center(
                child: Text('C', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.70,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? const LinearGradient(colors: [AppColors.teal, AppColors.tealLight])
                        : null,
                    color: isMe ? null : AppColors.card,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    border: isMe ? null : Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  timeStr,
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 9),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.teal, AppColors.tealLight]),
              ),
              child: Center(
                child: Text('S', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
