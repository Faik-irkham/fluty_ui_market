import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme_data.dart';
import 'screens/marketplace_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FlutyMarketApp());
}

class FlutyMarketApp extends StatelessWidget {
  const FlutyMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLUTY MARKET',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const MarketplacePage(),
    );
  }
}
