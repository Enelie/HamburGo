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
        SnackBar(content: Text(error)),
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

  // Ruta según rol
  String _routeByRole(String role) {
    switch (role) {
      case 'cliente':
        return '/home';
      case 'cocina':
        return '/kitchen';
      case 'repartidor':
        return '/delivery';
      case 'gerente':
        return '/manager';
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.fastfood, color: Colors.orange, size: 60),
                const SizedBox(height: 10),
                const Text(
                  "HamburGo",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Login / Registro",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nombre
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputStyle("Nombre", Icons.person),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'El nombre es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Email
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputStyle("Email", Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'El email es obligatorio';
                          }
                          if (!_isValidEmail(v)) return 'Email no válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: passController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputStyle("Contraseña", Icons.lock),
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'La contraseña es obligatoria';
                          }
                          if (v.length < 6) {
                            return 'Debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Rol
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        dropdownColor: const Color(0xFF2E2E2E),
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputStyle("Rol", Icons.group),
                        items: const [
                          DropdownMenuItem(
                              value: 'cliente',
                              child: Text('Cliente', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'cocina',
                              child: Text('Cocina', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'repartidor',
                              child: Text('Repartidor', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'gerente',
                              child: Text('Gerente', style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (value) {
                          if (value != null) selectedRole = value;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Botón registro
                      _actionButton(
                        label: "Registrarse",
                        onPressed: _isLoading ? null : _register,
                      ),
                      const SizedBox(height: 10),

                      // Botón login
                      _actionButton(
                        label: "Login",
                        onPressed: _isLoading ? null : _login,
                      ),

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: CircularProgressIndicator(color: Colors.orange),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPONENTES DE DISEÑO ---
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.orange),
      filled: true,
      fillColor: const Color(0xFF2E2E2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _actionButton({required String label, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
