// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class AddPartInvoice extends StatefulWidget {
  AddPartInvoice(
      {required this.invoiceNumber, required this.status, super.key});
  int? invoiceNumber;
  int? status;
  @override
  State<AddPartInvoice> createState() => _AddPartInvoiceState();
}

class _AddPartInvoiceState extends State<AddPartInvoice> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController mrpController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController cessController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController partDiscController = TextEditingController();
  TextEditingController partNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  double totalAmount = 0.0;
  String transdate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  Map<String, dynamic> jobcardDetails = {};

  bool isGstIncluded = false; // New state for GST inclusion/exclusion

  @override
  void dispose() {
    gstController.dispose();
    discountController.dispose();
    salePriceController.dispose();
    mrpController.dispose();
    cessController.dispose();
    super.dispose();
  }

  void _updateMRP() {
    final double gst = double.tryParse(gstController.text) ?? 0;
    final double cess = double.tryParse(cessController.text) ?? 0;
    final double discount = double.tryParse(discountController.text) ?? 0;
    final double amount = double.tryParse(salePriceController.text) ?? 0;

    double discountedAmount = amount - (amount * discount / 100);
    double gstAmount, cessAmount, finalAmount;

    if (isGstIncluded) {
      // GST is included in the amount
      double divisor = 1 + (gst / 100) + (cess / 100);
      double baseAmount = discountedAmount / divisor;
      gstAmount = baseAmount * gst / 100;
      cessAmount = baseAmount * cess / 100;
      finalAmount = baseAmount + gstAmount + cessAmount;
    } else {
      // GST is excluded from the amount
      gstAmount = discountedAmount * gst / 100;
      cessAmount = discountedAmount * cess / 100;
      finalAmount = discountedAmount + gstAmount + cessAmount;
    }

    mrpController.text = finalAmount.toStringAsFixed(2);
    gstTotalAmount = gstAmount.toStringAsFixed(2);
    cessTotalAmount = cessAmount.toStringAsFixed(2);
    totalAmount = finalAmount * double.parse(quantityController.text);
  }

  void _updateAmount() {
    final double gst = double.tryParse(gstController.text) ?? 0;
    final double cess = double.tryParse(cessController.text) ?? 0;
    final double discount = double.tryParse(discountController.text) ?? 0;
    final double mrp = double.tryParse(mrpController.text) ?? 0;

    final double withoutTaxes = mrp / (1 + gst / 100 + cess / 100);
    final double originalAmount = withoutTaxes / (1 - discount / 100);

    salePriceController.text = originalAmount.toStringAsFixed(2);

    gstTotalAmount = "${originalAmount * gst / 100}";
    cessTotalAmount = "${originalAmount * cess / 100}";
    totalAmount = mrp *
        (quantityController.text.isEmpty
            ? 0
            : double.parse(quantityController.text));
  }

  int _selectedOption = 0;
  //part
  List<Map<String, dynamic>> partList = [];
  int? partId;
  String partName = '';
  Map<String, dynamic>? partValue;

//Gst Amount
  String gstTotalAmount = "0";
  String cessTotalAmount = "0";

  //HSN code
  String hsnCode = '';
  int hsnId = 0;
  @override
  void initState() {
    fatchpart().then((value) => setState(() {
          quantityController.text = "1";
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
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  margin: EdgeInsets.only(right: Sizes.width * 0.03),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: 0,
                        groupValue: _selectedOption,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      Text(
                        'By Name',
                        style: rubikTextStyle(
                            16, FontWeight.w500, AppColor.colBlack),
                      ),
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedOption,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      Text('By Number',
                          style: rubikTextStyle(
                              16, FontWeight.w500, AppColor.colBlack)),
                    ],
                  ),
                ),
              ],
            )
          ],
          title: const Text("Add Part", overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        height: Sizes.height,
        color: AppColor.colPrimary.withOpacity(.2),
        child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: Sizes.height * 0.02, horizontal: Sizes.width * 0.03),
            child: Column(
              children: [
                addMasterOutside(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "Choose Part",
                            searchDropDown(
                                context,
                                "Search for a Part...",
                                partList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            setState(() {
                                              partId = item['item_Id'];
                                              partNameController.text =
                                                  item['item_Name'];
                                              hsnCode = item['hsn_Code'];
                                              hsnId = item['hsn_Id'];
                                              mrpController.text =
                                                  item['mrp'].toString();
                                              totalAmount = item['mrp'];
                                              gstController.text =
                                                  item['igst'].toString();
                                              salePriceController.text =
                                                  item['sale_Price'].toString();
                                              partDiscController.text =
                                                  item['item_Des'].toString();
                                              quantityController.text = "1";
                                              _updateAmount();
                                              _updateMRP();
                                            });
                                          },
                                          value: item,
                                          child: Row(
                                            children: [
                                              Text(
                                                _selectedOption == 0
                                                    ? item['item_Name']
                                                        .toString()
                                                    : item['item_Des']
                                                        .toString(),
                                                style: rubikTextStyle(
                                                    16,
                                                    FontWeight.w500,
                                                    AppColor.colBlack),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                partValue,
                                (value) {
                                  setState(() {
                                    partValue = value;
                                  });
                                },
                                searchController,
                                (value) {
                                  setState(() {
                                    partList
                                        .where((item) => item['item_Name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a Part...',
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
                          var result = await pushTo(const PartMaster());
                          if (result != null) {
                            partValue = null;
                            fatchpart().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  textformfiles(partNameController, labelText: "Part Name*"),
                  textformfiles(partDiscController, labelText: "Part Number*"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(quantityController,
                            labelText: "Quantity",
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                          setState(_updateAmount);
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: textformfiles(
                        salePriceController,
                        labelText: widget.status == 2 ? "NDP" : "Sale Price",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(_updateMRP);
                        },
                      )),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: textformfiles(
                        mrpController,
                        labelText: widget.status == 2 ? "Price" : "MRP",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(_updateAmount);
                        },
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: textformfiles(
                        cessController,
                        labelText: "Cess",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(_updateAmount);
                        },
                      )),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: textformfiles(
                        discountController,
                        labelText: widget.status == 2
                            ? "Discount % on Price*"
                            : "Discount % on MRP*",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(_updateMRP);
                        },
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: textformfiles(
                        gstController,
                        labelText: "GST %*",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(_updateMRP);
                        },
                        // suffixIcon: Switch(
                        //   activeTrackColor: AppColor.colPriLite,
                        //   activeColor: AppColor.colPrimary,
                        //   value: isGstIncluded,
                        //   onChanged: (bool value) {
                        //     setState(() {
                        //       isGstIncluded = value;
                        //       _updateMRP();
                        //     });
                        //   },
                        // ),
                      )),
                    ],
                  ),
                  ReuseContainer(
                      title: "Total Amount",
                      subtitle: totalAmount.toStringAsFixed(2))
                ], context: context),
                button("Add", AppColor.colPrimary, onTap: () {
                  if (partNameController.text.isEmpty ||
                      partDiscController.text.isEmpty) {
                    showCustomSnackbar(
                        context, "Please enter Part Name and Number");
                  } else if (mrpController.text.isEmpty ||
                      gstController.text.isEmpty) {
                    showCustomSnackbar(context, "Please enter MRP and GST");
                  } else {
                    String taxableAmount =
                        (totalAmount - double.parse(gstTotalAmount))
                            .toStringAsFixed(2);
                    widget.status == 4
                        ? Provider.of<InvoiceModel>(context, listen: false)
                            .addPart({
                            "location_Id": int.parse(
                                Preference.getString(PrefKeys.locationId)),
                            "prefix_Name": "online",
                            "pRtn": widget.invoiceNumber,
                            "item": partNameController.text.toString(),
                            "item_Name": partNameController.text.toString(),
                            "hsn_Code": hsnCode,
                            "quantity": quantityController.text.toString(),
                            "ndpPrice": salePriceController.text.toString(),
                            "discount_Item": "0",
                            "discountAmount": "0",
                            "totalPrice": "$totalAmount",
                            "gst": gstController.text.toString(),
                            "gstAmount": gstTotalAmount,
                            "cess": cessController.text.isEmpty
                                ? 0
                                : double.parse(cessController.text.toString()),
                            "cess_Amount": double.parse(cessTotalAmount),
                            "taxable": taxableAmount,
                            "tranDate": transdate,
                            "form_Type": "4",
                            "type": "1",
                            "itemId": partId ?? 0,
                            "hsn_Id": hsnId,
                            "igstAmount":
                                int.parse(gstController.text.toString()),
                            "cgstAmount":
                                int.parse(gstController.text.toString()) / 2,
                            "sgstAmount":
                                int.parse(gstController.text.toString()) / 2,
                            "reqserialno": 0,
                          })
                        : widget.status == 3
                            ? Provider.of<InvoiceModel>(context, listen: false)
                                .addPart({
                                "location_Id": int.parse(
                                    Preference.getString(PrefKeys.locationId)),
                                "prefix_Name": "online",
                                "doc_No": widget.invoiceNumber,
                                "item": partNameController.text.toString(),
                                "item_Name": partNameController.text.toString(),
                                "hsn_Code": hsnCode,
                                "qty": quantityController.text.toString(),
                                "mrp": "$totalAmount",
                                "sale_Price": taxableAmount,
                                "total_Price": totalAmount.toStringAsFixed(2),
                                "gst": gstController.text.toString(),
                                "gst_Amount": gstTotalAmount,
                                "cess": cessController.text.isEmpty
                                    ? "0"
                                    : cessController.text.toString(),
                                "cess_Amount": cessTotalAmount,
                                "taxable": taxableAmount,
                                "labour": "0",
                                "type": "1",
                                "discount_Item": "0",
                                "tranDate": transdate,
                                "form_Type": "4",
                                "dPP": "0",
                                "itemId": partId ?? 0,
                                "hsn_Id": hsnId,
                                "igstAmount":
                                    int.parse(gstController.text.toString()),
                                "cgstAmount":
                                    int.parse(gstController.text.toString()) /
                                        2,
                                "sgstAmount":
                                    int.parse(gstController.text.toString()) /
                                        2,
                              })
                            : widget.status == 2
                                ? Provider.of<InvoiceModel>(context,
                                        listen: false)
                                    .addPart({
                                    "location_Id": int.parse(
                                        Preference.getString(
                                            PrefKeys.locationId)),
                                    "prefix_Name": "online",
                                    "pInvo": widget.invoiceNumber,
                                    "item": partNameController.text.toString(),
                                    "item_Name":
                                        partNameController.text.toString(),
                                    "hsn_Code": hsnCode,
                                    "quantity":
                                        quantityController.text.toString(),
                                    "ndpPrice":
                                        salePriceController.text.toString(),
                                    "discount_Item": "0",
                                    "discountAmount": "0",
                                    "totalPrice": "$totalAmount",
                                    "gst": gstController.text.toString(),
                                    "gstAmount": gstTotalAmount,
                                    "cess": cessController.text.isEmpty
                                        ? 0
                                        : double.parse(
                                            cessController.text.toString()),
                                    "cess_Amount":
                                        double.parse(cessTotalAmount),
                                    "taxable": taxableAmount,
                                    "tranDate": transdate,
                                    "form_Type": "4",
                                    "itemId": partId ?? 0,
                                    "hsn_Id": hsnId,
                                    "igstAmount": int.parse(
                                        gstController.text.toString()),
                                    "cgstAmount": int.parse(
                                            gstController.text.toString()) /
                                        2,
                                    "sgstAmount": int.parse(
                                            gstController.text.toString()) /
                                        2,
                                    "reqserialno": 0,
                                  })
                                : Provider.of<InvoiceModel>(context,
                                        listen: false)
                                    .addPart({
                                    "Location_Id": int.parse(
                                        Preference.getString(
                                            PrefKeys.locationId)),
                                    "prefix_Name": "online",
                                    "invoice_No": widget.invoiceNumber,
                                    "item": partNameController.text.toString(),
                                    "item_Name":
                                        partNameController.text.toString(),
                                    "hsn_Code": hsnCode,
                                    "qty": quantityController.text.toString(),
                                    "mrp": mrpController.text.toString(),
                                    "sale_Price":
                                        salePriceController.text.toString(),
                                    "total_Price": "$totalAmount",
                                    "gst": gstController.text.toString(),
                                    "gst_Amount": gstTotalAmount,
                                    "cess": cessController.text.isEmpty
                                        ? 0
                                        : double.parse(
                                            cessController.text.toString()),
                                    "cess_Amount":
                                        double.parse(cessTotalAmount),
                                    "taxable": taxableAmount,
                                    "labour": "0",
                                    "discount_Item": discountController
                                            .text.isEmpty
                                        ? "0"
                                        : discountController.text.toString(),
                                    "type": "1",
                                    "tranDate": transdate,
                                    "form_Type": "4",
                                    "warranty_TypeId": 12,
                                    "mechnic_Id": 0,
                                    "issue_Date": transdate,
                                    "itemId": partId ?? 0,
                                    "hsn_Id": hsnId,
                                    "jobCard_No": 0,
                                    "prefix_Name_Job": "online",
                                    "igstAmount": int.parse(
                                        gstController.text.toString()),
                                    "cgstAmount": int.parse(
                                            gstController.text.toString()) /
                                        2,
                                    "sgstAmount": int.parse(
                                            gstController.text.toString()) /
                                        2
                                  });
                    Navigator.pop(context, "to update Data in parent widget");
                  }
                })
              ],
            )),
      ),
    );
  }

  //Get part List
  Future fatchpart() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetItemByLocationId?LocationId=${Preference.getString(PrefKeys.locationId)}");
    if (response is List) {
      // Map the response to a list of maps
      partList = response.map((item) => item as Map<String, dynamic>).toList();
      // Update the state if necessary
      setState(() {});
    } else {
      log('Error: API response is not a list');
    }
  }
}
