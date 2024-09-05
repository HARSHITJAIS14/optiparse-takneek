// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:optiparse/add_Image/add_image_options.dart';
import 'package:optiparse/auth/services/auth_service.dart';
import 'package:optiparse/transactions/transactions.dart';
import 'package:optiparse/profile_page.dart';

class MainPage extends StatefulWidget {
  int selectedIndex;

  MainPage({required this.selectedIndex});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthService authService = AuthService();

  // List of pages for all users (no login distinction)
  static final List<Widget> _widgetOptions = <Widget>[
    TransactionsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  // Method to show add post options
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return AddImageOptions(); // Show the PreAddPostSheet widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Always show FloatingActionButton
      floatingActionButton: FloatingActionButton(
        heroTag: "Unique",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(500),
        ),
        onPressed: () => _showOptions(context),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height * 0.08,
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: widget.selectedIndex == 0
                    ? Icon(
                        Icons.home,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      )
                    : Icon(
                        Icons.home_outlined,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                onPressed: () => _onItemTapped(0),
              ),
            ),
            IconButton(
              icon: widget.selectedIndex == 1
                  ? Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    )
                  : Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              onPressed: () => _onItemTapped(1),
            ),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(111, 77, 80, 80), // Very Dark Gray
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        // Use the widget list without login distinction
        child: _widgetOptions.elementAt(widget.selectedIndex),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
