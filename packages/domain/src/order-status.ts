export const orderStatuses = [
  'submitted',
  'quote_available',
  'quote_accepted',
  'paid',
  'purchased',
  'warehouse_received',
  'international_transit',
  'arrived_in_madagascar',
  'delivered',
  'cancelled',
] as const;

export type OrderStatus = (typeof orderStatuses)[number];
