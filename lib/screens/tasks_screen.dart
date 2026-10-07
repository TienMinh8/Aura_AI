import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'modals/capabilities_sheet.dart';

class TasksScreen extends StatefulWidget {
  final Function(int) onNavigateTab;
  const TasksScreen({super.key, required this.onNavigateTab});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Map<String, bool> routineStates = {
    'Morning brief': false,
    'Bitcoin price': false,
    'Motivation': false,
    'Weather': false,
    'AI news': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Nav
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks',
                    style: GoogleFonts.instrumentSerif(
                      fontSize: 38,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add custom routine')));
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Vintage Clock Hero
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        // Analog Alarm Clock Widget
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFFE6BE8A), Color(0xFF8C6239)],
                            ),
                            border: Border.all(color: const Color(0xFF4A3828), width: 4),
                            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFAF7EE),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Clock hands
                                Transform.rotate(
                                  angle: 1.2,
                                  child: Container(
                                    width: 3,
                                    height: 18,
                                    margin: const EdgeInsets.only(bottom: 14),
                                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(2)),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 4.8,
                                  child: Container(
                                    width: 2,
                                    height: 24,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(2)),
                                  ),
                                ),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(color: Color(0xFFC0392B), shape: BoxShape.circle),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Let Nova take on the routine',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Turn one on — it\'ll arrive by itself, every day.',
                          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Routines Card List
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildRoutineTile('Morning brief', '08:00', 'Weather, plans and news', '☀️'),
                        _buildDivider(),
                        _buildRoutineTile('Bitcoin price', '09:00', 'Price and 24h change', '📈'),
                        _buildDivider(),
                        _buildRoutineTile('Motivation', '08:30', 'A boost for the day', '🪴'),
                        _buildDivider(),
                        _buildRoutineTile('Weather', '07:30', 'The day\'s forecast', '🌧️'),
                        _buildDivider(),
                        _buildRoutineTile('AI news', '09:00', 'The day\'s top stories', '📰'),
                        _buildDivider(),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            onTap: () => widget.onNavigateTab(0), // Go to chat
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            title: const Text('Something else', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            subtitle: const Text('Describe it in chat — Nova will set it up', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bottom feature link banner
                  Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const CapabilitiesSheet(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('☀️🥛📜', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text('What else Memory can do', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineTile(String title, String time, String desc, String icon) {
    final isOn = routineStates[title] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                routineStates[title] = !isOn;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isOn ? 'Disabled $title' : 'Enabled $title')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isOn ? AppColors.primaryOrange : Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isOn ? 'Turned on' : 'Turn on',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Colors.white10);
  }
}
