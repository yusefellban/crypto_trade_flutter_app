import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeaderSection(),
            const SizedBox(height: 20),
            const _FeaturesGrid(),
            const SizedBox(height: 24),
            const _PromotionSection(),
            const SizedBox(height: 32),
            const _CoinSection(title: AppStrings.recentCoin, isRecent: true),
            const SizedBox(height: 32),
            const _CoinSection(title: AppStrings.topCoins, isRecent: false),
            const SizedBox(height: 120), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.headerGradientStart,
            AppColors.headerGradientEnd,
          ],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: const Text('👨🏻‍💻', style: TextStyle(fontSize: 24)),
            ),
          ),
          const Spacer(),
          _HeaderIcon(icon: Icons.search_rounded),
          const SizedBox(width: 16),
          _HeaderIcon(icon: Icons.wallet_rounded),
          const SizedBox(width: 16),
          _HeaderIcon(icon: Icons.notifications_none_rounded),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: AppColors.white.withOpacity(0.7), size: 28);
  }
}

class _FeaturesGrid extends StatelessWidget {
  const _FeaturesGrid();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.download_rounded, 'label': AppStrings.deposit},
      {'icon': Icons.person_add_alt_1_rounded, 'label': AppStrings.referral},
      {'icon': Icons.grid_view_rounded, 'label': AppStrings.gridTrading},
      {'icon': Icons.tune_rounded, 'label': AppStrings.margin},
      {'icon': Icons.star_border_rounded, 'label': AppStrings.launchpad},
      {'icon': Icons.savings_outlined, 'label': AppStrings.savings},
      {'icon': Icons.currency_bitcoin_rounded, 'label': AppStrings.liquidSwap},
      {'icon': Icons.apps_rounded, 'label': AppStrings.more},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Icon(features[index]['icon'], color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              features[index]['label'],
              style: const TextStyle(color: AppColors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _PromotionSection extends StatelessWidget {
  const _PromotionSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _PromotionCard(
            title: AppStrings.p2pTrading,
            subtitle: AppStrings.p2pDescription,
            icon: Icons.rocket_launch_rounded,
          ),
          const SizedBox(height: 16),
          _PromotionCard(
            title: AppStrings.creditDebitCard,
            subtitle: AppStrings.cardDescription,
            icon: Icons.credit_card_rounded,
          ),
        ],
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PromotionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_forward_rounded, color: AppColors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

class _CoinSection extends StatelessWidget {
  final String title;
  final bool isRecent;

  const _CoinSection({required this.title, required this.isRecent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _CoinCard(
                pair: index % 2 == 0 ? AppStrings.btcBusd : AppStrings.solBusd,
                price: index % 2 == 0 ? '40,059.83' : '2,059.83',
                change: index % 2 == 0 ? '+0.81%' : '-0.81%',
                isUp: index % 2 == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CoinCard extends StatelessWidget {
  final String pair;
  final String price;
  final String change;
  final bool isUp;

  const _CoinCard({
    required this.pair,
    required this.price,
    required this.change,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    final color = isUp ? AppColors.priceUp : AppColors.priceDown;
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Icon(Icons.currency_bitcoin_rounded, color: Colors.orange, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                pair,
                style: const TextStyle(color: AppColors.white, fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(color: color, fontSize: 10),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 30,
            width: double.infinity,
            child: CustomPaint(
              painter: _MockChartPainter(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockChartPainter extends CustomPainter {
  final Color color;
  _MockChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.8, size.width * 0.4, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.2, size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);

    // Gradient below
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
