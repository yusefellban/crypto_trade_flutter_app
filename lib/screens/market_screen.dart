import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'profile_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HeaderSection(),
            const SizedBox(height: 20),
            const _FilterTabs(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  _CoinListItem(
                    name: 'Bitcoin',
                    symbol: 'BTC',
                    price: '32,697.05',
                    change: '+0.81%',
                    isPositive: true,
                    assetPath: 'assets/bitcoin_ic.png',
                  ),
                  _CoinListItem(
                    name: 'Chainlink',
                    symbol: 'LINK',
                    price: '32,697.05',
                    change: '-0.81%',
                    isPositive: false,
                    assetPath: 'assets/app_ic.png', // Fallback for LINK
                  ),
                  _CoinListItem(
                    name: 'Cardano',
                    symbol: 'ADA',
                    price: '32,697.05',
                    change: '+0.81%',
                    isPositive: true,
                    assetPath: 'assets/cardano_ic.png',
                  ),
                  _CoinListItem(
                    name: 'SHIBA INU',
                    symbol: 'SHIB',
                    price: '32,697.05',
                    change: '-0.81%',
                    isPositive: false,
                    assetPath: 'assets/shiba_inu_ic.png',
                  ),
                  _CoinListItem(
                    name: 'HIFI',
                    symbol: 'MFT',
                    price: '32,697.05',
                    change: '-0.81%',
                    isPositive: false,
                    assetPath: 'assets/hifi_ic.png',
                  ),
                  _CoinListItem(
                    name: 'REN',
                    symbol: 'REN',
                    price: '32,697.05',
                    change: '+0.81%',
                    isPositive: true,
                    assetPath: 'assets/ren_ic.png',
                  ),
                  SizedBox(height: 16),
                  _AddFavoriteButton(),
                  SizedBox(height: 40),
                ],
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.selectedTab,
                child: Text('👨🏻‍💻', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          const Spacer(),
          _IconContainer(icon: Icons.search_rounded),
          const SizedBox(width: 16),
          _IconContainer(icon: Icons.crop_free_rounded), // Scan icon
          const SizedBox(width: 16),
          _IconContainer(icon: Icons.notifications_none_rounded),
        ],
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  final IconData icon;
  const _IconContainer({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: AppColors.primary, size: 28);
  }
}

class _FilterTabs extends StatefulWidget {
  const _FilterTabs();

  @override
  State<_FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<_FilterTabs> {
  int _selectedIndex = 1; // Default to 'Spot'

  final List<String> _tabs = ['Convert', 'Spot', 'Margin', 'Fiat'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final isSelected = _selectedIndex == entry.key;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = entry.key),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.selectedTab : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CoinListItem extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String change;
  final bool isPositive;
  final String assetPath;

  const _CoinListItem({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.priceUp : AppColors.priceDown;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(assetPath, width: 32, height: 32, errorBuilder: (_, __, ___) => 
              Icon(Icons.currency_bitcoin, color: AppColors.primary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  symbol,
                  style: TextStyle(color: AppColors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 30,
              child: CustomPaint(
                painter: _SparklinePainter(color: color),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  change,
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, size.width * 0.2, size.height * 0.82);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.95, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.1, size.width * 0.6, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.6, size.width * 0.8, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.15);

    canvas.drawPath(path, paint);

    // Subtle gradient below
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.2), color.withOpacity(0)],
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

class _AddFavoriteButton extends StatelessWidget {
  const _AddFavoriteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grey.withOpacity(0.2),
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, color: AppColors.grey.withOpacity(0.5), size: 24),
          const SizedBox(width: 12),
          Text(
            'Add Favorite',
            style: TextStyle(
              color: AppColors.grey.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
