// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class ContraVoucher extends StatefulWidget {
  ContraVoucher({super.key, required this.contraVoucherNo});
  int contraVoucherNo = 0;

  @override
  State<ContraVoucher> createState() => _ContraVoucherState();
}

class _ContraVoucherState extends State<ContraVoucher> {
  // Date
  TextEditingController contraDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

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
  //Controller
  TextEditingController contraVoucherController = TextEditingController();
  TextEditingController contraDetailsController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> contraDetails = {};
  @override
  void initState() {
    fatchledger().then((value) => setState(() {}));
    fatchCvNumber().then((value) => setState(() {
          widget.contraVoucherNo == 0
              ? null
              : fatchContraDetails().then((value) => setState(() {
                    ledgerId = contraDetails['ledger_Id'];
                    ledgerName = contraDetails['ledger_Name'];
                    modeId = contraDetails['voucher_Mode_Id'];
                    modeName = contraDetails['voucher_Mode'];
                    amountController.text = contraDetails['debitAmount'] ?? "0";
                    remarkController.text = contraDetails['remarks'] ?? "";
                  }));
        }));

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
          title: const Text("Contra", overflow: TextOverflow.ellipsis),
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
                ReuseContainer(title: "Voucher Type", subtitle: "Contra"),
                textformfiles(contraVoucherController,
                    labelText: "Contra Voucher No.",
                    keyboardType: TextInputType.number),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropdownTextfield(
                      context,
                      "Contra Date",
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
                              contraDate.text =
                                  DateFormat('yyyy/MM/dd').format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              contraDate.text,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: dropdownTextfield(
                          context,
                          "Head*",
                          searchDropDown(
                              context,
                              ledgerName.isNotEmpty
                                  ? ledgerName
                                  : "Select Head*",
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
                        var result = await pushTo(LedgerMaster(groupId: 7));
                        if (result != null) {
                          ledgerValue = null;
                          fatchledger().then((value) => setState(() {}));
                        }
                      },
                    )
                  ],
                ),
                textformfiles(amountController,
                    labelText: "Amount*", keyboardType: TextInputType.number),
                textformfiles(remarkController, labelText: "Remarks"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    button("Save", AppColor.colPrimary, onTap: () {
                      if (contraVoucherController.text.isEmpty) {
                        showCustomSnackbar(context, "Please enter IV Number");
                      } else if (ledgerId == null || modeId == null) {
                        showCustomSnackbar(
                            context, "Please select Mode and Head");
                      } else if (ledgerId == modeId) {
                        showCustomSnackbar(
                            context, "Please select different account");
                      } else if (amountController.text.isEmpty) {
                        showCustomSnackbar(context, "Please enter amount");
                      } else {
                        postContra();
                      }
                    }),
                  ],
                ),
              ], context: context),
            ],
          ),
        ),
      ),
    );
  }

//Post Income
  Future postContra() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
          widget.contraVoucherNo == 0
              ? "Transactions/PostContraVoucherAW"
              : "Transactions/UpdateContraVoucherAW?prefix=online&refno=${widget.contraVoucherNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
          {
            "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
            "Prefix_Name": "online",
            "Voucher_No": int.parse(contraVoucherController.text),
            "Tran_Date": contraDate.text.toString(),
            "Voucher_Type_Id": 1,
            "Voucher_Type": "Contra",
            "Voucher_Mode_Id": modeId,
            "Voucher_Mode": modeName,
            "Ledger_Id": ledgerId,
            "Ledger_Name": ledgerName,
            "DebitAmount": amountController.text.toString(),
            "CreditAmount": amountController.text.toString(),
            "Remarks": remarkController.text.toString(),
          });
      if (response["result"] == true) {
        widget.contraVoucherNo == 0
            ? null
            : Navigator.pop(context, "For fatch data in last screen");
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
    var responsemode = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=7");

    ledgerList = List<Map<String, dynamic>>.from(responsemode.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'group': item['ledger_Group_Id']
        }));
    modeList = List<Map<String, dynamic>>.from(responsemode.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'group': item['ledger_Group_Id']
        }));
  }

//Get Income Number
  Future fatchCvNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=Contra&Fldname=Voucher_No&transdatefld=Tran_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    contraVoucherController.text =
        widget.contraVoucherNo != 0 ? "${widget.contraVoucherNo}" : "$response";
  }

//Income Datails Get
  Future fatchContraDetails() async {
    var response = await ApiService.fetchData(
        'Transactions/GetContraVoucherAW?prefix=online&refno=${contraVoucherController.text}&locationid=${Preference.getString(PrefKeys.locationId)}');
    contraDetails = response;
  }
}
