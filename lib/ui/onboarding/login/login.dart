// ignore_for_file: non_constant_identifier_names, file_names, use_full_hex_values_for_flutter_colors, prefer_const_constructors, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  int selectedUserType = 0;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Sizes.height * 0.03),
                child: Image.asset(
                  Images.logomain,
                  height: Sizes.height * .15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(2, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {});
                      selectedUserType = index;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: !Responsive.isMobile(context)
                          ? Sizes.width * .10
                          : Sizes.width * .25,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedUserType == index
                                ? AppColor.colPrimary
                                : AppColor.colWhite,
                          ),
                        ),
                      ),
                      child: Text(index == 0 ? "Admin" : 'Staff',
                          style: rubikTextStyle(
                            20,
                            FontWeight.w500,
                            selectedUserType == index
                                ? AppColor.colBlack
                                : AppColor.colBlack.withOpacity(.3),
                          )),
                    ),
                  );
                }),
              ),
              SizedBox(height: Sizes.height * 0.06),
              textformfiles(
                emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an email";
                  } else if (!emailPattern
                      .hasMatch(emailController.text.toString())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                labelText: "Email",
              ),
              selectedUserType == 1
                  ? SizedBox(height: Sizes.height * 0.02)
                  : Container(),
              selectedUserType == 1
                  ? textformfiles(
                      usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter username";
                        }
                        return null;
                      },
                      labelText: "Username",
                    )
                  : Container(),
              SizedBox(height: Sizes.height * 0.02),
              textformfiles(
                passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
                obscureText: _isObscure,
                labelText: "Password",
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
              ),
              if (selectedUserType == 0)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ));
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Forgot Password",
                        style: rubikTextStyle(
                                13, FontWeight.w400, AppColor.colPrimary)
                            .copyWith(height: 2),
                      )),
                )
              else
                Container(),
              SizedBox(
                height: Sizes.height * 0.04,
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    loginPostApi();
                  }
                },
                child: button('Login', AppColor.colPrimary),
              ),
              SizedBox(height: Sizes.height * 0.02),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                },
                child: Text(
                  "Don't have an account? SignUp",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future loginPostApi() async {
    var response = await ApiService.postData("LoginAW/AWLOGINValid", {
      "MailId": emailController.text.toString(),
      "Password": passwordController.text.toString(),
      "UserType": selectedUserType == 0 ? "Admin" : "Staff",
      "UserName": usernameController.text.toString()
    });

    if (response["result"] == true) {
      Preference.setBool(PrefKeys.userstatus, response['result']);
      Preference.setString(PrefKeys.email, response['mailId']);
      Preference.setString(PrefKeys.financialYear,
          "${DateTime.now().month > 3 ? DateTime.now().year : DateTime.now().year - 1}");
      Preference.setString(PrefKeys.phoneNumber, response['mob']);
      Preference.setString(PrefKeys.locationId, response['locationId']);
      Preference.setString(PrefKeys.userType, response['userType']);
      Preference.setString(PrefKeys.staffId, response['staffId'] ?? "0");
      pushNdRemove(MultiProvider(
        providers: [
          ChangeNotifierProvider<Classvaluechange>(
              create: (_) => Classvaluechange()),
          ChangeNotifierProvider(create: (context) => MenuControlle())
        ],
        child: const FullScreen(),
      ));

      showCustomSnackbarSuccess(context, response['message']);
      // pushNdRemove(Login());
    } else {
      showCustomSnackbar(context, response['message']);
    }
  }
}
