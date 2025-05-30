// ignore_for_file: non_constant_identifier_names, file_names, use_full_hex_values_for_flutter_colors, prefer_const_constructors, empty_catches, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String otpvarify = '';
  final _formKey = GlobalKey<FormState>();
  //resendOtp
  int _start = 0; // Timer duration in seconds
  Timer? _timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _start = 60; // Reset timer duration
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (Sizes.height * 1 > 400)
              Align(
                  alignment: Alignment.topCenter,
                  child: AppbarClass(title: 'Forgot Password'))
            else
              SizedBox(height: 0),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Sizes.height * 1 <= 400)
                    AppbarClass(title: 'Forgot Password')
                  else
                    SizedBox(height: 0, width: 0),
                  if (Sizes.height * 1 < 400)
                    SizedBox(height: Sizes.height * .04)
                  else
                    Container(height: 0),
                  textformfiles(
                    _phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter phone no. / email id";
                      }
                      return null;
                    },
                    labelText: "Phone Number / Email",
                    suffixIcon: TextButton(
                      onPressed: _start > 0
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  _startResendTimer(); // Start the timer after sending OTP
                                  // Call the function with the OTP mobile number
                                  await verifyOtp(
                                      _phoneController.text, context);
                                } catch (e) {}
                              }
                            },
                      child: Text(_start > 0 ? '$_start sec' : 'Get OTP'),
                    ),
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                  otpvarify == ""
                      ? Container()
                      : textformfiles(
                          keyboardType: TextInputType.number,
                          _otpController,
                          maxLength: 6,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter OTP";
                            } else if (_otpController.text != otpvarify) {
                              return "Please enter valid OTP";
                            }
                            return null;
                          },
                          labelText: "OTP",
                        ),
                  SizedBox(
                    height: Sizes.height * 0.04,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          _otpController.text.length == 6) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePassword(
                                    email: _phoneController.text,
                                  )),
                        );
                      }
                    },
                    child: button('Save', AppColor.colPrimary),
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future verifyOtp(String otpMobileNo, BuildContext context) async {
    var response = await ApiService.fetchData(
        otpMobileNo.length == 10 && isStringAnInteger(otpMobileNo.toString())
            ? "Login/OtpVerification?otpmobileno=$otpMobileNo"
            : "Login/EMAILOtpVerification?otpemailid=$otpMobileNo");

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
