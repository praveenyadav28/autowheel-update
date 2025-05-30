// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class SaleReturn extends StatefulWidget {
  SaleReturn({super.key, required this.invoiceNumber});
  int invoiceNumber = 0;
  @override
  State<SaleReturn> createState() => _SaleReturnState();
}

class _SaleReturnState extends State<SaleReturn> {
//Controller
  TextEditingController salertnNoController = TextEditingController();
  TextEditingController saleInvNoController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _otherChargesController = TextEditingController();
  TextEditingController searchController = TextEditingController();

// Date
  TextEditingController salRtnDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  TextEditingController saleInvDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

//Ledger
  List<Map<String, dynamic>> ledgerList = [];
  String ledgerName = '';
  int? ledgerId;
  Map<String, dynamic>? ledgerDetails;

//Ledger Acount Type
  bool accountType = true;

  double _finalPrice = 0.0;
  double totalDiscount = 0.0;

  Map<String, dynamic> invoiceDetails = {};
  Map<String, dynamic> companyDetails = {};

  //Invoice model
  late InvoiceModel invoiceModel;
  @override
  void initState() {
    invoiceModel = Provider.of<InvoiceModel>(context, listen: false);

    updateApi().then((value) {
      widget.invoiceNumber == 0
          ? null
          : getSaleReturnDetails().then((value) => setState(() {}));
    });
    super.initState();
  }

  Future updateApi() async {
    await fatchReturnNumber();
    await getAccountDetails();
    await fatchledger();
  }

  @override
  void dispose() {
    _discountPriceController.removeListener(_calculateFinalPrice);
    _discountPercentageController.removeListener(_calculateFinalPrice);
    _otherChargesController.removeListener(_calculateFinalPrice);

    _discountPriceController.dispose();
    _discountPercentageController.dispose();
    _otherChargesController.dispose();
    super.dispose();
  }

  void _calculateFinalPrice() {
    double price = (invoiceModel.labours
            .fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])) +
        invoiceModel.parts
            .fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])));
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
          title: const Text("Sale Return", overflow: TextOverflow.ellipsis),
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
                textformfiles(salertnNoController,
                    labelText: 'Sale Return No*',
                    keyboardType: TextInputType.number),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dropdownTextfield(
                      context,
                      "Sale Return Date",
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
                              salRtnDate.text =
                                  DateFormat('yyyy/MM/dd').format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              salRtnDate.text,
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
                      child: textformfiles(saleInvNoController,
                          labelText: 'Sale Invoice No*',
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        getSaleInvoiceDetails()
                            .then((value) => setState(() {}));
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
                      "Sale Invoice Date",
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
                              saleInvDate.text =
                                  DateFormat('yyyy/MM/dd').format(selectedDate);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              saleInvDate.text,
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
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: Sizes.width * 0.02,
                runSpacing: Sizes.height * 0.02,
                children: [
                  SizedBox(
                      width: Sizes.width <= 900
                          ? double.infinity
                          : Sizes.width * .46,
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.width * 0.02),
                        decoration: BoxDecoration(
                            color: AppColor.colWhite,
                            border:
                                Border.all(color: AppColor.colBlack, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Credit"),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  accountType = !accountType;
                                  fatchledger().then((value) => setState(() {
                                        ledgerDetails = null;
                                        ledgerName = '';
                                      }));
                                });
                              },
                              child: Stack(
                                alignment: accountType
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 23,
                                    decoration: BoxDecoration(
                                        color: accountType
                                            ? AppColor.colGrey
                                            : AppColor.colPriLite,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  Container(
                                    width: 28,
                                    height: 28,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.colGrey,
                                              blurRadius: 2,
                                              spreadRadius: 1)
                                        ],
                                        shape: BoxShape.circle,
                                        color: accountType
                                            ? AppColor.colWhite
                                            : AppColor.colPrimary),
                                  ),
                                ],
                              ),
                            ),
                            const Text("Cash"),
                          ],
                        ),
                      )),
                  SizedBox(
                    width: Sizes.width <= 900
                        ? double.infinity
                        : Sizes.width * .46,
                    child: Row(
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
                                  ledgerDetails,
                                  (value) {
                                    setState(() {
                                      ledgerDetails = value;
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
                            var result =
                                await pushTo(LedgerMaster(groupId: 10));
                            if (result != null) {
                              fatchledger().then((value) => setState(() {}));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizes.height * 0.03),
              Wrap(
                runSpacing: Sizes.height * 0.02,
                spacing: Sizes.width * 0.02,
                children: [
                  Container(
                      width: Sizes.width <= 900
                          ? double.infinity
                          : Sizes.width * .46,
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
                                  final result = await pushTo(AddPartInvoice(
                                    status: 1,
                                    invoiceNumber:
                                        int.parse(salertnNoController.text),
                                  ));
                                  if (result != null) {
                                    setState(() {
                                      _calculateFinalPrice();
                                    });
                                  }
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
                                              invoiceModel.parts.length,
                                              (index) {
                                        return ListTile(
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
                                                  "₹${invoiceModel.parts[index]['sale_Price']} * ${invoiceModel.parts[index]['qty']} ",
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
                                                        ['total_Price'])
                                                    .toStringAsFixed(2)),
                                                PopupMenuButton(
                                                  position:
                                                      PopupMenuPosition.under,
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry>[
                                                    PopupMenuItem(
                                                        value: 'Delete',
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
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
                                                                          invoiceModel
                                                                              .parts
                                                                              .removeAt(index);
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Delete',
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColor.colRideFare),
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
                                                  right: 16, top: 7, bottom: 7),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColor.colPrimary,
                                                child: Text("${index + 1}",
                                                    style: rubikTextStyle(
                                                        14,
                                                        FontWeight.w500,
                                                        AppColor.colWhite)),
                                              ),
                                            ));
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
                              "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
                              style: rubikTextStyle(
                                  16, FontWeight.w500, AppColor.colBlack),
                            ),
                          )
                        ],
                      )),
                  Container(
                      width: Sizes.width <= 900
                          ? double.infinity
                          : Sizes.width * .46,
                      decoration: decorationBox(),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "‣ Add Labour",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            trailing: ElevatedButton(
                                onPressed: () async {
                                  final result = await pushTo(AddLabourInvoice(
                                    invoiceNumber:
                                        int.parse(salertnNoController.text),
                                    status: 1,
                                  ));
                                  if (result != null) {
                                    setState(() {
                                      _calculateFinalPrice();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.colPrimary),
                                child: const Text('Add +')),
                          ),
                          const Divider(),
                          SizedBox(
                              height: 200,
                              child: invoiceModel.labours.isEmpty
                                  ? const Center(child: Text("No Labour Added"))
                                  : SingleChildScrollView(
                                      child: Column(
                                          children: List.generate(
                                              invoiceModel.labours.length,
                                              (index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                                horizontalTitleGap: 0,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                dense: true,
                                                title: Text(
                                                  invoiceModel.labours[index]
                                                      ['item_Name'],
                                                  style: rubikTextStyle(
                                                      15,
                                                      FontWeight.w500,
                                                      AppColor.colBlack),
                                                ),
                                                subtitle: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "₹${invoiceModel.labours[index]['sale_Price']} * ${invoiceModel.labours[index]['qty']} ",
                                                      style: rubikTextStyle(
                                                          14,
                                                          FontWeight.w400,
                                                          AppColor.colBlack),
                                                    ),
                                                    Text(
                                                      " ( ${invoiceModel.labours[index]['gst']}% gst )",
                                                      style: rubikTextStyle(
                                                          14,
                                                          FontWeight.w400,
                                                          AppColor.colGrey),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "${invoiceModel.labours[index]['total_Price']}"),
                                                    PopupMenuButton(
                                                      position:
                                                          PopupMenuPosition
                                                              .under,
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
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('Cancel'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              invoiceModel.labours.removeAt(index);
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                              "₹ ${invoiceModel.labours.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
                              style: rubikTextStyle(
                                  16, FontWeight.w500, AppColor.colBlack),
                            ),
                          )
                        ],
                      )),
                ],
              ),
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
                        "₹ ${(invoiceModel.labours.fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount'])) + invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount']))).toStringAsFixed(2)}"),
                ReuseContainer(
                    title: "Cess",
                    subtitle:
                        "₹ ${(invoiceModel.labours.fold(0.0, (sum, map) => sum + map['cess_Amount']) + invoiceModel.parts.fold(0.0, (sum, map) => sum + map['cess_Amount'])).toStringAsFixed(2)}"),
                ReuseContainer(
                    title: "Net Amount",
                    subtitle: "₹  ${_finalPrice.toStringAsFixed(2)}"),
              ]),
              SizedBox(height: Sizes.height * 0.02),
              button("Save", AppColor.colPrimary, onTap: () {
                if (salertnNoController.text.isEmpty ||
                    saleInvNoController.text.isEmpty) {
                  showCustomSnackbar(
                      context, "Please enter Sale Return and Invoice Number");
                } else if (ledgerId == null) {
                  showCustomSnackbar(context, "Please select Ledger Account");
                } else if (invoiceModel.labours.isEmpty &&
                    invoiceModel.parts.isEmpty) {
                  showCustomSnackbar(
                      context, "Please add atleast one part or labour");
                } else {
                  postSaleReturn();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

//Get Return Number
  Future fatchReturnNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=Sale_Invoice_Rtn&Fldname=PRtn&transdatefld=PRtn_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    salertnNoController.text =
        widget.invoiceNumber != 0 ? "${widget.invoiceNumber}" : "$response";
  }

//Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=${accountType ? "10,23,24,25,29,9" : "7,8,11"}");

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

  //Post Sale Return
  Future postSaleReturn() async {
    var grossAmount = invoiceModel.labours
            .fold(0.0, (sum, map) => sum + double.parse(map['sale_Price'])) +
        invoiceModel.parts.fold(
            0.0,
            (sum, map) =>
                sum +
                (double.parse(map['sale_Price']) * double.parse(map['qty'])));
    String gstAmount = (invoiceModel.labours.fold(
                0.0, (sum, map) => sum + double.parse(map['gst_Amount'])) +
            invoiceModel.parts
                .fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount'])))
        .toStringAsFixed(2);
    String cessAmount = (invoiceModel.labours
                .fold(0.0, (sum, map) => sum + map['cess_Amount']) +
            invoiceModel.parts
                .fold(0.0, (sum, map) => sum + map['cess_Amount']))
        .toStringAsFixed(2);
    var response = await ApiService.postData(
        widget.invoiceNumber == 0
            ? 'Transactions/PostSaleReturnAW'
            : "Transactions/UpdateSaleReturnAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
        {
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": "online",
          "pRtn": int.parse(salertnNoController.text),
          "pRtn_Date": salRtnDate.text,
          "pInvo": int.parse(saleInvNoController.text),
          "pInvo_Date": saleInvDate.text,
          "splrInvo": "SplrInvo",
          "spltInvo_Date": "SpltInvo_Date",
          "discount_Item": totalDiscount.toStringAsFixed(2),
          "ledger_Id": ledgerId,
          "ledger_Name": ledgerName,
          "gross_Amount": grossAmount.toString(),
          "gst": gstAmount,
          "discount": totalDiscount.toStringAsFixed(2),
          "net_Amount": _finalPrice.toStringAsFixed(2),
          "other_Charge": _otherChargesController.text.isEmpty
              ? "0"
              : _otherChargesController.text.toString(),
          "remarks": "Remarks",
          "misc_Charge_Id": 1,
          "misc_Charge": "0",
          "misc_Per": 0,
          "misc_Amount": 0,
          "igst_Text": double.parse(gstAmount),
          "cgst_Tax": double.parse(gstAmount) / 2,
          "sgst_Tax": double.parse(gstAmount) / 2,
          "cess_Tax": double.parse(cessAmount),
          "extra1": "",
          "extra2": "",
          "extra3": "",
          "extra4": "",
          "saleReturn_Items": [...invoiceModel.labours, ...invoiceModel.parts],
        });
    if (response['result'] == true) {
      getSaleReturnData().then((value) => setState(() {
            generateInvoicePDF(
                6, invoiceDetails, companyDetails, ledgerDetails!);
          }));
      fatchReturnNumber().then((value) => setState(() {}));
      // pInvNoController.clear();
      showCustomSnackbarSuccess(context, '${response["message"]}');
      invoiceModel.clearData();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//fatch Purchase Invoice Data
  Future getSaleReturnData() async {
    invoiceDetails = await ApiService.fetchData(
        "Transactions/GetSaleReturnAW?prefix=online&refno=${salertnNoController.text}&locationid=${Preference.getString(PrefKeys.locationId)}");
  }

  //Get Return Details
  Future getSaleReturnDetails() async {
    var saleReturnDetails = await ApiService.fetchData(
        "Transactions/GetSaleReturnAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}");
    saleInvNoController.text = saleReturnDetails['pInvo'].toString();
    ledgerId = saleReturnDetails['ledger_Id'];
    ledgerName =
        ledgerList.firstWhere((element) => element['id'] == ledgerId)['name'];

    // Iterate through jobCard_Items and classify based on 'type'
    List items = (saleReturnDetails['saleReturn_Items'] as List);
    for (var item in items) {
      if (item['type'] == "1") {
        Provider.of<InvoiceModel>(context, listen: false).addPart(item);
      } else if (item['type'] == "2") {
        Provider.of<InvoiceModel>(context, listen: false).addLabour(item);
      }
    }
  }

  //Get Invoice Details
  Future getSaleInvoiceDetails() async {
    var returnDetails = await ApiService.fetchData(
        "Transactions/GetSaleInvoiceAW?prefix=online&refno=${saleInvNoController.text}&locationid=${Preference.getString(PrefKeys.locationId)}");

    // Iterate through jobCard_Items and classify based on 'type'
    List items = (returnDetails['sale_Invoice_Items'] as List);
    for (var item in items) {
      if (item['type'] == "1") {
        Provider.of<InvoiceModel>(context, listen: false).addPart({
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": "online",
          "invoice_No": int.parse(salertnNoController.text),
          "item": item['item'],
          "item_Name": item['item_Name'],
          "hsn_Code": item['hsn_Code'],
          "qty": item['qty'],
          "mrp": item['mrp'],
          "sale_Price": item['sale_Price'],
          "total_Price": item['total_Price'],
          "gst": item['gst'],
          "gst_Amount": item['gst_Amount'],
          "cess": item['cess'],
          "cess_Amount": item['cess_Amount'],
          "taxable": item['taxable'],
          "labour": item['labour'],
          "discount_Item": item['discount_Item'],
          "type": "1",
          "tranDate": item['tranDate'],
          "form_Type": item['form_Type'],
          "warranty_TypeId": item['warranty_TypeId'],
          "mechnic_Id": item['mechnic_Id'],
          "issue_Date": item['issue_Date'],
          "itemId": item['itemId'],
          "hsn_Id": item['hsn_Id'],
          "jobCard_No": item['jobCard_No'],
          "prefix_Name_Job": item['prefix_Name_Job'],
          "igstAmount": item['igstAmount'],
          "cgstAmount": item['cgstAmount'],
          "sgstAmount": item['sgstAmount']
        });
      } else if (item['type'] == "2") {
        Provider.of<InvoiceModel>(context, listen: false).addLabour({
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": "online",
          "invoice_No": int.parse(salertnNoController.text),
          "item": item['item'],
          "item_Name": item['item_Name'],
          "hsn_Code": item['hsn_Code'],
          "qty": item['qty'],
          "mrp": item['mrp'],
          "sale_Price": item['sale_Price'],
          "total_Price": item['total_Price'],
          "gst": item['gst'],
          "gst_Amount": item['gst_Amount'],
          "cess": item['cess'],
          "cess_Amount": item['cess_Amount'],
          "taxable": item['taxable'],
          "labour": item['labour'],
          "discount_Item": item['discount_Item'],
          "type": "2",
          "tranDate": item['tranDate'],
          "form_Type": item['form_Type'],
          "warranty_TypeId": item['warranty_TypeId'],
          "mechnic_Id": item['mechnic_Id'],
          "issue_Date": item['issue_Date'],
          "itemId": item['itemId'],
          "hsn_Id": item['hsn_Id'],
          "jobCard_No": item['jobCard_No'],
          "prefix_Name_Job": item['prefix_Name_Job'],
          "igstAmount": item['igstAmount'],
          "cgstAmount": item['cgstAmount'],
          "sgstAmount": item['sgstAmount']
        });
      }
    }
  }
}
