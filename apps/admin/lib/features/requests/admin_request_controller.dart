import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/status_badge.dart';
import 'admin_request_fixtures.dart';
import 'admin_request_models.dart';

/// Holds the platform's requests and the staff transitions triggered from the
/// shopper, logistics, and admin workspaces.
class AdminRequestController extends Notifier<List<ProductRequest>> {
  @override
  List<ProductRequest> build() => initialAdminRequests;

  void createQuote({
    required String requestId,
    required int productAmount,
    required int exchangeRate,
    required int serviceFee,
    required int localDeliveryFee,
  }) {
    final totalMGA =
        (productAmount * exchangeRate) + serviceFee + localDeliveryFee;
    final quote = ShopperQuote(
      productAmount: productAmount,
      exchangeRate: exchangeRate,
      serviceFee: serviceFee,
      localDeliveryFee: localDeliveryFee,
      totalMGA: totalMGA,
    );

    state = [
      for (final request in state)
        if (request.id == requestId)
          request.copyWith(status: OrderStatus.quoteAvailable, quote: quote)
        else
          request,
    ];
  }

  ProductRequest? requestById(String id) {
    for (final request in state) {
      if (request.id == id) {
        return request;
      }
    }
    return null;
  }

  void markPurchased(String id) => _updateStatus(id, OrderStatus.purchased);

  void receiveWarehouse(String id) =>
      _updateStatus(id, OrderStatus.warehouseReceived);

  void shipToMadagascar(String id) =>
      _updateStatus(id, OrderStatus.internationalTransit);

  void markArrived(String id) =>
      _updateStatus(id, OrderStatus.arrivedInMadagascar);

  void markDelivered(String id) => _updateStatus(id, OrderStatus.delivered);

  void _updateStatus(String id, OrderStatus status) {
    state = [
      for (final request in state)
        if (request.id == id) request.copyWith(status: status) else request,
    ];
  }
}

final adminRequestControllerProvider =
    NotifierProvider<AdminRequestController, List<ProductRequest>>(
      AdminRequestController.new,
    );
