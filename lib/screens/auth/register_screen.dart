import 'package:artverse/controllers/auth_controller.dart';
import 'package:artverse/screens/auth/login_screen.dart';
import 'package:artverse/v1/utils/snackbar.dart';
import 'package:artverse/widgets/auth_widget.dart';
import 'package:artverse/utils/date.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _reObscurePassword = true;
  DateTime? _selectedDate = DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;
    String birthDate = _birthDateController.text;

    // Validation
    if (fullName.isEmpty) {
      SnackbarHelper.showError(context, 'Full name cannot be null'); return;
    }
    
    if (email.isEmpty) {
      SnackbarHelper.showError(context, 'Email cannot be null'); return;
    }

    if (!email.contains('@')) {
      SnackbarHelper.showError(context, 'Incorrect Email format'); return;
    }
    
    if (password.isEmpty) {
      SnackbarHelper.showError(context, 'Password cannot be null'); return;
    }
    
    if (birthDate.isEmpty) {
      SnackbarHelper.showError(context, 'Birth date cannot be null'); return;
    }
    
    if (password.isEmpty) {
      SnackbarHelper.showError(context, 'Password cannot be null'); return;
    }

    if (rePassword.isEmpty) {
      SnackbarHelper.showError(context, 'Re-Password cannot be null'); return;
    }

    if (password != rePassword) {
      SnackbarHelper.showError(context, 'Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 6) {
      SnackbarHelper.showError(context, 'Password min 6 characters');
      return;
    }

    setState(() => _authController.isLoading = true);

    try {
      await _authController.register(
        email: email,
        password: password,
        fullName: fullName,
        birthDate: _selectedDate != null
            ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
            : null,
      );

      SnackbarHelper.showSuccess(context, 'Registration successful!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } catch (e) {
      SnackbarHelper.showError(context, 'Registration failed!');
      print(e.toString());
    } finally {
      setState(() => _authController.isLoading = false);
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
                'Sign Up',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Create an account to get started!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),
              AuthLabel(text: 'Full Name'),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _fullNameController,
                hint: 'Verona Everlyn',
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
                controller: _birthDateController,
                hint: 'DD/MM/YYYY',
                readOnly: true,
                obscure: false,
                onTap: () async {
                  final pickedDate = await selectDate(
                    context: context,
                    initialDate: _selectedDate, 
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _birthDateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                suffixIcon: Icon(Icons.calendar_today),
                keyboardType: TextInputType.datetime,
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
                text: _authController.isLoading ? 'Creating account...' : 'Sign Up',
                onPressed: () {
                  if (_authController.isLoading) return;
                  _handleRegister();
                },
                isDisabled: _authController.isLoading,
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
