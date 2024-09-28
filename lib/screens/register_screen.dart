import 'package:flutter/material.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  late String email;
  late String password;
  late String phoneNumber;
  late String name;
  late String address;
  late String role;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(String email, String password, String phoneNumber,
      String name, String address) {
    createUser(
        name: name,
        address: address,
        password: password,
        phone: phoneNumber,
        email: email);
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
                        "Register",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Register as a user by filling all the required fields",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
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
                        hintText: 'Enter your email',
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
                        // add email validation
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
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      onSaved: (newValue) {
                        password = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )),
                    ),
                    _gap(),
                    TextFormField(
                      onSaved: (newValue) {
                        name = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_rounded),
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
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    CheckboxListTile(
                      value: _rememberMe,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                      title: const Text('Remember me'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            _submitForm(
                                email, password, phoneNumber, name, address);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pop("/");
                        },
                        child: Text(
                          "Already have an account? Login Here",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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


//onPressed: () => {context.go('/seller')},