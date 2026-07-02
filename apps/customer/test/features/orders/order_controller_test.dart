import 'package:customer/features/orders/order_controller.dart';
import 'package:customer/shared/widgets/status_badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('customer order controller can create a new submitted request', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(orderControllerProvider.notifier);
    controller.createRequest(
      title: 'Demo Product',
      url: 'https://example.com/product',
    );

    final first = container.read(orderControllerProvider).first;
    expect(first.title, 'Demo Product');
    expect(first.status, OrderStatus.submitted);
  });
}
