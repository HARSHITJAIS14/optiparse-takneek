import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:optiparse/auth/widgets/custom_text_field.dart';
import 'package:optiparse/auth/services/auth_service.dart'; // Import AuthService
import 'package:optiparse/nav_bar.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_snackbar.dart';
import 'package:optiparse/main.dart';

class AddDetailsPage extends StatefulWidget {
  @override
  _AddDetailsPageState createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final AuthService _authService = AuthService(); // Instance of AuthService
  bool _isLoading = false; // For the circular progress indicator
  bool _isSubmitted = false; // To track if submission is complete

  Future<void> _submitDetails() async {
    setState(() {
      _isLoading = true;
    });

    final String accountNumber = _accountNumberController.text;
    final String email = _emailController.text;
    final _baseUrl = MyApp.baseUrl;

    // Fetch the token using AuthService
    final String? token = await _authService.getToken();

    final String apiUrl =
        '$_baseUrl/update_details?account_number=$accountNumber&email=$email';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token', // Add the fetched token
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSubmitted = true;
        });

        // Show success message while showing the Lottie animation
        await Future.delayed(Duration(seconds: 2));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage(selectedIndex: 0)),
        );
      } else {
        // Handle error response
        CustomSnackBar(message: 'Failed to update details').show(context);
      }
    } catch (e) {
      CustomSnackBar(message: 'An error occurred').show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Widget _submitButton() {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitDetails,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(100, 60)),
          backgroundColor: MaterialStateProperty.all(theme.secondaryContainer),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: theme.primary)
            : Text(
                'Save Details',
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
        onPressed: () => null,
      ),
      body: _isSubmitted
          ? Center(
              // Show Lottie animation on successful submission with a message
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/updated.json',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Details updated successfully!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(color: theme.surface),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Enter Your Details',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: theme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Provide the necessary details to continue',
                          style:
                              TextStyle(fontSize: 14, color: theme.onSurface),
                        ),
                        const SizedBox(height: 25),
                        CustomTextField(
                          icon: Icons.email,
                          label: "Email",
                          controller: _emailController,
                        ),
                        const SizedBox(height: 25),
                        CustomTextField(
                          icon: Icons.account_circle,
                          label: "Account Number",
                          controller: _accountNumberController,
                        ),
                        const SizedBox(height: 25),
                        _submitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
