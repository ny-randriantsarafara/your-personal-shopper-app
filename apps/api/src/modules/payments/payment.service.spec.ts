import { ManualMobileMoneyProvider } from './providers/manual-mobile-money.provider';
import { PaymentService } from './payment.service';

describe('PaymentService', () => {
  it('creates a normalized manual mobile money payment intent', async () => {
    const service = new PaymentService([new ManualMobileMoneyProvider()]);

    const result = await service.createIntent({
      providerCode: 'MANUAL_MOBILE_MONEY',
      amountMGA: 125000,
      customerPhone: '+261340000000',
    });

    expect(result.status).toBe('waiting_customer_action');
    expect(result.providerCode).toBe('MANUAL_MOBILE_MONEY');
    expect(result.instructions).toContain('125000');
  });
});
