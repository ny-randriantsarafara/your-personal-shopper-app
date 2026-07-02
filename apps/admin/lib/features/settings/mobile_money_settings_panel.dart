import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/workspaces/workspace_provider.dart';
import '../../shared/theme/app_colors.dart';
import 'settings_panel_heading.dart';

class _MoneyAccount {
  const _MoneyAccount({
    required this.name,
    required this.phone,
    required this.caption,
    required this.tone,
    required this.toneBackground,
  });

  final String name;
  final String phone;
  final String caption;
  final Color tone;
  final Color toneBackground;
}

/// Mobile Money account list, mirroring the designer money panel. Keeps the
/// provider names visible: MVola, Orange Money, Airtel Money.
class MobileMoneySettingsPanel extends ConsumerWidget {
  const MobileMoneySettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(adminUserProfileProvider);

    final accounts = [
      _MoneyAccount(
        name: 'MVola',
        phone: profile.phone,
        caption: 'Primary checkout number',
        tone: const Color(0xFFB91C1C),
        toneBackground: const Color(0xFFFEF2F2),
      ),
      const _MoneyAccount(
        name: 'Orange Money',
        phone: '+261 32 00 000 00',
        caption: 'Backup payment route',
        tone: Color(0xFFC2410C),
        toneBackground: Color(0xFFFFF7ED),
      ),
      const _MoneyAccount(
        name: 'Airtel Money',
        phone: '+261 33 00 000 00',
        caption: 'Backup payment route',
        tone: Color(0xFFBE123C),
        toneBackground: Color(0xFFFFF1F2),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsPanelHeading(
          title: 'Mobile Money',
          subtitle:
              'Choose which number receives payment prompts for MVola, Orange '
              'Money, and Airtel Money.',
        ),
        const SizedBox(height: 24),
        for (final account in accounts) ...[
          _AccountRow(account: account),
          if (account != accounts.last) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.account});

  final _MoneyAccount account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: account.toneBackground,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: account.tone.withValues(alpha: 0.15)),
            ),
            child: Text(
              account.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: account.tone,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.phone,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  account.caption,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _EditButton(),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F4F5),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Edit',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
