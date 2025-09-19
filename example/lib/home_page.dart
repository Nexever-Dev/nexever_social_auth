

import 'package:flutter/material.dart';
import 'package:nexever_social_auth/nexever_social_auth.dart';
import 'package:nexever_social_auth/social_login_functions/functions/apple_login.dart';
import 'package:nexever_social_auth/social_login_functions/functions/facebook_login.dart';
import 'package:nexever_social_auth/social_login_functions/functions/google_login.dart';
import 'package:nexever_social_auth/social_login_functions/state/login_states.dart';

class AuthController implements LoginState {
  final Function(UserCredential, String)? onSuccess;
  final Function(String)? onError;

  AuthController({this.onSuccess, this.onError});

  @override
  void error(error) {
    onError?.call(error.toString());
  }

  @override
  void success(UserCredential creds, String loginType) {
    onSuccess?.call(creds, loginType);
  }

  googleLoginn() async {
    LoginManager(loginMethod: GoogleLogin(), loginState: this).login();
  }

  faceBookLoginn() {
    LoginManager(loginMethod: FaceBookLogin(), loginState: this).login();
  }

  appleLoginn() {
    LoginManager(loginMethod: AppleLogin(), loginState: this).login();
  }
}

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  late AuthController authController;
  UserCredential? userCredentials;
  String? loginType;
  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authController = AuthController(
      onSuccess: (creds, type) {
        setState(() {
          userCredentials = creds;
          loginType = type;
          errorMessage = null;
          isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          errorMessage = error;
          userCredentials = null;
          loginType = null;
          isLoading = false;
        });
      },
    );
  }

  void _handleLogin(VoidCallback loginMethod) {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    loginMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Social Login Screen"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Login Buttons
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: isLoading ? null : () => _handleLogin(authController.googleLoginn),
              child: isLoading ? CircularProgressIndicator() : Text('Google Login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : () => _handleLogin(authController.faceBookLoginn),
              child: Text('Facebook Login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : () => _handleLogin(authController.appleLoginn),
              child: Text('Apple Login'),
            ),

            SizedBox(height: 30),

            // Error Display
            if (errorMessage != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Error:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ],
                ),
              ),

            // User Credentials Display
            if (userCredentials != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login Successful with $loginType!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),

                    // User Profile Card
                    if (userCredentials!.user != null)
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Picture and Name
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: userCredentials!.user!.photoURL != null
                                        ? NetworkImage(userCredentials!.user!.photoURL!)
                                        : null,
                                    child: userCredentials!.user!.photoURL == null
                                        ? Icon(Icons.person, size: 30)
                                        : null,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userCredentials!.user!.displayName ?? "No Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          userCredentials!.user!.email ?? "No Email",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                              Divider(),
                              SizedBox(height: 10),

                              // Detailed Information
                              Text(
                                "User Details:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),

                              _buildInfoRow("User ID:", userCredentials!.user!.uid),
                              _buildInfoRow("Email:", userCredentials!.user!.email ?? "Not provided"),
                              _buildInfoRow("Display Name:", userCredentials!.user!.displayName ?? "Not provided"),
                              _buildInfoRow("Phone Number:", userCredentials!.user!.phoneNumber ?? "Not provided"),
                              _buildInfoRow("Email Verified:", userCredentials!.user!.emailVerified.toString()),
                              _buildInfoRow("Creation Time:", userCredentials!.user!.metadata.creationTime?.toString() ?? "Unknown"),
                              _buildInfoRow("Last Sign In:", userCredentials!.user!.metadata.lastSignInTime?.toString() ?? "Unknown"),

                              if (userCredentials!.user!.providerData.isNotEmpty) ...[
                                SizedBox(height: 10),
                                Text(
                                  "Provider Information:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                ...userCredentials!.user!.providerData.map((provider) =>
                                    Padding(
                                      padding: EdgeInsets.only(left: 16, top: 4),
                                      child: Text("• ${provider.providerId}"),
                                    ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 16),

                    // Logout Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            userCredentials = null;
                            loginType = null;
                            errorMessage = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Clear Login Data'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}