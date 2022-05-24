import 'package:brainsist/screens/home_page.dart';
import 'package:brainsist/screens/signup_page.dart';
import 'package:brainsist/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../loading_view.dart';
import '../theme_helper.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isLoading = false;
  bool obscureText = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  

  loginWithGoogle() async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .handleSignIn(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.hashCode.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
    return;
  }

  // Sign In Function
  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // passign email,password to service class through provider statemanagement
        await Provider.of<UserProvider>(context, listen: false)
            .signIn(emailController.text, passwordController.text, context);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        throw Exception();
      }
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Log In'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'BRAINSIST',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            // Email TextFeild

                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                labelText: 'Email',
                                hintText: 'Enter your Email address',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your Email";
                                }
                                if ((val.isEmpty) &&
                                    RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),

                            // Password TextFeild

                            TextFormField(
                              obscureText: obscureText,
                              controller: passwordController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: obscureText == true
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                ),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                            ),
                            const SizedBox(height: 15.0),

                            // Sign In Button

                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                onPressed: signIn,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    'Log In'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                            // Create Account Button as highlight text

                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Text.rich(TextSpan(children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Create Account',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpPage()));
                                    },
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ])),
                            ),
                          ],
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton.icon(
                        style: ThemeHelper().buttonStyle(),
                        onPressed: loginWithGoogle,
                        icon: Icon(Icons.add),
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'SignIn with Google'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading Widget

          if (isLoading == true)
            Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: SizedBox(height: 100, child: LoadingView()))),
        ],
      ),
    );
  }
}
