import 'package:artverse/utils/constants.dart';
import 'package:artverse/utils/date.dart';
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

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  DateTime? _selectedDate = DateTime(DateTime.now().year - 18);
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
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Logout logic
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
                    hint: 'Verona Michigan',
                    keyboardType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                AuthLabel(
                    text: 'Phone Number'
                ),
                const SizedBox(height: 8),                
                AuthTextField(
                    controller: _phoneController,
                    hint: '82112334410',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🇮🇩', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Text('+62', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                ),

                const SizedBox(height: 20),

                AuthLabel(
                    text: 'Birth Date'
                ),
                const SizedBox(height: 8),
                AuthTextField(
                    controller: _birthDateController,
                    hint: 'DD/MM/YYYY',
                    readOnly: true, 
                    onTap: () async {
                        final pickedDate = await selectDate(context: context);
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

                AuthLabel(
                    text: 'Password'
                ),
                const SizedBox(height: 8),
                AuthTextField(
                    controller: _passwordController,
                    hint: '******',
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                ),

                const SizedBox(height: 20),

                AuthLabel(
                    text: 'Re-Password'
                ),
                const SizedBox(height: 8),
                AuthTextField(
                    controller: _rePasswordController,
                    hint: '******',
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureRePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureRePassword = !_obscureRePassword),
                    ),
                ),

                const SizedBox(height: 20),

                // Tombol Save
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : null,
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