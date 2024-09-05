import 'package:flutter/material.dart';
import 'package:optiparse/auth/screens/add_details.dart';
import 'package:optiparse/auth/screens/background_page.dart';
import 'package:optiparse/auth/services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_snackbar.dart'; // Import the custom SnackBar

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _username() {
    return CustomTextField(
      icon: Icons.person,
      label: "Username",
      controller: _usernameController,
    );
  }

  Widget _password() {
    return CustomTextField(
      icon: Icons.lock,
      label: "Password",
      obscureText: true,
      controller: _passwordController,
    );
  }

  Widget _confPassword() {
    return CustomTextField(
      icon: Icons.lock,
      label: "Confirm Password",
      obscureText: true,
      controller: _confirmPasswordController,
    );
  }

  Widget _regBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final username = _usernameController.text;
          final password = _passwordController.text;
          final confirmPassword = _confirmPasswordController.text;

          if (password != confirmPassword) {
            CustomSnackBar(message: 'Passwords do not match').show(context);
            return;
          }

          setState(() {
            _isLoading = true;
          });

          final success = await _authService.signup(username, password);

          setState(() {
            _isLoading = false;
          });

          if (success) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => AddDetailsPage(
                        
                      )),
            );
          } else {
            CustomSnackBar(message: 'Signup failed').show(context);
          }
        },
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(100, 60)),
          backgroundColor: WidgetStateProperty.all<Color>(
            Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
        child: _isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              )
            : const Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        backgroundImage: 'assets/bg.jpg',
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BackgroundPage(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
          decoration: BoxDecoration(
            color: theme.surface,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Create New Account',
                style: TextStyle(fontSize: 14, color: theme.onSurface),
              ),
              const SizedBox(height: 35),
              _username(),
              const SizedBox(height: 10.0),
              _password(),
              const SizedBox(height: 10.0),
              _confPassword(),
              const SizedBox(height: 10.0),
              _regBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
