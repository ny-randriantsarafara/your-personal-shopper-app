import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/workspaces/workspace_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import 'settings_panel_heading.dart';

class _AddressCard {
  const _AddressCard({
    required this.label,
    required this.name,
    required this.line,
    required this.city,
    required this.phone,
    required this.tag,
  });

  final String label;
  final String name;
  final String line;
  final String city;
  final String phone;
  final String tag;
}

/// Delivery and sender addresses, mirroring the designer address panel. Uses
/// neutral demo data instead of source-specific names.
class AddressSettingsPanel extends ConsumerWidget {
  const AddressSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(adminUserProfileProvider);

    final cards = [
      _AddressCard(
        label: 'Default delivery',
        name: profile.fullName,
        line: 'Lot II M 42 Bis, Antsakaviro',
        city: 'Antananarivo 101',
        phone: profile.phone,
        tag: 'Home',
      ),
      const _AddressCard(
        label: 'Sender / pickup',
        name: 'Regional Pickup Point',
        line: 'Ivandry Business Center',
        city: 'Antananarivo 101',
        phone: '+261 32 11 222 33',
        tag: 'Office',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: SettingsPanelHeading(
                title: 'Addresses',
                subtitle:
                    'Separate where we deliver locally from sender and pickup '
                    'references.',
              ),
            ),
            const SizedBox(width: 16),
            AppButton(
              label: 'Add address',
              icon: Icons.add,
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 560) {
              return Column(
                children: [
                  for (final card in cards) ...[
                    _AddressTile(card: card),
                    if (card != cards.last) const SizedBox(height: 16),
                  ],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _AddressTile(card: cards[0])),
                const SizedBox(width: 16),
                Expanded(child: _AddressTile(card: cards[1])),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const _DeliveryPreference(),
      ],
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.card});

  final _AddressCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: Color(0xFFA1A1AA),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  card.tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3F3F46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            card.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${card.line}\n${card.city}\n${card.phone}',
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryPreference extends StatelessWidget {
  const _DeliveryPreference();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 22,
            color: Color(0xFF71717A),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery preference',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Local dispatch defaults to Antananarivo courier. Regional '
                  'delivery can be confirmed before payment on each quote.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF52525B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
