import 'package:admin/features/requests/admin_request_controller.dart';
import 'package:admin/shared/widgets/status_badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('admin request controller can create a quote and update status', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(adminRequestControllerProvider.notifier);
    final submitted = container
        .read(adminRequestControllerProvider)
        .firstWhere((request) => request.status == OrderStatus.submitted);

    controller.createQuote(
      requestId: submitted.id,
      productAmount: 100,
      exchangeRate: 4600,
      serviceFee: 50000,
      localDeliveryFee: 15000,
    );

    final updated = container
        .read(adminRequestControllerProvider)
        .firstWhere((request) => request.id == submitted.id);

    expect(updated.status, OrderStatus.quoteAvailable);
    expect(updated.quote?.totalMGA, 525000);
  });
}
