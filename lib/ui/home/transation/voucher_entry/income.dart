// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class IncomeVoucher extends StatefulWidget {
  IncomeVoucher({super.key, required this.incomeVoucherNo});
  int incomeVoucherNo = 0;

  @override
  State<IncomeVoucher> createState() => _IncomeVoucherState();
}

class _IncomeVoucherState extends State<IncomeVoucher> {
  // Date
  TextEditingController incomeDate = TextEditingController(
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
  TextEditingController incomeVoucherController = TextEditingController();
  TextEditingController incomeDetailsController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> incomeDetails = {};
  @override
  void initState() {
    fatchledger().then((value) => setState(() {}));
    fatchIvNumber().then((value) => setState(() {
          widget.incomeVoucherNo == 0
              ? null
              : fatchIncomeDetails().then((value) => setState(() {
                    amountController.text = incomeDetails['amount'] ?? "";
                    purposeController.text = incomeDetails['particular'] ?? "";
                    incomeDetailsController.text = incomeDetails['type'] ?? "";
                    remarkController.text = incomeDetails['remarks'] ?? "";

                    modeId = incomeDetails['voucher_Mode_Id'];
                    ledgerId = incomeDetails['voucherType_Id'];
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
          title: const Text("Income", overflow: TextOverflow.ellipsis),
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
                textformfiles(incomeVoucherController,
                    labelText: "Income Voucher No.",
                    keyboardType: TextInputType.number),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropdownTextfield(
                      context,
                      "Income Date",
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
                              incomeDate.text =
                                  DateFormat('yyyy/MM/dd').format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              incomeDate.text,
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
                textformfiles(incomeDetailsController,
                    labelText: "Income Details"),
                textformfiles(purposeController,
                    labelText: "Purpose/Income By"),
                textformfiles(amountController,
                    labelText: "Amount", keyboardType: TextInputType.number),
                textformfiles(remarkController, labelText: "Remark"),
              ], context: context),
              button("Save", AppColor.colPrimary, onTap: () {
                if (incomeVoucherController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter IV Number");
                } else if (ledgerId == null || modeId == null) {
                  showCustomSnackbar(
                      context, "Please select Voucher Type and Mode");
                } else if (amountController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter amount");
                } else {
                  postIncome();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

//Post Income
  Future postIncome() async {
    try {
      Map<String, dynamic> response = await ApiService.postData(
          widget.incomeVoucherNo == 0
              ? "Transactions/PostIncomeVoucherAW"
              : "Transactions/UpdateIncomeVoucherAW?prefix=online&refno=${widget.incomeVoucherNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
          {
            "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
            "Prefix_Name": "online",
            "Iv_No": int.parse(incomeVoucherController.text),
            "IDate": incomeDate.text.toString(),
            "VoucherType_Id": ledgerId,
            "Type": incomeDetailsController.text.toString(),
            "Particular": purposeController.text.toString(),
            "Amount": amountController.text.toString(),
            "Balance_Amount": "0",
            "Voucher_Mode_Id": modeId,
            'Mode': modeName,
            "Remarks": remarkController.text.toString()
          });
      if (response["result"] == true) {
        widget.incomeVoucherNo == 0
            ? null
            : Navigator.pop(context, "For fatch data in last screen");
        fatchIncomeDetails().then((value) => setState(() {
              // Ledger
              int ledgerId = incomeDetails['voucherType_Id'];
              String ledgerName = ledgerList.isEmpty
                  ? ""
                  : ledgerList.firstWhere(
                      (element) => element['id'] == ledgerId)['name'];
              // mode
              int modeId = incomeDetails['voucher_Mode_Id'];
              String modeName = modeList.isEmpty
                  ? ""
                  : modeList
                      .firstWhere((element) => element['id'] == modeId)['name'];
              generatePaymentPDF(3, companyDetails, {
                "iv_No": incomeDetails['iv_No'],
                "iDate": incomeDetails['iDate'],
                "ledger_Name": ledgerName,
                "other1": incomeDetails['type'],
                "mode": incomeDetails['particular'],
                "cash_Amount": incomeDetails['amount'],
                "particular": modeName,
                "remarks": incomeDetails['remarks']
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

//Get Income Number
  Future fatchIvNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=Income&Fldname=Iv_No&transdatefld=IDate&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    incomeVoucherController.text =
        widget.incomeVoucherNo != 0 ? "${widget.incomeVoucherNo}" : "$response";
  }

//Income Datails Get
  Future fatchIncomeDetails() async {
    var response = await ApiService.fetchData(
        'Transactions/GetIncomeVoucherAW?prefix=online&refno=${incomeVoucherController.text}&locationid=${Preference.getString(PrefKeys.locationId)}');
    incomeDetails = response;
  }
}
