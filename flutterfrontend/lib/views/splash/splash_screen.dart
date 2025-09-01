import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../services/local_storage_service.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('🚀 App initialization started...');
      
      // Wait for auth provider to check saved session
      await Future.delayed(const Duration(seconds: 5));
      
      // Set loading to false after initialization
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error initializing app: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth ready state
    final isAuthReady = ref.watch(authReadyProvider);
    
    // Listen to auth state changes in the build method
    ref.listen(authProvider, (previous, next) {
      print('🔄 Auth state changed: ${previous?.username ?? 'None'} -> ${next?.username ?? 'None'}');
      if (!_isInitialized && next != null) {
        _isInitialized = true;
        _navigateToNextScreen();
      }
    });

    // Check if we should navigate immediately
    final user = ref.read(authProvider);
    if (!_isInitialized && isAuthReady && !_isLoading) {
      if (user != null) {
        print('✅ User already authenticated, navigating immediately');
        _isInitialized = true;
        // Use a post-frame callback to avoid build-time navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToNextScreen();
        });
      } else {
        print('❌ No user found, will navigate to login');
        _isInitialized = true;
        // Use a post-frame callback to avoid build-time navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToNextScreen();
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/swamiji.jpg',
              fit: BoxFit.cover,
            ),
          ),

        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    final user = ref.read(authProvider);
    final route = user == null ? AppRoutes.login : AppRoutes.home;
    
    print('🧭 Navigating to: $route (User: ${user?.username ?? 'None'})');
    Navigator.pushReplacementNamed(context, route);
  }


}
