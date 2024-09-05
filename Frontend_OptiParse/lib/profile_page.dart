import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP request
import 'package:optiparse/auth/services/auth_service.dart';
import 'package:optiparse/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userDetails; // To store fetched user details
  bool isLoading = true; // To show a loading spinner
  final _baseUrl = MyApp.baseUrl;
  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    // Get token from AuthService
    String? token = await _authService.getToken();

    if (token == null) {
      print('Token not found');
      return;
    }

    // Define the headers and endpoint
    final headers = {
      'Authorization': 'Bearer $token',
      'accept': 'application/json',
    };
    final url = Uri.parse('$_baseUrl/user');

    // Send the GET request
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Parse and store user details
      setState(() {
        userDetails = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to fetch user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : userDetails == null
              ? Center(child: Text('User details not found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: theme.primaryContainer,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  theme.primary, // Avatar background
                              child: Text(
                                userDetails!['username'][0]
                                    .toUpperCase(), // First letter of username
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileDetailField(
                              title: 'Username',
                              detail: userDetails!['username'],
                              icon: Icons.person,
                            ),
                            Divider(),
                            ProfileDetailField(
                              title: 'Email',
                              detail: userDetails!['email'],
                              icon: Icons.email,
                            ),
                            Divider(),
                            ProfileDetailField(
                              title: 'Account Number',
                              detail: userDetails!['account_number'],
                              icon: Icons.account_balance,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class ProfileDetailField extends StatelessWidget {
  const ProfileDetailField({
    super.key,
    required this.title,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.onSurface.withOpacity(0.5),
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
