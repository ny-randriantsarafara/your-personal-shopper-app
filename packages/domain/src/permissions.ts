export const permissions = [
  'request.create',
  'request.read',
  'request.assign',
  'quote.create',
  'quote.approve',
  'payment.read',
  'payment.verify',
  'payment.refund',
  'shipment.update',
  'workspace.manage',
  'user.manage',
] as const;

export type Permission = (typeof permissions)[number];
