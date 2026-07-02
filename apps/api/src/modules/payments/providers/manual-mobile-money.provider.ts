import {
  CreatePaymentIntentInput,
  PaymentIntentResult,
  PaymentProvider,
} from './payment-provider.interface';

export class ManualMobileMoneyProvider implements PaymentProvider {
  providerCode = 'MANUAL_MOBILE_MONEY' as const;

  createPaymentIntent(
    input: CreatePaymentIntentInput,
  ): Promise<PaymentIntentResult> {
    return Promise.resolve({
      providerCode: this.providerCode,
      status: 'waiting_customer_action',
      instructions: `Send ${input.amountMGA} MGA from ${input.customerPhone}, then wait for admin confirmation.`,
    });
  }
}
