import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _dateNaissanceController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _currentStep = 0;
  String? _selectedUserType = 'Client(e)';
  final List<String> _categories = [
    'Couture',
    'Cuisine',
    'Electricite',
    'Peinture',
    'Communication'
  ];
  final Set<String> _selectedCategories = {};

  // 📅 Date Picker
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateNaissanceController.text =
            DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  // 📍 Address Field
  Widget _buildAddressInput() {
    return TextFormField(
      controller: _addressController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Adresse",
        suffixIcon: IconButton(
          icon: const Icon(Icons.location_on),
          onPressed: _showGoogleMapsSuggestion,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showGoogleMapsSuggestion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Utiliser Google Maps"),
        content: const Text("Souhaitez-vous ouvrir Google Maps pour sélectionner votre adresse ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final query = _addressController.text.trim();
              final String googleMapsUrl = query.isNotEmpty
                  ? "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}"
                  : "https://www.google.com/maps/search/?api=1&query=";

              if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Impossible d'ouvrir Google Maps.")),
                );
              }
            },
            child: const Text("Ouvrir"),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    String? hintText,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
    VoidCallback? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onFieldSubmitted: (_) => onFieldSubmitted?.call(),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) return "Ce champ est obligatoire";
            if ((label == "Nom" || label == "Prénom") && !RegExp(r'^[a-zA-Z]+$').hasMatch(value.trim())) {
              return "Veuillez entrer uniquement des lettres";
            }
            if (label == "Mot de passe" && value.length < 6) {
              return "Le mot de passe doit contenir au moins 6 caractères";
            }
            if (label == "Confirmation" && value != _passwordController.text) {
              return "Les mots de passe ne correspondent pas";
            }
            if (label == "Numero de Telephone" && !RegExp(r'^[0-9]+$').hasMatch(value)) {
              return "Veuillez entrer uniquement des chiffres";
            }
            if (label == "Email" && !RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
              return "Email invalide";
            }
            return null;
          },
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < (_selectedUserType == 'Artisant(e)' ? 3 : 2)) {
        setState(() => _currentStep += 1);
      } else {
        _createAccount();
      }
    }
  }

  Future<void> _createAccount() async {
    final url = Uri.parse('https://artisant.onrender.com/v1/auth/register');

    final Map<String, dynamic> body = {
      "firstName": _prenomController.text.trim(),
      "lastName": _nomController.text.trim(),
      "email": _emailController.text.trim(), // ✅ Add email to request
      "phone": _phoneController.text.trim(),
      "password": _passwordController.text,
      "dateOfBirth": _parseDate(_dateNaissanceController.text),
      "address": {
        "street": _addressController.text.trim(),
        "city": "City",
        "state": "State",
        "zipCode": "Zip",
        "country": "Country",
        "coordinates": {"lat": 0, "lng": 0}
      },
      "role": _selectedUserType == "Client(e)" ? "client" : "artisan",
      "category": _selectedUserType == "Artisant(e)" && _selectedCategories.isNotEmpty
          ? _selectedCategories.first.toLowerCase()
          : "couture",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte créé avec succès 🎯")),
        );
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        debugPrint("Error: ${responseBody['message'] ?? response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${responseBody['message'] ?? 'Échec de l’inscription.'}")),
        );
      }
    } catch (e) {
      debugPrint("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Une erreur est survenue: $e")),
      );
    }
  }

  String _parseDate(String input) {
    try {
      final parts = input.split('/');
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    } catch (_) {
      return "2000-01-01";
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvoked: (bool didPop) async {
        if (!didPop && _currentStep > 0) {
          setState(() => _currentStep--);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset("images/logo.png", width: 120),
                    const SizedBox(height: 25),

                    // Progress bar and steps omitted for brevity (unchanged)

                    if (_currentStep == 0) ...[
                      _buildInput(label: "Nom", controller: _nomController),
                      const SizedBox(height: 15),
                      _buildInput(label: "Prénom", controller: _prenomController),
                      const SizedBox(height: 15),
                
                      _buildInput(
                        label: "Date de Naissance",
                        controller: _dateNaissanceController,
                        readOnly: true,
                        hintText: "JJ/MM/AAAA",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _selectDate,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildAddressInput(),
                    ],

                    // Remaining steps stay the same as previous message...

                if (_currentStep == 1) ...[
                   _buildInput(label: "Email", controller: _emailController, keyboardType: TextInputType.emailAddress), // ✅ Email field
                      const SizedBox(height: 15),
                      _buildInput(
                        label: "Numero de Telephone",
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _selectedUserType,
                        items: ['Client(e)', 'Artisant(e)']
                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedUserType = value),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],

                    if (_currentStep == 2) ...[
                      if (_selectedUserType == 'Client(e)') ...[
                        _buildInput(label: "Mot de passe", controller: _passwordController, obscureText: true),
                        const SizedBox(height: 15),
                        _buildInput(label: "Confirmation", controller: _confirmPasswordController, obscureText: true),
                      ] else ...[
                        const Text("Categorie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ..._categories.map((category) => CheckboxListTile(
                              title: Text(category),
                              value: _selectedCategories.contains(category),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedCategories.add(category);
                                  } else {
                                    _selectedCategories.remove(category);
                                  }
                                });
                              },
                            )),
                      ],
                    ],

                    if (_currentStep == 3 && _selectedUserType == 'Artisant(e)') ...[
                      _buildInput(label: "Mot de passe", controller: _passwordController, obscureText: true),
                      const SizedBox(height: 15),
                      _buildInput(label: "Confirmation", controller: _confirmPasswordController, obscureText: true),
                    ],

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: () => setState(() => _currentStep--),
                            child: const Text("Retour", style: TextStyle(fontSize: 18)),
                          ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8B3BB),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                          child: Text(
                            (_currentStep == 2 && _selectedUserType == 'Client(e)') ||
                                    (_currentStep == 3 && _selectedUserType == 'Artisant(e)')
                                ? "Confirmer"
                                : "Continuer",
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}