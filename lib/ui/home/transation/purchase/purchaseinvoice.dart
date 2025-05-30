// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class PurchaseInvoice extends StatefulWidget {
  PurchaseInvoice({super.key, required this.invoiceNumber});
  int invoiceNumber = 0;
  @override
  State<PurchaseInvoice> createState() => _PurchaseInvoiceState();
}

class _PurchaseInvoiceState extends State<PurchaseInvoice> {
  //Controller
  TextEditingController pInvNoController = TextEditingController();
  TextEditingController splrInvNoController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _otherChargesController = TextEditingController();

  double _finalPrice = 0.0;
  double totalDiscount = 0.0;

// Date
  TextEditingController purchaseInvDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  TextEditingController splrInvDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  String ledgerName = '';
  Map<String, dynamic>? ledgerValue;
  int? ledgerId;

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> pInvoiceDetails = {};

  //Invoice model
  late InvoiceModel invoiceModel;
  @override
  void initState() {
    invoiceModel = Provider.of<InvoiceModel>(context, listen: false);
    fatchledger().then((value) => setState(() {
          widget.invoiceNumber == 0
              ? null
              : getInvoiceDetails().then((value) => setState(() {}));
        }));
    getAccountDetails().then((value) => setState(() {}));

    fatchInvoiceNumber().then((value) => setState(() {}));
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
    var invoiceModel = Provider.of<InvoiceModel>(context);
    _calculateFinalPrice();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title:
                const Text("Puschase Invoice", overflow: TextOverflow.ellipsis),
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
                  textformfiles(pInvNoController,
                      labelText: 'Purchase Invoice No.*'),
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
                                purchaseInvDate.text = DateFormat('yyyy/MM/dd')
                                    .format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                purchaseInvDate.text,
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
                  textformfiles(splrInvNoController,
                      labelText: "Supplier Invoice Number"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Supplier Invoice Date",
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
                                splrInvDate.text = DateFormat('yyyy/MM/dd')
                                    .format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                splrInvDate.text,
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
                  textformfiles(_remarkController, labelText: "Remark"),
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
                                            status: 2,
                                            invoiceNumber: int.parse(
                                                pInvNoController.text),
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
                            "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + (double.parse(map['totalPrice'] ?? "0")))}",
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
                  if (pInvNoController.text.isEmpty) {
                    showCustomSnackbar(context, "Please enter Purchase");
                  } else if (ledgerId == null) {
                    showCustomSnackbar(context, "Please select Ledger Account");
                  } else if (invoiceModel.parts.isEmpty) {
                    showCustomSnackbar(context, "Please add Parts");
                  } else {
                    postPurchaseInvoice();
                  }
                }),
              ],
            ),
          ),
        ));
  }

//Get Invoice Number
  Future fatchInvoiceNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=P_Invoice&Fldname=PInvo&transdatefld=PInvo_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    pInvNoController.text =
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

  //Post Purchase Invoice
  Future postPurchaseInvoice() async {
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
            ? 'Transactions/PostPurchaseInvoiceAW'
            : "Transactions/UpdatePurchaseInvoiceAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
        {
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": "online",
          "pInvo": int.parse(pInvNoController.text),
          "pInvo_Date": purchaseInvDate.text.toString(),
          "ledger_Id": ledgerId,
          "ledger_Name": ledgerName,
          "splrInvo": splrInvNoController.text.toString(),
          "spltInvo_Date": splrInvDate.text.toString(),
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
          "remarks": _remarkController.text.toString(),
          "igst_Text": double.parse(gstAmount),
          "cgst_Tax": double.parse(gstAmount) / 2,
          "sgst_Tax": double.parse(gstAmount) / 2,
          "cess_Tax": double.parse(cessAmount),
          "extra1": "",
          "extra2": "",
          "extra3": "",
          "extra4": "",
          "purchase_Invoice_Items": invoiceModel.parts
        });
    if (response['result'] == true) {
      getPurchaseInvoiceData().then((value) => setState(() {
            generateInvoicePDF(
                3, pInvoiceDetails, companyDetails, ledgerValue ?? {});
          }));
      showCustomSnackbarSuccess(context, '${response["message"]}');
      invoiceModel.clearData();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//fatch Purchase Invoice Data
  Future getPurchaseInvoiceData() async {
    pInvoiceDetails = await ApiService.fetchData(
        "Transactions/GetPurchaseInvoiceAW?prefix=online&refno=${pInvNoController.text}&locationid=${Preference.getString(PrefKeys.locationId)}");
  }

  //Get Invoice Details
  Future getInvoiceDetails() async {
    var invoiceDetails = await ApiService.fetchData(
        "Transactions/GetPurchaseInvoiceAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}");
    _remarkController.text = invoiceDetails['remarks'] ?? "";
    splrInvNoController.text = invoiceDetails['splrInvo'] ?? "";
    pInvNoController.text = "${invoiceDetails['pInvo']}";
    _discountPriceController.text = "${invoiceDetails['discount']}";
    ledgerId = invoiceDetails['ledger_Id'];
    ledgerName =
        ledgerList.firstWhere((element) => element['id'] == ledgerId)['name'];

    // Clear previous lists
    invoiceModel.parts.clear();

    // Iterate through jobCard_Items and classify based on 'type'
    List items = (invoiceDetails['purchase_Invoice_Items'] as List);
    for (var item in items) {
      Provider.of<InvoiceModel>(context, listen: false).addPart(item);
    }
  }

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }
}
