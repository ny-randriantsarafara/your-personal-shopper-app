import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/workspaces/workspace_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_motion.dart';
import '../../shared/widgets/back_link.dart';
import 'address_settings_panel.dart';
import 'mobile_money_settings_panel.dart';
import 'profile_settings_panel.dart';
import 'security_settings_panel.dart';
import 'settings_nav.dart';

/// Account settings hub with a section navigation and animated panels,
/// mirroring the designer `AccountSettings`.
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  SettingsSection _section = SettingsSection.profile;

  static const double _twoColumnBreakpoint = 1024;

  Widget _panelFor(SettingsSection section) {
    return switch (section) {
      SettingsSection.profile => const ProfileSettingsPanel(
        key: ValueKey('profile'),
      ),
      SettingsSection.security => const SecuritySettingsPanel(
        key: ValueKey('security'),
      ),
      SettingsSection.money => const MobileMoneySettingsPanel(
        key: ValueKey('money'),
      ),
      SettingsSection.addresses => const AddressSettingsPanel(
        key: ValueKey('addresses'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1152),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BackLink(label: 'Back to Dashboard', onTap: () => context.go('/')),
            const SizedBox(height: 16),
            const _SettingsHeader(),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final nav = SettingsNav(
                  current: _section,
                  onSelect: (section) => setState(() => _section = section),
                );
                final content = _ContentPanel(child: _panelFor(_section));

                if (constraints.maxWidth < _twoColumnBreakpoint) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [nav, const SizedBox(height: 20), content],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 280, child: nav),
                    const SizedBox(width: 20),
                    Expanded(child: content),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends ConsumerWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(adminUserProfileProvider);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ACCOUNT CENTER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: Color(0xFFA1A1AA),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Settings that stay out of your way.',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                height: 1.05,
                color: AppColors.foreground,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Keep identity, payment phones, and delivery details organized '
              'in one calm place across every workspace.',
              style: TextStyle(fontSize: 15, color: AppColors.mutedForeground),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.foreground,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                  const Text(
                    '3 workspaces connected',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentPanel extends StatelessWidget {
  const _ContentPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17000000),
            blurRadius: 60,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: AppMotion.pageTransition,
        child: child,
      ),
    );
  }
}
