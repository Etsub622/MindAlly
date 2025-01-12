import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/models/login_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _logIn(BuildContext context) {
    final oldUser = LoginModel(
        email: emailController.text, password: passwordController.text, id: '');

    context.read<AuthBloc>().add(LoginEvent(loginEntity: oldUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularIndicator();
        } else {
          return _build(context);
        }
      }, listener: (context, state) async {
        if (state is LoginSuccess) {
          const snack = SnackBar(content: Text('User logged in successfully'));
          ScaffoldMessenger.of(context).showSnackBar(snack);

          final sharedPreferences = await SharedPreferences.getInstance();
          final loginLocalDataSource =
              LoginLocalDataSourceImpl(sharedPreferences: sharedPreferences);
          final token = await loginLocalDataSource.getToken();

          Map<String, dynamic> payload = JwtDecoder.decode(token);
          String role = payload['role'];
        

          if (role == 'patient') {
            context.go(AppPath.authOnboarding);
          } else if (role == 'professional') {
            context.go(AppPath.onboard2);
          }
        } else if (state is AuthError) {
          final snack = errorsnackBar('Try again later');
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      }),
    );
  }

  Widget _build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 50),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/image/logo.webp',
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                CustomTextField(text: "email", controller: emailController),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "password",
                    sign: Icon(Icons.remove_red_eye),
                    controller: passwordController,
                    isPassword: true),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.go(AppPath.forgotPassword);
                    },
                    child: Text('Forgot password?',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  wdth: double.infinity,
                  rad: 10,
                  hgt: 50,
                  text: "Log In",
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      _logIn(context);
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      context.go(AppPath.role);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account yet? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'SignUp',
                            style: TextStyle(
                              color: Color(0xffB57EDC),
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Or continue with',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  rad: 10,
                  wdth: double.infinity,
                  hgt: 50,
                  text: 'Log in with Google',
                  onPressed: () {},
                  icon: Image.asset(
                    'asset/image/student.png',
                    height: 40,
                    width: 40,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
