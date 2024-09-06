import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (res == "success") {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor, // Set to a dark color
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView( // To prevent overflow on smaller screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                // Instagram Logo
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor, // Use a light color for visibility
                  height: 64,
                ),
                const SizedBox(height: 64),
                // Email TextField
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  
                ),
                const SizedBox(height: 24),
                // Password TextField
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  isPass: true, 
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                // Login Button
                InkWell(
                  onTap: loginUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: primaryColor)
                      : Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                // Signup Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: const Text(
                        ' Sign up.',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
