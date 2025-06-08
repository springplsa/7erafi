import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostScreen extends StatefulWidget {
  final String initialPostType;

  const CreatePostScreen({
    Key? key,
    this.initialPostType = 'Vente',
  }) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late String _postType;
  String? _selectedPaymentMethod;
  String? _selectedDeliveryOption;
  String _title = '';
  String _description = '';
  String _price = '';
  File? _image;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // Options for dropdowns
  final List<String> _paymentMethods = ['Main à Main', 'ECCP', 'Autre méthode'];

  final List<String> _deliveryOptions = [
    'Livraison Disponible',
    'Récupération Locale',
    'Les deux',
    'Non précisé'
  ];

  @override
  void initState() {
    super.initState();
    _postType = widget.initialPostType;
  }

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer Une publication',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                'Titre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Entrez le titre de votre publication',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onChanged: (value) => _title = value,
              ),
              SizedBox(height: 20),

              // Post Type Section
              Text(
                'Type de Publication',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _postType,
                items: ['Vente', 'Commande'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _postType = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 20),

              // Price Section
              Text(
                'Prix',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Montant',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un prix';
                        }
                        return null;
                      },
                      onChanged: (value) => _price = value,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('DZD'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Payment Method Dropdown
              Text(
                'Méthode de paiement',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                hint: Text('Choisissez une méthode'),
                items: _paymentMethods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une méthode';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Delivery Options Dropdown
              Text(
                'Options de livraison',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDeliveryOption,
                hint: Text('Choisissez une option'),
                items: _deliveryOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDeliveryOption = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Image Section
              Text(
                'Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.photo_library),
                      label: Text('Galerie'),
                      onPressed: _getImage,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                      onPressed: _takePhoto,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              if (_image != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.file(
                    _image!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),

              // Description Section
              Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Décrivez votre publication...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onChanged: (value) => _description = value,
              ),
              SizedBox(height: 30),

              // Publish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  child: Text(
                    'Publier',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez sélectionner une méthode de paiement')),
      );
      return;
    }

    // STEP 3: Retrieve token from shared_preferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Token non disponible. Veuillez vous reconnecter.')),
      );
      return;
    }

    final url = Uri.parse('https://artisant.onrender.com/v1/posts');

    // Optional: prepare media object if an image is selected
    List<Map<String, dynamic>> mediaList = [];
    if (_image != null) {
      mediaList.add({
        "url": _image!
            .path, // You should ideally upload this to a server and use that URL
        "type": "image",
        "public_id": "local-${DateTime.now().millisecondsSinceEpoch}"
      });
    }

    final Map<String, dynamic> body = {
      "title": _title,
      "description": _description,
      "media": mediaList,
      "type": _postType.toLowerCase(),
      "price": int.tryParse(_price) ?? 0,
      "paymentMethod": _selectedPaymentMethod?.toLowerCase(),
      "delivery": _selectedDeliveryOption?.toLowerCase() ?? 'non précisé'
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ Post créé: $responseData');
        Navigator.pop(context, responseData);
      } else {
        print('❌ Erreur lors de la création: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de publication.')),
        );
      }
    } catch (e) {
      print('❌ Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la publication.')),
      );
    }
  }
}
