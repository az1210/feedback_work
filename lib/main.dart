import 'package:device_preview/device_preview.dart';
import 'package:feedback_work/core/config/supabase_config.dart';
import 'package:feedback_work/core/utils/cache_service/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './core/ui/theme.dart';
import './core/router/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  await ScreenUtil.ensureScreenSize();
  await Hive.initFlutter();
  final appBox = await Hive.openBox("feedbackWorks");
  CacheServiceImpl(box: appBox);

  runApp(
    DevicePreview(
      builder: (context) => const ProviderScope(
        child: MyApp(),
      ),
      enabled: false,
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 820), // Figma Design Size
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Feedback Work',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }
}
