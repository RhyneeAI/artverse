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
}