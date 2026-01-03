import 'package:flutter/material.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      {'emoji': '🔥', 'title': '7일 연속', 'desc': '7일 연속 학습', 'unlocked': true},
      {'emoji': '📚', 'title': '100문제', 'desc': '100문제 달성', 'unlocked': true},
      {
        'emoji': '🎯',
        'title': '90% 달성',
        'desc': '정답률 90% 이상',
        'unlocked': true,
      },
      {'emoji': '⭐', 'title': '500문제', 'desc': '500문제 달성', 'unlocked': false},
      {'emoji': '🏆', 'title': '1위 달성', 'desc': '랭킹 1위 달성', 'unlocked': false},
      {
        'emoji': '💎',
        'title': '30일 연속',
        'desc': '30일 연속 학습',
        'unlocked': false,
      },
      {
        'emoji': '🎖️',
        'title': '1000문제',
        'desc': '1000문제 달성',
        'unlocked': false,
      },
      {
        'emoji': '👑',
        'title': '완벽한 주',
        'desc': '일주일 연속 100%',
        'unlocked': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '배지',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3개 획득 • 5개 남음',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  return _buildBadgeCard(
                    badge['emoji'] as String,
                    badge['title'] as String,
                    badge['desc'] as String,
                    badge['unlocked'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(
    String emoji,
    String title,
    String desc,
    bool unlocked,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFF8FBFF) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked ? const Color(0xFFB0E0E6) : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 48,
              color: unlocked ? null : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: unlocked ? Colors.grey[900] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: unlocked ? Colors.grey[600] : Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
