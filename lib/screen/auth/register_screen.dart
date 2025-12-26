import 'package:artverse/screen/auth/login_screen.dart';
import 'package:artverse/widget/auth_widget.dart';
import 'package:artverse/util/date.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _reObscurePassword = true;
  DateTime? _selectedDate;
  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
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
                'Sign Up',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Create an account to get start!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),
              AuthLabel(text: 'Full Name'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _fullNameController,
                hint: 'Verona Michigan',
              ),

              const SizedBox(height: 20),
        
              AuthLabel(text: 'Email'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _emailController,
                hint: 'verona@artverse.com',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),
              
              AuthLabel(text: 'Date of Birth'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _dateController,
                hint: 'DD/MM/YYYY',
                readOnly: true,
                obscure: false,
                onTap: () async {
                    final pickedDate = await selectDate(context: context);
                    if (pickedDate != null) {
                        setState(() {
                            _selectedDate = pickedDate;
                            _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                    }
                },
                suffixIcon: Icon(Icons.calendar_today),
                keyboardType: TextInputType.datetime,
              ),

              const SizedBox(height: 20),
        
              AuthLabel(text: 'Username'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _usernameController,
                hint: 'vero',
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

              const SizedBox(height: 20),

              AuthLabel(text: 'Re-Password'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _rePasswordController,
                hint: '******',
                obscure: _reObscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _reObscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _reObscurePassword = !_reObscurePassword;
                    });
                  },
                ),
              ),
        
              const SizedBox(height: 24),
        
              AuthButton(
                text: 'Sign Up',
                onPressed: () {
                  
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthLabel(text: "Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                    child: const Text('Sign In'),
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
