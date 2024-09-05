import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:optiparse/nav_bar.dart';

class ImageUploadedPage extends StatefulWidget {
  final String responseMessage;

  const ImageUploadedPage({Key? key, required this.responseMessage})
      : super(key: key);

  @override
  _ImageUploadedPageState createState() => _ImageUploadedPageState();
}

class _ImageUploadedPageState extends State<ImageUploadedPage> {
  @override
  void initState() {
    super.initState();
    // Automatically navigate to TransactionsPage after 3 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(selectedIndex: 0),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Uploaded'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the response message
                Text(
                  "Image Uploaded!!! Navigating back to Transactions Page",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold), // Adjust font size as needed
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Lottie.asset(
                  'assets/done.json', // Your lottie animation file
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                // Optionally, display an animated sticker or icon here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
