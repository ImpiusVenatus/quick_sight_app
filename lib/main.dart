import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quicksight/provider/theme_provider.dart';
import 'package:quicksight/views/home_screen/home_screen.dart';
import 'package:quicksight/views/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resetProviders() {
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        key = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      key: key,
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const QuickSight(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashView(),
    ),
    GoRoute(
      path: '/main',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
  ],
);

class QuickSight extends StatelessWidget {
  const QuickSight({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      //theme: lightTheme,
      //darkTheme: darkTheme,
      routerConfig: _router,
    );
  }
}
