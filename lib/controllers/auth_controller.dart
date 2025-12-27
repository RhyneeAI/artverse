import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:artverse/models/user_model.dart';

class AuthController {
  final supabase = Supabase.instance.client;
  bool isLoading = false;
  
  Future<UserModel?> login(String email, String password) async {
    isLoading = true;
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      final user = response.user;
      if (user != null) {
        return UserModel(
          id: user.id,
          email: user.email!,
          full_name: user.userMetadata?['full_name'] as String?,
        );
      }
      return null;
    } finally {
      isLoading = false;
    }
  }
  
  Future<UserModel?> register({
    required String email,
    required String password,
    required String fullName,
    String? birthDate,
  }) async {
    isLoading = true;
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'birth_date': birthDate,
        },
      );

      final user = authResponse.user;
      if (user != null) {
        await supabase.from('users').insert({
          'id': user.id,
          'email': email,
          'full_name': fullName,
          'birth_date': birthDate,
          'is_validate': true,
          'validated_at': null,
        });

        return UserModel(
          id: user.id,
          email: email,
          password: password,
          full_name: fullName,
          birth_date: birthDate,
          is_validate: true,
        );
      }
      return null;
    } finally {
      isLoading = false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    
    final response = await supabase
      .from('users')
      .select()
      .eq('id', user.id)
      .single();
    
    return UserModel(
      id: response['id'],
      email: response['email'],
      full_name: response['full_name'],
      phone: response['phone'],
      profile_image: response['profile_image'],
      birth_date: response['birth_date'],
      is_validate: response['is_validate'],
      validated_at: response['validated_at'],
    );
  }

  Future<void> updateUser({
    required String userId,
    required String fullName,
    String? phone,
    String? birthDate,
    String? profileImage,
  }) async {
    isLoading = true;
    try {
      await supabase.from('users').update({
        'full_name': fullName,
        'phone': phone,
        'birth_date': birthDate,
        'profile_image': profileImage,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      
      await supabase.auth.updateUser(
        UserAttributes(data: {
          'full_name': fullName,
          'birth_date': birthDate,
        }),
      );
    } finally {
      isLoading = false;
    }
  }
}