// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

class CityMaster extends StatefulWidget {
  const CityMaster({super.key});
  @override
  State<CityMaster> createState() => _CityMasterState();
}

class _CityMasterState extends State<CityMaster> {
  TextEditingController cityController = TextEditingController();
  TextEditingController cityControllerEdit = TextEditingController();
  TextEditingController searchController = TextEditingController();
//City
  List cityList = [];

  //District
  List<Map<String, dynamic>> districtList = [];
  int? districtId;
  Map<String, dynamic>? districtValue;

  int selectedIndex = -1;

  String stateName = "Unknown";
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
  int stateId = 0;

  List filteredList = [];

  @override
  void initState() {
    fetchDistrict().then((value) => setState(() {}));
    fatchCity().then((value) => setState(() {
          filteredList = cityList;
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = cityList.where((value) {
        return value['city_Name']
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
          title: const Text("City", overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: districtList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: Sizes.height,
              color: AppColor.colPrimary.withOpacity(.1),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.height * 0.02,
                    horizontal: Sizes.width * .03),
                child: Column(
                  children: [
                    addMasterOutside(context: context, children: [
                      textformfiles(cityController, labelText: "City"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: dropdownTextfield(
                                context,
                                "District",
                                searchDropDown(
                                    context,
                                    "Select District",
                                    districtList
                                        .map((item) => DropdownMenuItem(
                                              onTap: () {
                                                setState(() {
                                                  districtId =
                                                      item['district_Id'];
                                                  stateId = item['state_Id'];
                                                  stateName =
                                                      getStateNameById();
                                                });
                                              },
                                              value: item,
                                              child: Text(
                                                item['district_Name']
                                                    .toString(),
                                                style: rubikTextStyle(
                                                    16,
                                                    FontWeight.w500,
                                                    AppColor.colBlack),
                                              ),
                                            ))
                                        .toList(),
                                    districtValue,
                                    (value) {
                                      setState(() {
                                        districtValue = value;
                                      });
                                    },
                                    searchController,
                                    (value) {
                                      setState(() {
                                        districtList
                                            .where((item) =>
                                                item['district_Name']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        value.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                    'Search for a District...',
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
                              var result = await pushTo(const DistrictMaster());
                              if (result != null) {
                                districtValue = null;
                                fetchDistrict()
                                    .then((value) => setState(() {}));
                              }
                            },
                          )
                        ],
                      ),
                      ReuseContainer(title: "State", subtitle: stateName),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          button("Save", AppColor.colPrimary, onTap: () {
                            if (cityController.text.isEmpty) {
                              showCustomSnackbar(context, "Please enter city");
                            } else if (districtId == null) {
                              showCustomSnackbar(
                                  context, "Please select district");
                            } else {
                              postCity().then((value) => setState(() {
                                    fatchCity().then((value) => setState(() {
                                          filteredList = cityList;
                                        }));
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
                          border:
                              Border.all(color: AppColor.colBlack, width: .5)),
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
                              'City Name',
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
                            flex: 2,
                            child: Text(
                              'Action',
                              style: rubikTextStyle(
                                  16, FontWeight.w600, AppColor.colBlack),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColor.colWhite,
                          border:
                              Border.all(color: AppColor.colBlack, width: .5)),
                      height: 200,
                      child: filteredList.isEmpty
                          ? const Center(child: Text("No data found"))
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children:
                                    List.generate(filteredList.length, (index) {
                                  //District
                                  int districtID =
                                      filteredList[index]['district_Id'];
                                  String districtName = districtList.firstWhere(
                                      (element) =>
                                          element['district_Id'] ==
                                          districtID)['district_Name'];
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: selectedIndex == index
                                            ? AppColor.colPrimary.withOpacity(1)
                                            : AppColor.colWhite,
                                        border: Border.all(
                                          color: AppColor.colPrimary
                                              .withOpacity(.08),
                                        )),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
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
                                              filteredList[index]["city_Name"],
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              districtName,
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
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              PopupMenuItem(
                                                  value: 'Edit',
                                                  onTap: () {
                                                    cityControllerEdit.text =
                                                        filteredList[index]
                                                            ["city_Name"];
                                                    districtID =
                                                        filteredList[index]
                                                            ['district_Id'];
                                                    districtName =
                                                        filteredList[index]
                                                            ['district_Name'];
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                              insetPadding:
                                                                  const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10),
                                                              contentPadding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Sizes.width *
                                                                          .02,
                                                                  vertical:
                                                                      Sizes.height *
                                                                          0.02),
                                                              title: const Text(
                                                                  'Edit City'),
                                                              content: EditCity(
                                                                  cityControllerEdit:
                                                                      cityControllerEdit,
                                                                  searchController:
                                                                      searchController,
                                                                  districtName:
                                                                      districtName,
                                                                  stateName:
                                                                      stateName,
                                                                  districtList:
                                                                      districtList,
                                                                  cityList:
                                                                      filteredList,
                                                                  districtId:
                                                                      districtId,
                                                                  index: index,
                                                                  stateId:
                                                                      stateId,
                                                                  districtValue:
                                                                      districtValue));
                                                        });
                                                  },
                                                  child: const Text('Edit')),
                                              PopupMenuItem(
                                                  value: 'Delete',
                                                  onTap: () {
                                                    deletecityApi(
                                                            filteredList[index]
                                                                ["city_Id"])
                                                        .then((value) =>
                                                            fatchCity().then(
                                                                (value) =>
                                                                    setState(
                                                                        () {
                                                                      filteredList =
                                                                          filteredList;
                                                                    })));
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

// Get District List
  Future fetchDistrict() async {
    final response = await ApiService.fetchData("MasterAW/GetDistrictAW");

    if (response is List) {
      // Assuming it's a list, convert each item to a Map
      districtList =
          response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for districts');
    }
  }

//Add City
  Future postCity() async {
    var response = await ApiService.postData('MasterAW/PostCityAW', {
      "City_Name": cityController.text.toString(),
      "District_Id": districtId,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "Refresh Data");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//Update City
  Future updateCity(id) async {
    var response =
        await ApiService.postData('MasterAW/UpdateCityByIdAW?Id=$id', {
      "City_Name": cityController.text.toString(),
      "District_Id": districtId,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "Refresh Data");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//State Name
  String getStateNameById() {
    // Find the state in the list
    final state = statesList.firstWhere((element) => element['id'] == stateId,
        orElse: () => {"id": -1, "name": "Unknown"});
    return state['name'];
  }

  //Get City List
  Future fatchCity() async {
    var response = await ApiService.fetchData("MasterAW/GetCityAllDetailsAW");
    cityList = response;
  }

  //Delete City
  Future deletecityApi(int? cityId) async {
    var response =
        await ApiService.postData("MasterAW/DeleteCityByIdAW?Id=$cityId", {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }
}

class EditCity extends StatefulWidget {
  EditCity({
    super.key,
    required this.cityControllerEdit,
    required this.searchController,
    required this.districtName,
    required this.stateName,
    required this.districtList,
    required this.cityList,
    required this.districtId,
    required this.index,
    required this.stateId,
    required this.districtValue,
  });

  TextEditingController cityControllerEdit;
  TextEditingController searchController;
  String districtName = '';
  String stateName = '';
  List<Map<String, dynamic>> districtList;
  List cityList;
  int? districtId;
  int? index;
  int? stateId;
  Map<String, dynamic>? districtValue;
  @override
  State<EditCity> createState() => _EditCityState();
}

class _EditCityState extends State<EditCity> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.width,
      child: addMasterOutside(context: context, children: [
        textformfiles(widget.cityControllerEdit, labelText: "City"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: dropdownTextfield(
                  context,
                  "District",
                  searchDropDown(
                      context,
                      widget.districtName,
                      widget.districtList
                          .map((item) => DropdownMenuItem(
                                onTap: () {
                                  setState(() {
                                    widget.districtId = item['district_Id'];
                                    widget.stateId = item['state_Id'];
                                  });
                                },
                                value: item,
                                child: Text(
                                  item['district_Name'].toString(),
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              ))
                          .toList(),
                      widget.districtValue,
                      (value) {
                        setState(() {
                          widget.districtValue = value;
                        });
                      },
                      widget.searchController,
                      (value) {
                        setState(() {
                          widget.districtList
                              .where((item) => item['district_Name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      'Search for a District...',
                      (isOpen) {
                        if (!isOpen) {
                          widget.searchController.clear();
                        }
                      })),
            ),
            const SizedBox(width: 10),
            addDefaultButton(context, () async {
              var result = await pushTo(const DistrictMaster());
              if (result != null) {
                widget.districtValue = null;
                fetchDistrict().then((value) => setState(() {}));
              }
            })
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button("Update", AppColor.colPrimary, onTap: () {
              if (widget.cityControllerEdit.text.isEmpty) {
                showCustomSnackbar(context, "Please enter city");
              } else if (widget.districtId == null) {
                showCustomSnackbar(context, "Please select district");
              } else {
                updateCity(widget.cityList[widget.index!]["city_Id"])
                    .then((value) => setState(() {
                          Navigator.pop(context);
                          widget.cityControllerEdit.clear();
                          widget.districtValue = null;
                          fatchCity().then((value) => setState(() {
                                widget.cityControllerEdit.clear();
                              }));
                        }));
              }
            })
          ],
        )
      ]),
    );
  }

// Get District List
  Future fetchDistrict() async {
    final response = await ApiService.fetchData("MasterAW/GetDistrictAW");

    if (response is List) {
      // Assuming it's a list, convert each item to a Map
      widget.districtList =
          response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for districts');
    }
  }

  //Get City List
  Future fatchCity() async {
    var response = await ApiService.fetchData("MasterAW/GetCityAllDetailsAW");
    widget.cityList = response;
  }

//Update City
  Future updateCity(id) async {
    var response =
        await ApiService.postData('MasterAW/UpdateCityByIdAW?Id=$id', {
      "City_Name": widget.cityControllerEdit.text.toString(),
      "District_Id": widget.districtId,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "Refresh Data");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }
}
