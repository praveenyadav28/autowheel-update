// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

class LedgerListClass extends StatefulWidget {
  LedgerListClass({required this.groupId, super.key});

  int groupId;
  @override
  State<LedgerListClass> createState() => _LedgerListClassState();
}

class _LedgerListClassState extends State<LedgerListClass> {
  List filteredList = [];

  TextEditingController searchController = TextEditingController();

  //Ledger
  List ledgerList = [];

  //City
  List cityList = [];

  //Group
  List groupList = [];

//Staff
  List staffList = [];

//Balance Type
  List<Map<String, dynamic>> groupTypeList = [
    {'id': 7, 'name': 'Bank Account'},
    {'id': 9, 'name': 'Sundry Creditors'},
    {'id': 10, 'name': 'Sundry Debitors'},
    {'id': 11, 'name': 'Cash In Hand'},
    {"id": 14, "name": "InDirect"},
  ];
  int? selectedgroupId;

  @override
  void initState() {
    selectedgroupId = widget.groupId;
    fatchledger(widget.groupId).then((value) => setState(() {}));
    fetchCity().then((value) => setState(() {}));
    fetchGroup().then((value) => setState(() {}));
    fatchstaff().then((value) => setState(() {}));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = ledgerList.where((value) {
        return value['ledger_Name']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['mob'].toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.height,
      color: AppColor.colPrimary.withOpacity(.1),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02, horizontal: Sizes.width * .02),
        child: Column(
          children: [
            addMasterOutside(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dropdownTextfield(
                    context,
                    "Ledger Type",
                    DropdownButton<int>(
                      underline: Container(),
                      value: selectedgroupId,
                      items: groupTypeList.map((data) {
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
                          fatchledger(selectedId!)
                              .then((value) => setState(() {}));
                          selectedgroupId = selectedId;
                          // Call function to make API request
                        });
                      },
                    ),
                  ),
                ],
              ),
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
              Container(),
            ], context: context),
            Responsive.isMobile(context)
                ? Column(
                    children: List.generate(filteredList.length, (index) {
                      // City
                      int cityId = filteredList[index]['city_Id'];
                      String cityName = cityList.isEmpty
                          ? ""
                          : cityList.firstWhere((element) =>
                              element['city_Id'] == cityId)['city_Name'];

                      //Staff
                      int staffId = filteredList[index]['staff_Id'];
                      String staffName = staffId == 1
                          ? "Admin"
                          : staffList.isEmpty
                              ? ''
                              : staffList.firstWhere((element) =>
                                  element['id'] == staffId)['staff_Name'];
                      return Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              vertical: Sizes.height * 0.01, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColor.colWhite,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(blurRadius: 2, color: AppColor.colGrey)
                            ],
                          ),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: ListTile(
                              minVerticalPadding: 0,
                              horizontalTitleGap: 0,
                              leading: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 7.5),
                                // margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    color: AppColor.colPrimary,
                                    shape: BoxShape.circle),
                                child: Text(
                                  '${index + 1}',
                                  style: rubikTextStyle(
                                      15, FontWeight.w500, AppColor.colWhite),
                                ),
                              ),
                              title: Text(filteredList[index]["ledger_Name"]),
                              trailing: Text(cityName),
                            ),
                            subtitle: ListTile(
                              title: Text(filteredList[index]["mob"]),
                              trailing: Text(staffName),
                            ),
                            trailing: const SizedBox(width: 0, height: 0),
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            children: [
                              widget.groupId == 7
                                  ? Container()
                                  : datastyle("Father's Name",
                                      filteredList[index]['son_Off'], context),
                              datastyle("Address",
                                  filteredList[index]['address'], context),
                              datastyle("Pin Code",
                                  filteredList[index]['pin_Code'], context),
                              datastyle(
                                  "Opening Balance",
                                  "${filteredList[index]['opening_Bal']} ${filteredList[index]['opening_Bal_Combo']}",
                                  context),
                              datastyle(
                                  "Closing Balance",
                                  "${filteredList[index]['closingBal']} ${filteredList[index]['closingBal_Type']}",
                                  context),
                              datastyle("GST Number",
                                  filteredList[index]['gst_No'], context),
                              const Divider(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => AddLedger(
                                              groupId: filteredList[index]
                                                  ['ledger_Group_Id'],
                                              isFirst: false,
                                              id: filteredList[index]
                                                  ['ledger_Id'],
                                              switchToSecondTab: () {},
                                            ),
                                          );
                                        },
                                        child: const Text("Edit",
                                            style: TextStyle(fontSize: 16))),
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Delete Ledger'),
                                                  content: const Text(
                                                      'Are you sure you want to delete ledger ?'),
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
                                                        deleteledgerApi(
                                                                filteredList[
                                                                        index][
                                                                    'ledger_Id'])
                                                            .then((value) {
                                                          fatchledger(
                                                                  selectedgroupId!)
                                                              .then((value) =>
                                                                  setState(() {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }));
                                                        });
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: AppColor
                                                                .colRideFare),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColor.colRideFare),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ));
                    }),
                  )
                : Table(
                    border: TableBorder.all(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor.colBlack),
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: AppColor.colPrimary),
                          children: [
                            tableHeader("Ledger Name"),
                            tableHeader("City"),
                            tableHeader("Mobile Number"),
                            tableHeader("Opening Amount"),
                            tableHeader("Closing Amount"),
                            tableHeader("Action"),
                          ]),
                      ...List.generate(filteredList.length, (index) {
                        // Group
                        int groupId = filteredList[index]['ledger_Group_Id'];

                        // City
                        int cityId = filteredList[index]['city_Id'];
                        String cityName = cityList.isEmpty
                            ? ""
                            : cityList.firstWhere((element) =>
                                element['city_Id'] == cityId)['city_Name'];
                        return TableRow(
                            decoration: BoxDecoration(color: AppColor.colWhite),
                            children: [
                              tableRow(filteredList[index]["ledger_Name"]),
                              tableRow(cityName),
                              tableRow(filteredList[index]["mob"]),
                              tableRow(
                                  "₹ ${filteredList[index]["opening_Bal"]} ${filteredList[index]['opening_Bal_Combo']}"),
                              tableRow(
                                  "₹ ${filteredList[index]["closingBal"]} ${filteredList[index]['closingBal_Type']}"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => AddLedger(
                                            groupId: groupId,
                                            isFirst: false,
                                            id: filteredList[index]
                                                ['ledger_Id'],
                                            switchToSecondTab: () {},
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit,
                                          color: AppColor.colPrimary)),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Delete Ledger'),
                                                content: const Text(
                                                    'Are you sure you want to delete ledger ?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deleteledgerApi(
                                                              filteredList[
                                                                      index]
                                                                  ['ledger_Id'])
                                                          .then((value) {
                                                        fatchledger(
                                                                selectedgroupId!)
                                                            .then((value) =>
                                                                setState(() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }));
                                                      });
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .colRideFare),
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
    );
  }

  //Get ledger List
  Future fatchledger(int groupID) async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=$groupID");
    ledgerList = response;
    filteredList = ledgerList;
  }

  //Delete ledger
  Future deleteledgerApi(int? ledgerId) async {
    var response = await ApiService.postData(
        "MasterAW/DeleteLedgerById?LedgerId=$ledgerId", {});
    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

  // Get City List
  Future fetchCity() async {
    final response = await ApiService.fetchData("MasterAW/GetCityAllDetailsAW");
    cityList = response;
  }

  // Get Group List
  Future fetchGroup() async {
    final response = await ApiService.fetchData("MasterAW/GetLedgerGroup");
    groupList = response;
  }

  //Get staff List
  Future fatchstaff() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetStaffDetailsLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    staffList = response;
  }
}
