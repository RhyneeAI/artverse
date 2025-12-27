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

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}