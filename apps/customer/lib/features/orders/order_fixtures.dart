import '../../shared/widgets/status_badge.dart';
import 'order_models.dart';

/// Neutral demo requests covering the key dashboard states. No real customer or
/// brand names are used; product titles are generic examples.
const List<ProductRequest> initialOrderRequests = [
  ProductRequest(
    id: 'REQ-001',
    title: 'Flagship Smartphone 256GB',
    url: 'https://example.com/flagship-smartphone',
    status: OrderStatus.quoteAvailable,
    quote: ShopperQuote(
      productAmount: 1099,
      exchangeRate: 4600,
      serviceFee: 50000,
      localDeliveryFee: 15000,
      totalMGA: 5120400,
    ),
  ),
  ProductRequest(
    id: 'REQ-002',
    title: 'Wireless Noise-Cancelling Headphones',
    url: 'https://example.com/wireless-headphones',
    status: OrderStatus.submitted,
  ),
  ProductRequest(
    id: 'REQ-003',
    title: 'Everyday Running Sneakers, Size 42',
    url: 'https://example.com/running-sneakers',
    status: OrderStatus.purchased,
    quote: ShopperQuote(
      productAmount: 110,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 536000,
    ),
  ),
  ProductRequest(
    id: 'REQ-004',
    title: 'Wireless Productivity Mouse',
    url: 'https://example.com/productivity-mouse',
    status: OrderStatus.arrivedInMadagascar,
    quote: ShopperQuote(
      productAmount: 90,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 444000,
    ),
  ),
];
