import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/config/workspace_config_provider.dart';
import 'core/routing/customer_routes.dart';
import 'shared/theme/app_colors.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _CustomerAppView());
  }
}

class _CustomerAppView extends ConsumerStatefulWidget {
  const _CustomerAppView();

  @override
  ConsumerState<_CustomerAppView> createState() => _CustomerAppViewState();
}

class _CustomerAppViewState extends ConsumerState<_CustomerAppView> {
  late final GoRouter _router = createCustomerRouter();

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(workspaceConfigProvider);

    return MaterialApp.router(
      title: config.publicName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.foreground,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ).copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.foreground,
          displayColor: AppColors.foreground,
        ),
      ),
      routerConfig: _router,
    );
  }
}
