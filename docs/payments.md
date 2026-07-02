# Payments

The apps consume one normalized Mobile Money payment workflow. Provider-specific behavior stays behind API adapters, so the frontends never branch on provider quirks.

## Provider adapter interface

Each provider implements a common interface (`apps/api/src/modules/payments/providers/payment-provider.interface.ts`):

```ts
interface PaymentProvider {
  providerCode: 'MVOLA' | 'ORANGE_MONEY' | 'AIRTEL_MONEY' | 'MANUAL_MOBILE_MONEY';
  createPaymentIntent(input): Promise<PaymentIntentResult>;
}
```

The full interface grows to include `getPaymentStatus`, `refundPayment`, and `handleWebhook` as real integrations land. `PaymentService` selects the provider by `providerCode` and delegates to it.

Provider codes and statuses are also shared as constants in `packages/payments`.

## Normalized payment record

```text
Payment
- id
- workspaceId
- orderId or quoteId
- provider
- amountMGA
- status
- customerPhone
- receiverAccountId
- providerReference
- checkoutUrl or instructions
- failureReason
- verifiedAt
- refundedAt
```

## Normalized customer-facing statuses

```text
pending
waiting_customer_action
processing
paid
failed
expired
refunded
```

## v1 strategy

- implement the real data model;
- implement the adapter interface;
- make `MANUAL_MOBILE_MONEY` fully functional;
- scaffold MVola, Orange Money, and Airtel Money adapters behind the same interface;
- add real provider integrations one by one when credentials and provider documentation are available.

This lets the product ship without blocking on third-party payment onboarding.
