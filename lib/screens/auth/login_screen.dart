import 'package:artverse/navigation/main_navigation.dart';
import 'package:artverse/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
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
                text: 'Log In',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainNavigation()));
                },
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
