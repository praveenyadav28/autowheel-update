// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, empty_catches, depend_on_referenced_packages, use_build_context_synchronously, must_be_immutable
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class AddStaffWidget extends StatefulWidget {
  AddStaffWidget(
      {required this.switchToSecondTab,
      super.key,
      required this.isFirst,
      this.id});
  bool isFirst;
  int? id;
  final VoidCallback switchToSecondTab;
  @override
  State<AddStaffWidget> createState() => _AddStaffWidgetState();
}

class _AddStaffWidgetState extends State<AddStaffWidget> {
  final TextEditingController _staffnamecontroller = TextEditingController();
  final TextEditingController _fathernamecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _pinCodecontroller = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  final TextEditingController _passwoedcontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //City
  List<Map<String, dynamic>> cityList = [];
  List<Map<String, dynamic>> districtList = [];
  int? cityId;
  Map<String, dynamic>? cityValue;
  String cityName = '';
  String stateName = 'Unknown';
  String districtName = 'Unknown';

  //Degination
  List<Map<String, dynamic>> deginationList = [];
  Map<String, dynamic>? selecteddeginationValue;
  String deginationName = '';
  int? deginationId;

  //Department
  List<Map<String, dynamic>> departmentList = [];
  Map<String, dynamic>? selecteddepartmentValue;
  String departmentName = '';
  int? departmentId;

//  Date
  TextEditingController joiningDatePickar = TextEditingController(
    text: DateFormat('M/d/yyyy').format(DateTime.now()),
  );
  TextEditingController leaveDatePickar = TextEditingController(
    text: DateFormat('M/d/yyyy').format(DateTime.now()),
  );

//Title
  List<Map<String, dynamic>> titleList = [
    {'id': 101, 'name': 'Mr.'},
    {'id': 102, 'name': 'Mrs.'},
    {'id': 103, 'name': 'Dr.'},
    {'id': 104, 'name': 'M/s'}
  ];
  int selectedtitleId = 101;

//Staff type
  String? _selectedType = 'subadmin';

  bool isload = false;
  bool _isDeactive = false;

  @override
  void initState() {
    fetchCity().then((value) => setState(() {}));

    fetchDistrict().then((value) => setState(() {}));
    deginationData().then((value) {
      widget.isFirst
          ? null
          : getstaffDetails().then((value) => setState(() {}));
    });
    departmentData();

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: AppColor.colPrimary.withOpacity(.1),
        height: Sizes.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
          child: Column(
            children: [
              addMasterOutside(
                context: context,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: dropdownTextfield(
                          context,
                          "",
                          defaultDropDown(
                              value: titleList.firstWhere(
                                  (item) => item['id'] == selectedtitleId),
                              items: titleList.map((data) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: data,
                                  child: Text(
                                    data['name'],
                                    style: rubikTextStyle(
                                        16, FontWeight.w500, AppColor.colBlack),
                                  ),
                                );
                              }).toList(),
                              onChanged: (selectedId) {
                                setState(() {
                                  selectedtitleId = selectedId!['id'];
                                  // Call function to make API request
                                });
                              }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: textformfiles(_staffnamecontroller,
                            labelText: "Staff Name*", validator: (value) {
                          if (value!.isEmpty &&
                              _staffnamecontroller.text.trim().isEmpty) {
                            return "Please enter staff name";
                          }
                          return null;
                        }),
                      ),
                    ],
                  ),
                  textformfiles(_fathernamecontroller,
                      labelText: 'Father Name'),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                      child: textformfiles(_mobilecontroller,
                          labelText: 'Mobile No.',
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: textformfiles(_pinCodecontroller,
                            labelText: 'Pin code',
                            keyboardType: TextInputType.number))
                  ]),
                  textformfiles(_addresscontroller, labelText: 'Address'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "City",
                            searchDropDown(
                                context,
                                widget.id != null ? cityName : "Select City",
                                cityList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            setState(() {
                                              cityId = item['city_Id'];
                                              cityName = item['city_Name'];
                                              int districtId =
                                                  item['district_Id'];
                                              districtName = districtList
                                                      .isEmpty
                                                  ? ""
                                                  : districtList.firstWhere(
                                                          (element) =>
                                                              element[
                                                                  'district_Id'] ==
                                                              districtId)[
                                                      'district_Name'];
                                              stateName = districtList.isEmpty
                                                  ? ""
                                                  : districtList.firstWhere(
                                                          (element) =>
                                                              element[
                                                                  'district_Id'] ==
                                                              districtId)[
                                                      'state_Name'];
                                            });
                                          },
                                          value: item,
                                          child: Row(
                                            children: [
                                              Text(
                                                item['city_Name'].toString(),
                                                style: rubikTextStyle(
                                                    16,
                                                    FontWeight.w500,
                                                    AppColor.colBlack),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                cityValue,
                                (value) {
                                  setState(() {
                                    cityValue = value;
                                  });
                                },
                                searchController,
                                (value) {
                                  setState(() {
                                    cityList
                                        .where((item) => item['city_Name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a City...',
                                (isOpen) {
                                  if (!isOpen) {
                                    searchController.clear();
                                  }
                                })),
                      ),
                      const SizedBox(width: 10),
                      addDefaultButton(
                        context,
                        () async {
                          var result = await pushTo(const CityMaster());
                          if (result != null) {
                            cityValue = null;

                            fetchDistrict().then((value) => setState(() {}));
                            fetchCity().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  ReuseContainer(title: "District", subtitle: districtName),
                  ReuseContainer(title: "State", subtitle: stateName),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Select Degination*",
                        searchDropDown(
                            context,
                            widget.id != null
                                ? deginationName
                                : 'Select Degination*',
                            deginationList
                                .map((item) => DropdownMenuItem(
                                      onTap: () {
                                        deginationId = item['id'];
                                        deginationName = item['name'];
                                      },
                                      value: item,
                                      child: Row(
                                        children: [
                                          Text(
                                            item['name'].toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            selecteddeginationValue,
                            (value) {
                              setState(() {
                                selecteddeginationValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                // Filter the Prionaity list based on the search value
                                deginationList
                                    .where((item) => item['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            'Search for a degination...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            }),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Select Department*",
                        searchDropDown(
                            context,
                            widget.id != null
                                ? departmentName
                                : 'Select Department*',
                            departmentList
                                .map((item) => DropdownMenuItem(
                                      onTap: () {
                                        departmentId = item['id'];
                                        departmentName = item['name'];
                                      },
                                      value: item,
                                      child: Row(
                                        children: [
                                          Text(item['name'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            selecteddepartmentValue,
                            (value) {
                              setState(() {
                                selecteddepartmentValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                // Filter the Prionaity list based on the search value
                                departmentList
                                    .where((item) => item['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            'Search for a department...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            }),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Joining Date",
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2500),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                joiningDatePickar.text =
                                    DateFormat('M/d/yyyy').format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                joiningDatePickar.text,
                                style: rubikTextStyle(
                                    16, FontWeight.w500, AppColor.colBlack),
                              ),
                              Icon(Icons.edit_calendar,
                                  color: AppColor.colBlack)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  textformfiles(
                    _passwoedcontroller,
                    labelText: 'Create Password*',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Password";
                      } else if (_passwoedcontroller.text.length < 6) {
                        return "Please enter minumum 6 digit";
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: RadioListTile<String>(
                            title: const Text('Sub-admin'),
                            contentPadding: EdgeInsets.zero,
                            value: 'subadmin',
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: RadioListTile<String>(
                            title: const Text('Staff'),
                            contentPadding: EdgeInsets.zero,
                            value: 'staff',
                            groupValue: _selectedType,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              !widget.isFirst
                  ? addMasterOutside(
                      context: context,
                      children: [
                        Center(
                          child: CheckboxListTile(
                            title: const Text('Deactivate Staff ID'),
                            value: _isDeactive,
                            onChanged: (bool? value) {
                              setState(() {
                                _isDeactive = value!;
                              });
                            },
                          ),
                        ),
                        _isDeactive && !widget.isFirst
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  dropdownTextfield(
                                    context,
                                    "Leave Date",
                                    InkWell(
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2500),
                                        ).then((selectedDate) {
                                          if (selectedDate != null) {
                                            leaveDatePickar.text =
                                                DateFormat('M/d/yyyy')
                                                    .format(selectedDate);
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            leaveDatePickar.text,
                                            style: rubikTextStyle(
                                                16,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                          ),
                                          Icon(Icons.edit_calendar,
                                              color: AppColor.colBlack)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )
                  : Container(),
              SizedBox(height: Sizes.height * 0.02),
              isload == true
                  ? const CircularProgressIndicator()
                  : button(onTap: () {
                      if (_staffnamecontroller.text.isEmpty ||
                          _passwoedcontroller.text.isEmpty) {
                        showCustomSnackbar(
                            context, "Please fill staff name and password");
                      } else if (deginationId == null && departmentId == null) {
                        showCustomSnackbar(
                            context, "Please select Degination and Department");
                      } else if (cityId == null) {
                        showCustomSnackbar(context, "Please select City");
                      } else {
                        addstaffApi();
                      }
                    }, widget.isFirst ? 'Save' : "Update", AppColor.colPrimary)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deginationData() async {
    await fetchDataByMiscTypeId(
      28,
      deginationList,
    );
  }

  Future<void> departmentData() async {
    await fetchDataByMiscTypeId(
      27,
      departmentList,
    );
  }

  Future addstaffApi() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
          widget.isFirst
              ? "MasterAW/PostStaffAW"
              : "MasterAW/UpdateStaffAW?Id=${widget.id}",
          {
            "Title_Id": selectedtitleId,
            "Staff_Name": _staffnamecontroller.text.toString(),
            "Son_Off": _fathernamecontroller.text.toString(),
            "Address": _addresscontroller.text.toString(),
            "Address2": "Not Set Yet",
            "City_Id": cityId.toString(),
            "City_Name": cityName,
            "District_Name": districtName,
            "State_Name": stateName,
            "Pin_Code": _pinCodecontroller.text.toString(),
            "Std_Code": "Not Set Yet",
            "Mob": _mobilecontroller.text.toString(),
            "Staff_Degination_Id": deginationId,
            "Staff_Department_Id": departmentId,
            "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
            "Joining_Date": joiningDatePickar.text.toString(),
            "Left_Date": "Not Set Yet",
            "UserName": _staffnamecontroller.text.toString(),
            "Password": _passwoedcontroller.text.toString(),
            "UserType": _selectedType,
            "UserValid": "UserValid"
          });
      if (response["result"] == true) {
        showCustomSnackbarSuccess(context, response["message"]);
        widget.isFirst ? null : Navigator.pop(context);
        widget.switchToSecondTab();
      } else {
        showCustomSnackbar(context, response["message"]);
      }
    } catch (e) {}
  }

  // Get City List
  Future fetchCity() async {
    final response = await ApiService.fetchData("MasterAW/GetCityAW");

    if (response is List) {
      // Assuming it's a list, convert each item to a Map
      cityList = response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for cities');
    }
  }

  // Get District List
  Future fetchDistrict() async {
    final response = await ApiService.fetchData("MasterAW/GetDistrictAW");

    if (response is List) {
      // Assuming it's a list, convert each item to a Map
      districtList =
          response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for cities');
    }
  }

  //get staff details
  Future getstaffDetails() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetStaffDetailsByStaffIdAW?StaffId=${widget.id}");
    _staffnamecontroller.text = response["staff_Name"];
    _fathernamecontroller.text = response['son_Off'];
    _addresscontroller.text = response['address'];
    _pinCodecontroller.text = response['pin_Code'];
    _mobilecontroller.text = response['mob'];
    joiningDatePickar.text = response['joining_Date'];
    _passwoedcontroller.text = response['password'];
    stateName = response['state_Name'];
    cityName = response['city_Name'];
    districtName = response['district_Name'];
    deginationId = response['staff_Degination_Id'];
    deginationName = deginationList
        .firstWhere((element) => element['id'] == deginationId)['name'];
    departmentId = response['staff_Department_Id'];
    departmentName = departmentList
        .firstWhere((element) => element['id'] == departmentId)['name'];
  }
}
