import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/di/injection.dart';
import '../logic/cubits/coin_detail/coin_detail_cubit.dart';
import '../logic/cubits/coin_detail/coin_detail_state.dart';

class CoinDetailScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CoinDetailCubit>()..fetchCoinDetail(coinId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<CoinDetailCubit, CoinDetailState>(
          builder: (context, state) {
            if (state is CoinDetailLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            } else if (state is CoinDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.priceDown, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(color: AppColors.white)),
                  ],
                ),
              );
            } else if (state is CoinDetailLoaded) {
              final coin = state.coinDetail;
              final isUp = (coin.priceChangePercentage24h ?? 0) >= 0;
              final color = isUp ? AppColors.priceUp : AppColors.priceDown;

              return CustomScrollView(
                slivers: [
                  _SliverHeader(coin: coin),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PriceSection(coin: coin, color: color, isUp: isUp),
                          const SizedBox(height: 32),
                          _StatsGrid(coin: coin),
                          const SizedBox(height: 32),
                          const Text(
                            "About",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _stripHtml(coin.description),
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.7),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _stripHtml(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }
}

class _SliverHeader extends StatelessWidget {
  final dynamic coin;
  const _SliverHeader({required this.coin});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.headerGradientStart, AppColors.background],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CachedNetworkImage(
                imageUrl: coin.image,
                width: 80,
                height: 80,
                placeholder: (context, url) => const CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              Text(
                coin.name,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                coin.symbol,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  final dynamic coin;
  final Color color;
  final bool isUp;

  const _PriceSection({required this.coin, required this.color, required this.isUp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Price",
              style: TextStyle(color: AppColors.white.withOpacity(0.5), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "\$${NumberFormat("#,##0.00").format(coin.currentPrice ?? 0)}",
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(isUp ? Icons.trending_up : Icons.trending_down, color: color, size: 20),
              const SizedBox(width: 4),
              Text(
                "${coin.priceChangePercentage24h?.toStringAsFixed(2)}%",
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final dynamic coin;
  const _StatsGrid({required this.coin});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _StatCard(
          label: "Market Cap",
          value: "\$${_formatLarge(coin.marketCap)}",
        ),
        _StatCard(
          label: "Volume (24h)",
          value: "\$${_formatLarge(coin.totalVolume)}",
        ),
        _StatCard(
          label: "High (24h)",
          value: "\$${NumberFormat("#,##0.00").format(coin.high24h ?? 0)}",
        ),
        _StatCard(
          label: "Low (24h)",
          value: "\$${NumberFormat("#,##0.00").format(coin.low24h ?? 0)}",
        ),
        if (coin.hashingAlgorithm != null)
          _StatCard(
            label: "Algorithm",
            value: coin.hashingAlgorithm!,
          ),
      ],
    );
  }

  String _formatLarge(double? value) {
    if (value == null) return "0";
    if (value >= 1e12) return "${(value / 1e12).toStringAsFixed(2)}T";
    if (value >= 1e9) return "${(value / 1e9).toStringAsFixed(2)}B";
    if (value >= 1e6) return "${(value / 1e6).toStringAsFixed(2)}M";
    return NumberFormat("#,##0").format(value);
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.white.withOpacity(0.5), fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
