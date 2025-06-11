import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostScreen extends StatefulWidget {
  final String initialPostType;

  const CreatePostScreen({Key? key, this.initialPostType = 'Vente'}) : super(key: key);

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

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final List<String> _paymentMethods = ['Main à Main', 'ECCP', 'Autre méthode'];

  final List<String> _deliveryOptions = [
    'Livraison Disponible',
    'Récupération Locale',
    'Les deux',
    'Non précisé'
  ];

  final Color appColor = Color(0xFF0066CC); // Replace with your actual app color

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _postType = widget.initialPostType;
  }

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _image = File(image.path));
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _image = File(photo.path));
    }
  }

  Future<String?> _uploadImage(File imageFile, String token) async {
    final uri = Uri.parse('https://artisant.onrender.com/v1/Orders/post_orders');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['url'];
      } else {
        print('Upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Upload exception: $e');
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une méthode de paiement')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token non disponible. Veuillez vous reconnecter.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    String? uploadedImageUrl;
    if (_image != null) {
      uploadedImageUrl = await _uploadImage(_image!, token);
      if (uploadedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec du téléversement de l\'image.')),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    final postUrl = Uri.parse('https://artisant.onrender.com/v1/posts');

    final mediaList = uploadedImageUrl != null
        ? [
            {
              "url": uploadedImageUrl,
              "type": "image",
              "public_id": "uploaded-${DateTime.now().millisecondsSinceEpoch}"
            }
          ]
        : [];

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
        postUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Navigator.pop(context, responseData);
      } else {
        print('Post failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de publication.')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la publication.')),
      );
    }

    setState(() => _isLoading = false);
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
    // You can implement actual navigation here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text('Créer Une publication'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLabel('Titre'),
                    buildTextField(
                      hint: 'Entrez le titre de votre publication',
                      onChanged: (val) => _title = val,
                    ),
                    SizedBox(height: 20),

                    buildLabel('Type de Publication'),
                    DropdownButtonFormField<String>(
                      value: _postType,
                      items: ['Vente', 'Commande'].map((value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (value) => setState(() => _postType = value!),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),

                    buildLabel('Prix'),
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            hint: 'Montant',
                            keyboardType: TextInputType.number,
                            onChanged: (val) => _price = val,
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
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    buildLabel('Méthode de paiement'),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      hint: Text('Choisissez une méthode'),
                      items: _paymentMethods.map((value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedPaymentMethod = value),
                      validator: (value) => value == null ? 'Sélectionnez une méthode' : null,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),

                    buildLabel('Options de livraison'),
                    DropdownButtonFormField<String>(
                      value: _selectedDeliveryOption,
                      hint: Text('Choisissez une option'),
                      items: _deliveryOptions.map((value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedDeliveryOption = value),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),

                    buildLabel('Image'),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.photo_library),
                            label: Text('Galerie'),
                            onPressed: _getImage,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.camera_alt),
                            label: Text('Caméra'),
                            onPressed: _takePhoto,
                          ),
                        ),
                      ],
                    ),
                    if (_image != null)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.file(_image!, height: 150, width: double.infinity, fit: BoxFit.cover),
                      ),
                    SizedBox(height: 20),

                    buildLabel('Description'),
                    buildTextField(
                      hint: 'Décrivez votre publication...',
                      maxLines: 4,
                      onChanged: (val) => _description = val,
                    ),
                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitPost,
                        child: Text('Publier', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: appColor,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Créer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget buildLabel(String text) => Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));

  Widget buildTextField({
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder()),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
      onChanged: onChanged,
    );
  }
}
