class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? priceChangePercentage24h;
  final SparklineModel? sparklineIn7d;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.priceChangePercentage24h,
    this.sparklineIn7d,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: (json['current_price'] as num?)?.toDouble(),
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble(),
      sparklineIn7d: json['sparkline_in_7d'] != null
          ? SparklineModel.fromJson(json['sparkline_in_7d'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'price_change_percentage_24h': priceChangePercentage24h,
      'sparkline_in_7d': sparklineIn7d?.toJson(),
    };
  }
}

class SparklineModel {
  final List<double>? price;

  SparklineModel({this.price});

  factory SparklineModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? priceList = json['price'] as List<dynamic>?;
    return SparklineModel(
      price: priceList?.map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
    };
  }
}
