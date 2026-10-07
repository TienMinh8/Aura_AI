import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/aura_nav_icons.dart';
import 'chat_screen.dart';
import 'today_screen.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _switchTab(int index) {
    if (_currentIndex != index) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Thứ tự 4 Tab chính: Chat / Today / Tasks / Profile
    final List<Widget> screens = [
      const ChatScreen(),
      TodayScreen(onNavigateTab: _switchTab),
      TasksScreen(onNavigateTab: _switchTab),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgOled,
      extendBody: true, // Cho phép nội dung cuộn mượt phía sau floating bar
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildFloatingBottomBar(),
    );
  }

  Widget _buildFloatingBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E22).withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNavItem(
                      index: 0,
                      label: 'Chat',
                      iconBuilder: (color) => AuraNavIcons.chat(color: color, size: 21),
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      index: 1,
                      label: 'Today',
                      iconBuilder: (color) => AuraNavIcons.today(color: color, size: 21),
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      index: 2,
                      label: 'Tasks',
                      iconBuilder: (color) => AuraNavIcons.tasks(color: color, size: 21),
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      index: 3,
                      label: 'Profile',
                      iconBuilder: (color) => AuraNavIcons.profile(color: color, size: 21),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required Widget Function(Color color) iconBuilder,
  }) {
    final isSelected = _currentIndex == index;
    final itemColor = isSelected ? AppTheme.amberOrange : Colors.white;
    final textColor = isSelected ? AppTheme.amberOrange : const Color(0xFFA1A1AA);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _switchTab(index),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.fastOutSlowIn,
          width: isSelected ? 82 : 68,
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF38383D) : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconBuilder(itemColor),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  height: 1.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
