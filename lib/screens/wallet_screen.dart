import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../logic/cubits/wallet/wallet_cubit.dart';
import '../logic/cubits/wallet/wallet_state.dart';
import '../data/models/coin_model.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'My Wallet',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  } else if (state is WalletLoaded) {
                    if (state.coins.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, size: 80, color: AppColors.grey.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(
                              'Your wallet is empty',
                              style: TextStyle(color: AppColors.grey, fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.coins.length,
                      itemBuilder: (context, index) {
                        return _WalletItem(coin: state.coins[index]);
                      },
                    );
                  } else if (state is WalletError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletItem extends StatelessWidget {
  final CoinModel coin;
  const _WalletItem({required this.coin});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final isPositive = (coin.priceChangePercentage24h ?? 0) >= 0;
    final color = isPositive ? AppColors.priceUp : AppColors.priceDown;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: coin.image,
            width: 40,
            height: 40,
            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) => const Icon(Icons.currency_bitcoin, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  coin.symbol.toUpperCase(),
                  style: const TextStyle(color: AppColors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormatter.format(coin.currentPrice ?? 0),
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: color,
                  ),
                  Text(
                    '${coin.priceChangePercentage24h?.toStringAsFixed(2) ?? '0.00'}%',
                    style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
            onPressed: () => context.read<WalletCubit>().toggleWallet(coin),
          ),
        ],
      ),
    );
  }
}
