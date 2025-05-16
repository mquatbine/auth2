import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_oauth2_login/helpers/sliderightroute.dart';
import 'package:flutter_oauth2_login/screens/login.dart';
import 'package:flutter_oauth2_login/services/auth.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String _title = 'Register';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const _RegisterForm(),
      builder: EasyLoading.init(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final AuthService _auth = AuthService();
  final TapGestureRecognizer _loginTap = TapGestureRecognizer();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _loginTap.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      errorStyle: const TextStyle(color: Color.fromARGB(255, 26, 255, 1)),
      filled: true,
      fillColor: const Color.fromARGB(255, 0, 0, 0),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Color.fromARGB(255, 128, 255, 0), width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Color.fromARGB(255, 235, 235, 235), width: 1),
      ),
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.w300, color: Color.fromARGB(255, 128, 255, 0)),
      hintStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.w300, color: Color.fromARGB(255, 128, 255, 0)),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(icon, color: const Color.fromARGB(255, 128, 255, 0), size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFC8E36),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Text(
                  'Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),

              // Full Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: _decoration(
                    label: 'Full Name',
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),

              // Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration(
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                  ),
                  validator: (v) => v != null && EmailValidator.validate(v) ? null : 'Invalid email',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),

              // Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: _decoration(
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                  ),
                  validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),

              // Register Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add, color: Colors.black),
                    label: const Text('REGISTER',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 200, 0)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Color.fromARGB(255, 128, 255, 0), width: 1),
                      )),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show();
                        final res = await _auth.register(
                            _emailCtrl.text, _passwordCtrl.text, _nameCtrl.text);
                        EasyLoading.dismiss();
                        if (res != null && res.statusCode >= 200 && res.statusCode < 300) {
                          Navigator.pushReplacement(
                            context,
                            SlideRightRoute(page: const LoginScreen(errMsg: 'Registration successful!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration failed.')));
                        }
                      }
                    },
                  ),
                ),
              ),

              // Back to Login
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Login here',
                        recognizer: _loginTap..onTap = () {
                          Navigator.push(
                            context,
                            SlideRightRoute(page: const LoginScreen(errMsg: '')),
                          );
                        },
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 128, 255, 0)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
