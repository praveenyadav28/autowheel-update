// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class ExpanceVoucher extends StatefulWidget {
  ExpanceVoucher({super.key, required this.expanseVoucherNo});
  int expanseVoucherNo = 0;

  @override
  State<ExpanceVoucher> createState() => _ExpanceVoucherState();
}

class _ExpanceVoucherState extends State<ExpanceVoucher> {
  // Date
  TextEditingController expanseDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  // TextEditingController fromDate = TextEditingController(
  //     text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  // TextEditingController toDate = TextEditingController(
  //     text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

  // final List<Map<String, dynamic>> data = [
  //   {
  //     'PartyName': 'TVS MOTORS',
  //     'Address': 'RAJKOT',
  //     'CityName': 'RAJKOT',
  //     'DistrictName': 'RAJKOT',
  //     'StateName': 'GUJARAT',
  //     'Mob': '',
  //     'DueDate': '11-04-2024',
  //     'ClosingBal': '20000',
  //     'BalType': 'Cr',
  //     'Remarks': '',
  //     'StaffName': 'KAPIL'
  //   },
  //   {
  //     'PartyName': 'SURENDER',
  //     'Address': 'RAJKOT',
  //     'CityName': 'RAJKOT',
  //     'DistrictName': 'RAJKOT',
  //     'StateName': 'GUJARAT',
  //     'Mob': '',
  //     'DueDate': '01-03-2024',
  //     'ClosingBal': '34000',
  //     'BalType': 'Dr',
  //     'Remarks': '',
  //     'StaffName': 'KAPIL'
  //   },
  //   {
  //     'PartyName': 'Anil Sharma',
  //     'Address': 'RAJKOT',
  //     'CityName': 'RAJKOT',
  //     'DistrictName': 'RAJKOT',
  //     'StateName': 'GUJARAT',
  //     'Mob': '',
  //     'DueDate': '11-04-2024',
  //     'ClosingBal': '57402',
  //     'BalType': 'Dr',
  //     'Remarks': 'INSTALLMENT',
  //     'StaffName': 'KAPIL'
  //   },
  //   {
  //     'PartyName': 'SURESH JI SH...',
  //     'Address': 'RAJKOT',
  //     'CityName': 'RAJKOT',
  //     'DistrictName': 'RAJKOT',
  //     'StateName': 'GUJARAT',
  //     'Mob': '',
  //     'DueDate': '12-04-2024',
  //     'ClosingBal': '243000',
  //     'BalType': 'Dr',
  //     'Remarks': '',
  //     'StaffName': 'KAPIL'
  //   },
  //   {
  //     'PartyName': 'BAJAJ',
  //     'Address': 'SODALA',
  //     'CityName': 'Jaipur',
  //     'DistrictName': 'Jaipur',
  //     'StateName': 'RAJASTHAN',
  //     'Mob': '556435973',
  //     'DueDate': '25-01-2024',
  //     'ClosingBal': '5366',
  //     'BalType': 'Cr',
  //     'Remarks': '26 JAN.MEETI...',
  //     'StaffName': 'KAPIL'
  //   },
  //   {
  //     'PartyName': 'RAHUL SHAR...',
  //     'Address': 'SHAYAM NA...',
  //     'CityName': 'Jaipur',
  //     'DistrictName': 'Jaipur',
  //     'StateName': 'RAJASTHAN',
  //     'Mob': '',
  //     'DueDate': '24-01-2024',
  //     'ClosingBal': '5371955',
  //     'BalType': 'Cr',
  //     'Remarks': '',
  //     'StaffName': 'KAPIL'
  //   },
  //   {
  //     'PartyName': 'KRISHNA SH...',
  //     'Address': 'SHAYAM NA...',
  //     'CityName': 'Jaipur',
  //     'DistrictName': 'Jaipur',
  //     'StateName': 'RAJASTHAN',
  //     'Mob': '',
  //     'DueDate': '24-01-2024',
  //     'ClosingBal': '708',
  //     'BalType': 'Cr',
  //     'Remarks': '',
  //     'StaffName': 'KAPIL'
  //   },
  // ];

  // final ScrollController _horizontalScrollController = ScrollController();

  //Controller
  TextEditingController expanceVoucherController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController expanseDetailsController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  int? ledgerId;
  Map<String, dynamic>? ledgerValue;
  String ledgerName = '';

  List<Map<String, dynamic>> modeList = [];
  String modeName = '';
  int? modegroup;
  Map<String, dynamic>? modeValue;
  int? modeId;

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> expanseDetails = {};
  @override
  void initState() {
    fatchledger().then((value) => setState(() {}));
    fatchEvNumber().then((value) => setState(() {
          widget.expanseVoucherNo == 0
              ? null
              : fatchexpanseDetails().then((value) => setState(() {
                    amountController.text = expanseDetails['amount'] ?? "";
                    purposeController.text = expanseDetails['particular'] ?? "";
                    expanseDetailsController.text =
                        expanseDetails['type'] ?? "";
                    remarkController.text = expanseDetails['remarks'] ?? "";

                    modeId = expanseDetails['voucher_Mode_Id'];
                    ledgerId = expanseDetails['voucherType_Id'];
                    modeName = modeList.firstWhere(
                        (element) => element['id'] == modeId)['name'];

                    ledgerName = ledgerList.firstWhere(
                        (element) => element['id'] == ledgerId)['name'];
                  }));
        }));
    getAccountDetails().then((value) => setState(() {}));
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
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("Expanse Voucher", overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        color: AppColor.colPrimary.withOpacity(.1),
        height: Sizes.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.width * 0.03, vertical: Sizes.height * 0.02),
          child: Column(
            children: [
              // addMasterOutside(children: [
              //   Column(
              //     children: [
              //       dropdownTextfield(
              //         context,
              //         "From Date",
              //         InkWell(
              //           onTap: () async {
              //             FocusScope.of(context).requestFocus(FocusNode());
              //             await showDatePicker(
              //               context: context,
              //               initialDate: DateTime.now(),
              //               firstDate: DateTime(1900),
              //               lastDate: DateTime(2500),
              //             ).then((selectedDate) {
              //               if (selectedDate != null) {
              //                 fromDate.text =
              //                     DateFormat('yyyy/MM/dd').format(selectedDate);
              //               }
              //             });
              //           },
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(
              //                 fromDate.text,
              //                 style: rubikTextStyle(
              //                     16, FontWeight.w500, AppColor.colBlack),
              //               ),
              //               Icon(Icons.edit_calendar, color: AppColor.colBlack)
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              //   Column(
              //     children: [
              //       dropdownTextfield(
              //         context,
              //         "To Date",
              //         InkWell(
              //           onTap: () async {
              //             FocusScope.of(context).requestFocus(FocusNode());
              //             await showDatePicker(
              //               context: context,
              //               initialDate: DateTime.now(),
              //               firstDate: DateTime(1900),
              //               lastDate: DateTime(2500),
              //             ).then((selectedDate) {
              //               if (selectedDate != null) {
              //                 toDate.text =
              //                     DateFormat('yyyy/MM/dd').format(selectedDate);
              //               }
              //             });
              //           },
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(
              //                 toDate.text,
              //                 style: rubikTextStyle(
              //                     16, FontWeight.w500, AppColor.colBlack),
              //               ),
              //               Icon(Icons.edit_calendar, color: AppColor.colBlack)
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              //   Column(
              //     children: [
              //       button("View Date Wise", AppColor.colPrimary),
              //     ],
              //   ),
              // ], context: context),
              // Container(
              //     width: double.infinity,
              //     height: 300,
              //     decoration: BoxDecoration(
              //         border: Border.all(), color: AppColor.colWhite),
              //     child: Scrollbar(
              //       controller: _horizontalScrollController,
              //       thumbVisibility: true,
              //       child: SingleChildScrollView(
              //         controller: _horizontalScrollController,
              //         scrollDirection: Axis.horizontal,
              //         child: SingleChildScrollView(
              //           scrollDirection: Axis.vertical,
              //           child: DataTable(
              //             columns: const [
              //               DataColumn(label: Text('PartyName')),
              //               DataColumn(label: Text('Address')),
              //               DataColumn(label: Text('CityName')),
              //               DataColumn(label: Text('DistrictName')),
              //               DataColumn(label: Text('StateName')),
              //               DataColumn(label: Text('Mob')),
              //               DataColumn(label: Text('DueDate')),
              //               DataColumn(label: Text('ClosingBal')),
              //               DataColumn(label: Text('BalType')),
              //               DataColumn(label: Text('Remarks')),
              //               DataColumn(label: Text('StaffName')),
              //             ],
              //             rows: data
              //                 .map(
              //                   (item) => DataRow(
              //                     cells: [
              //                       DataCell(Text(item['PartyName'])),
              //                       DataCell(Text(item['Address'])),
              //                       DataCell(Text(item['CityName'])),
              //                       DataCell(Text(item['DistrictName'])),
              //                       DataCell(Text(item['StateName'])),
              //                       DataCell(Text(item['Mob'])),
              //                       DataCell(Text(item['DueDate'])),
              //                       DataCell(Text(item['ClosingBal'])),
              //                       DataCell(Text(item['BalType'])),
              //                       DataCell(Text(item['Remarks'])),
              //                       DataCell(Text(item['StaffName'])),
              //                     ],
              //                   ),
              //                 )
              //                 .toList(),
              //           ),
              //         ),
              //       ),
              //     )),
              // SizedBox(height: Sizes.height * 0.02),
              addMasterOutside(children: [
                textformfiles(expanceVoucherController,
                    labelText: "Expanse Voucher No.",
                    keyboardType: TextInputType.number),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropdownTextfield(
                      context,
                      "Expanse Date",
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
                              expanseDate.text =
                                  DateFormat('yyyy/MM/dd').format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              expanseDate.text,
                              style: rubikTextStyle(
                                  16, FontWeight.w500, AppColor.colBlack),
                            ),
                            Icon(Icons.edit_calendar, color: AppColor.colBlack)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ], context: context),
              addMasterOutside(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: dropdownTextfield(
                          context,
                          "Voucher Type*",
                          searchDropDown(
                              context,
                              ledgerName.isNotEmpty
                                  ? ledgerName
                                  : "Select Voucher Type*",
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
                        var result = await pushTo(LedgerMaster(groupId: 14));
                        if (result != null) {
                          ledgerValue = null;
                          fatchledger().then((value) => setState(() {}));
                        }
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
                          "Mode*",
                          searchDropDown(
                              context,
                              modeName.isNotEmpty ? modeName : "Select Mode*",
                              modeList
                                  .map((item) => DropdownMenuItem(
                                        onTap: () {
                                          modeId = item['id'];
                                          modeName = item['name'];
                                          modegroup = item['group'];
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
                              modeValue,
                              (value) {
                                setState(() {
                                  modeValue = value;
                                });
                              },
                              searchController,
                              (value) {
                                setState(() {
                                  modeList
                                      .where((item) => item['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              },
                              'Search for a mode...',
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
                        var result = await pushTo(LedgerMaster(groupId: 7));
                        if (result != null) {
                          modeValue = null;
                          fatchledger().then((value) => setState(() {}));
                        }
                      },
                    )
                  ],
                ),
                textformfiles(expanseDetailsController,
                    labelText: "Expanse Details"),
                textformfiles(purposeController, labelText: "Purpose/Exp. By"),
                textformfiles(amountController,
                    labelText: "Amount", keyboardType: TextInputType.number),
                textformfiles(remarkController, labelText: "Remark"),
              ], context: context),
              button("Save", AppColor.colPrimary, onTap: () {
                if (expanceVoucherController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter EV Number");
                } else if (ledgerId == null || modeId == null) {
                  showCustomSnackbar(
                      context, "Please select Voucher Type and Mode");
                } else if (amountController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter amount");
                } else {
                  postExpanse();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

//Post Expanse
  Future postExpanse() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
          widget.expanseVoucherNo == 0
              ? "Transactions/PostExpencesVoucherAW"
              : "Transactions/UpdateExpencesVoucherAW?prefix=online&refno=${widget.expanseVoucherNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
          {
            "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
            "Prefix_Name": "online",
            "Ev_No": int.parse(expanceVoucherController.text),
            "EDate": expanseDate.text.toString(),
            "VoucherType_Id": ledgerId,
            "Type": expanseDetailsController.text.toString(),
            "Particular": purposeController.text.toString(),
            "Amount": amountController.text.toString(),
            "Balance_Amount": "0",
            "Voucher_Mode_Id": modeId,
            'Mode': modeName,
            "Remarks": remarkController.text.toString()
          });
      if (response["result"] == true) {
        widget.expanseVoucherNo == 0
            ? null
            : Navigator.pop(context, "For fatch data in last screen");
        fatchexpanseDetails().then((value) => setState(() {
              // Ledger
              int ledgerId = expanseDetails['voucherType_Id'];
              String ledgerName = ledgerList.isEmpty
                  ? ""
                  : ledgerList.firstWhere(
                      (element) => element['id'] == ledgerId)['name'];
              // mode
              int modeId = expanseDetails['voucher_Mode_Id'];
              String modeName = modeList.isEmpty
                  ? ""
                  : modeList
                      .firstWhere((element) => element['id'] == modeId)['name'];
              generatePaymentPDF(2, companyDetails, {
                "ev_No": expanseDetails['ev_No'],
                "eDate": expanseDetails['eDate'],
                "ledger_Name": ledgerName,
                "other1": expanseDetails['type'],
                "mode": expanseDetails['particular'],
                "cash_Amount": expanseDetails['amount'],
                "particular": modeName,
                "remarks": expanseDetails['remarks']
              });
            }));
        showCustomSnackbarSuccess(context, response["message"]);
      } else {
        showCustomSnackbar(context, response["message"]);
      }
    } catch (e) {
      print("$e error");
    }
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=14");
    var responsemode = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=7");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
    modeList = List<Map<String, dynamic>>.from(responsemode.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'group': item['ledger_Group_Id']
        }));
  }

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }

//Get Expanse Number
  Future fatchEvNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=Expense&Fldname=Ev_No&transdatefld=EDate&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    expanceVoucherController.text = widget.expanseVoucherNo != 0
        ? "${widget.expanseVoucherNo}"
        : "$response";
  }

//Expanse Datails Get
  Future fatchexpanseDetails() async {
    var response = await ApiService.fetchData(
        'Transactions/GetExpencesVoucherAW?prefix=online&refno=${expanceVoucherController.text}&locationid=${Preference.getString(PrefKeys.locationId)}');
    expanseDetails = response;
  }
}
