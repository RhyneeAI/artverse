import 'package:artverse/home/home.dart';
import 'package:artverse/utils/constants.dart';
import 'package:artverse/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedAvatar; 
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureRePassword = true;

  final List<String> _avatars = [
    'avatar.png',
    'boy.png',
    'cheetah.png',
    'frog.png',
    'gamer.png',
    'koala.png',
    'man.png',
    'wild-boar.png',
    'woman.png',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _emailController.text = user.email ?? '';

        if (docSnapshot.exists && docSnapshot.data() != null) {
          final data = docSnapshot.data()!; 
          _fullNameController.text = data['fullName'] ?? '';
          _phoneController.text = (data['phone'] ?? '');
          _selectedAvatar = data['avatarName']; 

          final birthDateRaw = data['birthDate'];
          if (birthDateRaw != null) {
            DateTime? birthDate;
            if (birthDateRaw is Timestamp) {
              birthDate = birthDateRaw.toDate();
            } else if (birthDateRaw is DateTime) {
              birthDate = birthDateRaw;
            } else if (birthDateRaw is String && birthDateRaw.isNotEmpty) {
              birthDate = DateFormat('dd/MM/yyyy').parse(birthDateRaw);
            }
            if (birthDate != null) {
              _birthDateController.text = DateFormat('dd/MM/yyyy').format(birthDate);
              _selectedDate = birthDate;
            }
          }
        }
      });
    } catch (e) {
      SnackbarHelper.showError(context, 'Gagal memuat data profile');
      print(e);
    }
  }

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

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200, // Adjust sesuai jumlah avatar
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              final path = 'assets/images/profile/$avatar';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(path),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String birthDate = _birthDateController.text.trim();
    String password = _passwordController.text.trim();
    String rePassword = _rePasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || birthDate.isEmpty || _selectedAvatar == null) {
      SnackbarHelper.showError(context, 'Semua fields wajib diisi, termasuk pilih avatar dan tanggal lahir');
      return;
    }

    if (password.isNotEmpty) {
      if (rePassword.isEmpty) {
        SnackbarHelper.showError(context, 'Ulangi password wajib diisi');
        return;
      }
      if (password != rePassword) {
        SnackbarHelper.showError(context, 'Password dan ulangi password tidak sama');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      await user.updateDisplayName(fullName);
      final currentUser = FirebaseAuth.instance.currentUser!;
      await currentUser.updateDisplayName(fullName);
      // if (currentUser.email != email) {
      //   await currentUser.updateEmail(email);
      // }
      if (password.isNotEmpty) {
        await currentUser.updatePassword(password);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'birthDate': birthDate,
        'avatarName': _selectedAvatar,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      SnackbarHelper.showSuccess(context, 'Profile berhasil diupdate!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'invalid-email') {
        errorMessage = 'Format email invalid.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah dipakai.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Silakan login ulang untuk update email/password.';
      } else {
        errorMessage = 'Gagal update profile: ${e.message}';
      }
      SnackbarHelper.showError(context, errorMessage);
    } catch (e) {
      SnackbarHelper.showError(context, 'Error tak terduga: $e');
    } finally {
      setState(() => _isLoading = false);
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 32),

                // Profile Photo (pilih dari assets)
                Center(
                  child: GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            image: _selectedAvatar != null
                                ? DecorationImage(
                                    image: AssetImage('assets/images/profile/$_selectedAvatar'),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _selectedAvatar == null
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(Icons.edit, size: 20, color: Colors.white), // Ganti icon biar cocok pilih aset
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true, // Biar ga bisa edit
                  decoration: InputDecoration(  // <- Ditambahkan InputDecoration dan kurung kurawal
                    labelText: 'Email Address',
                    filled: true, // Aktifkan background fill
                    fillColor: Colors.grey[300], // Mirip bg-secondary Bootstrap
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary), // Pastikan AppColors.primary sudah didefinisikan
                    ),
                    labelStyle: TextStyle(color: AppColors.textPrimary2),
                    hintStyle: TextStyle(color: AppColors.textPrimary),
                  ),
                  style: TextStyle(color: AppColors.textPrimary2),
                ),
                const SizedBox(height: 16),

                // Full Name Field
                TextField(
                  controller: _fullNameController,
                  decoration: customInputDecoration(
                    labelText: 'Full Name',
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number Field
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
                const SizedBox(height: 16),

                // Tombol Save
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}