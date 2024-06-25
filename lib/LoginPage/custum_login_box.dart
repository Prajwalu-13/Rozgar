import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final String text;

  const LoginPage({super.key, required this.text});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isGoogleSigningIn = false;

  void _login() {
    String userId = _userIdController.text;
    String password = _passwordController.text;
    // Implement your login logic here
    print("User ID: $userId, Password: $password");
  }

  void _loginWithGoogle() async {
    setState(() {
      _isGoogleSigningIn = true;
    });

    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Perform your login logic with Google user
        print("Google user: ${googleUser.displayName}");
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    } finally {
      setState(() {
        _isGoogleSigningIn = false;
      });
    }
  }

  void _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // You can get AccessToken and use it to get profile data
        final AccessToken accessToken = result.accessToken!;
        // Example: print the user ID
        //print("Facebook user: ${accessToken.userId}");
      } else if (result.status == LoginStatus.cancelled) {
        print("Facebook login cancelled by the user.");
      } else if (result.status == LoginStatus.failed) {
        print("Facebook login failed: ${result.message}");
      }
    } catch (e) {
      print("Error signing in with Facebook: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0), // Adjust the blur intensity as needed
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/loginback.jpeg'), // Change this to your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFf9f1eb),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26, // Shadow color
                    offset: Offset(0, 9), // Vertical offset
                    blurRadius: 5, // Blur radius
                    spreadRadius: 2, // Spread radius
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.045,
                  ),
                  TextField(
                    controller: _userIdController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_rounded),
                      labelText: 'User ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFa78377), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      labelText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFa78377), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.045,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(widget.text),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('OR'),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust width as needed
                    child: Row(
                      children: [
                        Expanded(
                          child: _isGoogleSigningIn
                              ? CircularProgressIndicator()
                              : ElevatedButton.icon(
                                  onPressed: _loginWithGoogle,
                                  icon: Image.asset(
                                    'assets/google.png', // Add your Google logo asset path here
                                    height: 25,
                                    width: 24,
                                  ),
                                  label: Text('${widget.text} with Google'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    minimumSize: Size(double.infinity, 50),
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loginWithFacebook,
                            icon: Image.asset(
                              'assets/facebook.png', // Add your Facebook logo asset path here
                              height: 25,
                              width: 24,
                            ),
                            label: Text('${widget.text} with Facebook'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
