import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/status_badge.dart';
import 'order_fixtures.dart';
import 'order_models.dart';

/// Holds the customer's product requests and the transitions triggered from the
/// designer customer flow (create, accept quote, authorize payment).
class OrderController extends Notifier<List<ProductRequest>> {
  @override
  List<ProductRequest> build() => initialOrderRequests;

  void createRequest({required String title, required String url}) {
    final newRequest = ProductRequest(
      id: 'REQ-00${state.length + 1}',
      title: title,
      url: url,
      status: OrderStatus.submitted,
    );
    state = [newRequest, ...state];
  }

  ProductRequest? requestById(String id) {
    for (final request in state) {
      if (request.id == id) {
        return request;
      }
    }
    return null;
  }

  void acceptQuote(String id) {
    _updateStatus(id, OrderStatus.quoteAccepted);
  }

  void markPaymentAuthorized(String id) {
    _updateStatus(id, OrderStatus.paid);
  }

  void _updateStatus(String id, OrderStatus status) {
    state = [
      for (final request in state)
        if (request.id == id) request.copyWith(status: status) else request,
    ];
  }
}

final orderControllerProvider =
    NotifierProvider<OrderController, List<ProductRequest>>(
      OrderController.new,
    );
