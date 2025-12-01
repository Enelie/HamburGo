// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/supabase_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  bool _isLoading = false;
  String selectedRole = 'cliente';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    return emailRegExp.hasMatch(email);
  }

  // Registro de usuario
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final supabase = context.read<SupabaseProvider>();
    final String? error = await supabase.signUp(
      emailController.text.trim(),
      passController.text,
      nameController.text.trim(),
      selectedRole,
    );

    if (!mounted) return;

    if (error == null) {
      Navigator.pushReplacementNamed(context, _routeByRole(selectedRole));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Error desconocido')),
      );
    }

    setState(() => _isLoading = false);
  }

  // Login de usuario
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final supabase = context.read<SupabaseProvider>();
    final userData = await supabase.signInWithRole(
      emailController.text.trim(),
      passController.text,
    );

    if (!mounted) return;

    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas.')),
      );
    } else {
      final role = userData['role'] as String? ?? 'cliente';
      Navigator.pushReplacementNamed(context, _routeByRole(role));
    }

    setState(() => _isLoading = false);
  }

  // Retorna la ruta según el rol
  String _routeByRole(String role) {
    switch (role) {
      case 'cliente':
        return '/home';        // EditorPage
      case 'cocina':
        return '/kitchen';     // KitchenPage
      case 'repartidor':
        return '/delivery';    // DeliveryPage
      case 'gerente':
        return '/manager';     // ManagerPage
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
                  if (v.trim().length < 2) return 'Nombre muy corto';
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El email es obligatorio';
                  if (!_isValidEmail(v.trim())) return 'Email no válido';
                  return null;
                },
              ),
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
                  if (v.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                  DropdownMenuItem(value: 'cocina', child: Text('Cocina')),
                  DropdownMenuItem(value: 'repartidor', child: Text('Repartidor')),
                  DropdownMenuItem(value: 'gerente', child: Text('Gerente')),
                ],
                onChanged: (value) {
                  if (value != null) selectedRole = value;
                },
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Registrarse'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
