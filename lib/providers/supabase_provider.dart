import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  SupabaseClient get client => supabase;

  // Registro de usuario
  Future<String?> signUp(String email, String password, String name, String role) async {
    try {
      final response = await supabase.auth.signUp(email: email, password: password);

      if (response.user == null) return 'Usuario no creado';

      final userId = response.user!.id;

      try {
        await supabase.from('users').insert({
          'id': userId,
          'name': name,
          'email': email,
          'role': role,
        });
      } catch (e) {
  return 'Error al insertar en tabla users: $e';
}

      return null; // Éxito
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Login con retorno de datos de usuario (incluye rol)
  Future<Map<String, dynamic>?> signInWithRole(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email, password: password);

      if (response.user == null) return null;

      final data = await supabase.from('users').select().eq('id', response.user!.id).single();
      return Map<String, dynamic>.from(data);
    } catch (e) {
      print('Error signIn: $e');
      return null;
    }
  }
}
