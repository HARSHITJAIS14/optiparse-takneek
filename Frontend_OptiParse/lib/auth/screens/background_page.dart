import 'package:flutter/material.dart';
import 'package:optiparse/auth/services/auth_service.dart';
import 'login.dart'; // Import the LoginPage
import 'signup.dart'; // Import the SignupPage

class BackgroundPage extends StatelessWidget {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg', // Path to your background image
              fit: BoxFit.cover, // Adjust fit as needed
            ),
          ),

          // Blurred Background Layer
          Positioned.fill(
            child: Container(
              color: Colors.black
                  .withOpacity(0.3), // Adjust color and opacity if needed
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, top: 100),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan,',
                    style: TextStyle(
                      color: Color.fromARGB(
                          243, 203, 202, 202), // Same color as button text
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Upload,',
                    style: TextStyle(
                      color: Color.fromARGB(
                          243, 203, 202, 202), // Same color as button text
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View..!!',
                    style: TextStyle(
                      color: Color.fromARGB(
                          243, 203, 202, 202), //Same color as button text
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Sign In Button as TextButton
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Rounded corners
                      ),
                      color: theme.surface
                          .withOpacity(0.5), // Button background color
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color.fromARGB(
                                255, 255, 255, 255), // Text color
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between buttons
                  // Create Account Button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text(
                      'Create An Account',
                      style: TextStyle(
                        color: Color.fromARGB(255, 203, 202, 202), // Text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
