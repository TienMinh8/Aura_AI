import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CalendarSyncSheet extends StatefulWidget {
  const CalendarSyncSheet({super.key});

  @override
  State<CalendarSyncSheet> createState() => _CalendarSyncSheetState();
}

class _CalendarSyncSheetState extends State<CalendarSyncSheet> {
  bool exportToApple = false;
  bool importFromApple = false;

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
        title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Apple Calendar Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.apple, size: 24),
                    SizedBox(width: 8),
                    Text('Apple Calendar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Text('Export', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                      child: const Text('💬 ➔ TUE 6', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Switch.adaptive(
                      value: exportToApple,
                      activeTrackColor: AppColors.primaryOrange,
                      onChanged: (val) => setState(() => exportToApple = val),
                    ),
                  ],
                ),
                const Text('Sync your Memory AI reminders to your calendar.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const Divider(height: 28, color: Colors.white12),
                Row(
                  children: [
                    const Text('Import', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                      child: const Text('TUE 6 ➔ 💬', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    Switch.adaptive(
                      value: importFromApple,
                      activeTrackColor: AppColors.primaryOrange,
                      onChanged: (val) => setState(() => importFromApple = val),
                    ),
                  ],
                ),
                const Text('Import events from your calendar into Memory AI.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Google Calendar Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    SizedBox(width: 10),
                    Text('Google Calendar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Sync, import and export events from Google Calendar.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecting Google account...')));
                    },
                    icon: const Icon(Icons.link, size: 18),
                    label: const Text('Connect account', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
