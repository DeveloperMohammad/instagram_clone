import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;
  Uint8List? _image;
  bool isLoading = false;

  @override
  void initState() {
    _bioController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else {
      log(res);
      showSnackBar(res, context);
    }
    await AuthMethods().login(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      isLoading = false;
    });
  }

  navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(flex: 2, child: Container()),
                // an svg image
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: primaryColor,
                  height: 60,
                ),
                // const SizedBox(height: 64),
                const SizedBox(height: 22),
                // circular image
                Stack(
                  children: [
                    _image == null
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                'https://th.bing.com/th/id/R.86ddf59f73f9ad652fa8d5aa4b91803b?rik=FkmJyBJWUlailg&pid=ImgRaw&r=0'),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(_image!),
                          ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                // text field for user name
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter a unique username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 22),
                // text field for email
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 22),
                // text field for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 22),
                // text field for biography
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Write something about yourself',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 22),
                // Signup button
                isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : GestureDetector(
                        onTap: signupUser,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            color: blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                          child: const Text('Sign up'),
                        ),
                      ),
                const SizedBox(height: 40),
                // Flexible(flex: 2, child: Container()),
                // already have an account button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Already have an account?"),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
