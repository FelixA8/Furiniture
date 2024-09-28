import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furiniture/services/seller_firebase.dart';
import 'package:furiniture/widgets/upload_image_form.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SellerRegistrationNavigation extends StatefulWidget {
  final String uid;
  const SellerRegistrationNavigation({super.key, required this.uid});

  @override
  State<SellerRegistrationNavigation> createState() =>
      _SellerRegistrationNavigationState();
}

class _SellerRegistrationNavigationState
    extends State<SellerRegistrationNavigation> {
  late String email;
  late String storeName;
  late String address;
  late String phoneNumber;
  late String logoUrl;
  late String uid = widget.uid;
  File? _image;
  final picker = ImagePicker();
  bool isUploading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _submitForm(String address, String email, String phoneNumber,
      String storeName, String uid) async {
    // send data to firebase
    setState(() {
      isUploading = true;
    });
    var response = await createSeller(
        address: address,
        email: email,
        image: _image,
        phoneNumber: phoneNumber,
        storeName: storeName,
        uid: uid);
    if (response != "") {
      context.go("/seller/${response}");
    } else {}

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 100),
                    _gap(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Register as a Seller",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Fill your data to be a seller!",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      onSaved: (newValue) {
                        storeName = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value.length < 3) {
                          return 'Please enter a valid store name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Store Name',
                        hintText: 'Enter your store name',
                        prefixIcon: Icon(Icons.store),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      onSaved: (newValue) {
                        address = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value.length < 3) {
                          return 'Please enter a valid store location';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Store Location',
                        hintText: 'Enter your store location',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      onSaved: (newValue) {
                        email = newValue!;
                      },
                      validator: (value) {
                        // add email validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter store email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      onSaved: (newValue) {
                        phoneNumber = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        bool phoneValid =
                            RegExp(r"^\+?[\d\s\-\(\)]{7,15}$").hasMatch(value);
                        if (!phoneValid) {
                          return 'Please enter a valid phone number';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter store phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    UploadImageForm(
                      image: _image,
                      pickImage: pickImage,
                      showImage: false,
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: isUploading
                          ? Text('Submitting...')
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Register as Seller',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                  _submitForm(address, email, phoneNumber,
                                      storeName, uid);
                                }
                              },
                            ),
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

  Widget _gap() => const SizedBox(height: 16);
}
