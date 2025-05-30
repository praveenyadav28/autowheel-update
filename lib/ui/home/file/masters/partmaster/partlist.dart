// ignore_for_file: use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class PartListClass extends StatefulWidget {
  const PartListClass({
    super.key,
  });

  @override
  State<PartListClass> createState() => _PartListClassState();
}

class _PartListClassState extends State<PartListClass> {
  //Part
  List partList = [];

  List filteredList = [];

  TextEditingController searchController = TextEditingController();

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];

  //groupList
  List<Map<String, dynamic>> groupList = [];

//HSN Type
  List<Map<String, dynamic>> hsnCodeList = [];

  @override
  void initState() {
    fatchpart().then((value) => setState(() {
          filteredList = partList;
        }));
    fatchledger().then((value) => setState(() {}));
    gstHsnData().then((value) => setState(() {}));
    groupListData().then((value) => setState(() {}));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = partList.where((value) {
        // Ledger
        int ledgerId = value['manufacturer_Id'];
        String ledgerName = ledgerList.isEmpty
            ? ""
            : ledgerList
                .firstWhere((element) => element['id'] == ledgerId)['name'];
        return ledgerName.toLowerCase().contains(searchText.toLowerCase()) ||
            value['item_Name']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['item_Des'].toLowerCase().contains(searchText.toLowerCase());
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
                        // Manufacturer
                        int ledgerId = filteredList[index]['manufacturer_Id'];
                        String ledgerName = ledgerList.isEmpty
                            ? ""
                            : ledgerList.firstWhere(
                                (element) => element['id'] == ledgerId)['name'];

                        // Group
                        int groupId = filteredList[index]['group_Id'];
                        String groupName = groupList.isEmpty
                            ? ""
                            : groupList.firstWhere(
                                (element) => element['id'] == groupId)['name'];

                        // HSN
                        int hsnId = filteredList[index]['hsn_Id'];
                        String hsnName = hsnCodeList.isEmpty
                            ? ""
                            : hsnCodeList.firstWhere((element) =>
                                element['hsn_Id'] == hsnId)['hsn_Code'];
                        return Container(
                            margin:
                                EdgeInsets.only(bottom: Sizes.height * 0.02),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.colWhite,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2, color: AppColor.colGrey)
                              ],
                            ),
                            child: ExpansionTile(
                              dense: true,
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
                                title: Text(filteredList[index]["item_Name"]),
                                trailing:
                                    Text("₹ ${filteredList[index]['mrp']}"),
                              ),
                              subtitle: ListTile(
                                  title: Text(filteredList[index]['bin_No']),
                                  trailing: Text(
                                      "${filteredList[index]['stock_Qty']} UNIT")),
                              trailing: const SizedBox(width: 0, height: 0),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              children: [
                                const Divider(),
                                datastyle("GST",
                                    "${filteredList[index]['gst']} %", context),
                                datastyle(
                                    "Profit  Margin",
                                    "${filteredList[index]['margin']} %",
                                    context),
                                datastyle(
                                    "Discount",
                                    "${filteredList[index]['discount']} %",
                                    context),
                                datastyle("NDP",
                                    "${filteredList[index]['ndp']}", context),
                                datastyle(
                                    "Opening Stock",
                                    "${filteredList[index]['opening_Stock']}",
                                    context),
                                datastyle("Manufacturer", ledgerName, context),
                                datastyle("Group", groupName, context),
                                datastyle("HSN Code", hsnName, context),
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
                                              builder: (context) => AddParts(
                                                isFirst: false,
                                                id: filteredList[index]
                                                    ['item_Id'],
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete part'),
                                                    content: const Text(
                                                        'Are you sure you want to delete part ?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deletepartApi(
                                                                  filteredList[
                                                                          index]
                                                                      [
                                                                      'item_Id'])
                                                              .then((value) {
                                                            fatchpart().then(
                                                                (value) =>
                                                                    setState(
                                                                        () {
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
                            decoration:
                                BoxDecoration(color: AppColor.colPrimary),
                            children: [
                              tableHeader("Part Name"),
                              tableHeader("Part Number"),
                              tableHeader("Price"),
                              tableHeader("Stock"),
                              tableHeader("Manufacturer"),
                              tableHeader("Group"),
                              tableHeader("Action"),
                            ]),
                        ...List.generate(filteredList.length, (index) {
                          // Manufacturer
                          int ledgerId = filteredList[index]['manufacturer_Id'];
                          String ledgerName = ledgerList.isEmpty
                              ? ""
                              : ledgerList.firstWhere((element) =>
                                  element['id'] == ledgerId)['name'];

                          // Group
                          int groupId = filteredList[index]['group_Id'];
                          String groupName = groupList.isEmpty
                              ? ""
                              : groupList.firstWhere((element) =>
                                  element['id'] == groupId)['name'];

                          return TableRow(
                              decoration:
                                  BoxDecoration(color: AppColor.colWhite),
                              children: [
                                tableRow(filteredList[index]["item_Name"]),
                                tableRow(filteredList[index]['item_Des']),
                                tableRow("${filteredList[index]["mrp"]}"),
                                tableRow("${filteredList[index]['stock_Qty']}"),
                                tableRow(ledgerName),
                                tableRow(groupName),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => AddParts(
                                              isFirst: false,
                                              id: filteredList[index]
                                                  ['item_Id'],
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
                                                      const Text('Delete part'),
                                                  content: const Text(
                                                      'Are you sure you want to delete part ?'),
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
                                                        deletepartApi(
                                                                filteredList[
                                                                        index]
                                                                    ['item_Id'])
                                                            .then((value) {
                                                          fatchpart().then(
                                                              (value) =>
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
          )),
    );
  }

  //Get part List
  Future fatchpart() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetItemByLocationId?LocationId=${Preference.getString(PrefKeys.locationId)}");
    partList = response;
    filteredList = partList;
  }

  //Delete part
  Future deletepartApi(int? partId) async {
    var response =
        await ApiService.postData("MasterAW/DeleteItem?ItemId=$partId", {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
      fatchpart().then((value) => setState(() {}));
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=9,10");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
  }

//Get Hsn List
  Future<void> gstHsnData() async {
    var response = await ApiService.fetchData("MasterAW/GetHSNMaster");
    if (response is List) {
      hsnCodeList =
          response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for districts');
    }
  }

//Part Group
  Future<void> groupListData() async {
    await fetchDataByMiscAdd(101, groupList);
  }
}
