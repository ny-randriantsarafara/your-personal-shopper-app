export const paymentProviders = [
  'MVOLA',
  'ORANGE_MONEY',
  'AIRTEL_MONEY',
  'MANUAL_MOBILE_MONEY',
] as const;

export type PaymentProviderCode = (typeof paymentProviders)[number];

export const paymentStatuses = [
  'pending',
  'waiting_customer_action',
  'processing',
  'paid',
  'failed',
  'expired',
  'refunded',
] as const;

export type PaymentStatus = (typeof paymentStatuses)[number];
