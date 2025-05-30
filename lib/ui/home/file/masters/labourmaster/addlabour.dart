// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class AddLabour extends StatefulWidget {
  AddLabour(
      {required this.switchToSecondTab,
      super.key,
      required this.isFirst,
      this.id});
  bool isFirst;
  int? id;
  final VoidCallback switchToSecondTab;
  @override
  State<AddLabour> createState() => _AddLabourState();
}

class _AddLabourState extends State<AddLabour> {
  //Controller
  TextEditingController jobCodeController = TextEditingController();
  TextEditingController labourNameController = TextEditingController();
  TextEditingController mrpController = TextEditingController();
  TextEditingController searchController = TextEditingController();

//Category
  List<Map<String, dynamic>> labourGroupList = [];
  int? labourGroupId;

  //GST Dealer Type
  List<Map<String, dynamic>> sacCodeList = [];
  int? sacCodeId;
  Map<String, dynamic>? sacCodeValue;
  String sacCodeName = '';

//Gst
  String gstPersentage = '';

  @override
  void initState() {
    labourGroupData().then((value) {
      gstSacData().then((value) {
        widget.id == null
            ? null
            : getlabourDetails().then((value) => setState(() {
                  // sacCodeValue =
                }));
      });
    });

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
            addMasterOutside(context: context, children: [
              textformfiles(jobCodeController, labelText: 'Job Code*'),
              textformfiles(labourNameController, labelText: "Labour Name*"),
              textformfiles(mrpController,
                  labelText: 'MRP*', keyboardType: TextInputType.number),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: dropdownTextfield(
                      context,
                      "Labour Group*",
                      DropdownButton<int>(
                        underline: Container(),
                        value: labourGroupId,
                        items: labourGroupList.map((data) {
                          return DropdownMenuItem<int>(
                            value: data['id'],
                            child: Text(
                              data["name"],
                              style: rubikTextStyle(
                                  16, FontWeight.w500, AppColor.colBlack),
                            ),
                          );
                        }).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        isExpanded: true,
                        onChanged: (selectedId) {
                          setState(() {
                            labourGroupId = selectedId!;
                            // Call function to make API request
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  addDefaultButton(
                    context,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGroupScreen(
                                    sourecID: 105,
                                    name: 'Labour Group',
                                  ))).then((value) =>
                          labourGroupData().then((value) => setState(() {})));
                    },
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: dropdownTextfield(
                        context,
                        "Sac Code*",
                        searchDropDown(
                            context,
                            widget.id != null
                                ? sacCodeName
                                : "Select Sac Code*",
                            sacCodeList
                                .map((item) => DropdownMenuItem(
                                      onTap: () {
                                        setState(() {
                                          sacCodeId = item['hsn_Id'];
                                          gstPersentage =
                                              item['igst'].toString();
                                          sacCodeName = item['hsn_Code'];
                                        });
                                      },
                                      value: item,
                                      child: Text(
                                        item['hsn_Code'].toString(),
                                        style: rubikTextStyle(16,
                                            FontWeight.w500, AppColor.colBlack),
                                      ),
                                    ))
                                .toList(),
                            sacCodeValue,
                            (value) {
                              setState(() {
                                sacCodeValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                sacCodeList
                                    .where((item) => item['hsn_Code']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            'Search for a Sac Code...',
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
                      var result = await pushTo(const HsnCode());
                      if (result != null) {
                        sacCodeValue = null;
                        gstSacData().then((value) => setState(() {}));
                      }
                    },
                  )
                ],
              ),
              ReuseContainer(title: "GST", subtitle: "$gstPersentage %"),
            ]),
            SizedBox(height: Sizes.height * 0.02),
            button(widget.isFirst ? "Save" : "Update", AppColor.colPrimary,
                onTap: () {
              if (jobCodeController.text.isEmpty ||
                  labourNameController.text.isEmpty ||
                  mrpController.text.isEmpty) {
                showCustomSnackbar(
                    context, "Please enter Jobcode, Labour Name and MRP");
              } else if (labourGroupId == null || sacCodeId == null) {
                showCustomSnackbar(
                    context, "Please select Labour Group and Sac Code");
              } else {
                postLabour().then((value) => setState(() {}));
              }
            }),
          ],
        ),
      ),
    );
  }

//Post Labour
  Future postLabour() async {
    var response = await ApiService.postData(
        widget.isFirst
            ? 'MasterAW/PostLabourMasterAW'
            : "MasterAW/UpdateLabourByIdAW?Id=${widget.id}",
        {
          "Job_Code": jobCodeController.text.toString(),
          "Labour_Name": labourNameController.text.toString(),
          "Labour_Group_Id": labourGroupId,
          "ModelId": 1,
          "Model_GroupId": 1,
          "BrandId": 1,
          "Sac_Code_Id": sacCodeId,
          "Sac_Code": sacCodeName,
          "Igst": gstPersentage,
          "Cgst": "${int.parse(gstPersentage) / 2}",
          "Sgst": "${int.parse(gstPersentage) / 2}",
          "Cess": "Cess",
          "Mrp": mrpController.text.toString(),
          "Qty": "1",
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
        });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      widget.switchToSecondTab();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//Get category
  Future<void> labourGroupData() async {
    await fetchDataByMiscAdd(105, labourGroupList).then((_) {
      if (labourGroupList.isNotEmpty) {
        setState(() {
          labourGroupId = labourGroupList.first['id'];
        });
      }
    });
  }

//Get Sac List
  Future gstSacData() async {
    var response = await ApiService.fetchData("MasterAW/GetHSNMaster");
    if (response is List) {
      setState(() {
        sacCodeList =
            response.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      throw Exception('Unexpected data format for districts');
    }
  }

  //get labour details
  Future getlabourDetails() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLabourByLabourIdAW?LabourId=${widget.id}");
    mrpController.text = response[0]["mrp"].toString();
    labourNameController.text = response[0]["labour_Name"].toString();
    jobCodeController.text = response[0]["job_Code"].toString();
    gstPersentage = response[0]['igst'].toString();
    labourGroupId = response[0]['labour_Group_Id'];
    sacCodeId = response[0]['sac_Code_Id'];
    sacCodeName = response[0]['sac_Code'];
  }
}
