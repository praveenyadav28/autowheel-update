// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

class VehicleMaster extends StatefulWidget {
  const VehicleMaster({super.key});
  @override
  State<VehicleMaster> createState() => _VehicleMasterState();
}

class _VehicleMasterState extends State<VehicleMaster> {
  TextEditingController modelCodeController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  TextEditingController modelCodeControllerEdit = TextEditingController();
  TextEditingController modelNameControllerEdit = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //groupList
  List<Map<String, dynamic>> groupList = [];
  int? selectedgroupListId;

  //Vehicle List
  List vehicleList = [];

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  int? ledgerId;
  Map<String, dynamic>? ledgerValue;
  String ledgerName = '';

  List filteredList = [];

  @override
  void initState() {
    fatchVehicle().then((value) => setState(() {
          filteredList = vehicleList;
        }));
    fatchledger().then((value) => setState(() {}));
    groupListData().then((value) => setState(() {
          selectedgroupListId = groupList[0]["id"];
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = vehicleList.where((value) {
        return value['model_Code']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['manufacturer']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['model_Name']
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
          title: const Text("Vehicle Master", overflow: TextOverflow.ellipsis),
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
              addMasterOutside(
                context: context,
                children: [
                  textformfiles(modelNameController, labelText: "Model Name*"),
                  textformfiles(modelCodeController,
                      labelText: "Model Code (Optional)"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: dropdownTextfield(
                        context,
                        "Vehicle Group*",
                        DropdownButton<int>(
                          underline: Container(),
                          value: selectedgroupListId,
                          items: groupList.map((data) {
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
                              selectedgroupListId = selectedId!;
                            });
                          },
                        ),
                      )),
                      const SizedBox(width: 10),
                      addDefaultButton(
                        context,
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGroupScreen(
                                        sourecID: 104,
                                        name: 'Vehicle Group',
                                      ))).then((value) =>
                              groupListData().then((value) => setState(() {})));
                        },
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "Manufacturer*",
                            searchDropDown(
                                context,
                                "Select Manufacturer*",
                                ledgerList
                                    .map((item) => DropdownMenuItem(
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
                                                AppColor.colBlack),
                                          ),
                                        ))
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
                                        .where((item) => item['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a ledger...',
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
                          var result = await pushTo(LedgerMaster(groupId: 9));
                          if (result != null) {
                            ledgerValue = null;
                            fatchledger().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button("Save", AppColor.colPrimary, onTap: () {
                        if (modelNameController.text.isEmpty) {
                          showCustomSnackbar(
                              context, "Please enter Model Name");
                        } else if (ledgerId == null ||
                            selectedgroupListId == null) {
                          showCustomSnackbar(context,
                              "Please select Vehicle Group and Manufacturer");
                        } else {
                          postVehicle();
                        }
                      }),
                    ],
                  )
                ],
              ),
              const Divider(),
              SizedBox(height: Sizes.height * 0.02),
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
              Responsive.isMobile(context)
                  ? Column(
                      children: List.generate(filteredList.length, (index) {
                        //Group
                        int groupId = filteredList[index]['model_GroupId'];
                        String groupName = groupList.isEmpty
                            ? ""
                            : groupList.firstWhere(
                                (element) => element['id'] == groupId)['name'];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Sizes.height * 0.01),
                          decoration: BoxDecoration(
                            color: AppColor.colWhite,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(blurRadius: 2, color: AppColor.colGrey),
                            ],
                          ),
                          child: ListTile(
                            minVerticalPadding: 0,
                            horizontalTitleGap: 0,
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 7.5),
                              decoration: BoxDecoration(
                                  color: AppColor.colPrimary,
                                  shape: BoxShape.circle),
                              child: Text(
                                '${index + 1}',
                                style: rubikTextStyle(
                                    16, FontWeight.w500, AppColor.colWhite),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(filteredList[index]['model_Name']),
                                Text(filteredList[index]['model_Code']),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(groupName,
                                    style: const TextStyle(fontSize: 13)),
                                Text(filteredList[index]['manufacturer'],
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              position: PopupMenuPosition.under,
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 'Edit',
                                  onTap: () {
                                    modelCodeControllerEdit.text =
                                        filteredList[index]['model_Code'];
                                    modelNameControllerEdit.text =
                                        filteredList[index]['model_Name'];
                                    selectedgroupListId =
                                        filteredList[index]['model_GroupId'];
                                    ledgerId =
                                        filteredList[index]['manufacturerId'];
                                    ledgerName =
                                        filteredList[index]['manufacturer'];
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal:
                                                          Sizes.width * .02,
                                                      vertical:
                                                          Sizes.height * 0.02),
                                              title: const Text('Edit Vehicle'),
                                              content: EditVehicle(
                                                  modelCodeControllerEdit:
                                                      modelCodeControllerEdit,
                                                  modelNameControllerEdit:
                                                      modelNameControllerEdit,
                                                  searchController:
                                                      searchController,
                                                  selectedgroupListId:
                                                      selectedgroupListId,
                                                  index: index,
                                                  ledgerId: ledgerId,
                                                  groupList: groupList,
                                                  vehicleList: filteredList,
                                                  ledgerList: ledgerList,
                                                  ledgerName: ledgerName,
                                                  ledgerValue: ledgerValue));
                                        });
                                  },
                                  child: const Text('Edit'),
                                ),
                                PopupMenuItem(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete vehicle'),
                                              content: const Text(
                                                  'Are you sure you want to delete vehicle ?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deletevehicle(
                                                            filteredList[index]
                                                                ['model_Id'])
                                                        .then((_) {
                                                      setState(() {});
                                                      Navigator.of(context)
                                                          .pop();
                                                    }).catchError((error) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Error'),
                                                              content: Text(error
                                                                  .toString()),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    value: 'Delete',
                                    child: const Text('Delete')),
                              ],
                              icon: const Icon(
                                Icons.more_vert,
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  : Table(
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.colBlack),
                      children: [
                        TableRow(
                            decoration:
                                BoxDecoration(color: AppColor.colPrimary),
                            children: [
                              tableHeader("Model Name"),
                              tableHeader("Model Code"),
                              tableHeader("Vehicle Group"),
                              tableHeader("Manufacturer"),
                              tableHeader("Action"),
                            ]),
                        ...List.generate(filteredList.length, (index) {
                          //Group
                          int groupId = filteredList[index]['model_GroupId'];
                          String groupName = groupList.isEmpty
                              ? ""
                              : groupList.firstWhere((element) =>
                                  element['id'] == groupId)['name'];

                          return TableRow(
                              decoration:
                                  BoxDecoration(color: AppColor.colWhite),
                              children: [
                                tableRow(filteredList[index]["model_Name"]),
                                tableRow(filteredList[index]['model_Code']),
                                tableRow(groupName),
                                tableRow(filteredList[index]['manufacturer']),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          modelCodeControllerEdit.text =
                                              filteredList[index]['model_Code'];
                                          modelNameControllerEdit.text =
                                              filteredList[index]['model_Name'];
                                          selectedgroupListId =
                                              filteredList[index]
                                                  ['model_GroupId'];
                                          ledgerId = filteredList[index]
                                              ['manufacturerId'];
                                          ledgerName = filteredList[index]
                                              ['manufacturer'];
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          Sizes.height * 0.02,
                                                      horizontal:
                                                          Sizes.width * 0.02),
                                                  child: EditVehicle(
                                                      modelCodeControllerEdit:
                                                          modelCodeControllerEdit,
                                                      modelNameControllerEdit:
                                                          modelNameControllerEdit,
                                                      searchController:
                                                          searchController,
                                                      selectedgroupListId:
                                                          selectedgroupListId,
                                                      index: index,
                                                      ledgerId: ledgerId,
                                                      groupList: groupList,
                                                      vehicleList: filteredList,
                                                      ledgerList: ledgerList,
                                                      ledgerName: ledgerName,
                                                      ledgerValue: ledgerValue),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit,
                                            color: AppColor.colPrimary)),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Delete vehicle'),
                                                  content: const Text(
                                                      'Are you sure you want to delete vehicle ?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        deletevehicle(
                                                                filteredList[
                                                                        index][
                                                                    'model_Id'])
                                                            .then((_) {
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        }).catchError((error) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Error'),
                                                                  content: Text(
                                                                      error
                                                                          .toString()),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.delete,
                                            color: AppColor.colRideFare)),
                                  ],
                                )
                              ]);
                        })
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  //fatch vehicle list
  Future fatchVehicle() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetVehicleMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    vehicleList = response;
  }

//Add Vehicle
  Future postVehicle() async {
    var response = await ApiService.postData('MasterAW/PostVehicleMasterAW', {
      "Model_Code": modelCodeController.text.toString(),
      "Model_Name": modelNameController.text.toString(),
      "ModelDescription": "ModelDescription",
      "Model_Group": "Model_Group",
      "Manufacturer": ledgerName,
      "Model_GroupId": selectedgroupListId,
      "ManufacturerId": ledgerId,
      "BrandId": 1,
      "WithBattery": "WithBattery",
      "Discontinue": "Discontinue",
      "TradeCertNo": "TradeCertNo",
      "FuelCapacity": "FuelCapacity",
      "PurchasePrice": "PurchasePrice",
      "ExShowRoomPrice": "ExShowRoomPrice",
      "HsnCodeId": 1,
      "HsnCode": "HsnCode",
      "Igst": "Igst",
      "Cgst": "Cgst",
      "Sgst": "Sgst",
      "Cess": "Cess",
      "RegdAmount": "RegdAmount",
      "InsuranceAmount": "InsuranceAmount",
      "HpaAmount": "HpaAmount",
      "AgreementAmount": "AgreementAmount",
      "AcessAmount": "AcessAmount",
      "OtherAmount": "OtherAmount",
      "Discount": "Discount",
      "VehicleDes1": "VehicleDes1",
      "VehicleDes2": "VehicleDes2",
      "VehicleDes3": "VehicleDes3",
      "VehicleDes4": "VehicleDes4",
      "VehicleDes5": "VehicleDes5",
      "SubcidyAplicableStatus": 1,
      "SubcidyInvoiceManualPriceStatus": 1,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "Update Data");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=9");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
  }

//Vehicle Group
  Future<void> groupListData() async {
    await fetchDataByMiscAdd(104, groupList);
  }

//Delete Vehicle
  Future<void> deletevehicle(int vehicleId) async {
    var response = await ApiService.postData(
        "MasterAW/DeleteVehicleMasterByIdAW?Id=$vehicleId", {});
    if (response['status'] == false) {
      throw Exception(response['message']);
    } else {
      fatchVehicle().then((value) => setState(() {
            filteredList = vehicleList;
          }));
    }
  }
}

class EditVehicle extends StatefulWidget {
  EditVehicle({
    super.key,
    required this.modelCodeControllerEdit,
    required this.modelNameControllerEdit,
    required this.searchController,
    required this.selectedgroupListId,
    required this.index,
    required this.ledgerId,
    required this.groupList,
    required this.vehicleList,
    required this.ledgerList,
    required this.ledgerName,
    required this.ledgerValue,
  });
  TextEditingController modelNameControllerEdit;
  TextEditingController modelCodeControllerEdit;
  TextEditingController searchController;
  int? selectedgroupListId;
  int? ledgerId;
  int index;
  List<Map<String, dynamic>> groupList;
  List vehicleList;
  List<Map<String, dynamic>> ledgerList;
  Map<String, dynamic>? ledgerValue;
  String ledgerName = '';

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  @override
  void initState() {
    fatchVehicle().then((value) => setState(() {}));
    fatchledger().then((value) => setState(() {}));
    groupListData().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return addMasterOutside(
      context: context,
      children: [
        textformfiles(widget.modelNameControllerEdit, labelText: "Model Name"),
        textformfiles(widget.modelCodeControllerEdit, labelText: "Model"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: dropdownTextfield(
              context,
              "Vehicle Group*",
              DropdownButton<int>(
                underline: Container(),
                value: widget.selectedgroupListId,
                items: widget.groupList.map((data) {
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
                    widget.selectedgroupListId = selectedId!;
                    setState(() {});
                  });
                },
              ),
            )),
            const SizedBox(width: 10),
            addDefaultButton(
              context,
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddGroupScreen(
                              sourecID: 104,
                              name: 'Vehicle Group',
                            ))).then((value) =>
                    groupListData().then((value) => setState(() {})));
              },
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: dropdownTextfield(
                  context,
                  "Manufacturer",
                  searchDropDown(
                      context,
                      widget.ledgerName,
                      widget.ledgerList
                          .map((item) => DropdownMenuItem(
                                onTap: () {
                                  widget.ledgerId = item['id'];
                                  widget.ledgerName = item['name'];
                                },
                                value: item,
                                child: Text(
                                  item['name'].toString(),
                                  style: rubikTextStyle(
                                      14, FontWeight.w500, AppColor.colBlack),
                                ),
                              ))
                          .toList(),
                      widget.ledgerValue,
                      (value) {
                        setState(() {
                          widget.ledgerValue = value!;
                        });
                      },
                      widget.searchController,
                      (value) {
                        setState(() {
                          widget.ledgerList
                              .where((item) => item['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      'Search for a ledger...',
                      (isOpen) {
                        if (!isOpen) {
                          widget.searchController.clear();
                        }
                      })),
            ),
            const SizedBox(width: 10),
            addDefaultButton(
              context,
              () async {
                var result = await pushTo(LedgerMaster(groupId: 9));
                if (result != null) {
                  widget.ledgerValue = null;
                  fatchledger().then((value) => setState(() {}));
                }
              },
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button("Update", AppColor.colPrimary, onTap: () {
              editVehicle(widget.vehicleList[widget.index]['model_Id']);
            }),
          ],
        )
      ],
    );
  }

//Edit Vehicle
  Future editVehicle(int? id) async {
    var response =
        await ApiService.postData('MasterAW/UpdateVehicleMasterByIdAW?Id=$id', {
      "Model_Code": widget.modelCodeControllerEdit.text.toString(),
      "Model_Name": widget.modelNameControllerEdit.text.toString(),
      "ModelDescription": "ModelDescription",
      "Model_Group": "Model_Group",
      "Manufacturer": widget.ledgerName,
      "Model_GroupId": widget.selectedgroupListId,
      "ManufacturerId": widget.ledgerId,
      "BrandId": 1,
      "WithBattery": "WithBattery",
      "Discontinue": "Discontinue",
      "TradeCertNo": "TradeCertNo",
      "FuelCapacity": "FuelCapacity",
      "PurchasePrice": "PurchasePrice",
      "ExShowRoomPrice": "ExShowRoomPrice",
      "HsnCodeId": 1,
      "HsnCode": "HsnCode",
      "Igst": "Igst",
      "Cgst": "Cgst",
      "Sgst": "Sgst",
      "Cess": "Cess",
      "RegdAmount": "RegdAmount",
      "InsuranceAmount": "InsuranceAmount",
      "HpaAmount": "HpaAmount",
      "AgreementAmount": "AgreementAmount",
      "AcessAmount": "AcessAmount",
      "OtherAmount": "OtherAmount",
      "Discount": "Discount",
      "VehicleDes1": "VehicleDes1",
      "VehicleDes2": "VehicleDes2",
      "VehicleDes3": "VehicleDes3",
      "VehicleDes4": "VehicleDes4",
      "VehicleDes5": "VehicleDes5",
      "SubcidyAplicableStatus": 1,
      "SubcidyInvoiceManualPriceStatus": 1,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      fatchVehicle().then((value) => setState(() {
            Navigator.pop(context);
          }));
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  //fatch vehicle list
  Future fatchVehicle() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetVehicleMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    widget.vehicleList = response;
  }

//Vehicle Group
  Future<void> groupListData() async {
    await fetchDataByMiscAdd(104, widget.groupList);
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=9");

    widget.ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
  }
}
