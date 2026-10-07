import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WidgetsSheet extends StatefulWidget {
  const WidgetsSheet({super.key});

  @override
  State<WidgetsSheet> createState() => _WidgetsSheetState();
}

class _WidgetsSheetState extends State<WidgetsSheet> {
  String selectedSize = 'Medium'; // Small, Medium, Large

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
        title: const Text('Widgets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Phone mockup background
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF272C44), Color(0xFF151824)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                // Mockup Notch
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                // Widget Card Preview
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: selectedSize == 'Small' ? 140 : double.infinity,
                  height: selectedSize == 'Small' ? 140 : (selectedSize == 'Large' ? 260 : 150),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('💬', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('June 20', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                          const Spacer(),
                          const Text('+', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildWidgetRow('4:00 PM', 'Grocery shopping', selectedSize != 'Small' ? 'Whole Foods' : null),
                      const SizedBox(height: 8),
                      _buildWidgetRow('8:00 PM', 'Water plants', null),
                      if (selectedSize == 'Large') ...[
                        const SizedBox(height: 8),
                        _buildWidgetRow('9:30 PM', 'Read before bed', null),
                        const SizedBox(height: 8),
                        _buildWidgetRow('10:00 PM', 'Take vitamins', null),
                      ]
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Size selectors
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Small', 'Medium', 'Large'].map((size) {
                      final isSel = selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSize = size),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.black : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Instructions
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'How to add the widget to your home screen?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('1. Tap and hold anywhere on your phone\'s home screen', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 6),
                Text('2. Tap the + button in the top corner', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 6),
                Text('3. Search for Memory AI and add the widget', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWidgetRow(String time, String title, String? sub) {
    return Row(
      children: [
        Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryOrange)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1),
              if (sub != null) Text(sub, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}
