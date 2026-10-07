import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool showEventBadge = true;
  bool isThinking = false;

  final List<Map<String, dynamic>> messages = [
    {
      'isUser': false,
      'time': '15:34',
      'text': 'New event — today at 4:00 PM. What is it?',
    },
    {
      'isUser': false,
      'isDoc': true,
      'time': '15:34',
      'text': 'I read OpenWeather (OpenWeatherMap)\'s official docs. How to connect:\n\n1. Sign up for a free account at openweathermap.org\n2. Confirm your email; your API key (APPID) is sent to you\n3. Open home.openweathermap.org/api_keys\n4. Copy the key and paste it here\n\n🔒 This message won\'t be kept in the chat or shown to the AI.',
    },
    {
      'isUser': false,
      'time': '15:35',
      'text': 'What should I remind you about, and when?\n\nWhat should I automate? Pick one or just describe it.',
    },
    {
      'isUser': true,
      'time': '15:35',
      'text': 'Send me a digest of AI and tech news every day at 9am.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Assistant Capsule
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: const [
                    Text('Nova', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Memory AI', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),

            // Suggestions Carousel
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  _buildChip('📰 News', 'AI news'),
                  _buildChip('⛅ Weather', 'Weather update'),
                  _buildChip('✨ Motivation', 'Motivation boost', active: true),
                  _buildChip('📈 Price', 'Bitcoin price'),
                ],
              ),
            ),

            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: messages.length + (isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isThinking) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4, top: 8),
                      child: Row(
                        children: const [
                          SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textMuted)),
                          SizedBox(width: 8),
                          Text('Thinking...', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        ],
                      ),
                    );
                  }

                  final msg = messages[index];
                  final isUser = msg['isUser'] as bool;
                  final isDoc = msg['isDoc'] ?? false;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.white
                            : (isDoc ? AppColors.card : Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                        border: isDoc ? Border.all(color: AppColors.border) : null,
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color: isUser ? Colors.black : Colors.white,
                          fontSize: 14.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Active Event Pill Tag
            if (showEventBadge)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.orangeSoft,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppColors.primaryOrange),
                        const SizedBox(width: 6),
                        const Text(
                          'New event · Today at 16:00',
                          style: TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => showEventBadge = false),
                          child: const Icon(Icons.close, size: 14, color: AppColors.primaryOrange),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.background,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Name the event...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: AppColors.textSecondary, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 14),
                        IconButton(
                          icon: const Icon(Icons.alternate_email, color: AppColors.textSecondary, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.mic, color: AppColors.textSecondary, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice input activated')));
                          },
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleSend,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_upward, color: Colors.black, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String preset, {bool active = false}) {
    return GestureDetector(
      onTap: () {
        _textController.text = preset;
        _handleSend();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.orangeSoft : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.primaryOrange.withValues(alpha: 0.4) : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'isUser': true, 'time': '15:36', 'text': text});
      _textController.clear();
      isThinking = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        isThinking = false;
        messages.add({
          'isUser': false,
          'time': '15:36',
          'text': 'Got it! I saved "$text" and added it to your routine.',
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
