// import 'package:artverse/auth/email_verification.dart';
import 'package:artverse/utils/constants.dart';
import 'package:artverse/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:artverse/auth/login.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  DateTime? _selectedDate;
  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Fungsi Register dengan Firebase
  Future<void> _register() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _birthDateController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _rePasswordController.text.isEmpty) {
      SnackbarHelper.showError(context, 'Semua field harus diisi!');
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      SnackbarHelper.showError(context, 'Password dan konfirmasi password tidak sama!');
      return;
    }

    if (_passwordController.text.length < 6) {
      SnackbarHelper.showError(context, 'Password minimal 6 karakter');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Buat user di Firebase Auth (email = username)
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user!;

      await user.sendEmailVerification();

      await user.updateDisplayName(_fullNameController.text.trim());
      await user.reload();

      // 2. Simpan data tambahan ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': _fullNameController.text.trim(),
        'username': _emailController.text.trim(),
        'birthDate': _selectedDate,
        'phone': _phoneController.text.trim(),
        'emailVerified': false,
        'emailVerifiedAt': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Sukses → langsung ke Home atau Login
      if (mounted) {
        SnackbarHelper.showSuccess(
          context,
          'Registrasi berhasil!',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Terjadi kesalahan';
      if (e.code == 'weak-password') msg = 'Password terlalu lemah (min 6 karakter)';
      if (e.code == 'email-already-in-use') msg = 'Email sudah terdaftar';
      if (e.code == 'invalid-email') msg = 'Format email tidak valid';

      if (mounted) {
        SnackbarHelper.showError(context, msg);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),  // Kembali normal, bukan ganti stack
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create an account to continue!',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                // Full Name
                TextField(
                  controller: _fullNameController,
                  decoration: customInputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration(
                    labelText: 'Email',
                    hintText: 'contoh: nama@artverse.com',
                  ),
                ),
                const SizedBox(height: 16),

                // Birth Date
                TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: customInputDecoration(
                    labelText: 'Birth of Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: customInputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🇮🇩', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Text('+62', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: customInputDecoration(
                    labelText: 'Set Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Re-enter Password
                TextField(
                  controller: _rePasswordController,
                  obscureText: _obscureRePassword,
                  decoration: customInputDecoration(
                    labelText: 'Re-enter Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureRePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureRePassword = !_obscureRePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Register
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Register', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),

                // Sudah punya akun?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ),
                      child: const Text('Login', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}