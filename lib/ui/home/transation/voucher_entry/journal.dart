import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // Date
  TextEditingController journalDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

//HSN Type
  List<Map<String, dynamic>> hsnCodeList = [];
  int? hsnCodeId;
  Map<String, dynamic>? hsnCodeValue;
  String hsnCodeName = '';
//Gst
  String gstPersentage = '0';
  double gstAmount = 0.0;
  double taxableAmount = 0.0;

//Party Details
  List<Map<String, dynamic>> creditPartyList = [];
  String creditPartyName = '';
  String creditPartyBalance = '';
  Map<String, dynamic>? creditPartyValue;
  int? creditPartyId;

  List<Map<String, dynamic>> debitPartyList = [];
  String debitPartyName = '';
  String debitPartyBalance = '';
  Map<String, dynamic>? debitPartyValue;
  int? debitPartyId;

  //Controller
  TextEditingController journalController = TextEditingController();
  TextEditingController creditamountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> creditParties = [];

  @override
  void initState() {
    fatchledger().then((value) => setState(() {}));
    gstHsnData().then((value) => setState(() {}));
    super.initState();
  }

  void calculateGST() {
    double amount = double.tryParse(creditamountController.text) ?? 0.0;
    double gstPercentage = double.tryParse(gstPersentage) ?? 0.0;

    if (gstPercentage > 0) {
      setState(() {
        taxableAmount = amount / (1 + gstPercentage / 100);
        gstAmount = amount - taxableAmount;
      });
    } else {
      setState(() {
        gstAmount = 0.0;
        taxableAmount = amount;
      });
    }

    // taxableAmount = amount / (1 + gstPercentage);
    // gstAmount = amount - taxableAmount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: const Text("Journal", overflow: TextOverflow.ellipsis),
            backgroundColor: AppColor.colPrimary),
        backgroundColor: AppColor.colWhite,
        body: Container(
          height: Sizes.height,
          color: AppColor.colPrimary.withOpacity(.1),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.width * 0.03, vertical: Sizes.height * 0.02),
            child: Column(
              children: [
                addMasterOutside(children: [
                  textformfiles(journalController,
                      labelText: "Journal Voucher No.",
                      keyboardType: TextInputType.number),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Journal Date",
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
                                journalDate.text = DateFormat('yyyy/MM/dd')
                                    .format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                journalDate.text,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "Debit Party*",
                            searchDropDown(
                                context,
                                "Select Debit Party*",
                                debitPartyList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            debitPartyId = item['id'];
                                            debitPartyName = item['name'];
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
                                debitPartyValue,
                                (value) {
                                  setState(() {
                                    debitPartyValue = value;
                                  });
                                },
                                searchController,
                                (value) {
                                  setState(() {
                                    debitPartyList
                                        .where((item) => item['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a debit party...',
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
                            debitPartyValue = null;
                            fatchledger().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                ], context: context),
                const Divider(),
                addMasterOutside(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "Credit Party*",
                            searchDropDown(
                                context,
                                "Select Credit Party*",
                                creditPartyList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            creditPartyId = item['id'];
                                            creditPartyName = item['name'];
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
                                creditPartyValue,
                                (value) {
                                  setState(() {
                                    creditPartyValue = value;
                                  });
                                },
                                searchController,
                                (value) {
                                  setState(() {
                                    creditPartyList
                                        .where((item) => item['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a credit party...',
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
                            creditPartyValue = null;
                            fatchledger().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textformfiles(onChanged: (value) {
                        calculateGST();
                      }, creditamountController, labelText: "Amount"),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "HSN Code*",
                            searchDropDown(
                                context,
                                "Select HSN Code*",
                                hsnCodeList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            setState(() {
                                              hsnCodeId = item['hsn_Id'];
                                              gstPersentage =
                                                  item['igst'].toString();
                                              hsnCodeName = item['hsn_Code'];
                                              calculateGST();
                                            });
                                          },
                                          value: item,
                                          child: Text(
                                            item['hsn_Code'].toString(),
                                            style: rubikTextStyle(
                                                16,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                          ),
                                        ))
                                    .toList(),
                                hsnCodeValue,
                                (value) {
                                  setState(() {
                                    hsnCodeValue = value;
                                  });
                                },
                                searchController,
                                (value) {
                                  setState(() {
                                    hsnCodeList
                                        .where((item) => item['hsn_Code']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a Hsn Code...',
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
                            hsnCodeValue = null;
                            gstHsnData().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  ReuseContainer(
                      title: "GST",
                      subtitle:
                          "₹ ${gstAmount.toStringAsFixed(2)} ( $gstPersentage %)"),
                  ReuseContainer(
                      title: "Taxable",
                      subtitle: "₹ ${taxableAmount.toStringAsFixed(2)}"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (creditPartyValue != null &&
                                hsnCodeValue != null &&
                                creditamountController.text.isNotEmpty) {
                              setState(() {
                                creditParties.add({
                                  'creditParty': creditPartyValue,
                                  'hsnCode': hsnCodeValue,
                                  'finalAmount':
                                      double.parse(creditamountController.text),
                                  'gstAmount': gstAmount.toStringAsFixed(2),
                                  'gstPersentage': gstPersentage,
                                  'taxableAmount':
                                      taxableAmount.toStringAsFixed(2),
                                });
                                creditPartyValue = null;
                                hsnCodeValue = null;
                                taxableAmount = 0.0;
                                gstPersentage = '0';
                                gstAmount = 0;
                                creditamountController.clear();
                              });
                            } else {
                              showCustomSnackbar(
                                  context, "Please fill all forms perfectly");
                            }
                          },
                          child: const Text("Add +"))
                    ],
                  ),
                ], context: context),
                const Divider(),
                Responsive.isMobile(context)
                    ? Column(
                        children: List.generate(
                        creditParties.length,
                        (index) {
                          final party = creditParties[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                "Credit Party: ${party['creditParty']['name']}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "HSN Code: ${party['hsnCode']['hsn_Code']}"),
                                  Text(
                                      "Final Amount (Including GST): ${party['finalAmount']}"),
                                  Text(
                                      "Taxable Amount: ${party['taxableAmount']}"),
                                  Text("GST Amount: ${party['gstAmount']}"),
                                  Text(
                                      "GST Percentage: ${party['gstPersentage']}"),
                                ],
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    creditParties.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ))
                    : Table(
                        border: TableBorder.all(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.colBlack),
                        children: [
                          TableRow(
                              decoration:
                                  BoxDecoration(color: AppColor.colPrimary),
                              children: [
                                tableHeader("Party Name"),
                                tableHeader("Amount"),
                                tableHeader("HSN Code"),
                                tableHeader("GST"),
                                tableHeader("Taxable"),
                                tableHeader("Action"),
                              ]),
                          ...List.generate(creditParties.length, (index) {
                            return TableRow(
                                decoration:
                                    BoxDecoration(color: AppColor.colWhite),
                                children: [
                                  tableRow(
                                      "${creditParties[index]["creditParty"]['name']}"),
                                  tableRow(
                                      "${creditParties[index]['finalAmount']}"),
                                  tableRow(
                                      "${creditParties[index]["hsnCode"]['hsn_Code']}"),
                                  tableRow(
                                      "${creditParties[index]["gstAmount"]} ( ${creditParties[index]["gstPersentage"]} )"),
                                  tableRow(
                                      "₹ ${creditParties[index]['taxableAmount']}"),
                                  IconButton(
                                      onPressed: () {
                                        creditParties.removeAt(index);
                                      },
                                      icon: Icon(Icons.delete,
                                          color: AppColor.colRideFare))
                                ]);
                          })
                        ],
                      ),
                addMasterOutside(children: [
                  textformfiles(remarkController, labelText: "Remark"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button("Save", AppColor.colPrimary, onTap: () {
                        // if (partnamecontroller.text.isEmpty ||
                        //     partnumberController.text.isEmpty) {
                        //   showCustomSnackbar(
                        //       context, "Please enter Part Name and Number");
                        // } else if (hsnCodeId == null ||
                        //     ledgerId == null ||
                        //     selectedgroupListId == null) {
                        //   showCustomSnackbar(context,
                        //       "Please select HSN Code, Manufacturer and Item Group");
                        // } else {
                        //   postItem();
                        // }
                      }),
                    ],
                  ),
                ], context: context),
              ],
            ),
          ),
        ));
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

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=7,9,10,14");
    creditPartyList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
    debitPartyList = creditPartyList;
  }
}
