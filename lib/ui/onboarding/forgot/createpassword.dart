// ignore_for_file: non_constant_identifier_names, file_names, use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class CreatePassword extends StatefulWidget {
  CreatePassword({required this.email, super.key});
  String? email;
  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (Sizes.height * 1 > 400)
                Align(
                    alignment: Alignment.topCenter,
                    child: AppbarClass(title: 'Reset Password'))
              else
                SizedBox(height: 0),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (Sizes.height * 1 <= 400)
                      AppbarClass(title: 'Reset Password')
                    else
                      SizedBox(height: 0, width: 0),
                    if (Sizes.height * 1 < 400)
                      SizedBox(height: Sizes.height * .04)
                    else
                      Container(height: 0),
                    RichText(
                      text: TextSpan(
                        style: rubikTextStyle(
                            15, FontWeight.w400, AppColor.colBlack),
                        children: [
                          TextSpan(
                              text:
                                  'Your new password and id will be sent on your '),
                          TextSpan(
                            text: widget.email,
                            style: rubikTextStyle(
                                15, FontWeight.w400, AppColor.colPrimary),
                          ),
                          TextSpan(
                            text: ', after reseting the password.',
                            style: rubikTextStyle(
                                15, FontWeight.w400, AppColor.colBlack),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Sizes.height * 0.05),
                    textformfiles(
                      _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        } else if (value.length < 6) {
                          return "Please enter a minimum of 6 characters";
                        }
                        return null;
                      },
                      labelText: 'New Password',
                    ),
                    SizedBox(height: Sizes.height * 0.02),
                    textformfiles(
                      _confirmpasswordController,
                      validator: (value) {
                        if (_passwordController.text !=
                            _confirmpasswordController.text) {
                          return "Please enter same password";
                        }
                        return null;
                      },
                      labelText: "Confirm Password",
                    ),
                    SizedBox(
                      height: Sizes.height * 0.04,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          resetpassPostApi();
                        }
                      },
                      child: button('Save', AppColor.colPrimary),
                    ),
                    SizedBox(height: Sizes.height * 0.06)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetpassPostApi() async {
    var response = await ApiService.postData(
        "Login/ForgotPassword?MOBOrMail=${widget.email?.length == 10 && isStringAnInteger(widget.email.toString()) ? 'MOB' : "MailId"}",
        {
          "MOB":
              "${widget.email?.length == 10 && isStringAnInteger(widget.email.toString()) ? widget.email : ""}",
          "MailId":
              "${widget.email?.length == 10 && isStringAnInteger(widget.email.toString()) ? "" : widget.email}",
          "Password": _passwordController.text.toString()
        });

    if (response["result"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      pushNdRemove(Login());
    } else {
      showCustomSnackbar(context, response['message']);
    }
  }

  bool isStringAnInteger(String value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
