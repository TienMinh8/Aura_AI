import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'modals/capabilities_sheet.dart';

class TodayScreen extends StatefulWidget {
  final Function(int) onNavigateTab;
  const TodayScreen({super.key, required this.onNavigateTab});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  int selectedDay = 6;
  bool isGridView = false;
  int selectedDayRange = 1; // 1 | 3 | 7
  bool isFabMenuOpen = false;

  final List<Map<String, dynamic>> days = [
    {'name': 'SA', 'day': 3},
    {'name': 'SU', 'day': 4},
    {'name': 'MO', 'day': 5},
    {'name': 'TU', 'day': 6},
    {'name': 'WE', 'day': 7},
    {'name': 'TH', 'day': 8},
    {'name': 'FR', 'day': 9},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Header: "Oct 2026" + Layers Icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Oct 2026',
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
                          child: const Icon(Icons.layers_outlined, size: 20, color: Colors.white),
                        ),
                        onPressed: () => _showFilterLayersMenu(context),
                      ),
                    ],
                  ),
                ),

                // Date strip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: days.map((d) {
                      final isSelected = selectedDay == d['day'];
                      return GestureDetector(
                        onTap: () => setState(() => selectedDay = d['day']),
                        child: Column(
                          children: [
                            Text(
                              d['name'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryOrange : Colors.transparent,
                                shape: BoxShape.circle,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryOrange.withValues(alpha: 0.4),
                                          blurRadius: 10,
                                        )
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${d['day']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const Divider(height: 20, color: Colors.white12),

                // Main body: Empty state or Timeline View
                Expanded(
                  child: isGridView ? _buildTimelineGridView() : _buildEmptyStateView(),
                ),
              ],
            ),

            // Floating bottom toolbar (View switch capsule & Orange FAB)
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // View Switch Capsule
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: Icon(Icons.format_list_bulleted, color: !isGridView ? Colors.white : AppColors.textMuted, size: 20),
                          onPressed: () => setState(() => isGridView = false),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: Icon(Icons.grid_view_rounded, color: isGridView ? Colors.white : AppColors.textMuted, size: 20),
                          onPressed: () => setState(() => isGridView = true),
                        ),
                        if (isGridView) ...[
                          const SizedBox(width: 4),
                          ...[1, 3, 7].map((val) {
                            final isSel = selectedDayRange == val;
                            return GestureDetector(
                              onTap: () => setState(() => selectedDayRange = val),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSel ? Colors.white : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$val',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSel ? Colors.black : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),

                  // Orange (+) FAB
                  GestureDetector(
                    onTap: () => setState(() => isFabMenuOpen = !isFabMenuOpen),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x66FF9500),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isFabMenuOpen ? 0.125 : 0.0,
                        child: const Icon(Icons.add, color: Colors.black, size: 28),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // FAB Menu Popup (Reminder, Task, Post, Recording)
            if (isFabMenuOpen)
              Positioned(
                right: 20,
                bottom: 76,
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202024),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
                  ),
                  child: Column(
                    children: [
                      _buildFabMenuItem('Reminder', '🔔', () {
                        setState(() => isFabMenuOpen = false);
                        widget.onNavigateTab(0); // Go to Chat
                      }),
                      _buildFabMenuItem('Task', '🔁', () {
                        setState(() => isFabMenuOpen = false);
                        widget.onNavigateTab(2); // Go to Tasks
                      }),
                      _buildFabMenuItem('Post', '✈️', () {
                        setState(() => isFabMenuOpen = false);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create Post')));
                      }),
                      _buildFabMenuItem('Recording', '🎙️', () {
                        setState(() => isFabMenuOpen = false);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Start Recording')));
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabMenuItem(String title, String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateView() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pill notification card
            Container(
              width: 220,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: AppColors.primaryOrange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 5, width: 80, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(height: 6),
                        Container(height: 5, width: 45, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Nothing planned today',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask the chat to plan it — or add one below.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                widget.onNavigateTab(0); // Go to Chat
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add event', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 36),
            InkWell(
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
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineGridView() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
      itemCount: 10,
      itemBuilder: (context, index) {
        final hour = index + 13;
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : hour;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      '$displayHour $period',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            // Current Time Indicator at 3:35 PM
            if (hour == 15)
              Positioned(
                top: 35,
                left: 45,
                right: 0,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.primaryOrange, blurRadius: 8)],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  void _showFilterLayersMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF202024),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Show', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildFilterCheck('Events', Icons.calendar_today, true),
              _buildFilterCheck('Google', Icons.g_mobiledata, true),
              _buildFilterCheck('Apple', Icons.apple, true),
              _buildFilterCheck('Tasks', Icons.check_box_outlined, true),
              _buildFilterCheck('Recordings', Icons.mic_none, true),
              _buildFilterCheck('Posts', Icons.send_outlined, true),
              _buildFilterCheck('Automations', Icons.repeat, false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterCheck(String title, IconData icon, bool checked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(checked ? Icons.check : null, size: 18, color: Colors.white),
          const SizedBox(width: 12),
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
