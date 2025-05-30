// import 'package:autowheel_workshop/utils/components/library.dart';

// class AddBranch extends StatefulWidget {
//   const AddBranch({super.key});

//   @override
//   State<AddBranch> createState() => _AddBranchState();
// }

// class _AddBranchState extends State<AddBranch> {
//   TextEditingController gstNumberController = TextEditingController();
//   TextEditingController businesNameController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController mobileNumberController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController pinCodeController = TextEditingController();
//   TextEditingController dealerCodeController = TextEditingController();
//   TextEditingController jurdictionController = TextEditingController();

// //Location
//   String countryValue = "";
//   String stateValue = "";
//   String cityValue = "";

//   //gst Applicable
//   bool isSwitched = false;

//   void _toggleSwitch(bool value) {
//     setState(() {
//       isSwitched = value;
//     });
//   }

//   String getimagepath = '';
//   File? _image;
//   @override
//   Widget build(BuildContext context) {
//     Uint8List bytes = base64Decode(getimagepath);
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 Container(
//                   width: 135,
//                   height: 135,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: AppColor.colPrimary.withOpacity(.1),
//                     image: _image != null
//                         ? DecorationImage(
//                             image: FileImage(_image!), fit: BoxFit.cover)
//                         : getimagepath.isNotEmpty
//                             ? DecorationImage(
//                                 image: MemoryImage(
//                                   bytes,
//                                   // You can specify other parameters such as width, height, fit, etc.
//                                 ),
//                                 fit: BoxFit.cover)
//                             : null,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     // getImage();
//                   },
//                   child: CircleAvatar(
//                     maxRadius: 16,
//                     backgroundColor: AppColor.colPrimary,
//                     child: Icon(Icons.edit, size: 20, color: AppColor.colWhite),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(height: Sizes.height * 0.04),
//             addMasterOutside(context: context, children: [
//               textformfiles(
//                 gstNumberController,
//                 labelText: 'GST Number',
//                 readOnly: !isSwitched,
//                 prefixIcon: const Icon(Icons.gesture),
//                 suffixIcon: Switch(
//                   value: isSwitched,
//                   onChanged: _toggleSwitch,
//                   activeTrackColor: Colors.lightGreenAccent,
//                   activeColor: Colors.green,
//                 ),
//               ),
//               textformfiles(businesNameController,
//                   labelText: 'Business Name',
//                   prefixIcon: const Icon(Icons.business)),
//               textformfiles(descriptionController,
//                   labelText: 'Description',
//                   prefixIcon: const Icon(Icons.description)),
//               textformfiles(emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   labelText: 'Email',
//                   prefixIcon: const Icon(Icons.mail)),
//               textformfiles(mobileNumberController,
//                   keyboardType: TextInputType.phone,
//                   labelText: 'Mobile No.',
//                   prefixIcon: const Icon(Icons.phone)),
//               textformfiles(addressController, labelText: 'Address'),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                       child: textformfiles(pinCodeController,
//                           keyboardType: TextInputType.number,
//                           labelText: 'Pin Code')),
//                   const SizedBox(width: 10),
//                   Expanded(
//                       child: textformfiles(dealerCodeController,
//                           keyboardType: TextInputType.number,
//                           labelText: 'Dealer Code')),
//                 ],
//               ),
//               textformfiles(jurdictionController, labelText: 'Jurdiction'),
//               CSCPicker(
//                 showStates: true,
//                 showCities: false,
//                 defaultCountry: CscCountry.India,
//                 dropdownDecoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                     color: AppColor.colWhite,
//                     border: Border.all(width: 1, color: AppColor.colBlack)),
//                 disabledDropdownDecoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                     color: AppColor.colWhite,
//                     border: Border.all(color: AppColor.colBlack, width: 1)),
//                 countryDropdownLabel: "Select Country",
//                 stateDropdownLabel: "Select State",
//                 cityDropdownLabel: "Select City",
//                 selectedItemStyle:
//                     rubikTextStyle(16, FontWeight.w500, AppColor.colBlack),
//                 dropdownHeadingStyle:
//                     rubikTextStyle(18, FontWeight.w500, AppColor.colBlack),
//                 dropdownItemStyle: TextStyle(
//                   color: AppColor.colBlack,
//                   fontSize: 14,
//                 ),
//                 dropdownDialogRadius: 10.0,
//                 searchBarRadius: 10.0,
//                 onCountryChanged: (value) {
//                   setState(() {
//                     countryValue =
//                         value; // Assign empty string if value is null
//                   });
//                 },

//                 ///triggers once state selected in dropdown
//                 onStateChanged: (value) {
//                   setState(() {
//                     stateValue =
//                         value ?? ""; // Assign empty string if value is null
//                   });
//                 },

//                 ///triggers once city selected in dropdown
//                 onCityChanged: (value) {
//                   setState(() {
//                     cityValue =
//                         value ?? ""; // Assign empty string if value is null
//                   });
//                 },
//               ),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   button(
//                     "Save",
//                     AppColor.colPrimary,
//                     onTap: () async {
//                       // String base64Image =
//                       //     "${_image != null ? convertImageToBase64(_image!) : getimagepath}";
//                       // postProfileApi(base64Image);
//                     },
//                   )
//                 ],
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }
