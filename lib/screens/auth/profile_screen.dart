import 'package:artverse/models/user_model.dart';
import 'package:artverse/utils/constants.dart';
import 'package:artverse/utils/snackbar.dart';
import 'package:artverse/utils/date.dart';
import 'package:artverse/screens/auth/login_screen.dart';
import 'package:artverse/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  String? _selectedAvatar; 
  DateTime? _selectedDate;

  final AuthController _authController = AuthController();
  late Future<UserModel?> _userData;

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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userData = _authController.getCurrentUser();

    _userData.then((user) {
      if (user != null && mounted) {
        setState(() {
          if (_selectedAvatar == null) {
            _selectedAvatar = user.profile_image ?? _avatars[0];
          }
        });
      }
    });
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400, // Adjust sesuai jumlah avatar
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

  void _updateProfile() async {
    if (_fullNameController.text.isEmpty) {
      SnackbarUtils.showError(context, 'Full name is required');
      return;
    }

    setState(() => _authController.isLoading = true);
    
    try {
      final user = await _authController.getCurrentUser();
      if (user == null) throw Exception('User not found');

      final fullName = _fullNameController.text;
      String phone = _phoneController.text.toString();
      print("asdasd{$phone}");

      if(fullName.isEmpty) {
        SnackbarUtils.showError(context, 'Full name cannot be null'); return;
      }
      
      if(phone.isNotEmpty && phone.length < 10) {
        SnackbarUtils.showError(context, 'Minimum 10 digits phone number'); return;
      }
      
      await _authController.updateUser(
        userId: user.id!,
        fullName: fullName.trim(),
        phone: phone,
        birthDate: _selectedDate != null 
            ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2,'0')}-${_selectedDate!.day.toString().padLeft(2,'0')}"
            : null,
        profileImage: _selectedAvatar,
      );
     
      SnackbarUtils.showSuccess(context, 'Profile updated successfully');
    } catch (e) {
      SnackbarUtils.showError(context, 'Update failed: $e');
    } finally {
      setState(() => _authController.isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final user = snapshot.data;
        if (user == null) {
          return Center(child: Text('No user data'));
        }
        
        // SET DATA KE CONTROLLER
        _fullNameController.text = user.full_name ?? '';
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _birthDateController.text = user.birth_date ?? '';

        if (user.birth_date != null) {
          final dateParts = user.birth_date!.split('-');
          if (dateParts.length == 3) {
            _birthDateController.text = "${dateParts[2]}/${dateParts[1]}/${dateParts[0]}";
            _selectedDate = DateTime(
              int.parse(dateParts[0]),
              int.parse(dateParts[1]),
              int.parse(dateParts[2]),
            );
          }
        }
        
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final confirm = await SnackbarUtils.showConfirmationDialog(
                              context: context,
                              title: 'Konfirmasi Logout',
                              message: 'Apakah anda yakin ingin logout?',
                              confirmText: 'Logout',
                            );
                            if (confirm) {
                              await _authController.logout();
                              SnackbarUtils.showSuccess(context, 'Berhasil Logout');

                              await Future.delayed(Duration(milliseconds: 772));

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginScreen()),
                                (route) => false, // Hapus semua route
                              );
                            }
                          },
                          icon: Icon(Icons.logout),
                        ),
                      ],
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

                    AuthLabel(
                        text: 'Email Address'
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                        controller: _emailController,
                        hint: 'verona@artverse.com',
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true
                    ),

                    const SizedBox(height: 20),

                    AuthLabel(
                        text: 'Full Name'
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                        controller: _fullNameController,
                        hint: 'Verona Everlyn',
                        keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 20),

                    // AuthLabel(
                    //     text: 'Phone Number'
                    // ),
                    // const SizedBox(height: 8),                
                    // AuthTextField(
                    //   controller: _phoneController,
                    //   hint: '82112334410',
                    //   keyboardType: TextInputType.text,
                    //   prefixIcon: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 12),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text('🇮🇩', style: TextStyle(fontSize: 24)),
                    //         SizedBox(width: 8),
                    //         Text('+62', style: TextStyle(fontSize: 15)),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // const SizedBox(height: 20),

                    AuthLabel(
                        text: 'Birth Date'
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                        controller: _birthDateController,
                        hint: 'DD/MM/YYYY',
                        readOnly: true, 
                        onTap: () async {
                            final pickedDate = await DateUtilz.selectDate(
                              context: context,
                              initialDate: _selectedDate, 
                            );
                            if (pickedDate != null) {
                                setState(() {
                                    _selectedDate = pickedDate;
                                    print(_selectedDate);
                                    _birthDateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                });
                            }
                        },
                        fillColor: AppColors.accent2,
                        suffixIcon: Icon(Icons.calendar_today),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Save
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _authController.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
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
    );
  }
}