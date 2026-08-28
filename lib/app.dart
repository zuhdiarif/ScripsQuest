import 'package:flutter/material.dart';
import 'package:raion_hackjam/core/constants/app_constants.dart';
import 'package:raion_hackjam/core/di/app_providers.dart';
import 'package:raion_hackjam/core/routes/app_router.dart';
import 'package:raion_hackjam/core/theme/app_theme.dart';

class ScripsQuestApp extends StatelessWidget {
  const ScripsQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
