import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/role_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end/core/routes/app_path.dart';


class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  String? selectedRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to MindAlly",
              style: TextStyle(
                fontFamily: 'Poppins',
                // fontSize: 20,
                color: Color(0xffB57EDC),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoleWidget(
                onPressed: () {
                  setState(() {
                    selectedRole = 'student';
                  });
                },
                color: selectedRole == 'student'
                    ? Color(0xffDCD0FF)
                    : Colors.white,
                image: Image.asset('asset/image/student.png'),
                text: 'Sign up as student'),
            SizedBox(
              height: 35,
            ),
            RoleWidget(
                onPressed: () {
                  setState(() {
                    selectedRole = 'professional';
                  });
                },
                color: selectedRole == 'professional'
                    ? Color(0xffDCD0FF)
                    : Colors.white,
                image: Image.asset('asset/image/therapist.jpg'),
                text: 'Sign up as professional'),
            SizedBox(
              height: 30,
            ),
            CustomButton(
              rad: 10,
              color: selectedRole == 'student' || selectedRole == 'professional'
                  ? Color(0xffB57EDC)
                  : Color(0xffDCD0FF),
              text: selectedRole == 'student'
                  ? 'Sign Up as Student'
                  : selectedRole == 'professional'
                      ? 'Sign Up as Professional'
                      : 'Sign Up',
              onPressed: () {
                if (selectedRole == 'student') {
                  context.go(AppPath.student);
                } else if (selectedRole == 'professional') {
                  context.go(AppPath.professional);
                } else {
                  null;
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => context.go(AppPath.login),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      color: Colors.black,
                      // fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xffB57EDC),
                          // fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ), 
            ),
          ],
        ),
      ),
    ));
  }
}
