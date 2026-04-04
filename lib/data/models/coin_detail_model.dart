class CoinDetailModel {
  final String id;
  final String symbol;
  final String name;
  final String description;
  final String image;
  final double? currentPrice;
  final double? priceChangePercentage24h;
  final double? marketCap;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final String? hashingAlgorithm;
  final List<String>? categories;

  CoinDetailModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.image,
    this.currentPrice,
    this.priceChangePercentage24h,
    this.marketCap,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.hashingAlgorithm,
    this.categories,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    final marketData = json['market_data'] as Map<String, dynamic>?;
    final descriptionMap = json['description'] as Map<String, dynamic>?;
    final imageMap = json['image'] as Map<String, dynamic>?;

    return CoinDetailModel(
      id: json['id'] as String,
      symbol: (json['symbol'] as String).toUpperCase(),
      name: json['name'] as String,
      description: descriptionMap?['en'] ?? '',
      image: imageMap?['large'] ?? '',
      currentPrice: (marketData?['current_price']?['usd'] as num?)?.toDouble(),
      priceChangePercentage24h: (marketData?['price_change_percentage_24h'] as num?)?.toDouble(),
      marketCap: (marketData?['market_cap']?['usd'] as num?)?.toDouble(),
      totalVolume: (marketData?['total_volume']?['usd'] as num?)?.toDouble(),
      high24h: (marketData?['high_24h']?['usd'] as num?)?.toDouble(),
      low24h: (marketData?['low_24h']?['usd'] as num?)?.toDouble(),
      hashingAlgorithm: json['hashing_algorithm'] as String?,
      categories: (json['categories'] as List?)?.map((e) => e as String).toList(),
    );
  }
}
