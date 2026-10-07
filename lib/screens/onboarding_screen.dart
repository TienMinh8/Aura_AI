import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool isYearlyPlan = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Step Dots
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final isCurrent = index == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isCurrent ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primaryOrange : Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),

            // Page Carousel
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => currentPage = page),
                children: [
                  _buildSlide1(),
                  _buildSlide2(),
                  _buildSlide3(),
                  _buildSlide4(),
                  _buildPaywallSlide(),
                ],
              ),
            ),

            // Bottom Navigation Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (currentPage > 0 && currentPage < 4)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.card,
                          padding: const EdgeInsets.all(14),
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (currentPage < 4) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          widget.onComplete();
                        }
                      },
                      child: Text(
                        currentPage == 3
                            ? 'Turn on notifications'
                            : (currentPage == 4 ? 'Start 3-Day Free Trial' : 'Next'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
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

  // Slide 1 (IMG_8712/8713)
  Widget _buildSlide1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)),
                  child: const Text('Memory AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: const Text('Remind me to take an umbrella if it rains tomorrow', style: TextStyle(color: Colors.black, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Rain from 8 AM. I\'ll remind you at 7:30.', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
                const SizedBox(height: 14),
                // Weather widget preview
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4B6CB7), Color(0xFF182848)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('LONDON', style: TextStyle(fontSize: 11, letterSpacing: 1)),
                          Text('14°C', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          Text('Rain ↑16° ↓11°', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      const Text('🌧️', style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text('Chat that gets things done', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Just ask. Memory remembers the details and acts on them.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const Spacer(),
        ],
      ),
    );
  }

  // Slide 2 (IMG_8716)
  Widget _buildSlide2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildMiniAppRow('Telegram', 'Get reminders directly...', '✈️'),
                const SizedBox(height: 8),
                _buildMiniAppRow('Google Calendar', 'Sync your events...', '📅'),
                const SizedBox(height: 8),
                _buildMiniAppRow('Notion', 'Sync notes and tasks...', '📝'),
                const SizedBox(height: 8),
                _buildMiniAppRow('X (Twitter)', 'Schedule & track posts...', '𝕏'),
              ],
            ),
          ),
          const Spacer(),
          const Text('Connected to your apps', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Telegram, Google, X and Notion — all in one assistant.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMiniAppRow(String name, String desc, String icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.green, size: 18),
        ],
      ),
    );
  }

  // Slide 3 (IMG_8717)
  Widget _buildSlide3() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildRoutinePreviewRow('20:00', 'Water reminder', Colors.pinkAccent, '💧'),
                const SizedBox(height: 8),
                _buildRoutinePreviewRow('07:00', 'Morning weather', Colors.lightBlueAccent, '⛅'),
                const SizedBox(height: 8),
                _buildRoutinePreviewRow('08:00', 'Tech news digest', Colors.orangeAccent, '📰'),
              ],
            ),
          ),
          const Spacer(),
          const Text('Works in the background', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Set an automation once. Memory runs it on schedule, for you.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildRoutinePreviewRow(String time, String title, Color barColor, String icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Container(width: 3, height: 16, decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          Text(icon, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // Slide 4 (IMG_8718)
  Widget _buildSlide4() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🔔', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Memory AI  ·  now', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      SizedBox(height: 4),
                      Text('In 20 minutes — call with Anna', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('You wanted to bring up the demo', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text('Memory reminds you at the right moment', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Turn on notifications so nothing you mentioned gets lost.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const Spacer(),
        ],
      ),
    );
  }

  // Slide 5: Paywall (IMG_8719)
  Widget _buildPaywallSlide() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: widget.onComplete,
          ),
        ),
        const Center(child: Text('💬', style: TextStyle(fontSize: 36))),
        const SizedBox(height: 6),
        const Center(
          child: Text('Unlock Memory AI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        // Pricing options
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isYearlyPlan = false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !isYearlyPlan ? AppColors.orangeSoft : AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: !isYearlyPlan ? AppColors.primaryOrange : AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Monthly', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      Text('\$9.99', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('/ month', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isYearlyPlan = true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isYearlyPlan ? AppColors.primaryOrange : AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Yearly', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isYearlyPlan ? Colors.black : Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                            child: const Text('3 days free', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('\$2.49', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isYearlyPlan ? Colors.black : Colors.white)),
                      Text('/ month', style: TextStyle(fontSize: 11, color: isYearlyPlan ? Colors.black87 : AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Trial timeline
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 2),
                        Text('Activate your free trial and get access to Memory AI', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('In 2 Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 2),
                        Text('We\'ll send you a reminder before your trial ends', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
