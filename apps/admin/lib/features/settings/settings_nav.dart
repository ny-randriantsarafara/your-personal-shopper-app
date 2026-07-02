import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';

/// Sections of the account settings screen.
enum SettingsSection { profile, security, money, addresses }

class _NavItem {
  const _NavItem({
    required this.section,
    required this.label,
    required this.description,
    required this.icon,
  });

  final SettingsSection section;
  final String label;
  final String description;
  final IconData icon;
}

const List<_NavItem> _items = [
  _NavItem(
    section: SettingsSection.profile,
    label: 'Profile',
    description: 'Name and email',
    icon: Icons.person_outline,
  ),
  _NavItem(
    section: SettingsSection.security,
    label: 'Security',
    description: 'Password and access',
    icon: Icons.lock_outline,
  ),
  _NavItem(
    section: SettingsSection.money,
    label: 'Mobile Money',
    description: 'Payment phones',
    icon: Icons.smartphone,
  ),
  _NavItem(
    section: SettingsSection.addresses,
    label: 'Addresses',
    description: 'Shipping and sender',
    icon: Icons.place_outlined,
  ),
];

/// Left/stacked navigation panel for account settings, mirroring the designer
/// settings sidebar.
class SettingsNav extends StatelessWidget {
  const SettingsNav({
    required this.current,
    required this.onSelect,
    super.key,
  });

  final SettingsSection current;
  final ValueChanged<SettingsSection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 40,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in _items)
            _NavButton(
              item: item,
              selected: item.section == current,
              onTap: () => onSelect(item.section),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : const Color(0xFF3F3F46);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? AppColors.foreground : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0x1FFFFFFF)
                      : const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected
                        ? const Color(0x26FFFFFF)
                        : const Color(0x0A111113)),
                ),
                child: Icon(
                  item.icon,
                  size: 18,
                  color: selected ? Colors.white : const Color(0xFF71717A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: selected
                            ? const Color(0x99FFFFFF)
                            : const Color(0xFFA1A1AA),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: selected ? const Color(0xCCFFFFFF) : const Color(0x40A1A1AA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
