import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_viewer/views/auth/login_view.dart';
import '../../models/user.dart';
import '../../view_models/user_view_model.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final double contentWidth = isSmallScreen ? screenSize.width * 0.9 : 500;
    final double verticalSpacing = screenSize.height * 0.02;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: contentWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: verticalSpacing * 4),
                Text(
                  'Ticket View',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: verticalSpacing / 2),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: verticalSpacing * 1.5),
                _buildTextField(nameController, 'Name'),
                SizedBox(height: verticalSpacing),
                _buildTextField(
                  emailController,
                  'Email',
                  errorText: emailError,
                  onChanged: (value) => setState(() => emailError = null),
                ),
                SizedBox(height: verticalSpacing),
                _buildPasswordField(
                  passwordController,
                  'Password',
                  _isPasswordVisible,
                      (value) => setState(() => passwordError = null),
                      () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  errorText: passwordError,
                ),
                SizedBox(height: verticalSpacing),
                _buildPasswordField(
                  confirmPasswordController,
                  'Confirm Password',
                  _isConfirmPasswordVisible,
                      (value) => setState(() => confirmPasswordError = null),
                      () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  errorText: confirmPasswordError,
                ),
                SizedBox(height: verticalSpacing * 2),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginView()),
                    );
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        String? errorText,
        void Function(String)? onChanged,
      }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      bool isVisible,
      void Function(String) onChanged,
      VoidCallback onIconPressed, {
        String? errorText,
      }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blueAccent,
          ),
          onPressed: onIconPressed,
        ),
      ),
      onChanged: onChanged,
    );
  }

  void _registerUser() {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    bool isValid = true;

    if (email.isEmpty) {
      setState(() {
        emailError = 'Email cannot be empty';
        isValid = false;
      });
    } else if (!isEmailValid(email)) {
      setState(() {
        emailError = 'Invalid email format';
        isValid = false;
      });
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Password cannot be empty';
        isValid = false;
      });
    } else if (password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
        isValid = false;
      });
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = 'Confirm Password cannot be empty';
        isValid = false;
      });
    } else if (confirmPassword != password) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
        isValid = false;
      });
    }

    if (isValid) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.addUser(
        User(
          id: DateTime.now().toString(),
          name: nameController.text,
          email: email,
          role: 'Customer',
        ),
      );
      Navigator.pop(context);
    }
  }
}
