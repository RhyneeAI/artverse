import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:artverse/models/user_model.dart';

class AuthController {
  final supabase = Supabase.instance.client;

  Future<UserModel?> login(String email, String password) async {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // UserModel? getCurrentUserModel() {
  //   final user = supabase.auth.currentUserModel;
  //   return user != null 
  //       ? UserModel(id: user.id, email: user.email!)
  //       : null;
  // }
}