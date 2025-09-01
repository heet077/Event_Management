import 'package:avd_decoration_application/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/local_storage_service.dart';
import '../../themes/app_theme.dart';
import '../../utils/responsive_text_style.dart';
import '../../utils/validators.dart';
import '../custom_widget/custom_button.dart';
import '../custom_widget/custom_input_field.dart';


final userProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Simple validation
    if (username.isEmpty || password.isEmpty) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    try {
      // Use the auth provider for login
      final authNotifier = ref.read(authProvider.notifier);
      
      // For demo purposes, create a user model and call login
      // In real app, this would be an API call
      if (username == 'admin' && password == 'admin') {
        final user = UserModel(
          username: username,
          role: 'admin',
          email: '$username@example.com',
        );
        
        // Save user data to shared preferences
        final localStorage = ref.read(localStorageServiceProvider);
        await localStorage.saveUserData(user);
        
        // Update auth state
        ref.read(authProvider.notifier).state = user;
        
        print('✅ Admin user logged in: $username');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (username == 'user' && password == 'user') {
        final user = UserModel(
          username: username,
          role: 'user',
          email: '$username@example.com',
        );
        
        // Save user data to shared preferences
        final localStorage = ref.read(localStorageServiceProvider);
        await localStorage.saveUserData(user);
        
        // Update auth state
        ref.read(authProvider.notifier).state = user;
        
        print('✅ Regular user logged in: $username');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      print('❌ Login error: $e');
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/IMG_2379.PNG',
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Login',
                        style: ResponsiveTextStyle.heading(context).copyWith(color: AppColors.primary),
                      ),

                      const SizedBox(height: 32),
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person_outline,
                        validator: Validators.validateUsername,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        toggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        label: 'Sign In',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _handleLogin();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
