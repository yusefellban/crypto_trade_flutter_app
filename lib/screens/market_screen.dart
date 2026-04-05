import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/di/injection.dart';
import '../logic/cubits/market_cubit.dart';
import '../logic/cubits/market_state.dart';
import '../logic/cubits/wallet/wallet_cubit.dart';
import '../logic/cubits/wallet/wallet_state.dart';
import '../data/models/coin_model.dart';
import 'profile_screen.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MarketCubit>()..fetchMarketData(),
      child: Scaffold(
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
                child: BlocBuilder<MarketCubit, MarketState>(
                  builder: (context, state) {
                    if (state is MarketLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    } else if (state is MarketLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.coins.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.coins.length) {
                            return const Column(
                              children: [
                                SizedBox(height: 16),
                                _AddFavoriteButton(),
                                SizedBox(height: 40),
                              ],
                            );
                          }
                          return _CoinListItem(coin: state.coins[index]);
                        },
                      );
                    } else if (state is MarketError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<MarketCubit>().fetchMarketData(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
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
          const _IconContainer(icon: Icons.search_rounded),
          const SizedBox(width: 16),
          const _IconContainer(icon: Icons.crop_free_rounded), // Scan icon
          const SizedBox(width: 16),
          const _IconContainer(icon: Icons.notifications_none_rounded),
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
  final CoinModel coin;

  const _CoinListItem({required this.coin});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final isPositive = (coin.priceChangePercentage24h ?? 0) >= 0;
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
            child: CachedNetworkImage(
              imageUrl: coin.image,
              width: 32,
              height: 32,
              placeholder: (context, url) => const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
              errorWidget: (context, url, error) => Icon(Icons.currency_bitcoin, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  coin.symbol.toUpperCase(),
                  style: const TextStyle(color: AppColors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 35,
              child: coin.sparklineIn7d != null && coin.sparklineIn7d!.price != null && coin.sparklineIn7d!.price!.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (coin.sparklineIn7d!.price!.length - 1).toDouble(),
                        minY: coin.sparklineIn7d!.price!.reduce((a, b) => a < b ? a : b) * 0.999,
                        maxY: coin.sparklineIn7d!.price!.reduce((a, b) => a > b ? a : b) * 1.001,
                        lineBarsData: [
                          LineChartBarData(
                            spots: coin.sparklineIn7d!.price!
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            color: color,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  color.withOpacity(0.3),
                                  color.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('---', style: TextStyle(color: AppColors.grey))),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter.format(coin.currentPrice ?? 0),
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${isPositive ? '+' : ''}${coin.priceChangePercentage24h?.toStringAsFixed(2) ?? '0.00'}%',
                  style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
              bool isInWallet = false;
              if (state is WalletLoaded) {
                isInWallet = state.coins.any((c) => c.id == coin.id);
              }
              return IconButton(
                icon: Icon(
                  isInWallet ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isInWallet ? AppColors.primary : AppColors.grey,
                  size: 24,
                ),
                onPressed: () => context.read<WalletCubit>().toggleWallet(coin),
              );
            },
          ),
        ],
      ),
    );
  }
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
