export type PaymentProviderCode =
  'MVOLA' | 'ORANGE_MONEY' | 'AIRTEL_MONEY' | 'MANUAL_MOBILE_MONEY';

export type PaymentIntentStatus =
  | 'pending'
  | 'waiting_customer_action'
  | 'processing'
  | 'paid'
  | 'failed'
  | 'expired'
  | 'refunded';

export interface CreatePaymentIntentInput {
  providerCode: PaymentProviderCode;
  amountMGA: number;
  customerPhone: string;
}

export interface PaymentIntentResult {
  providerCode: PaymentProviderCode;
  status: PaymentIntentStatus;
  instructions?: string;
  providerReference?: string;
  checkoutUrl?: string;
}

export interface PaymentProvider {
  providerCode: PaymentProviderCode;
  createPaymentIntent(
    input: CreatePaymentIntentInput,
  ): Promise<PaymentIntentResult>;
}
