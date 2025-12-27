import 'package:artverse/controllers/auth_controller.dart';
import 'package:artverse/navigation/main_navigation.dart';
import 'package:artverse/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:artverse/utils/snackbar.dart';
import '../../widgets/auth_widget.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthController _authController = AuthController();

  void _handleLogin() async {   
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if(email.isEmpty) {
      SnackbarHelper.showInfo(context, 'Email cannot be empty');
      return;
    }

    if(!email.contains('@')) {
      SnackbarHelper.showInfo(context, 'Incorrect Email format');
      return;
    }

    if(password.isEmpty) {
      SnackbarHelper.showInfo(context, 'Password cannot be empty');
      return;
    }

    setState(() {
      _authController.isLoading = true;
    });

    try {
      await _authController.login(email, password);
      SnackbarHelper.showSuccess(context, 'Berhasil Login');

      await Future.delayed(Duration(milliseconds: 772));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    } catch (e) {
      SnackbarHelper.showError(context, 'Incorrect username or password');
      print(e.toString());
    } finally {
      setState(() {
        _authController.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
                            Text(
                'Sign in to your\nAccount',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Enter your email and password to log in',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),
        
              AuthLabel(text: 'Email'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _emailController,
                hint: 'verona@artverse.com',
                keyboardType: TextInputType.emailAddress,
              ),
        
              const SizedBox(height: 20),
        
              AuthLabel(text: 'Password'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _passwordController,
                hint: '******',
                obscure: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
        
              const SizedBox(height: 24),
        
              AuthButton(
                text: _authController.isLoading ? 'Loading...' : 'Log In',
                onPressed: () {
                  if (_authController.isLoading) return;
                  _handleLogin();
                },
                isDisabled: _authController.isLoading,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthLabel(text: "Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              )
            ],
          ),
          
        ),
      ),
    );
  }
}
