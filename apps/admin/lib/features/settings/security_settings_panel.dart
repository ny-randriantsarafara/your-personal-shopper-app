import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import 'settings_panel_heading.dart';

/// Password and access controls, mirroring the designer security panel.
class SecuritySettingsPanel extends StatefulWidget {
  const SecuritySettingsPanel({super.key});

  @override
  State<SecuritySettingsPanel> createState() => _SecuritySettingsPanelState();
}

class _SecuritySettingsPanelState extends State<SecuritySettingsPanel> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsPanelHeading(
          title: 'Password & security',
          subtitle:
              'Simple controls for protecting high-value purchase requests.',
        ),
        const SizedBox(height: 24),
        AppTextField(
          label: 'Current password',
          controller: _current,
          hint: '••••••••',
          obscureText: true,
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final next = AppTextField(
              label: 'New password',
              controller: _next,
              hint: '••••••••',
              obscureText: true,
            );
            final confirm = AppTextField(
              label: 'Confirm password',
              controller: _confirm,
              hint: '••••••••',
              obscureText: true,
            );

            if (constraints.maxWidth < 520) {
              return Column(
                children: [next, const SizedBox(height: 20), confirm],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: next),
                const SizedBox(width: 20),
                Expanded(child: confirm),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, size: 18, color: Color(0xFFA1A1AA)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Two-step verification will use your primary Mobile Money '
                  'phone for sensitive actions.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF52525B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(label: 'Update password', onPressed: () {}),
        ),
      ],
    );
  }
}
