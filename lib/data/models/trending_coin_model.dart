class TrendingResponse {
  final List<TrendingCoinListItem>? coins;

  TrendingResponse({this.coins});

  factory TrendingResponse.fromJson(Map<String, dynamic> json) {
    if (json['coins'] == null) return TrendingResponse(coins: []);
    return TrendingResponse(
      coins: (json['coins'] as List)
          .map((i) => TrendingCoinListItem.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'coins': coins?.map((e) => e.toJson()).toList(),
      };
}

class TrendingCoinListItem {
  final TrendingCoinModel? item;

  TrendingCoinListItem({this.item});

  factory TrendingCoinListItem.fromJson(Map<String, dynamic> json) {
    return TrendingCoinListItem(
      item: json['item'] != null
          ? TrendingCoinModel.fromJson(json['item'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'item': item?.toJson(),
      };
}

class TrendingCoinModel {
  final String id;
  final int? coinId;
  final String name;
  final String symbol;
  final int? marketCapRank;
  final String thumb;
  final String small;
  final String large;
  final String slug;
  final double? priceBtc;
  final TrendingCoinData? data;

  TrendingCoinModel({
    required this.id,
    this.coinId,
    required this.name,
    required this.symbol,
    this.marketCapRank,
    required this.thumb,
    required this.small,
    required this.large,
    required this.slug,
    this.priceBtc,
    this.data,
  });

  factory TrendingCoinModel.fromJson(Map<String, dynamic> json) {
    return TrendingCoinModel(
      id: json['id'] as String,
      coinId: (json['coin_id'] as num?)?.toInt(),
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
      thumb: json['thumb'] as String,
      small: json['small'] as String,
      large: json['large'] as String,
      slug: json['slug'] as String,
      priceBtc: (json['price_btc'] as num?)?.toDouble(),
      data: json['data'] != null ? TrendingCoinData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin_id': coinId,
        'name': name,
        'symbol': symbol,
        'market_cap_rank': marketCapRank,
        'thumb': thumb,
        'small': small,
        'large': large,
        'slug': slug,
        'price_btc': priceBtc,
        'data': data?.toJson(),
      };
}

class TrendingCoinData {
  final double? price;
  final Map<String, dynamic>? priceChangePercentage24h;
  final String? marketCap;
  final String? totalVolume;
  final String? sparkline;

  TrendingCoinData({
    this.price,
    this.priceChangePercentage24h,
    this.marketCap,
    this.totalVolume,
    this.sparkline,
  });

  factory TrendingCoinData.fromJson(Map<String, dynamic> json) {
    return TrendingCoinData(
      price: _priceFromJson(json['price']),
      priceChangePercentage24h: json['price_change_percentage_24h'] as Map<String, dynamic>?,
      marketCap: json['market_cap'] as String?,
      totalVolume: json['total_volume'] as String?,
      sparkline: json['sparkline'] as String?,
    );
  }

  static double? _priceFromJson(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    if (value is int) return value.toDouble();
    return null;
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'price_change_percentage_24h': priceChangePercentage24h,
        'market_cap': marketCap,
        'total_volume': totalVolume,
        'sparkline': sparkline,
      };

  double get usdChange => (priceChangePercentage24h?['usd'] as num?)?.toDouble() ?? 0.0;
}
