import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ConnectedAppsSheet extends StatelessWidget {
  const ConnectedAppsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Connected apps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: AppColors.textMuted),
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Messaging', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _buildAppGroup([
            _buildAppItem('Telegram', 'Get reminders and updates directly in Telegram.', '✈️', const Color(0xFF0088CC)),
            _buildAppItem('X (Twitter)', 'Schedule and track your X posts with AI.', '𝕏', Colors.black),
            _buildAppItem('Slack', 'Send messages and manage channels', '💬', const Color(0xFF4A154B)),
            _buildAppItem('Discord', 'Manage servers and send messages', '🎮', const Color(0xFF5865F2)),
          ]),
          const SizedBox(height: 24),
          const Text('Meetings', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _buildAppGroup([
            _buildAppItem('Zoom', 'Zoom meetings arrive as transcripts with speaker tags', '📹', const Color(0xFF2D8CFF)),
          ]),
          const SizedBox(height: 24),
          const Text('Productivity', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _buildAppGroup([
            _buildAppItem('Google Calendar', 'Sync your Google Calendar events with Memory', '📅', const Color(0xFF1A73E8)),
            _buildAppItem('Notion', 'Sync notes and tasks from your Notion pages', '📝', Colors.black),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAppGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildAppItem(String name, String desc, String iconChar, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            alignment: Alignment.center,
            child: Text(iconChar, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
