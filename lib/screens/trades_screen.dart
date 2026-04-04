import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../core/di/injection.dart';
import '../logic/cubits/trades_cubit.dart';
import '../logic/cubits/trades_state.dart';
import '../data/models/trending_coin_model.dart';

class TradesScreen extends StatelessWidget {
  const TradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TradesCubit>()..fetchTrendingCoins(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<TradesCubit, TradesState>(
            builder: (context, state) {
              if (state is TradesLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              } else if (state is TradesLoaded) {
                final coin = state.trendingResponse.coins?.first.item;
                if (coin == null) return const Center(child: Text("No trending coins found", style: TextStyle(color: Colors.white)));
                return _TradesContent(coin: coin);
              } else if (state is TradesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<TradesCubit>().fetchTrendingCoins(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _TradesContent extends StatelessWidget {
  final TrendingCoinModel coin;
  const _TradesContent({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderSection(),
        const SizedBox(height: 16),
        const _FilterTabs(),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _PriceSection(coin: coin),
              const SizedBox(height: 24),
              _ChartSection(coin: coin),
              const SizedBox(height: 16),
              const _TimeRangeSelector(),
              const SizedBox(height: 24),
              const _ActionButtons(),
              const SizedBox(height: 24),
              const _OrderBookSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
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
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF2D3238),
            child: Text('👨🏻‍💻', style: TextStyle(fontSize: 18)),
          ),
          const Spacer(),
          const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 20),
          const Icon(Icons.monetization_on_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 20),
          const Icon(Icons.star_border_rounded, color: AppColors.primary, size: 28),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatefulWidget {
  const _FilterTabs();

  @override
  State<_FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<_FilterTabs> {
  int _selectedIndex = 1;
  final List<String> _tabs = ['Convert', 'Spot', 'Margin', 'Fiat'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2228),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2D3238) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  final TrendingCoinModel coin;
  const _PriceSection({required this.coin});

  @override
  Widget build(BuildContext context) {
    final price = coin.data?.price?.toStringAsFixed(2) ?? "0.00";
    final change = coin.data?.usdChange ?? 0.0;
    final isPositive = change >= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: isPositive ? AppColors.priceUp : AppColors.priceDown,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.swap_vert_rounded, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                '${coin.symbol.toUpperCase()}/USD',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final TrendingCoinModel coin;
  const _ChartSection({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, right: 20),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value % 5 != 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${18 + (value / 5).toInt()}:00',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _generateMockSpots(),
              isCurved: false,
              color: AppColors.priceUp,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.priceUp.withOpacity(0.2),
                    AppColors.priceUp.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateMockSpots() {
    return const [
      FlSpot(0, 40059),
      FlSpot(2, 40100),
      FlSpot(4, 40020),
      FlSpot(6, 40080),
      FlSpot(8, 40150),
      FlSpot(10, 40090),
      FlSpot(12, 40180),
      FlSpot(14, 40120),
      FlSpot(16, 40250),
      FlSpot(18, 40200),
      FlSpot(20, 40300),
    ];
  }
}

class _TimeRangeSelector extends StatefulWidget {
  const _TimeRangeSelector();

  @override
  State<_TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<_TimeRangeSelector> {
  int _selectedIndex = 0;
  final List<String> _ranges = ['1m', '5m', '15m', '15m', '1d', 'More'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_ranges.length, (index) {
        final isSelected = _selectedIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1E2228) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _ranges[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.priceUp,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Buy',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.priceDown,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Sell',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

class _OrderBookSection extends StatelessWidget {
  const _OrderBookSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabItem('Open Order (2)', false),
              _tabItem('Order Books', true),
              _tabItem('Market Trades', false),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          color: Colors.white.withOpacity(0.02),
          child: const Row(
            children: [
              Expanded(child: Text('Bid', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Expanded(child: Text('Ask', textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 12))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildBidList()),
              const SizedBox(width: 20),
              Expanded(child: _buildAskList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabItem(String label, bool isSelected) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 2,
            width: 40,
            color: AppColors.primary,
          ),
      ],
    );
  }

  Widget _buildBidList() {
    return Column(
      children: List.generate(8, (index) => _OrderRow(
        price: '27,486.39',
        amount: '2485.27',
        color: AppColors.priceUp,
        volumePercent: 0.2 + (index * 0.1),
        isBid: true,
      )),
    );
  }

  Widget _buildAskList() {
    return Column(
      children: List.generate(8, (index) => _OrderRow(
        price: '27,486.39',
        amount: '2485.27',
        color: AppColors.priceDown,
        volumePercent: 0.1 + (index * 0.08),
        isBid: false,
      )),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String price;
  final String amount;
  final Color color;
  final double volumePercent;
  final bool isBid;

  const _OrderRow({
    required this.price,
    required this.amount,
    required this.color,
    required this.volumePercent,
    required this.isBid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: isBid ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: volumePercent,
                child: Container(color: color.withOpacity(0.1)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              Text(amount, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
