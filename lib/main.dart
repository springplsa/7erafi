import 'package:flutter/material.dart';
import 'package:start_up/screens/artisan/home.dart';
import 'package:start_up/screens/creat_actt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_up/screens/forget_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> loginUser({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('https://artisant.onrender.com/v1/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Login successful: ${data['token']}');
    // Save token in secure storage and navigate to home screen
  } else {
    print('Login failed: ${response.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirstUi());
}

class FirstUi extends StatelessWidget {
  const FirstUi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7erafi',
      debugShowCheckedModeBanner: false,
      home: const Welcome(), // First screen with logo & button
    );
  }
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://artisant.onrender.com/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
     final data = jsonDecode(response.body);
final token = data['token'];
final userId = data['user']['id']?.toString(); // Ensure it's a String

final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token);
await prefs.setString('user_id', userId ?? '');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion réussie')),
        );

        // Navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home(tabName: '')),
        );
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Erreur de connexion';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png", width: 150.0),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTextInput("Email", Icons.email, _emailController),
                    const SizedBox(height: 10),
                    _buildTextInput("Mot de Passe", Icons.lock, _passwordController, isPassword: true),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPinkButton("Se connecter", _handleLogin),
                        const SizedBox(width: 10),
                        _buildOutlineButton("Créer un compte", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CreateAccount()),
                          );
                        }),
                      ],
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgetPassword()),
                  );
                },
                child: const Text(
                  "Mot de passe oublié?",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPinkButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: const Color(0xFFF8B3BB),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildOutlineButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFF8B3BB)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18, color: Color(0xFFF8B3BB))),
    );
  }
}
