// ignore_for_file: empty_catches, use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddLedger extends StatefulWidget {
  AddLedger(
      {required this.switchToSecondTab,
      required this.groupId,
      super.key,
      required this.isFirst,
      this.id});
  bool isFirst;
  int? id;
  int? groupId;
  final VoidCallback switchToSecondTab;

  @override
  State<AddLedger> createState() => _AddLedgerState();
}

class _AddLedgerState extends State<AddLedger> {
  //Controller
  TextEditingController customernameController = TextEditingController();
  TextEditingController parentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panCardController = TextEditingController();
  TextEditingController openingAmountController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //District
  List<Map<String, dynamic>> cityList = [];
  List<Map<String, dynamic>> districtList = [];
  int? cityId;
  Map<String, dynamic>? cityValue;
  String cityName = '';
  String stateName = 'Unknown';
  String districtName = 'Unknown';

//Title
  List<Map<String, dynamic>> titleList = [
    {'id': 101, 'name': 'Mr.'},
    {'id': 102, 'name': 'Mrs.'},
    {'id': 103, 'name': 'Dr.'},
    {'id': 104, 'name': 'M/s'}
  ];
  int selectedtitleId = 101;

//Balance Type
  List<Map<String, dynamic>> balanceTypeList = [
    {'id': 109, 'name': 'Credit'},
    {'id': 110, 'name': 'Debit'},
  ];
  int selectedbalanceTypeId = 109;

//Category
  List<Map<String, dynamic>> catergoryList = [];
  int? catergoryId;

//GST Dealer Type
  List<Map<String, dynamic>> gestDealerList = [];
  int? gestDealerId;

//Staff
  List<Map<String, dynamic>> staffList = [];
  int? selectedStaffId;

  //Date
  TextEditingController wefDatePicker = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController dueDatePicker = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

//Ledger Group
  List<Map<String, dynamic>> ledgergroupList = [
    {
      "id": 7,
      "ledger_Group_Name": "Bank Accounts",
      "mainLedger_Id": 0,
      "locationId": 0
    },
    {
      "id": 9,
      "ledger_Group_Name": "Sundry Creditors",
      "mainLedger_Id": 0,
      "locationId": 0
    },
    {
      "id": 10,
      "ledger_Group_Name": "Sundry Debtors",
      "mainLedger_Id": 0,
      "locationId": 0
    },
    {
      "id": 11,
      "ledger_Group_Name": "Cash In Hand",
      "mainLedger_Id": 0,
      "locationId": 0
    },
    {
      "id": 14,
      "ledger_Group_Name": "InDirect",
      "mainLedger_Id": 0,
      "locationId": 0
    }
  ];
  int? ledgergroupId;
  Map<String, dynamic>? ledgerGroupValue;
  String ledgerGroupName = '';

  @override
  void initState() {
    categoryData().then((value) => setState(() {}));
    ledgergroupId = widget.groupId == 0 ? 9 : widget.groupId;
    gstDealerData().then((value) {
      fetchDistrict().then((value) => setState(() {}));
      fetchCity().then((value) => setState(() {
            widget.isFirst
                ? null
                : getledgerDetails().then((value) => setState(() {}));
          }));
    });

    fatchstaff().then((value) => setState(() {
          selectedStaffId = staffList[0]['id'];
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.height,
      color: AppColor.colPrimary.withOpacity(.1),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
        child: Column(
          children: [
            widget.groupId != 0
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      dropdownTextfield(
                          context,
                          "Ledger Group",
                          searchDropDown(
                              context,
                              "Ledger Group*",
                              ledgergroupList
                                  .map((item) => DropdownMenuItem(
                                        onTap: () {
                                          setState(() {
                                            ledgergroupId = item['id'];
                                            ledgerGroupName =
                                                item['ledger_Group_Name'];
                                          });
                                        },
                                        value: item,
                                        child: Row(
                                          children: [
                                            Text(
                                              item['ledger_Group_Name']
                                                  .toString(),
                                              style: rubikTextStyle(
                                                  16,
                                                  FontWeight.w500,
                                                  AppColor.colBlack),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              ledgerGroupValue,
                              (value) {
                                setState(() {
                                  ledgerGroupValue = value;
                                });
                              },
                              searchController,
                              (value) {
                                setState(() {
                                  ledgergroupList
                                      .where((item) => item['ledger_Group_Name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              },
                              'Search for a group...',
                              (isOpen) {
                                if (!isOpen) {
                                  searchController.clear();
                                }
                              })),
                    ],
                  ),
            widget.groupId != 0
                ? Container()
                : SizedBox(height: Sizes.height * 0.02),
            ledgergroupId == 7
                ? addMasterOutside(children: [
                    textformfiles(customernameController,
                        labelText: "Ledger Name*"),
                    textformfiles(addressController, labelText: 'Address'),
                    ledgerCity(context),
                    ledgerDistrict(),
                    ledgerState(),
                    textformfiles(pinCodeController,
                        labelText: 'Pin Code',
                        keyboardType: TextInputType.number),
                    textformfiles(
                      mobileNumberController,
                      keyboardType: TextInputType.phone,
                      labelText: 'Mobile No.',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    textformfiles(
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.mail),
                    ),
                    ledgerBalance(context),
                    ledgerGst(),
                  ], context: context)
                : addMasterOutside(context: context, children: [
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
                                      style: rubikTextStyle(16, FontWeight.w500,
                                          AppColor.colBlack),
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
                          child: textformfiles(customernameController,
                              labelText: "Ledger Name*"),
                        ),
                      ],
                    ),
                    textformfiles(parentController, labelText: "Parent Name"),
                    textformfiles(addressController, labelText: 'Address'),
                    ledgerCity(context),
                    ledgerDistrict(),
                    ledgerState(),
                    textformfiles(pinCodeController,
                        labelText: 'Pin Code',
                        keyboardType: TextInputType.number),
                    textformfiles(aadharController,
                        maxLength: 12,
                        labelText: 'Aadhar Card',
                        keyboardType: TextInputType.number),
                    textformfiles(panCardController,
                        labelText: 'Pan Card',
                        textCapitalization: TextCapitalization.characters),
                    textformfiles(
                      mobileNumberController,
                      keyboardType: TextInputType.phone,
                      labelText: 'Mobile No.',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    textformfiles(
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.mail),
                    ),
                    ledgerBalance(context),
                    ledgerGst(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        dropdownTextfield(
                          context,
                          "GST Dealer Type",
                          DropdownButton<int>(
                            underline: Container(),
                            value: gestDealerId,
                            items: gestDealerList.map((data) {
                              return DropdownMenuItem<int>(
                                value: data['id'],
                                child: Text(
                                  data['name'],
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              );
                            }).toList(),
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                gestDealerId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        dropdownTextfield(
                          context,
                          "Category",
                          DropdownButton<int>(
                            underline: Container(),
                            value: catergoryId,
                            items: catergoryList.map((data) {
                              return DropdownMenuItem<int>(
                                value: data['id'],
                                child: Text(
                                  data['name'],
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              );
                            }).toList(),
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                catergoryId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: dropdownTextfield(
                          context,
                          "Wef. Date",
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2400),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  wefDatePicker.text = DateFormat('yyyy/MM/dd')
                                      .format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(wefDatePicker.text,
                                    style: rubikTextStyle(16, FontWeight.w500,
                                        AppColor.colBlack)),
                                Icon(Icons.edit_calendar,
                                    color: AppColor.colBlack)
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                            child: dropdownTextfield(
                          context,
                          "Due Date",
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2400),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  dueDatePicker.text = DateFormat('yyyy/MM/dd')
                                      .format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dueDatePicker.text,
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                                Icon(Icons.edit_calendar,
                                    color: AppColor.colBlack)
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dropdownTextfield(
                          context,
                          "Select Staff",
                          DropdownButton<int>(
                            underline: Container(),
                            value: selectedStaffId,
                            items: staffList.map((data) {
                              return DropdownMenuItem<int>(
                                value: data['id'],
                                child: Text(
                                  data['name'],
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              );
                            }).toList(),
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                selectedStaffId = selectedId!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ]),
            SizedBox(height: Sizes.height * 0.02),
            button(widget.isFirst ? "Save" : "Update", AppColor.colPrimary,
                onTap: () {
              if (customernameController.text.isEmpty) {
                showCustomSnackbar(context, "Please enter Ledger Name");
              } else if (gestDealerId == 28
                  ? gstNumberController.text.isEmpty
                  : false) {
                showCustomSnackbar(context, "Please enter Gst Number");
              } else if (cityId == null) {
                showCustomSnackbar(context, "Please select city and district");
              } else {
                postLedger();
              }
            }),
          ],
        ),
      ),
    );
  }

  ledgerGst() {
    return textformfiles(gstNumberController,
        labelText: 'GST Number', suffixIcon: const Icon(Icons.search));
  }

  ledgerBalance(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: textformfiles(openingAmountController,
                labelText: 'Opening Balance',
                keyboardType: TextInputType.number)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dropdownTextfield(
                context,
                "",
                DropdownButton<int>(
                  underline: Container(),
                  value: selectedbalanceTypeId,
                  items: balanceTypeList.map((data) {
                    return DropdownMenuItem<int>(
                      value: data['id'],
                      child: Text(
                        data['name'],
                        style: rubikTextStyle(
                            16, FontWeight.w500, AppColor.colBlack),
                      ),
                    );
                  }).toList(),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  isExpanded: true,
                  onChanged: (selectedId) {
                    setState(() {
                      selectedbalanceTypeId = selectedId!;
                      // Call function to make API request
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ledgerState() => ReuseContainer(title: "State", subtitle: stateName);

  ledgerDistrict() => ReuseContainer(title: "District", subtitle: districtName);

  ledgerCity(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: dropdownTextfield(
              context,
              "City*",
              searchDropDown(
                  context,
                  widget.id != null ? cityName : "Select City*",
                  cityList
                      .map((item) => DropdownMenuItem(
                            onTap: () {
                              setState(() {
                                cityId = item['city_Id'];
                                cityName = item['city_Name'];
                                int districtId = item['district_Id'];
                                districtName = districtList.isEmpty
                                    ? ""
                                    : districtList.firstWhere((element) =>
                                        element['district_Id'] ==
                                        districtId)['district_Name'];
                                stateName = districtList.isEmpty
                                    ? ""
                                    : districtList.firstWhere((element) =>
                                        element['district_Id'] ==
                                        districtId)['state_Name'];
                              });
                            },
                            value: item,
                            child: Row(
                              children: [
                                Text(
                                  item['city_Name'].toString(),
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
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
              fetchCity().then((value) => setState(() {}));
              fetchDistrict().then((value) => setState(() {}));
            }
          },
        )
      ],
    );
  }

//Post and Update Ledger
  Future postLedger() async {
    var response = await ApiService.postData(
        widget.isFirst
            ? 'MasterAW/PostLedgerMaster'
            : "MasterAW/UpdatePostLedgerMasterByIdAW?LedgerId=${widget.id}",
        {
          "Title_Id": selectedtitleId,
          "Ledger_Name": customernameController.text.toString(),
          "Son_Off": parentController.text.toString(),
          "Address": addressController.text.toString(),
          "Address2": "",
          "City_Id": cityId,
          "Std_Code": "",
          "Mob": mobileNumberController.text.toString(),
          "Pin_Code": pinCodeController.text.toString(),
          "Ledger_Group_Id": ledgergroupId,
          "Opening_Bal": openingAmountController.text.toString(),
          "Opening_Bal_Combo": selectedbalanceTypeId != 110 ? "Cr" : "Dr",
          "Gst_No": gstNumberController.text.toString(),
          "Address_TA": "",
          "Address2_TA": "",
          "Std_Code_TA": "",
          "Mob_TA": "",
          "Pin_Code_TA": "",
          "SubcidyIdNo": " ",
          "DueDate": "17/12/2023",
          "ClosingBal": "0",
          "ClosingBal_Type": "Dr",
          "Category_Id": catergoryId,
          "Staff_Id": selectedStaffId,
          "CreditLimit": "",
          "CreditDays": "",
          "WhatappNo": int.parse(mobileNumberController.text.trim().isEmpty
              ? "0"
              : mobileNumberController.text.trim()),
          "EmailId": emailController.text.toString(),
          "BirthdayDate": "",
          "AnniversaryDate": "",
          "DistanceKm": "",
          "DiscountSource": "0",
          "DiscountValid": "Dr",
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "OtherNumber1": 1,
          "OtherNumber2": 2,
          "OtherNumber3": 3,
          "OtherNumber4": 4,
          "OtherNumber5": 5,
          "GSTTypeId": gestDealerId,
          "IGST": 28,
          "CGST": 14,
          "SGST": 14,
          "CESS": 1,
          "RCMStatus": 28,
          "ITCStatus": 14,
          "ExpencesTypeId": 14,
          "RCMCategory": 1,
          "AadharNo": aadharController.text.toString(),
          "PanNo": panCardController.text.toString()
        });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      widget.isFirst ? null : Navigator.pop(context);
      customernameController.clear();
      parentController.clear();
      addressController.clear();
      pinCodeController.clear();
      aadharController.clear();
      panCardController.clear();
      mobileNumberController.clear();
      emailController.clear();
      openingAmountController.clear();
      gstNumberController.clear();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//Get category
  Future<void> categoryData() async {
    await fetchDataByMiscTypeId(15, catergoryList).then((_) {
      if (catergoryList.isNotEmpty) {
        catergoryId = catergoryList.first['id'];
      }
    });
  }

//Get Gst Dealer
  Future<void> gstDealerData() async {
    await fetchDataByMiscTypeId(20, gestDealerList).then((_) {
      if (gestDealerList.isNotEmpty) {
        gestDealerId = gestDealerList.first['id'];
      }
    });
  }

//Get staff list
  Future<void> fatchstaff() async {
    final url = Uri.parse(
        'http://lms.muepetro.com/api/MasterAW/GetStaffDetailsLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Staffmodel> staffmodelList =
            staffmodelFromJson(response.body);
        staffList.clear();
        for (var item in staffmodelList) {
          staffList.add({'id': item.id, 'name': item.staffName});
        }
        setState(() {});
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

  //get Ledger details
  Future getledgerDetails() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerbyId?LedgerId=${widget.id}");
    customernameController.text = response["ledger_Name"];
    parentController.text = response['son_Off'];
    openingAmountController.text = response['opening_Bal'];
    emailController.text = response['emailId'];
    mobileNumberController.text = response['mob'];
    addressController.text = response['address'];
    pinCodeController.text = response['pin_Code'];
    gstNumberController.text = response['gst_No'];
    panCardController.text = response['panNo'];
    aadharController.text = response['aadharNo'];
    var balanceType = response['opening_Bal_Combo'];
    selectedbalanceTypeId = balanceType == "Cr" ? 109 : 110;
    cityId = response['city_Id'];
    cityName = cityList
        .firstWhere((element) => element['city_Id'] == cityId)['city_Name'];
    districtName = cityList
        .firstWhere((element) => element['city_Id'] == cityId)['district_Name'];
    stateName = cityList
        .firstWhere((element) => element['city_Id'] == cityId)['state_Name'];
    selectedStaffId = response['staff_Id'];
    gestDealerId = response['gstTypeId'];
    catergoryId = response['category_Id'];
  }
}
