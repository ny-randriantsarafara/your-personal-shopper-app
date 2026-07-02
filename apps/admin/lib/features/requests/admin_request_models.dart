import '../../shared/widgets/status_badge.dart';

/// Cost breakdown a shopper produces for a request, mirroring the designer
/// `Quote` shape.
class ShopperQuote {
  const ShopperQuote({
    required this.productAmount,
    required this.exchangeRate,
    required this.serviceFee,
    required this.localDeliveryFee,
    required this.totalMGA,
  });

  final int productAmount;
  final int exchangeRate;
  final int serviceFee;
  final int localDeliveryFee;
  final int totalMGA;
}

/// A purchase request as seen from staff workspaces, mirroring the designer
/// `ProductRequest` shape.
class ProductRequest {
  const ProductRequest({
    required this.id,
    required this.title,
    required this.url,
    required this.status,
    this.imageUrl,
    this.quote,
  });

  final String id;
  final String title;
  final String url;
  final OrderStatus status;
  final String? imageUrl;
  final ShopperQuote? quote;

  ProductRequest copyWith({OrderStatus? status, ShopperQuote? quote}) {
    return ProductRequest(
      id: id,
      title: title,
      url: url,
      status: status ?? this.status,
      imageUrl: imageUrl,
      quote: quote ?? this.quote,
    );
  }
}
