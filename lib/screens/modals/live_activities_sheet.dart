import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LiveActivitiesSheet extends StatefulWidget {
  const LiveActivitiesSheet({super.key});

  @override
  State<LiveActivitiesSheet> createState() => _LiveActivitiesSheetState();
}

class _LiveActivitiesSheetState extends State<LiveActivitiesSheet> {
  bool showOnLockScreen = true;
  final Set<String> selectedCategories = {
    'Reminder', 'Call', 'Meeting', 'Work', 'Presentation', 'Deadline',
    'Documents', 'Workout', 'Running', 'Yoga', 'Football', 'Swimming',
    'Cycling', 'Walk', 'Doctor', 'Dentist', 'Pill', 'Therapy'
  };

  final List<Map<String, String>> categories = [
    {'name': 'Reminder', 'icon': '🔔'},
    {'name': 'Call', 'icon': '☎️'},
    {'name': 'Meeting', 'icon': '👥'},
    {'name': 'Work', 'icon': '💼'},
    {'name': 'Presentation', 'icon': '🎤'},
    {'name': 'Deadline', 'icon': '⏳'},
    {'name': 'Documents', 'icon': '📁'},
    {'name': 'Workout', 'icon': '🏋️'},
    {'name': 'Running', 'icon': '👟'},
    {'name': 'Yoga', 'icon': '🧘'},
    {'name': 'Football', 'icon': '⚽'},
    {'name': 'Swimming', 'icon': '🏊'},
    {'name': 'Cycling', 'icon': '🚲'},
    {'name': 'Walk', 'icon': '🥾'},
    {'name': 'Doctor', 'icon': '🩺'},
    {'name': 'Dentist', 'icon': '🦷'},
    {'name': 'Pill', 'icon': '💊'},
    {'name': 'Therapy', 'icon': '🛋️'},
  ];

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
        title: const Text('Live Activities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Lock screen preview graphic
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B3874), Color(0xFF0D1A38)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                const Text('Tuesday, October 6', style: TextStyle(color: Color(0xFFA4C4FF), fontSize: 12)),
                const SizedBox(height: 4),
                const Text('9:12', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300)),
                const SizedBox(height: 16),
                // Dynamic Island card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xEE121626),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Text('👥', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('in 48 minutes', style: TextStyle(color: AppColors.primaryOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                            const Text('Team standup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: const LinearProgressIndicator(
                                value: 0.45,
                                backgroundColor: Colors.white24,
                                color: Colors.white,
                                minHeight: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Toggle card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: AppColors.primaryOrange, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Show on Lock Screen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('The current or next event with a live countdown', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: showOnLockScreen,
                  activeTrackColor: AppColors.primaryOrange,
                  onChanged: (val) => setState(() => showOnLockScreen = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Categories', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Tap a category to stop showing its events', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 14),
          // 18 Categories grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final name = cat['name']!;
              final icon = cat['icon']!;
              final isSel = selectedCategories.contains(name);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSel) {
                      selectedCategories.remove(name);
                    } else {
                      selectedCategories.add(name);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSel ? AppColors.borderLight : AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      if (isSel)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: const Icon(Icons.check, size: 12, color: Colors.black),
                          ),
                        ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 30)),
                            const SizedBox(height: 8),
                            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
