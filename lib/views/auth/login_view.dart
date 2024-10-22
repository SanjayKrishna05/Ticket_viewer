import 'package:flutter/material.dart';
import 'package:ticket_viewer/views/auth/registration_view.dart';
import '../dashboard/dash_board_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? emailError;
  String? passwordError;

  // Hardcoded user data for validation
  final List<Map<String, String>> users = [
    {'email': 'admin@gmail.com', 'password': 'admin123'},
    {'email': 'admin@example.com', 'password': 'adminpass'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final double contentWidth = isSmallScreen ? screenSize.width * 0.9 : 500;
    final double verticalSpacing = screenSize.height * 0.02;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 32.0,
          ),
          child: Container(
            width: contentWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenSize.height * 0.08),
                Text(
                  'Ticket View',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 30 : 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing * 1.2),
                _buildTextFormField(
                  controller: emailController,
                  label: 'Email',
                  errorText: emailError,
                  onChanged: (_) => setState(() => emailError = null),
                ),
                _buildTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  errorText: passwordError,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () => setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    }),
                  ),
                  onChanged: (_) => setState(() => passwordError = null),
                ),
                SizedBox(height: verticalSpacing * 2),
                _buildLoginButton(context),
                SizedBox(height: verticalSpacing),
                _buildSignUpTextButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String email = emailController.text;
        String password = passwordController.text;

        if (email.isEmpty) {
          setState(() => emailError = 'Email cannot be empty');
          return;
        }
        if (password.isEmpty) {
          setState(() => passwordError = 'Password cannot be empty');
          return;
        }

        bool isValidUser = users.any(
              (user) => user['email'] == email && user['password'] == password,
        );

        if (isValidUser) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardView()),
          );
        } else {
          setState(() {
            emailError = 'Invalid email or password';
            passwordError = 'Invalid email or password';
          });
        }
      },
      child: const Text('Login'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  Widget _buildSignUpTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegistrationView()),
        );
      },
      child: const Text('Don\'t have an account? Sign up'),
    );
  }
}
