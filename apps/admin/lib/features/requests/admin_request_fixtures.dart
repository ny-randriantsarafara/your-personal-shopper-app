import '../../shared/widgets/status_badge.dart';
import 'admin_request_models.dart';

/// Neutral demo requests spanning the full fulfilment lifecycle so every staff
/// workspace (shopper, logistics, admin) has representative content.
const List<ProductRequest> initialAdminRequests = [
  ProductRequest(
    id: 'REQ-101',
    title: 'Wireless Noise-Cancelling Headphones',
    url: 'https://example.com/wireless-headphones',
    status: OrderStatus.submitted,
  ),
  ProductRequest(
    id: 'REQ-102',
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
    id: 'REQ-103',
    title: 'Mirrorless Camera Body',
    url: 'https://example.com/mirrorless-camera',
    status: OrderStatus.paid,
    quote: ShopperQuote(
      productAmount: 900,
      exchangeRate: 4600,
      serviceFee: 40000,
      localDeliveryFee: 15000,
      totalMGA: 4195000,
    ),
  ),
  ProductRequest(
    id: 'REQ-104',
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
    id: 'REQ-105',
    title: 'Portable Bluetooth Speaker',
    url: 'https://example.com/bluetooth-speaker',
    status: OrderStatus.warehouseReceived,
    quote: ShopperQuote(
      productAmount: 130,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 628000,
    ),
  ),
  ProductRequest(
    id: 'REQ-106',
    title: 'Mechanical Keyboard',
    url: 'https://example.com/mechanical-keyboard',
    status: OrderStatus.internationalTransit,
    quote: ShopperQuote(
      productAmount: 160,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 766000,
    ),
  ),
  ProductRequest(
    id: 'REQ-107',
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
  ProductRequest(
    id: 'REQ-108',
    title: 'Compact Travel Backpack',
    url: 'https://example.com/travel-backpack',
    status: OrderStatus.delivered,
    quote: ShopperQuote(
      productAmount: 80,
      exchangeRate: 4600,
      serviceFee: 20000,
      localDeliveryFee: 10000,
      totalMGA: 398000,
    ),
  ),
];
