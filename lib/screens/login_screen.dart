import 'package:flutter/material.dart';
import 'package:furiniture/services/person_firebase.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  late String email;
  late String password;
  bool isChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(String email, String password) async {
    // send data to firebase
    var response = await signInUser(password: password, email: email);

    if (response.user != null) {
      await saveUserData(email: response.user?.email, uid: response.user?.uid);
      GoRouter.of(context).go("/user/${response.user?.uid}");
    }
  }

  Future<void> checkForAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    String? userUid = prefs.getString('userUid');

    if (userEmail != null && userUid != null) {
      GoRouter.of(context).push("/user/$userUid");
    }
    setState(() {
      isChecked = true;
    });
  }

  @override
  void initState() {
    super.initState();
    checkForAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isChecked
          ? Form(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Welcome Seller!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Enter your email and password to continue.",
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
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
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
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                  _submitForm(email, password);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push("/register");
                              },
                              child: Text(
                                "Do not have an account? Register Here",
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
            )
          : Container(),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}


//onPressed: () => {context.go('/seller')},