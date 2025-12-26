import 'dart:async';

import 'package:artverse/v1/home/home.dart';
import 'package:artverse/v1/utils/constants.dart';
import 'package:artverse/v1/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:artverse/auth/login.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResending = false;
  int _countdown = 0;
  Timer? _countdownTimer;

  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _listenToVerificationStatus();
  }

  void _listenToVerificationStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) return;

      // Reload user untuk update status emailVerified
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified && mounted) {
        // Update Firestore hanya sekali
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'emailVerified': true,
          'emailVerifiedAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        if (mounted) {
          SnackbarHelper.showSuccess(context, 'Email berhasil diverifikasi! 🎉');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (_isResending || _countdown > 0) return;

    setState(() {
      _isResending = true;
    });

    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      SnackbarHelper.showSuccess(context, 'Email verifikasi dikirim ulang!');

      // Mulai countdown 60 detik
      setState(() => _countdown = 60);

      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            _isResending = false;
            timer.cancel();
          }
        });
      });
    } catch (e) {
      SnackbarHelper.showError(context, 'Gagal mengirim ulang. Coba lagi nanti.');
      setState(() => _isResending = false);
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();   
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon besar
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 120,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 40),

                  // Judul
                  Text(
                    'Verifikasi Email Kamu',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Email tujuan
                  Text(
                    'Kami telah mengirimkan link verifikasi ke:',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'email kamu',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Instruksi
                  Text(
                    'Klik link di email untuk menyelesaikan verifikasi.\nKamu akan otomatis masuk ke aplikasi setelahnya.',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Tombol Kirim Ulang
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_countdown > 0 || _isResending) ? null : _resendVerificationEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _countdown > 0
                          ? Text('Kirim ulang dalam $_countdown detik', style: const TextStyle(fontSize: 16))
                          : const Text('Kirim ulang email verifikasi', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Kembali ke Login
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _signOut,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: AppColors.primary),
                      ),
                      child: Text(
                        'Kembali ke Log In',
                        style: TextStyle(fontSize: 16, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}