import 'package:flutter/material.dart';
import 'package:optiparse/auth/services/auth_service.dart';
import 'package:optiparse/nav_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_appbar.dart';
import 'background_page.dart';
import '../widgets/custom_snackbar.dart'; // Import the custom SnackBar

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false; // Loading state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _loginBtn() {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true; // Show loading indicator
                });

                final username = _emailController.text;
                final password = _passwordController.text;

                final success = await _authService.login(username, password);

                setState(() {
                  _isLoading = false; // Hide loading indicator
                });

                if (success) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainPage(selectedIndex: 0,),
                    ),
                  );
                } else {
                  CustomSnackBar(message: 'Login failed').show(context);
                }
              },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(100, 60)),
          backgroundColor:
              MaterialStateProperty.all<Color>(theme.secondaryContainer),
        ),
        child: _isLoading
            ? CircularProgressIndicator(
                color: theme.primary,
              )
            : Text(
                'LOGIN',
                style: TextStyle(fontSize: 18, color: theme.primary),
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(color: theme.surface),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sign into your account',
                    style: TextStyle(fontSize: 14, color: theme.onSurface),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    icon: Icons.person,
                    label: "Registered Username",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    icon: Icons.lock,
                    label: "Password",
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  _loginBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
