import 'package:avd_decoration_application/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../services/local_storage_service.dart';
import '../../themes/app_theme.dart';
import '../../utils/constants.dart';
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

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
        const SnackBar(
            content: Text('Please enter both username and password')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create auth service instance
      final authService = AuthService(apiBaseUrl);

      // Call the login API
      final response = await authService.login(username, password);

      // Close loading dialog
      Navigator.of(context).pop();

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final user = UserModel(
          id: userData['id'],
          username: userData['username'],
          role: userData['role'],
          email: userData['email'] ?? '', // Handle missing email field
          createdAt: userData['created_at'] != null
              ? DateTime.parse(userData['created_at'])
              : null,
        );

        // Save user data to shared preferences
        final localStorage = ref.read(localStorageServiceProvider);
        await localStorage.saveUserData(user);

        // Update auth state
        ref.read(authProvider.notifier).updateUser(user);

        print('✅ User logged in successfully: ${user.username}');
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Welcome ${user.username}!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
          print(response['message']);
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      // Close loading dialog if it's still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      print('❌ Login error: $e');
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 32.0),
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
                        style: ResponsiveTextStyle.heading(context)
                            .copyWith(color: AppColors.primary),
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
