import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class UsageSheet extends StatefulWidget {
  const UsageSheet({super.key});

  @override
  State<UsageSheet> createState() => _UsageSheetState();
}

class _UsageSheetState extends State<UsageSheet> {
  int selectedTopUp = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Big balance card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text('\$9.93', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Text('remaining', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Used 1% of a monthly \$10', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 14),
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
                const SizedBox(height: 24),
                const Text('Daily usage', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Not enough history yet to compare today with your usual day.',
                        style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Average', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              SizedBox(height: 2),
                              Text('\$0.0000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(width: 36),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Today', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              SizedBox(height: 2),
                              Text('\$0.0895', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryOrange)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '21.683 tokens today · 21.683 this month',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Top up', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.8,
                  children: [5, 10, 25, 50, 100, 500].map((val) {
                    final isSel = selectedTopUp == val;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTopUp = val),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.orangeSoft : AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSel ? AppColors.primaryOrange : AppColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '\$$val',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSel ? AppColors.primaryOrange : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('History', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Today', style: TextStyle(fontSize: 14)),
                      Text('\$0.0895', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
