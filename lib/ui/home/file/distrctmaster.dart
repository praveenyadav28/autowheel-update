// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:autowheel_workshop/utils/components/library.dart';

class DistrictMaster extends StatefulWidget {
  const DistrictMaster({super.key});
  @override
  State<DistrictMaster> createState() => _DistrictMasterState();
}

class _DistrictMasterState extends State<DistrictMaster> {
  TextEditingController districtController = TextEditingController();
  TextEditingController districtControllerEdit = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List filteredList = [];

  //State
  List<Map<String, dynamic>> statesList = [
    {"id": 11, "name": "ANDAMAN AND NICOBAR ISLANDS"},
    {"id": 10, "name": "ANDHRA PRADESH(Old)"},
    {"id": 39, "name": "Andhra Pradesh (New)"},
    {"id": 12, "name": "ARUNACHAL PRADESH"},
    {"id": 7, "name": "ASSAM"},
    {"id": 13, "name": "BIHAR"},
    {"id": 14, "name": "CHANDIGARH"},
    {"id": 15, "name": "CHHATTISGARH"},
    {"id": 16, "name": "Dadra and Nagar Haveli and Daman and Diu"},
    {"id": 17, "name": "DAMAN AND DIU"},
    {"id": 18, "name": "DELHI"},
    {"id": 20, "name": "GUJARAT"},
    {"id": 3, "name": "HARYANA"},
    {"id": 21, "name": "HIMACHAL PRADESH"},
    {"id": 22, "name": "JAMMU AND KASHMIR"},
    {"id": 23, "name": "JHARKHAND"},
    {"id": 24, "name": "KARNATAKA"},
    {"id": 25, "name": "KERALA"},
    {"id": 26, "name": "LAKSHADWEEP"},
    {"id": 40, "name": "LADAKH (NEWLY ADDED)"},
    {"id": 27, "name": "MANIPUR"},
    {"id": 28, "name": "MEGHALAYA"},
    {"id": 29, "name": "MIZORAM"},
    {"id": 2, "name": "MADHYA PRADESH"},
    {"id": 9, "name": "MAHARASHTRA"},
    {"id": 30, "name": "NAGALAND"},
    {"id": 8, "name": "ODISHA"},
    {"id": 31, "name": "PUDUCHERRY"},
    {"id": 6, "name": "PUNJAB"},
    {"id": 1, "name": "RAJASTHAN"},
    {"id": 32, "name": "SIKKIM"},
    {"id": 33, "name": "TAMIL NADU"},
    {"id": 34, "name": "TELANGANA"},
    {"id": 35, "name": "TRIPURA"},
    {"id": 37, "name": "UTTARAKHAND"},
    {"id": 36, "name": "UTTAR PRADESH"},
    {"id": 38, "name": "WEST BENGAL"},
    {"id": 41, "name": "OTHER TERRITORY"},
    {"id": 42, "name": "CENTRE JURISDICTION"}
  ];
  int? stateId;
  Map<String, dynamic>? stateValue;

  //District List
  List districtLists = [];
  int selectedIndex = -1;

  @override
  void initState() {
    fatchDistrict().then((value) => setState(() {
          filteredList = districtLists;
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = districtLists.where((value) {
        return value['district_Name']
            .toLowerCase()
            .contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, "Update Data");
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("District", overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        height: Sizes.height,
        color: AppColor.colPrimary.withOpacity(.1),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
          child: Column(
            children: [
              addMasterOutside(context: context, children: [
                textformfiles(districtController, labelText: "District"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropdownTextfield(
                        context,
                        "State",
                        searchDropDown(
                            context,
                            "Select State",
                            statesList
                                .map((item) => DropdownMenuItem(
                                      onTap: () {
                                        stateId = item['id'];
                                      },
                                      value: item,
                                      child: Text(
                                        item['name'].toString(),
                                        style: rubikTextStyle(14,
                                            FontWeight.w500, AppColor.colBlack),
                                      ),
                                    ))
                                .toList(),
                            stateValue,
                            (value) {
                              setState(() {
                                stateValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                statesList
                                    .where((item) => item['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            'Search for a State...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            })),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    button("Save", AppColor.colPrimary, onTap: () {
                      if (districtController.text.isEmpty) {
                        showCustomSnackbar(
                            context, "Please enter District Name");
                      } else if (stateId == null) {
                        showCustomSnackbar(context, "Please select State");
                      } else {
                        postDistrict().then((value) => setState(() {
                              fatchDistrict().then((value) => setState(() {}));
                            }));
                      }
                    })
                  ],
                )
              ]),
              addMasterOutside(children: [
                Container(),
                Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textformfiles(searchController,
                        onChanged: (value) => filterList(value),
                        labelText: 'Search',
                        suffixIcon: Icon(
                          Icons.search,
                          size: 30,
                          color: AppColor.colBlack,
                        )),
                  ],
                ),
              ], context: context),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColor.colWhite,
                    border: Border.all(color: AppColor.colBlack, width: .5)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Sr. No.',
                        style: rubikTextStyle(
                            16, FontWeight.w600, AppColor.colBlack),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'District Name',
                        style: rubikTextStyle(
                            16, FontWeight.w600, AppColor.colBlack),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'State Name',
                        style: rubikTextStyle(
                            16, FontWeight.w600, AppColor.colBlack),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Action',
                          style: rubikTextStyle(
                              16, FontWeight.w600, AppColor.colBlack),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColor.colWhite,
                    border: Border.all(color: AppColor.colBlack, width: .5)),
                margin: EdgeInsets.only(bottom: Sizes.height * 0.02),
                height: 200,
                child: filteredList.isEmpty
                    ? const Center(child: Text("No data found"))
                    : SingleChildScrollView(
                        child: Column(
                          children: List.generate(filteredList.length, (index) {
                            //State
                            int stateId = filteredList[index]['state_Id'];
                            String stateName = statesList.firstWhere(
                                (element) => element['id'] == stateId)['name'];
                            return Container(
                              decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? AppColor.colPrimary.withOpacity(1)
                                      : AppColor.colWhite,
                                  border: Border.all(
                                    color: AppColor.colPrimary.withOpacity(.08),
                                  )),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${index + 1}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        filteredList[index]["district_Name"],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        stateName,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: PopupMenuButton(
                                      onOpened: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      onCanceled: () {
                                        setState(() {
                                          selectedIndex = -1;
                                        });
                                      },
                                      position: PopupMenuPosition.under,
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                            value: 'Edit',
                                            onTap: () {
                                              districtControllerEdit.text =
                                                  filteredList[index]
                                                      ["district_Name"];
                                              stateId = filteredList[index]
                                                  ['state_Id'];
                                              stateName = filteredList[index]
                                                  ['state_Name'];
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal:
                                                                    Sizes.width *
                                                                        .02,
                                                                vertical:
                                                                    Sizes
                                                                            .height *
                                                                        0.02),
                                                        title: const Text(
                                                            'Edit District'),
                                                        content: EditDistrict(
                                                            stateName:
                                                                stateName,
                                                            districtControllerEdit:
                                                                districtControllerEdit,
                                                            searchController:
                                                                searchController,
                                                            statesList:
                                                                statesList,
                                                            stateId: stateId,
                                                            stateValue:
                                                                stateValue,
                                                            districtList:
                                                                filteredList,
                                                            index: index));
                                                  });
                                            },
                                            child: const Text('Edit')),
                                        PopupMenuItem(
                                            value: 'Delete',
                                            onTap: () {
                                              deleteDistrictApi(
                                                      filteredList[index]
                                                          ["district_Id"])
                                                  .then((value) =>
                                                      fatchDistrict().then(
                                                          (value) =>
                                                              setState(() {})));
                                            },
                                            child: const Text('Delete')),
                                      ],
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Add District
  Future postDistrict() async {
    var response = await ApiService.postData('MasterAW/PostDistrictAW', {
      "District_Name": districtController.text.toString(),
      "State_Id": stateId,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "Refresh Data");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  //Delete District
  Future deleteDistrictApi(int? districtgggId) async {
    var response = await ApiService.postData(
        "MasterAW/DeleteDistrictByIdAW?Id=$districtgggId", {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

  //Get District
  Future fatchDistrict() async {
    var response = await ApiService.fetchData("MasterAW/GetDistrictAW");
    districtLists = response;
  }
}

class EditDistrict extends StatefulWidget {
  EditDistrict({
    super.key,
    required this.districtControllerEdit,
    required this.searchController,
    required this.statesList,
    required this.stateId,
    required this.stateName,
    required this.stateValue,
    required this.districtList,
    required this.index,
  });

  TextEditingController districtControllerEdit;
  TextEditingController searchController;
  List<Map<String, dynamic>> statesList;
  int? stateId;
  String stateName;
  Map<String, dynamic>? stateValue;
  List districtList;
  int? index;
  @override
  State<EditDistrict> createState() => _EditDistrictState();
}

class _EditDistrictState extends State<EditDistrict> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.width,
      child: addMasterOutside(context: context, children: [
        textformfiles(widget.districtControllerEdit, labelText: "District"),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dropdownTextfield(
                context,
                "State",
                searchDropDown(
                    context,
                    widget.stateName,
                    widget.statesList
                        .map((item) => DropdownMenuItem(
                              onTap: () {
                                widget.stateId = item['id'];
                              },
                              value: item,
                              child: Text(
                                item['name'].toString(),
                                style: rubikTextStyle(
                                    14, FontWeight.w500, AppColor.colBlack),
                              ),
                            ))
                        .toList(),
                    widget.stateValue,
                    (value) {
                      setState(() {
                        widget.stateValue = value;
                      });
                    },
                    widget.searchController,
                    (value) {
                      setState(() {
                        widget.statesList
                            .where((item) => item['name']
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    'Search for a State...',
                    (isOpen) {
                      if (!isOpen) {
                        widget.searchController.clear();
                      }
                    })),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button("Update", AppColor.colPrimary, onTap: () {
              if (widget.districtControllerEdit.text.isEmpty) {
                showCustomSnackbar(context, "Please enter District Name");
              } else if (widget.stateId == 0) {
                showCustomSnackbar(context, "Please select State");
              } else {
                updateDistrict(
                        widget.districtList[widget.index!]["district_Id"])
                    .then((value) => setState(() {
                          fatchDistrict().then((value) => setState(() {
                                widget.districtControllerEdit.clear();
                                Navigator.pop(context);
                              }));
                        }));
              }
            })
          ],
        )
      ]),
    );
  }

  //Get District
  Future fatchDistrict() async {
    var response = await ApiService.fetchData("MasterAW/GetDistrictAW");
    widget.districtList = response;
  }

//Update District
  Future updateDistrict(id) async {
    var response =
        await ApiService.postData('MasterAW/UpdateDistrictByIdAW?Id=$id', {
      "District_Name": widget.districtControllerEdit.text.toString(),
      "State_Id": widget.stateId,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }
}
