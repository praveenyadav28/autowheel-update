// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class PurchaseReturn extends StatefulWidget {
  PurchaseReturn({super.key, required this.invoiceNumber});
  int invoiceNumber = 0;
  @override
  State<PurchaseReturn> createState() => _PurchaseReturnState();
}

class _PurchaseReturnState extends State<PurchaseReturn> {
  //Controller
  TextEditingController pRtnNoController = TextEditingController();
  TextEditingController pInvNoController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _otherChargesController = TextEditingController();

  double _finalPrice = 0.0;
  double totalDiscount = 0.0;
  final TextEditingController searchController = TextEditingController();

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> pReturnDetails = {};

// Date
  TextEditingController prtnDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  TextEditingController pInvDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  String ledgerName = '';
  String ledgerAddress = '';
  Map<String, dynamic>? ledgerValue;
  int? ledgerId;

  //Invoice model
  late InvoiceModel invoiceModel;
  @override
  void initState() {
    invoiceModel = Provider.of<InvoiceModel>(context, listen: false);
    fatchledger().then((value) => setState(() {}));
    getAccountDetails().then((value) => setState(() {}));
    widget.invoiceNumber == 0
        ? null
        : getreturnDetails().then((value) => setState(() {}));
    fatchReturnNumber().then((value) => setState(() {}));
    super.initState();
  }

  void _calculateFinalPrice() {
    double price = invoiceModel.parts
        .fold(0.0, (sum, map) => sum + double.parse(map['totalPrice'] ?? "0"));
    double discountPrice =
        double.tryParse(_discountPriceController.text) ?? 0.0;
    double discountPercentage =
        double.tryParse(_discountPercentageController.text) ?? 0.0;
    double otherCharges = double.tryParse(_otherChargesController.text) ?? 0.0;

    double discountFromPercentage = (price * discountPercentage) / 100;
    totalDiscount = discountPrice + discountFromPercentage;
    _finalPrice = price - totalDiscount + otherCharges;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _calculateFinalPrice();
    var invoiceModel = Provider.of<InvoiceModel>(context);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title:
                const Text("Purchase Return", overflow: TextOverflow.ellipsis),
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
                  textformfiles(pRtnNoController,
                      labelText: 'Purchase Return No.*'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Purchase Return Date",
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
                                prtnDate.text = DateFormat('yyyy/MM/dd')
                                    .format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prtnDate.text,
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
                        child: textformfiles(pInvNoController,
                            keyboardType: TextInputType.number,
                            labelText: 'Purchase Invoice No.*'),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          getInvoiceDetails().then((value) => setState(() {}));
                        },
                        child: Container(
                            height: (Responsive.isMobile(context)) ? 45 : 40,
                            width: (Responsive.isMobile(context)) ? 45 : 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.colWhite,
                              border: Border.all(
                                width: 1,
                                color: AppColor.colBlack,
                              ),
                            ),
                            child: Icon(
                              Icons.search,
                              color: AppColor.colBlack,
                            )),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Purchase Invoice Date",
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
                                pInvDate.text = DateFormat('yyyy/MM/dd')
                                    .format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pInvDate.text,
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
                            "Ledger Account*",
                            searchDropDown(
                                context,
                                ledgerName.isEmpty
                                    ? "Select Ledger Account*"
                                    : ledgerName,
                                ledgerList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            ledgerId = item['id'];
                                            ledgerName = item['name'];
                                            ledgerAddress = item['address'];
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
                  ReuseContainer(
                      title: "Place of Supply", subtitle: ledgerAddress)
                ]),
                SizedBox(height: Sizes.height * 0.02),
                Container(
                    width: double.infinity,
                    decoration: decorationBox(),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text(
                            "‣ Add Spare Part",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPartInvoice(
                                            status: 4,
                                            invoiceNumber: int.parse(
                                                pRtnNoController.text),
                                          )),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.colPrimary),
                              child: const Text('Add +')),
                        ),
                        const Divider(),
                        SizedBox(
                            height: 200,
                            child: invoiceModel.parts.isEmpty
                                ? const Center(
                                    child: Text("No Spare Parts Added"))
                                : SingleChildScrollView(
                                    child: Column(
                                        children: List.generate(
                                            invoiceModel.parts.length, (index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                              horizontalTitleGap: 0,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              dense: true,
                                              title: Text(
                                                invoiceModel.parts[index]
                                                    ['item_Name'],
                                                style: rubikTextStyle(
                                                    15,
                                                    FontWeight.w500,
                                                    AppColor.colBlack),
                                              ),
                                              subtitle: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "₹${invoiceModel.parts[index]['ndpPrice']} * ${invoiceModel.parts[index]['quantity']} ",
                                                    style: rubikTextStyle(
                                                        14,
                                                        FontWeight.w400,
                                                        AppColor.colBlack),
                                                  ),
                                                  Text(
                                                    " ( ${invoiceModel.parts[index]['gst']}% gst )",
                                                    style: rubikTextStyle(
                                                        14,
                                                        FontWeight.w400,
                                                        AppColor.colGrey),
                                                  ),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(double.parse(invoiceModel
                                                                  .parts[index]
                                                              ['totalPrice'] ??
                                                          "0")
                                                      .toStringAsFixed(2)),
                                                  PopupMenuButton(
                                                    position:
                                                        PopupMenuPosition.under,
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <PopupMenuEntry>[
                                                      PopupMenuItem(
                                                          value: 'Delete',
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Delete part'),
                                                                    content:
                                                                        const Text(
                                                                            'Are you sure you want to delete part ?'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            invoiceModel.parts.removeAt(index);
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Delete',
                                                                          style:
                                                                              TextStyle(color: AppColor.colRideFare),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          child: const Text(
                                                              'Delete')),
                                                    ],
                                                    icon: const Icon(
                                                      Icons.more_vert,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              leading: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16,
                                                    top: 7,
                                                    bottom: 7),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      AppColor.colPrimary,
                                                  child: Text("${index + 1}",
                                                      style: rubikTextStyle(
                                                          14,
                                                          FontWeight.w500,
                                                          AppColor.colWhite)),
                                                ),
                                              )),
                                        ],
                                      );
                                    })),
                                  )),
                        Divider(thickness: 0, color: AppColor.colGrey),
                        ListTile(
                          dense: true,
                          title: Text(
                            "Subtotal",
                            style: rubikTextStyle(
                                16, FontWeight.w500, AppColor.colBlack),
                          ),
                          trailing: Text(
                            "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + (double.parse(map['totalPrice'] ?? "0"))).toStringAsFixed(2)}",
                            style: rubikTextStyle(
                                16, FontWeight.w500, AppColor.colBlack),
                          ),
                        )
                      ],
                    )),
                SizedBox(height: Sizes.height * 0.02),
                addMasterOutside(context: context, children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          _discountPriceController,
                          labelText: "Discount in ₹",
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateFinalPrice(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          _discountPercentageController,
                          labelText: "Discount in %",
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateFinalPrice(),
                        ),
                      ),
                    ],
                  ),
                  textformfiles(
                    _otherChargesController,
                    labelText: "Other",
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateFinalPrice(),
                  ),
                  ReuseContainer(
                      title: "Gst",
                      subtitle:
                          "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['gstAmount'])).toStringAsFixed(2)}"),
                  ReuseContainer(
                      title: "Cess",
                      subtitle:
                          "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + map['cess_Amount']).toStringAsFixed(2)}"),
                  ReuseContainer(
                      title: "Net Amount",
                      subtitle: "₹  ${_finalPrice.toStringAsFixed(2)}"),
                ]),
                SizedBox(height: Sizes.height * 0.02),
                button("Save", AppColor.colPrimary, onTap: () {
                  if (pInvNoController.text.isEmpty ||
                      pRtnNoController.text.isEmpty) {
                    showCustomSnackbar(context,
                        "Please enter Purchase Return and Invoice Number");
                  } else if (ledgerId == null) {
                    showCustomSnackbar(context, "Please select Ledger Account");
                  } else if (invoiceModel.parts.isEmpty) {
                    showCustomSnackbar(context, "Please add Parts");
                  } else {
                    postPurchaseReturn();
                  }
                }),
              ],
            ),
          ),
        ));
  }

//Get Return Number
  Future fatchReturnNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=P_Invoice_Rtn&Fldname=PRtn&transdatefld=PRtn_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    pRtnNoController.text =
        widget.invoiceNumber != 0 ? "${widget.invoiceNumber}" : "$response";
  }

//Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=9");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'mob': item['mob'],
          'address': item['address'],
          'gst_No': item['gst_No'],
        }));
  }

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }

  //Post Purchase Return
  Future postPurchaseReturn() async {
    var grossAmount = invoiceModel.parts.fold(
        0.0,
        (sum, map) =>
            sum +
            (double.parse(map['ndpPrice']) * double.parse(map['quantity'])));
    String gstAmount = invoiceModel.parts
        .fold(0.0, (sum, map) => sum + double.parse(map['gstAmount']))
        .toStringAsFixed(2);
    String cessAmount = invoiceModel.parts
        .fold(0.0, (sum, map) => sum + map['cess_Amount'])
        .toStringAsFixed(2);
    var response = await ApiService.postData(
        widget.invoiceNumber == 0
            ? 'Transactions/PostPurchaseReturnAW'
            : "Transactions/UpdatePurchaseReturnAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
        {
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": "online",
          "pRtn": int.parse(pRtnNoController.text),
          "pRtn_Date": prtnDate.text.toString(),
          "pInvo": int.parse(pInvNoController.text),
          "pInvo_Date": pInvDate.text.toString(),
          "ledger_Id": ledgerId,
          "ledger_Name": ledgerName,
          "splrInvo": "SplrInvo",
          "spltInvo_Date": "SpltInvo_Date",
          "gross_Amount": grossAmount.toStringAsFixed(2),
          "gst": gstAmount,
          "discount_Item": "0",
          "other_Charge": _otherChargesController.text.isEmpty
              ? "0"
              : _otherChargesController.text.toString(),
          "discount": totalDiscount.toStringAsFixed(2),
          "net_Amount": _finalPrice.toStringAsFixed(2),
          "misc_Charge_Id": 1,
          "misc_Charge": "0",
          "misc_Per": 0,
          "misc_Amount": 0,
          "remarks": "",
          "igst_Text": double.parse(gstAmount),
          "cgst_Tax": double.parse(gstAmount) / 2,
          "sgst_Tax": double.parse(gstAmount) / 2,
          "cess_Tax": double.parse(cessAmount),
          "extra1": "",
          "extra2": "",
          "extra3": "",
          "extra4": "",
          "purchaseReturn_Items": invoiceModel.parts
        });
    if (response['result'] == true) {
      getPurchaseReturnData().then((value) => setState(() {
            generateInvoicePDF(
                5, pReturnDetails, companyDetails, ledgerValue ?? {});
          }));
      fatchReturnNumber().then((value) => setState(() {}));
      pInvNoController.clear();
      showCustomSnackbarSuccess(context, '${response["message"]}');
      invoiceModel.clearData();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//fatch Purchase Invoice Data
  Future getPurchaseReturnData() async {
    pReturnDetails = await ApiService.fetchData(
        "Transactions/GetPurchaseReturnAW?prefix=online&refno=${pInvNoController.text}&locationid=${Preference.getString(PrefKeys.locationId)}");
  }

  //Get Invoice Details
  Future getInvoiceDetails() async {
    var invoiceDetails = await ApiService.fetchData(
        "Transactions/GetPurchaseInvoiceAW?prefix=online&refno=${pInvNoController.text}&locationid=${Preference.getString(PrefKeys.locationId)}");

    // Iterate through jobCard_Items and classify based on 'type'
    List items = (invoiceDetails['purchase_Invoice_Items'] as List);
    for (var item in items) {
      Provider.of<InvoiceModel>(context, listen: false).addPart(item);
    }
  }

  //Get Return Details
  Future getreturnDetails() async {
    var returnDetails = await ApiService.fetchData(
        "Transactions/GetPurchaseReturnAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}");
    pInvNoController.text = returnDetails['pInvo'].toString();
    ledgerId = returnDetails['ledger_Id'];
    ledgerName = returnDetails['ledger_Name'];
    // Iterate through jobCard_Items and classify based on 'type'
    List items = (returnDetails['purchaseReturn_Items'] as List);
    for (var item in items) {
      Provider.of<InvoiceModel>(context, listen: false).addPart(item);
    }
  }
}
