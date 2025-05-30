// ignore_for_file: non_constant_identifier_names, file_names, use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable, use_build_context_synchronously
import 'package:autowheel_workshop/utils/components/library.dart';

class BusinessDetails extends StatefulWidget {
  BusinessDetails(
      {required this.outlet,
      required this.vehicleList,
      required this.phoneNo,
      required this.vehicleType,
      super.key});
  String outlet;
  String phoneNo;
  String vehicleType;
  List vehicleList;
  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;
  bool isload = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: OnboardingScreen(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppbarClass(title: 'Business Details'),
              SizedBox(height: Sizes.height * .04),
              textformfiles(
                nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Company Name";
                  }
                  return null;
                },
                labelText: "Company Name",
              ),
              SizedBox(height: Sizes.height * 0.02),
              textformfiles(
                ownerController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter owner name";
                  }
                  return null;
                },
                labelText: "Owner Name",
              ),
              SizedBox(height: Sizes.height * 0.02),
              textformfiles(
                businessController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter business type";
                  }
                  return null;
                },
                labelText: "Business Type",
              ),
              SizedBox(height: Sizes.height * 0.02),
              textformfiles(
                addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
                labelText: "Address",
              ),
              SizedBox(height: Sizes.height * 0.02),
              textformfiles(emailController,
                  keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter an email";
                } else if (!emailPattern
                    .hasMatch(emailController.text.toString())) {
                  return 'Enter a valid email address';
                }
                return null;
              }, labelText: "Email id"),
              SizedBox(height: Sizes.height * 0.02),
              textformfiles(
                passwordController,
                validator: (value) {
                  if (value!.isEmpty && value.length < 6) {
                    return "Please enter minimum 6 digit";
                  }
                  return null;
                },
                labelText: "Create Password",
                obscureText: _isObscure,
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
              ),
              SizedBox(
                height: Sizes.height * 0.04,
              ),
              isload == true
                  ? CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          isload = true;
                          busenissPostApi().then((value) => setState(() {
                                isload = false;
                              }));
                        }
                      },
                      child: button('Submit', AppColor.colPrimary),
                    ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  Future busenissPostApi() async {
    var response = await ApiService.postData("LoginAW/AWSignUP", {
      "CompanyName": nameController.text.toString(),
      "OwnerName": ownerController.text.toString(),
      "BusinessType": businessController.text.toString(),
      "Address1": addressController.text.toString(),
      "MOB": widget.phoneNo,
      "MailId": emailController.text.toString(),
      "UserValid": "1",
      "Password": passwordController.text.toString(),
      "VehicleType": widget.vehicleType,
      "outlet": widget.outlet,
      "Vehicle": widget.vehicleList
    });

    if (response["result"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      pushNdRemove(Login());
    } else {
      showCustomSnackbar(context, response['message']);
    }
  }
}
