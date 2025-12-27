class UserModel {
  final String? id;
  final String email;
  final String? full_name;
  final String? profile_photo;
  final String? birth_date;
  final String? password;
  final bool is_validate;
  final String? validated_at;

  UserModel({
    this.id, 
    required this.email, 
    this.full_name,
    this.profile_photo,
    this.birth_date,
    this.password,
    this.is_validate = true, 
    this.validated_at,
  });
}