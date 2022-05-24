import 'package:brainsist/model/client.dart';
import 'package:brainsist/screens/home_page.dart';
import 'package:brainsist/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../loading_view.dart';
import '../theme_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // client variable
  var client = Client(id: '', userName: '', phoneNumber: '', email: '');

  // TextField Decoration
  inputDecoration(String label, String hint) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.person),
      labelText: label,
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  // Sign up Function
  createAccount() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        client.userName = nameController.text;
        client.phoneNumber = phoneController.text;
        client.email = emailController.text;
      });
      try {
        // passign email,password to service class through provider statemanagement
        Provider.of<UserProvider>(context, listen: false)
            .signUp(client, passwordController.text, context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.hashCode.toString()),
          backgroundColor: Colors.orange,
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign Up'),
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
                            // FullName TextFeild

                            TextFormField(
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please enter Full Name";
                                  }
                                  return null;
                                },
                                decoration:
                                    inputDecoration('Full Name', 'Full Name')),
                            const SizedBox(height: 20.0),

                            // Mobile Number TextFeild

                            TextFormField(
                              controller: phoneController,
                              decoration:
                                  inputDecoration('Mobile Number', 'Phone No.'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter 10 digit Mobile Number';
                                }
                                if ((value.isEmpty) &&
                                    !RegExp(r"^(\d+)*$").hasMatch(value)) {
                                  return "Enter a valid phone number";
                                }
                                if (value.length < 10) {
                                  return 'Mobile Number must be 10 digit';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),

                            // Email TextFeild

                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              decoration: inputDecoration(
                                  'Email', 'Enter your Email address'),
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

                            // Sign Up Button

                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                onPressed: createAccount,
                                child: Text(
                                  'Create Account'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )),
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
