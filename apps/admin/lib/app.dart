import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/admin_routes.dart';
import 'shared/theme/app_colors.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _AdminAppView());
  }
}

class _AdminAppView extends ConsumerStatefulWidget {
  const _AdminAppView();

  @override
  ConsumerState<_AdminAppView> createState() => _AdminAppViewState();
}

class _AdminAppViewState extends ConsumerState<_AdminAppView> {
  late final GoRouter _router = createAdminRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Personal Shopper Admin',
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
