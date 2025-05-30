// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class JobCardScreen extends StatefulWidget {
  JobCardScreen({required this.jobcardNumber, required this.srNo, super.key});
  int jobcardNumber = 0;
  int? srNo;
  @override
  State<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends State<JobCardScreen> {
  //Controller
  TextEditingController jobcardNoController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController chassisNoController = TextEditingController();
  TextEditingController engineNoController = TextEditingController();
  TextEditingController couponNoController = TextEditingController();
  TextEditingController kmsController = TextEditingController();
  TextEditingController voiceController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  // Date
  TextEditingController jobcardDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController soldonDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController jobInDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController jobOutDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController nextServiceDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController insurenceRenewDatePickar = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  //Time
  late TimeOfDay jobInTimePicker;
  late TimeOfDay jobOutTimePicker;

  Future<void> _selectJobInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: jobInTimePicker,
    );
    if (picked != null && picked != jobInTimePicker) {
      setState(() {
        jobInTimePicker = picked;
      });
    }
  }

  Future<void> _selectJobOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: jobOutTimePicker,
    );
    if (picked != null && picked != jobOutTimePicker) {
      setState(() {
        jobOutTimePicker = picked;
      });
    }
  }

  //Model Name
  List<Map<String, dynamic>> modelNameList = [];
  String modalName = '';
  Map<String, dynamic>? modelValue;
  int? modelNameId;

  //colorList
  List<Map<String, dynamic>> colorList = [];
  int? colorListId;

  //sourceList
  List<Map<String, dynamic>> sourceList = [];
  int? sourceListId;

  //serviceTypeList
  List<Map<String, dynamic>> serviceTypeList = [];
  int? serviceTypeListId;

  //serviceNumberList
  List<Map<String, dynamic>> serviceNumberList = [];
  int? serviceNumberListId;

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  int? ledgerId;
  Map<String, dynamic>? ledgerValue;
  String ledgerName = '';

  //Manager
  List<Map<String, dynamic>> managerList = [];
  int? managerId;

  //mechanic
  List<Map<String, dynamic>> mechanicList = [];
  int? mechanicId;

  //Fuel
  double _value = 50;

  @override
  void initState() {
    jobInTimePicker = TimeOfDay.now();
    jobOutTimePicker = TimeOfDay.now();
    fatchJobcardNumber().then((value) => setState(() {}));
    colorListData().then(
      (value) => setState(() {
        colorListId = colorList.first["id"];
      }),
    );
    sourceListData().then(
      (value) => setState(() {
        sourceListId = sourceList.first["id"];
      }),
    );
    serviceTypeListData().then(
      (value) => setState(() {
        serviceTypeListId = serviceTypeList.first["id"];
      }),
    );
    serviceNumberListData().then(
      (value) => setState(() {
        serviceNumberListId = serviceNumberList.first["id"];
      }),
    );
    fatchledger().then((value) => setState(() {}));
    fatchmanager().then(
      (value) => setState(() {
        managerId = managerList.first["id"];
      }),
    );
    fatchmechanic().then(
      (value) => setState(() {
        mechanicId = mechanicList.first["id"];
        widget.jobcardNumber == 0
            ? null
            : getJobcardDetails().then((value) => setState(() {}));
      }),
    );
    fatchVehicle().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text("Job Card", overflow: TextOverflow.ellipsis),
        backgroundColor: AppColor.colPrimary,
      ),
      backgroundColor: AppColor.colWhite,
      body: Container(
        color: AppColor.colPrimary.withValues(alpha: .1),
        height: Sizes.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02,
            horizontal: Sizes.width * .03,
          ),
          child: Column(
            children: [
              addMasterOutside(
                context: context,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: textformfiles(
                          jobcardNoController,
                          labelText: 'Job Card No*',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: dropdownTextfield(
                          context,
                          "Job Card Date",
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
                                  jobcardDatePickar.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  jobcardDatePickar.text,
                                  style: rubikTextStyle(
                                    16,
                                    FontWeight.w500,
                                    AppColor.colBlack,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: AppColor.colBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textformfiles(
                    textCapitalization: TextCapitalization.characters,
                    vehicleNoController,
                    labelText: 'Vehicle No*',
                    suffixIcon: Icon(Icons.camera_alt),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: textformfiles(
                          textCapitalization: TextCapitalization.characters,
                          engineNoController,
                          labelText: "Engine Number",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          textCapitalization: TextCapitalization.characters,
                          chassisNoController,
                          labelText: 'Chassis No',
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
                          "Model Name*",
                          searchDropDown(
                            context,
                            modalName.isEmpty
                                ? "Select Model Name*"
                                : modalName,
                            modelNameList
                                .map(
                                  (item) => DropdownMenuItem(
                                    onTap: () {
                                      modelNameId = item['id'];
                                      modalName = item['name'];
                                    },
                                    value: item,
                                    child: Text(
                                      item['name'].toString(),
                                      style: rubikTextStyle(
                                        14,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            modelValue,
                            (value) {
                              setState(() {
                                modelValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                modelNameList
                                    .where(
                                      (item) => item['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()),
                                    )
                                    .toList();
                              });
                            },
                            'Search for a model...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      addDefaultButton(context, () async {
                        var result = await pushTo(const VehicleMaster());
                        if (result != null) {
                          fatchVehicle().then((value) => setState(() {}));
                        }
                      }),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: dropdownTextfield(
                          context,
                          "Model Varient*",
                          DropdownButton<int>(
                            underline: Container(),
                            value: colorListId,
                            items:
                                colorList.map((data) {
                                  return DropdownMenuItem<int>(
                                    value: data['id'],
                                    child: Text(
                                      data['name'],
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                colorListId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      addDefaultButton(context, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AddGroupScreen(
                                  sourecID: 103,
                                  name: 'Vehicle Color',
                                ),
                          ),
                        ).then(
                          (value) =>
                              colorListData().then((value) => setState(() {})),
                        );
                      }),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Customer Name*",
                          searchDropDown(
                            context,
                            ledgerName.isEmpty
                                ? "Select Customer*"
                                : ledgerName,
                            ledgerList
                                .map(
                                  (item) => DropdownMenuItem(
                                    onTap: () {
                                      ledgerId = item['id'];
                                      ledgerName = item['name'];
                                    },
                                    value: item,
                                    child: Text(
                                      item['name'].toString(),
                                      style: rubikTextStyle(
                                        14,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            ledgerValue,
                            (value) {
                              setState(() {
                                ledgerValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                ledgerList
                                    .where(
                                      (item) => item['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()),
                                    )
                                    .toList();
                              });
                            },
                            'Search for a ledger...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      addDefaultButton(context, () async {
                        var result = await pushTo(LedgerMaster(groupId: 10));
                        if (result != null) {
                          ledgerValue = null;
                          fatchledger().then((value) => setState(() {}));
                        }
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Service Type",
                          DropdownButton<int>(
                            underline: Container(),
                            value: serviceTypeListId,
                            items:
                                serviceTypeList.map((data) {
                                  return DropdownMenuItem<int>(
                                    value: data['id'],
                                    child: Text(
                                      data['name'],
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                serviceTypeListId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          kmsController,
                          labelText: "Odometer",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Slider(
                          activeColor: AppColor.colPrimary,
                          value: _value,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: _value.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              _value = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(fuelController, labelText: "Fuel"),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Mechanic*",
                          DropdownButton<int>(
                            underline: Container(),
                            value: mechanicId,
                            items:
                                mechanicList.map((data) {
                                  return DropdownMenuItem<int>(
                                    value: data['id'],
                                    child: Text(
                                      data['name'],
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                mechanicId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Work Manager*",
                          DropdownButton<int>(
                            underline: Container(),
                            value: managerId,
                            items:
                                managerList.map((data) {
                                  return DropdownMenuItem<int>(
                                    value: data['id'],
                                    child: Text(
                                      data['name'],
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                managerId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
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
                          "Job In Date",
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
                                  jobInDatePickar.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  jobInDatePickar.text,
                                  style: rubikTextStyle(
                                    16,
                                    FontWeight.w500,
                                    AppColor.colBlack,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: AppColor.colBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Job In Time",
                          InkWell(
                            onTap: () {
                              _selectJobInTime(context);
                            },
                            child: Center(
                              child: Text(
                                jobInTimePicker.format(context),
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                            ),
                          ),
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
                          "Job Out Date",
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
                                  jobOutDatePickar.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  jobOutDatePickar.text,
                                  style: rubikTextStyle(
                                    16,
                                    FontWeight.w500,
                                    AppColor.colBlack,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: AppColor.colBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Job Out Time",
                          InkWell(
                            onTap: () {
                              _selectJobOutTime(context);
                            },
                            child: Center(
                              child: Text(
                                jobOutTimePicker.format(context),
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textformfiles(voiceController, labelText: "Customer Voice"),
                  textformfiles(remarkController, labelText: "Remark"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Next Service Date",
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
                                  nextServiceDatePickar.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  nextServiceDatePickar.text,
                                  style: rubikTextStyle(
                                    16,
                                    FontWeight.w500,
                                    AppColor.colBlack,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: AppColor.colBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Insurence Renewal Date",
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
                                  insurenceRenewDatePickar.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  insurenceRenewDatePickar.text,
                                  style: rubikTextStyle(
                                    16,
                                    FontWeight.w500,
                                    AppColor.colBlack,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: AppColor.colBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  textformfiles(
                    remarkController,
                    labelText: "Estimated Amount",
                  ),

                  Center(
                    child: button(
                      "Upload Documents",
                      AppColor.colGrey,
                      width: 200,
                    ),
                  ),
                  Center(
                    child: button("Add Labour", AppColor.colGrey, width: 200),
                  ),
                ],
              ),
              SizedBox(height: Sizes.height * 0.02),
              button(
                width: 300,
                widget.jobcardNumber == 0 ? "Save" : "Update",
                AppColor.colPrimary,
                onTap: () {
                  if (jobcardNoController.text.isEmpty) {
                    showCustomSnackbar(context, "Please enter Jobcard Number");
                  } else if (vehicleNoController.text.isEmpty &&
                      chassisNoController.text.isEmpty) {
                    showCustomSnackbar(
                      context,
                      "Please enter Vehicle or Chassis Number",
                    );
                  } else if (modelNameId == null || colorListId == null) {
                    showCustomSnackbar(
                      context,
                      "Please select Modal Name and Color",
                    );
                  } else if (ledgerId == null || sourceListId == null) {
                    showCustomSnackbar(
                      context,
                      "Please select Customer Name and Source",
                    );
                  } else if (mechanicId == null || managerId == null) {
                    showCustomSnackbar(
                      context,
                      "Please select Mechanic and Manager",
                    );
                  } else {
                    widget.jobcardNumber == 0 ? postJobcard() : updateJobcard();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Fatch Model Name list
  Future fatchVehicle() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetVehicleMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    modelNameList = List<Map<String, dynamic>>.from(
      response.map(
        (item) => {
          'id': item['model_Id'],
          'name': "${item['model_Name']} ${item['model_Code']}",
        },
      ),
    );
  }

  //Vehicle color
  Future<void> colorListData() async {
    await fetchDataByMiscAdd(103, colorList);
  }

  //Source
  Future<void> sourceListData() async {
    await fetchDataByMiscAdd(106, sourceList);
  }

  //serviceType
  Future<void> serviceTypeListData() async {
    await fetchDataByMiscTypeId(31, serviceTypeList);
  }

  //serviceNumber
  Future<void> serviceNumberListData() async {
    await fetchDataByMiscTypeId(33, serviceNumberList);
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetLedgerByGroupId?LedgerGroupId=10",
    );

    ledgerList = List<Map<String, dynamic>>.from(
      response.map(
        (item) => {'id': item['ledger_Id'], 'name': item['ledger_Name']},
      ),
    );
  }

  //Get manager List
  Future fatchmanager() async {
    List manager = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseDesinationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&Deginationid=1",
    );
    List supervisor = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseDesinationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&Deginationid=2",
    );

    List response = [...manager, ...supervisor];

    managerList = List<Map<String, dynamic>>.from(
      response.map((item) => {'id': item['id'], 'name': item['staff_Name']}),
    );
  }

  //Get mechanic List
  Future fatchmechanic() async {
    List response = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseDesinationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&Deginationid=3",
    );

    mechanicList = List<Map<String, dynamic>>.from(
      response.map((item) => {'id': item['id'], 'name': item['staff_Name']}),
    );
  }

  //Post Jobcard
  Future postJobcard() async {
    try {
      Map<String, dynamic> response =
          await ApiService.postData("Transactions/PostJobCardAW", {
            "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
            "Prefix_Name": "online",
            "Job_No": int.parse(jobcardNoController.text),
            "Job_Date": jobcardDatePickar.text.toString(),
            "Vehicle_No": vehicleNoController.text.toString(),
            "Chassis_No": chassisNoController.text.toString(),
            "Engine_No": engineNoController.text.toString(),
            "Model_Id": modelNameId,
            "Colour_Id": colorListId,
            "Source_Id": sourceListId,
            "Service_type_id": serviceTypeListId,
            "Coupon_No": couponNoController.text.toString(),
            "Service_No": "$serviceNumberListId",
            "Kms": kmsController.text.toString(),
            "Fuel": fuelController.text.toString(),
            "Vehicle_Sold": soldonDatePickar.text.toString(),
            "Mechanic_Id": mechanicId,
            "Work_Mgr_Id": managerId,
            "Ledger_Id": ledgerId,
            "Customer_Name": ledgerName,
            "Job_In": jobInDatePickar.text.toString(),
            "Job_InTime": "2024-01-27 00:00:00.000",
            "Job_Out": jobOutDatePickar.text.toString(),
            "Job_OutTime": "2024-01-27 00:00:00.000",
            "Customer_Voice": voiceController.text.toString(),
            "Job_Status": "0",
            "Next_ServiceInDays": "Next_ServiceInDays",
            "Next_ServiceOnDate": nextServiceDatePickar.text.toString(),
            "Insurance_Renewal": insurenceRenewDatePickar.text.toString(),
            "Remarks": remarkController.text.toString(),
            "Extra1": "0",
            "Extra2": "0",
            "Extra3": "0",
            "Extra4": "0",
            "JobCard_Items": [],
          });
      if (response["result"] == true) {
        Navigator.pop(context, "For fatch data in last screen");
        showCustomSnackbarSuccess(context, response["message"]);
      } else {
        showCustomSnackbar(context, response["message"]);
      }
    } catch (e) {
      print("$e error");
    }
  }

  //Update Jobcard
  Future updateJobcard() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
        "Transactions/UpdateJobCardAW?Id=${widget.srNo}",
        {
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "Prefix_Name": "online",
          "Job_No": int.parse(jobcardNoController.text),
          "Job_Date": jobcardDatePickar.text.toString(),
          "Vehicle_No": vehicleNoController.text.toString(),
          "Chassis_No": chassisNoController.text.toString(),
          "Engine_No": engineNoController.text.toString(),
          "Model_Id": modelNameId,
          "Colour_Id": colorListId,
          "Source_Id": sourceListId,
          "Service_type_id": serviceTypeListId,
          "Coupon_No": couponNoController.text.toString(),
          "Service_No": "$serviceNumberListId",
          "Kms": kmsController.text.toString(),
          "Fuel": fuelController.text.toString(),
          "Vehicle_Sold": soldonDatePickar.text.toString(),
          "Mechanic_Id": mechanicId,
          "Work_Mgr_Id": managerId,
          "Ledger_Id": ledgerId,
          "Customer_Name": ledgerName,
          "Job_In": jobInDatePickar.text.toString(),
          "Job_InTime": "2024-01-27 00:00:00.000",
          "Job_Out": jobOutDatePickar.text.toString(),
          "Job_OutTime": "2024-01-27 00:00:00.000",
          "Customer_Voice": voiceController.text.toString(),
          "Job_Status": "0",
          "Next_ServiceInDays": "Next_ServiceInDays",
          "Next_ServiceOnDate": nextServiceDatePickar.text.toString(),
          "Insurance_Renewal": insurenceRenewDatePickar.text.toString(),
          "Remarks": remarkController.text.toString(),
          "JobCard_Items": [],
        },
      );
      if (response["result"] == true) {
        Navigator.pop(context, "For fatch data in last screen");
        showCustomSnackbarSuccess(context, response["message"]);
      } else {
        showCustomSnackbar(context, response["message"]);
      }
    } catch (e) {
      print("$e error");
    }
  }

  //Get jobcard Number/
  Future fatchJobcardNumber() async {
    var response = await ApiService.fetchData(
      "Transactions/GetInvoiceNoAW?Tblname=Job_Card&Fldname=Job_No&transdatefld=Job_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}",
    );
    jobcardNoController.text =
        widget.jobcardNumber != 0 ? "${widget.jobcardNumber}" : "$response";
  }

  //Get Jobcard Details
  Future getJobcardDetails() async {
    var response = await ApiService.fetchData(
      "Transactions/GetJobCardAW?prefix=online&refno=${widget.jobcardNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    vehicleNoController.text = response['vehicle_No'] ?? "";
    fuelController.text = response['fuel'] ?? "";
    remarkController.text = response['remarks'] ?? "";
    kmsController.text = response['kms'] ?? "";
    widget.srNo = response['sr_No'] ?? 0;
    voiceController.text = response['customer_Voice'] ?? "";
    couponNoController.text = response['coupon_No'] ?? "";
    engineNoController.text = response['engine_No'] ?? "";
    chassisNoController.text = response['chassis_No'] ?? "";
    modelNameId = response['model_Id'];
    modalName =
        modelNameList.isEmpty
            ? ""
            : modelNameList.firstWhere(
              (element) => element['id'] == modelNameId,
            )['name'];
    colorListId = response['colour_Id'];
    sourceListId = response['source_Id'];
    serviceTypeListId = response['service_type_id'];
    managerId = response['work_Mgr_Id'];
    mechanicId = response['mechanic_Id'];
    serviceNumberListId = int.parse(response['service_No']);
    ledgerId = response['ledger_Id'];
    ledgerName =
        ledgerList.firstWhere((element) => element['id'] == ledgerId)['name'];
  }
}
