import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_project/Screen/forgot_password_screen.dart';
import 'package:first_project/Screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:get/route_manager.dart';

import '../Services/firebase_auth.dart';
import '../Services/validator.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe= false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final focusEmail = FocusNode();
  final focuspassword = FocusNode();

  bool _isprocessing = false;
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusEmail.unfocus();
        focuspassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.deepPurple[100],
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: _initializeFirebase(),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0,top: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                       child: Image.asset("assets/image1.jpeg"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0,top: 12),
                      child: Text(
                          'Welcome to ToXSL',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            focusNode: focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: passwordController,
                            focusNode: focuspassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Password",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: TextButton(onPressed: (){Get.to(ForgotPasswordScreen());},
                                child: Text('forgot password?')),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Checkbox(value: _rememberMe,
                                    checkColor: Colors.white,
                                    activeColor: Colors.deepPurpleAccent,
                                    onChanged: (value){
                                  setState(() {
                                    _rememberMe= value!;
                                  });
                                    }),
                                Text('Remember me')
                              ],
                            ),
                          ),
                          SizedBox(height: 24.0),
                          _isprocessing
                              ? CircularProgressIndicator()
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    focusEmail.unfocus();
                                    focuspassword.unfocus();

                                    if (_formKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        _isprocessing = true;
                                      });

                                      User? user = await FirebaseAuthHelper
                                          .signInUsingEmailPassword(
                                        email: emailController.text,
                                        password:
                                        passwordController.text,
                                      );

                                      setState(() {
                                        _isprocessing = false;
                                      });

                                      if (user != null) {
                                        Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(user: user),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 20,),
                          Text('-OR-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          SizedBox(height: 20,),
                          Text('Sign-in with',style: TextStyle(fontSize: 18),),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(height: 50,width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  image:AssetImage('assets/gmail_logo.png'),)
                              ),),
                              Container(height: 50,width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image:AssetImage('assets/google_logo.png'),)
                                ),),
                            ],),
                          SizedBox(height: 40,),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Footer(
                              child: GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));},
                                child: RichText(text: TextSpan(text: 'Don\'t have an account ?',style: TextStyle(color: Colors.black,fontSize: 15),
                                    children: [
                                      TextSpan(text: 'Register here',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold))
                                    ]
                                ),
                                ),

                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
          ),
    ),
     ),
      );
  }
}
