// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:autowheel_workshop/utils/components/library.dart';

class BusinessType extends StatefulWidget {
  BusinessType({super.key, required this.phoneNo});
  String phoneNo;
  @override
  _BusinessTypeState createState() => _BusinessTypeState();
}

class _BusinessTypeState extends State<BusinessType> {
  String singleoutlate = "Single Outlet";
  List<String> outlate = ['Single Outlet', 'Multi-Outlet'];
  String selectedVehicleType = 'Car';
  List selectedFeatures = [];
  TextEditingController outletController = TextEditingController();

  Map<String, List> vehicleFeatures = {
    'Car': [
      {"VehicleDetails": "Sedan"},
      {"VehicleDetails": "Hatchback"},
      {"VehicleDetails": "SUV"},
      {"VehicleDetails": "Convertible"},
      {"VehicleDetails": "Coupe"},
      {"VehicleDetails": "Wagon"},
      {"VehicleDetails": "Luxury Car"},
      {"VehicleDetails": "Hybrid Car"},
      {"VehicleDetails": "Sports Car"},
    ],
    'Heavy Vehicles': [
      {"VehicleDetails": "Truck"},
      {"VehicleDetails": "Bus"},
      {"VehicleDetails": "Crane"},
      {"VehicleDetails": "Loader"},
      {"VehicleDetails": "Excavator"},
      {"VehicleDetails": "Bulldozer"},
    ],
    'Bike': [
      {"VehicleDetails": "Cruiser bikes"},
      {"VehicleDetails": "Road bikes"},
      {"VehicleDetails": "Mountain bikes"},
      {"VehicleDetails": "Hybrid bikes"},
      {"VehicleDetails": "Commuter bikes"},
    ],
    'Tractor': [
      {"VehicleDetails": "Utility Tractors"},
      {"VehicleDetails": "Row Crop Tractors"},
      {"VehicleDetails": "Orchard Tractors"},
      {"VehicleDetails": "Garden Tractors"},
      {"VehicleDetails": "Subcompact Tractors"},
      {"VehicleDetails": "Specialty Tractors"},
    ],
    'Electric Vehicles': [
      {"VehicleDetails": "E-Bike"},
      {"VehicleDetails": "E-Scooter"},
      {"VehicleDetails": "E-Rickshaw"},
      {"VehicleDetails": "E-Loader"},
      {"VehicleDetails": "E-cycle"},
    ],
    'Machine': [
      {"VehicleDetails": "Electronics"},
      {"VehicleDetails": "Computer"},
      {"VehicleDetails": "Welding machines"},
      {"VehicleDetails": "Grass-cutting machines"},
      {"VehicleDetails": "Other"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    outletController.text = "2";
    return Scaffold(
      body: OnboardingScreen(
        child: SizedBox(
          height: Sizes.height * 0.76,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppbarClass(title: 'Business Details'),
                SizedBox(height: Sizes.height * .04),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Sizes.width * 0.02),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      icon: Icon(Icons.keyboard_arrow_down_outlined,
                          color: AppColor.colBlack),
                      isExpanded: true,
                      value: selectedVehicleType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVehicleType = newValue!;
                          selectedFeatures = [];
                        });
                      },
                      items: [
                        'Car',
                        'Heavy Vehicles',
                        'Bike',
                        'Tractor',
                        'Electric Vehicles',
                        'Machine'
                      ]
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack)),
                            ),
                          )
                          .toList(),
                    )),
                SizedBox(height: Sizes.height * 0.02),
                Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: vehicleFeatures[selectedVehicleType]!.map(
                    (featureMap) {
                      String feature = featureMap['VehicleDetails']!;
                      return ChoiceChip(
                        selectedColor: AppColor.colPrimary,
                        label: Text(
                          feature,
                          style: rubikTextStyle(
                              16, FontWeight.w400, AppColor.colBlack),
                        ),
                        selected: selectedFeatures.contains(featureMap),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedFeatures.insert(0, featureMap);
                            } else {
                              selectedFeatures.remove(featureMap);
                            }
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
                SizedBox(height: Sizes.height * .03),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: DropdownButtonFormField(
                          value: singleoutlate,
                          style: rubikTextStyle(
                              16, FontWeight.w500, AppColor.colBlack),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Sizes.width * 0.02),
                          ),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.keyboard_arrow_down_outlined,
                              color: AppColor.colBlack),
                          isExpanded: true,
                          items: outlate.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: rubikTextStyle(
                                    16, FontWeight.w500, AppColor.colBlack),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              singleoutlate = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    singleoutlate == "Single Outlet"
                        ? Container()
                        : const SizedBox(width: 20),
                    singleoutlate == "Single Outlet"
                        ? Container()
                        : Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: outletController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: rubikTextStyle(
                                  16, FontWeight.w400, AppColor.colBlack),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: AppColor.colBlack)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: AppColor.colBlack)),
                                labelText: "Outlets",
                                alignLabelWithHint: true,
                                labelStyle: rubikTextStyle(
                                    16, FontWeight.w500, AppColor.colBlack),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: AppColor.colBlack)),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: Sizes.height * 0.04),
                button(
                  "Save Details",
                  AppColor.colPrimary,
                  onTap: () {
                    selectedFeatures.isEmpty
                        ? showCustomSnackbar(
                            context, "Please select vehicles list")
                        : pushTo(BusinessDetails(
                            outlet: singleoutlate == "Single Outlet"
                                ? "1"
                                : outletController.text,
                            phoneNo: widget.phoneNo,
                            vehicleList: selectedFeatures,
                            vehicleType: selectedVehicleType,
                          ));
                  },
                ),
                SizedBox(height: Sizes.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
