import {
  CreatePaymentIntentInput,
  PaymentIntentResult,
  PaymentProvider,
} from './providers/payment-provider.interface';

export class PaymentService {
  constructor(private readonly providers: PaymentProvider[]) {}

  async createIntent(input: CreatePaymentIntentInput): Promise<PaymentIntentResult> {
    const provider = this.providers.find((candidate) => candidate.providerCode === input.providerCode);

    if (!provider) {
      throw new Error(`Unsupported payment provider: ${input.providerCode}`);
    }

    return provider.createPaymentIntent(input);
  }
}
