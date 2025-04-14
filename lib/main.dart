import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mindfulbalance/pages/auth/login_page.dart';
import 'package:mindfulbalance/pages/auth/signup_page.dart';
import 'package:mindfulbalance/pages/dashboard.dart';
import 'package:mindfulbalance/pages/mindfulness.dart';
import 'package:mindfulbalance/pages/family_checkin.dart';
import 'package:mindfulbalance/pages/moodtrends.dart';
import 'package:mindfulbalance/providers/auth_provider.dart';
import 'package:mindfulbalance/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MindfulBalanceApp(),
    ),
  );
}

class MindfulBalanceApp extends StatelessWidget {
  const MindfulBalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MindfulBalance',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const AuthWrapper(),
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignupPage(),
            '/home': (context) => const HomePage(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthProvider().authStateChanges,
      builder: (context, snapshot) {
        print('Auth state: ${snapshot.connectionState}');
        print('Has data: ${snapshot.hasData}');
        print('Error: ${snapshot.error}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final _authProvider = AuthProvider();

  final List<Widget> pages = [
    const DashboardPage(),
    const MindfulnessPage(),
    const FamilyCheckInPage(),
    const MoodTrendsPage(),
  ];

  Future<void> _handleLogout() async {
    try {
      await _authProvider.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MindfulBalance'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement),
            label: 'Mindfulness',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom),
            label: 'Family',
          ),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Trends'),
        ],
      ),
    );
  }
}
