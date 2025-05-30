// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatefulWidget {
  ReceiptScreen({super.key, required this.reciptVoucherNo});
  int reciptVoucherNo = 0;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  // Date
  TextEditingController receiptDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  TextEditingController paymentDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

  //Controller
  TextEditingController receiptVoucherController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();
  TextEditingController chequeController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  String ledgerName = '';
  Map<String, dynamic>? ledgerValue;
  int? ledgerId;

  List<Map<String, dynamic>> modeList = [];
  String modeName = '';
  int? modegroup;
  Map<String, dynamic>? modeValue;
  int? modeId;

  String totalAmount = '0';
  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> recieptDetails = {};

  @override
  void initState() {
    fatchledger().then((value) => setState(() {
          fatchRvNumber().then((value) => setState(() {
                widget.reciptVoucherNo == 0
                    ? null
                    : fatchrecieptDetails().then((value) => setState(() {
                          paidAmountController.text =
                              recieptDetails['cash_Amount'] ?? "";
                          chequeController.text =
                              recieptDetails['cheque_No'] ?? "";
                          remarkController.text =
                              recieptDetails['other1'] ?? "";
                          modeId = recieptDetails['voucher_Mode_Id'];
                          ledgerId = recieptDetails['ledger_Id'];
                          ledgerName = recieptDetails['ledger_Name'];
                          modeName = modeList.firstWhere(
                              (element) => element['id'] == modeId)['name'];
                        }));
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
          title: const Text("Receipt", overflow: TextOverflow.ellipsis),
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
              addMasterOutside(children: [
                textformfiles(receiptVoucherController,
                    labelText: "Receipt Voucher No.*",
                    keyboardType: TextInputType.number),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropdownTextfield(
                      context,
                      "Receipt mode Date",
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
                              receiptDate.text =
                                  DateFormat('yyyy/MM/dd').format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              receiptDate.text,
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
                          "Customer A/C*",
                          searchDropDown(
                              context,
                              ledgerName.isNotEmpty
                                  ? ledgerName
                                  : "Select Customer Account*",
                              ledgerList
                                  .map((item) => DropdownMenuItem(
                                        onTap: () {
                                          ledgerId = item['id'];
                                          ledgerName = item['name'];
                                          totalAmount =
                                              item['opening_Bal'].isEmpty
                                                  ? "0"
                                                  : item['opening_Bal'];
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
                              'Search for a Customer...',
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
                        var result = await pushTo(LedgerMaster(groupId: 10));
                        if (result != null) {
                          ledgerValue = null;
                          fatchledger().then((value) => setState(() {}));
                        }
                      },
                    )
                  ],
                ),
                textformfiles(paidAmountController,
                    labelText: "Paid Amount",
                    prefixIcon:
                        const IconButton(onPressed: null, icon: Text("₹")),
                    keyboardType: TextInputType.number),
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
                        var result = await pushTo(LedgerMaster(groupId: 0));
                        if (result != null) {
                          modeValue = null;
                          fatchledger().then((value) => setState(() {}));
                        }
                      },
                    )
                  ],
                ),
              ], context: context),
              modegroup != 7
                  ? Container()
                  : addMasterOutside(children: [
                      textformfiles(chequeController,
                          labelText: "Cheque Number",
                          keyboardType: TextInputType.number),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dropdownTextfield(
                            context,
                            "Cheque Date",
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2500),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    paymentDate.text = DateFormat('yyyy/MM/dd')
                                        .format(selectedDate);
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    paymentDate.text,
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
                    ], context: context),
              textformfiles(remarkController, labelText: "Remark"),
              SizedBox(height: Sizes.height * 0.02),
              button("Save", AppColor.colPrimary, onTap: () {
                if (receiptVoucherController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter RV Number");
                } else if (paidAmountController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter Paid Amount");
                } else if (ledgerId == null) {
                  showCustomSnackbar(context, "Please select customer");
                } else if (modeId == null) {
                  showCustomSnackbar(context, "Please select voucher mode");
                } else {
                  postReciept();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

//Post Reciept
  Future postReciept() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
          widget.reciptVoucherNo == 0
              ? "Transactions/PostReceiptVoucherAW"
              : "Transactions/UpdateReceiptVoucherAW?prefix=online&refno=${widget.reciptVoucherNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
          {
            "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
            "Prefix_Name": "online",
            "Rv_No": int.parse(receiptVoucherController.text),
            "Receipt_Date": receiptDate.text.toString(),
            "Ledger_Id": ledgerId,
            "Ledger_Name": ledgerName,
            "Total_Amount": totalAmount,
            "Cash_Amount": paidAmountController.text.toString(),
            "Balance_Amount": "0",
            "Voucher_Mode_Id": modeId,
            "Mode": modeName,
            "Cheque_No": chequeController.text.toString(),
            "Cheque_Date": paymentDate.text.toString(),
            "Other1": remarkController.text.toString(),
            "Other2": "2",
            "Other3": "3",
            "Other4": "4",
            "Other5": "5",
            "OtherNo1": 0,
            "OtherNo2": 0,
            "OtherNo3": 0,
            "OtherNo4": 0,
            "OtherNo5": 0
          });
      if (response["result"] == true) {
        widget.reciptVoucherNo == 0
            ? null
            : Navigator.pop(context, "For fatch data in last screen");
        fatchrecieptDetails().then((value) => setState(() {
              generatePaymentPDF(
                1,
                companyDetails,
                recieptDetails,
              );
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
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=9,10");
    var responsemode = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=7,8,11");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          "opening_Bal": item["opening_Bal"],
          "mob": item["mob"],
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

//Get Invoice Number
  Future fatchRvNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=Receipt&Fldname=Rv_No&transdatefld=Receipt_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    receiptVoucherController.text =
        widget.reciptVoucherNo != 0 ? "${widget.reciptVoucherNo}" : "$response";
  }

//Reciept Datails Get
  Future fatchrecieptDetails() async {
    var response = await ApiService.fetchData(
        'Transactions/GetReceiptVoucherAW?prefix=online&refno=${receiptVoucherController.text}&locationid=${Preference.getString(PrefKeys.locationId)}');
    recieptDetails = response;
  }
}
