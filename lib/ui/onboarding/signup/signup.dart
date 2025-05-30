// ignore_for_file: use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String otpvarify = '';
  final _formKey = GlobalKey<FormState>();

  //resendOtp
  int _start = 0; // Timer duration in seconds
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _start = 30; // Reset timer duration
      _timer?.cancel(); // Cancel any existing timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_start > 0) {
            _start--;
          } else {
            _timer?.cancel(); // End timer
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Sizes.height * 0.03),
                  child: Image.asset(
                    Images.logomain,
                    height: Sizes.height * .15,
                  ),
                ),
                textformfiles(
                  mobileController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Phone Number";
                    } else if (mobileController.text.length != 10) {
                      return "Please enter valid number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  labelText: "Phone Number",
                  maxLength: 10,
                  onChanged: (value) {
                    setState(() {
                      _start = 0;
                    });
                  },
                  suffixIcon: mobileController.text.length == 10
                      ? TextButton(
                          onPressed: _start > 0
                              ? null
                              : () async {
                                  _startResendTimer(); // Start the timer after sending OTP
                                  await verifyOtp(
                                      mobileController.text, context);
                                },
                          child: Text(_start > 0 ? '$_start sec' : 'Get OTP'),
                        )
                      : null,
                ),
                SizedBox(height: Sizes.height * 0.02),
                otpvarify == ""
                    ? Container()
                    : textformfiles(
                        keyboardType: TextInputType.number,
                        otpController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter OTP";
                          } else if (value != otpvarify) {
                            return 'Enter correct otp';
                          }
                          return null;
                        },
                        labelText: "OTP",
                      ),
                SizedBox(height: Sizes.height * 0.04),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate() && otpvarify != "") {
                      pushTo(BusinessType(
                        phoneNo: mobileController.text.trim(),
                      ));
                    }
                  },
                  child: button('Sign Up', AppColor.colPrimary),
                ),
                SizedBox(height: Sizes.height * 0.02),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? SignIn",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future verifyOtp(String otpMobileNo, BuildContext context) async {
    var response = await ApiService.fetchData(
        "Login/OtpVerification?otpmobileno=$otpMobileNo");
    if (response["result"] == true) {
      otpvarify = response["otp"];
      showCustomSnackbarSuccess(context, response["message"]);
    } else {
      showCustomSnackbar(context, response["message"]);
    }
  }
}
