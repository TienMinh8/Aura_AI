import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'modals/capabilities_sheet.dart';
import 'modals/connected_apps_sheet.dart';
import 'modals/usage_sheet.dart';
import 'modals/widgets_sheet.dart';
import 'modals/live_activities_sheet.dart';
import 'modals/calendar_sync_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedTheme = 'Dark'; // System, Light, Dark

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Sun Avatar Header (IMG_8731)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Sun glow
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFB74D).withValues(alpha: 0.4),
                          AppColors.primaryOrange.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  // Sun disk
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFFFFD180), Color(0xFFE69500)],
                      ),
                      boxShadow: [
                        BoxShadow(color: Color(0x66E69500), blurRadius: 20, offset: Offset(0, 4)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'M',
                      style: GoogleFonts.instrumentSerif(
                        fontSize: 52,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ),
                  // Edit pencil icon
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1C1C1F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Text(
                'Minh',
                style: GoogleFonts.instrumentSerif(
                  fontSize: 32,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Family & Teams (IMG_8731)
            const Text('Family & teams', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Share events with family or a team', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Everyone in a space sees its events and gets the reminders.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpaceChip('Family', '🏠', const Color(0xFF452B12)),
                      _buildSpaceChip('Work', '💼', const Color(0xFF1A2F4C)),
                      _buildSpaceChip('Home', '🪴', const Color(0xFF193F2A)),
                    ],
                  ),
                  const Divider(height: 28, color: Colors.white12),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter invite code dialog')));
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.mail_outline, size: 20, color: AppColors.textSecondary),
                        SizedBox(width: 12),
                        Text('Enter invite code', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Spacer(),
                        Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Assistant Section (IMG_8731 / 8732)
            const Text('Assistant', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.auto_awesome,
                    title: 'Capabilities',
                    sub: 'Morning brief, water, birthdays and more',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const CapabilitiesSheet(),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  _buildListTile(
                    icon: Icons.calendar_today,
                    title: 'Calendars',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarSyncSheet()));
                    },
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  _buildListTile(
                    icon: Icons.link,
                    title: 'Connected apps',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectedAppsSheet()));
                    },
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  _buildListTile(
                    icon: Icons.contact_page_outlined,
                    title: 'What Memory knows about me',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('What Memory knows about me')));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Usage (IMG_8732)
            const Text('Usage', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const UsageSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bar_chart, size: 22, color: AppColors.textSecondary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Monthly limit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.01,
                              backgroundColor: Colors.white12,
                              color: AppColors.primaryOrange,
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('1%', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Reminders (IMG_8732)
            const Text('Reminders', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.mail_outline,
                    title: 'Email',
                    sub: 'Receive reminder notifications by email',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email settings')));
                    },
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  _buildListTile(
                    icon: Icons.flash_on,
                    title: 'Live Activities',
                    sub: 'Show ongoing events on the Lock Screen',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveActivitiesSheet()));
                    },
                  ),
                  const Divider(height: 1, color: Colors.white12),
                  _buildListTile(
                    icon: Icons.dashboard_customize_outlined,
                    title: 'Widgets',
                    badge: 'Set up',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const WidgetsSheet()));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Appearance (IMG_8732 / 8733)
            const Text('Appearance', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  // 3 Theme cards
                  Row(
                    children: [
                      _buildThemeCard('System', true),
                      const SizedBox(width: 8),
                      _buildThemeCard('Light', false),
                      const SizedBox(width: 8),
                      _buildThemeCard('Dark', false),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white12),
                  _buildSimpleRow('Language', 'English', Icons.language),
                  const Divider(height: 20, color: Colors.white12),
                  _buildSimpleRow('App icon', 'Classic', Icons.app_registration),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sign out button (IMG_8733)
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed out')));
                  },
                  leading: const Icon(Icons.logout, color: AppColors.red),
                  title: const Text('Sign out', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceChip(String title, String emoji, Color bgColor) {
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, String? sub, String? badge, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.textSecondary, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: sub != null ? Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) Text(badge, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
      ],
    );
  }

  Widget _buildThemeCard(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primaryOrange : AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: title == 'Light' ? Colors.white70 : const Color(0xFF1C1C1F),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
