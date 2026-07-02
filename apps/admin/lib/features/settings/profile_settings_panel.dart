import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/workspaces/workspace_provider.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import 'settings_panel_heading.dart';

/// Profile identity form, mirroring the designer profile panel.
class ProfileSettingsPanel extends ConsumerStatefulWidget {
  const ProfileSettingsPanel({super.key});

  @override
  ConsumerState<ProfileSettingsPanel> createState() =>
      _ProfileSettingsPanelState();
}

class _ProfileSettingsPanelState extends ConsumerState<ProfileSettingsPanel> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(adminUserProfileProvider);
    _firstName = TextEditingController(text: profile.firstName);
    _lastName = TextEditingController(text: profile.lastName);
    _email = TextEditingController(text: profile.email);
    _phone = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsPanelHeading(
          title: 'Profile',
          subtitle:
              'This identity appears on orders, quotes, and delivery handoffs.',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final firstName = AppTextField(
              label: 'First name',
              controller: _firstName,
            );
            final lastName = AppTextField(
              label: 'Last name',
              controller: _lastName,
            );

            if (constraints.maxWidth < 520) {
              return Column(
                children: [firstName, const SizedBox(height: 20), lastName],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: firstName),
                const SizedBox(width: 20),
                Expanded(child: lastName),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        AppTextField(
          label: 'Email address',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        AppTextField(
          label: 'Primary phone',
          controller: _phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton(label: 'Save profile', onPressed: () {}),
        ),
      ],
    );
  }
}
