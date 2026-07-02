import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/workspaces/workspace.dart';
import '../../core/workspaces/workspace_provider.dart';
import '../theme/app_colors.dart';

class _WorkspaceOption {
  const _WorkspaceOption({
    required this.name,
    required this.description,
    required this.route,
    required this.icon,
    required this.tint,
    required this.tintBackground,
  });

  final String name;
  final String description;
  final String route;
  final IconData icon;
  final Color tint;
  final Color tintBackground;
}

const List<_WorkspaceOption> _options = [
  _WorkspaceOption(
    name: 'Shopper',
    description: 'Manage quotes & purchases',
    route: '/shopper',
    icon: Icons.shopping_bag_outlined,
    tint: Color(0xFF9333EA),
    tintBackground: Color(0xFFFAF5FF),
  ),
  _WorkspaceOption(
    name: 'Logistics Hub',
    description: 'Warehouse & transit',
    route: '/logistics',
    icon: Icons.local_shipping_outlined,
    tint: Color(0xFFEA580C),
    tintBackground: Color(0xFFFFF7ED),
  ),
  _WorkspaceOption(
    name: 'Admin Console',
    description: 'Platform overview',
    route: '/',
    icon: Icons.shield_outlined,
    tint: Color(0xFF27272A),
    tintBackground: Color(0xFFF4F4F5),
  ),
];

String currentWorkspaceLabel(String location) {
  return switch (location) {
    '/shopper' => 'Shopper',
    '/logistics' => 'Logistics Hub',
    '/settings' => 'Account Settings',
    _ => 'Admin Console',
  };
}

/// Header chip that opens a dropdown to switch staff workspaces and reach
/// account settings, mirroring the designer workspace switcher.
class WorkspaceSwitcher extends ConsumerWidget {
  const WorkspaceSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(adminUserProfileProvider);
    final location = GoRouterState.of(context).uri.path;
    final currentLabel = currentWorkspaceLabel(location);

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.card),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      builder: (context, controller, child) {
        return InkWell(
          key: const Key('workspace-switcher-button'),
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Avatar(initials: profile.initials),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFFA1A1AA),
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        SizedBox(
          width: 300,
          child: _MenuContent(
            profile: profile,
            currentLabel: currentLabel,
            onSelectRoute: (route) => context.go(route),
          ),
        ),
      ],
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent({
    required this.profile,
    required this.currentLabel,
    required this.onSelectRoute,
  });

  final AdminUserProfile profile;
  final String currentLabel;
  final ValueChanged<String> onSelectRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            children: [
              _Avatar(initials: profile.initials, muted: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      profile.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0x0F111113)),
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Text(
            'Switch Workspace',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFFA1A1AA),
            ),
          ),
        ),
        for (final option in _options)
          _WorkspaceRow(
            option: option,
            selected: option.name == currentLabel,
            onTap: () {
              MenuController.maybeOf(context)?.close();
              onSelectRoute(option.route);
            },
          ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(height: 1, color: Color(0x0F111113)),
        ),
        _ActionRow(
          icon: Icons.settings_outlined,
          label: 'Account Settings',
          selected: currentLabel == 'Account Settings',
          onTap: () {
            MenuController.maybeOf(context)?.close();
            onSelectRoute('/settings');
          },
        ),
        _ActionRow(
          icon: Icons.logout,
          label: 'Sign Out',
          destructive: true,
          onTap: () => MenuController.maybeOf(context)?.close(),
        ),
      ],
    );
  }
}

class _WorkspaceRow extends StatelessWidget {
  const _WorkspaceRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _WorkspaceOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0x0A111113) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: option.tintBackground,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x0D111113)),
              ),
              child: Icon(option.icon, size: 16, color: option.tint),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.foreground
                      : const Color(0xFF3F3F46),
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                size: 18,
                color: AppColors.foreground,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? const Color(0xFFDC2626) : AppColors.foreground;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0x0A111113) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, this.muted = false});

  final String initials;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: muted ? 40 : 36,
      height: muted ? 40 : 36,
      decoration: BoxDecoration(
        color: muted ? const Color(0xFFF4F4F5) : AppColors.foreground,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x0D111113)),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: muted ? const Color(0xFF52525B) : Colors.white,
        ),
      ),
    );
  }
}
