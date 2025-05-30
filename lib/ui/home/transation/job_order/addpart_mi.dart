// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class AddPartMI extends StatefulWidget {
  AddPartMI({required this.jobcardNo, super.key});
  int? jobcardNo;

  @override
  State<AddPartMI> createState() => _AddPartMIState();
}

class _AddPartMIState extends State<AddPartMI> {
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
    totalAmount =
        mrp *
        (quantityController.text.isEmpty
            ? 0
            : double.parse(quantityController.text));
  }

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
    fetchJobcardDetails().then((value) => setState(() {}));
    fetchPart().then(
      (value) => setState(() {
        quantityController.text = "1";
      }),
    );
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text("Add Part", overflow: TextOverflow.ellipsis),
        backgroundColor: AppColor.colPrimary,
      ),
      backgroundColor: AppColor.colWhite,
      body: Container(
        height: Sizes.height,
        color: AppColor.colPrimary.withOpacity(.2),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02,
            horizontal: Sizes.width * 0.03,
          ),
          child: Column(
            children: [
              addMasterOutside(
                children: [
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
                                .map(
                                  (item) => DropdownMenuItem(
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
                                          item['item_Name'].toString(),
                                          style: rubikTextStyle(
                                            16,
                                            FontWeight.w500,
                                            AppColor.colBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
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
                                    .where(
                                      (item) => item['item_Name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()),
                                    )
                                    .toList();
                              });
                            },
                            'Search for a Part...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      addDefaultButton(context, () async {
                        var result = await pushTo(const PartMaster());
                        if (result != null) {
                          partValue = null;
                          fetchPart().then((value) => setState(() {}));
                        }
                      }),
                    ],
                  ),
                  textformfiles(partNameController, labelText: "Part Name*"),
                  textformfiles(partDiscController, labelText: "Part Number*"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          quantityController,
                          labelText: "Quantity",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(_updateAmount);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          salePriceController,
                          labelText: "Sale Price",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(_updateMRP);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          mrpController,
                          labelText: "MRP*",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(_updateAmount);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          cessController,
                          labelText: "Cess",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(_updateAmount);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          discountController,
                          labelText: "Discount % on MRP",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(_updateMRP);
                          },
                        ),
                      ),
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
                        ),
                      ),
                    ],
                  ),
                  ReuseContainer(
                    title: "Total Amount",
                    subtitle: totalAmount.toStringAsFixed(2),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      button(
                        "Add",
                        AppColor.colPrimary,
                        onTap: () {
                          if (partNameController.text.isEmpty ||
                              partDiscController.text.isEmpty) {
                            showCustomSnackbar(
                              context,
                              "Please enter Part Name and Number",
                            );
                          } else if (mrpController.text.isEmpty ||
                              gstController.text.isEmpty) {
                            showCustomSnackbar(
                              context,
                              "Please enter MRP and GST",
                            );
                          } else {
                            postItem();
                          }
                        },
                      ),
                    ],
                  ),
                ],
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Get part List
  Future fetchPart() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetItemByLocationId?LocationId=${Preference.getString(PrefKeys.locationId)}",
    );
    if (response is List) {
      // Map the response to a list of maps
      partList = response.map((item) => item as Map<String, dynamic>).toList();
      // Update the state if necessary
      setState(() {});
    }
  }

  //Post Material Invoice
  Future postItem() async {
    String taxableAmount = "${totalAmount - double.parse(gstTotalAmount)}";
    var response = await ApiService.postData('Transactions/PostMIAW', {
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
      "Prefix_Name": "online",
      "Job_No": widget.jobcardNo,
      "Job_Date": jobcardDetails['job_Date'],
      "Vehicle_No": jobcardDetails["vehicle_No"],
      "Chassis_No": jobcardDetails["chassis_No"],
      "Engine_No": jobcardDetails["engine_No"],
      "Model_Id": jobcardDetails['model_Id'],
      "Colour_Id": jobcardDetails['colour_Id'],
      "Source_Id": jobcardDetails['source_Id'],
      "Service_type_id": jobcardDetails['service_type_id'],
      "Coupon_No": jobcardDetails['coupon_No'],
      "Service_No": jobcardDetails['service_No'],
      "Kms": jobcardDetails['kms'],
      "Fuel": jobcardDetails['fuel'],
      "Vehicle_Sold": jobcardDetails["vehicle_Sold"],
      "Mechanic_Id": jobcardDetails['mechanic_Id'],
      "Work_Mgr_Id": jobcardDetails['work_Mgr_Id'],
      "Ledger_Id": jobcardDetails['ledger_Id'],
      "Customer_Name": jobcardDetails['customer_Name'],
      "Job_In": jobcardDetails['job_In'],
      "Job_InTime": jobcardDetails['job_InTime'],
      "Job_Out": jobcardDetails['job_Out'],
      "Job_OutTime": jobcardDetails['job_OutTime'],
      "Customer_Voice": jobcardDetails['customer_Voice'],
      "Job_Status": jobcardDetails['job_Status'],
      "Next_ServiceInDays": jobcardDetails['next_ServiceInDays'],
      "Next_ServiceOnDate": jobcardDetails['next_ServiceOnDate'],
      "Insurance_Renewal": jobcardDetails['insurance_Renewal'],
      "Remarks": jobcardDetails['remarks'],
      "Extra1": "0",
      "Extra2": "0",
      "Extra3": "0",
      "Extra4": "0",
      "jobCard_Items": [
        {
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "Prefix_Name": "online",
          "Job_No": widget.jobcardNo,
          "Item": partNameController.text.toString(),
          "Item_Name": partNameController.text.toString(),
          "Hsn_Code": hsnCode,
          "Qty": quantityController.text.toString(),
          "Mrp": mrpController.text.toString(),
          "Sale_Price": salePriceController.text.toString(),
          "Total_Price": totalAmount.toStringAsFixed(2),
          "Gst": gstController.text.toString(),
          "Gst_Amount": gstTotalAmount,
          "Cess":
              cessController.text.isEmpty
                  ? 0
                  : double.parse(cessController.text.toString()),
          "Cess_Amount": double.parse(cessTotalAmount),
          "Taxable": double.parse(taxableAmount).toStringAsFixed(2),
          "Labour": "0",
          "Discount_Item":
              discountController.text.isEmpty
                  ? "0"
                  : discountController.text.toString(),
          "Type": "1",
          "TranDate": transdate,
          "Form_Type": "4",
          "Warranty_TypeId": 12,
          "Mechnic_Id": jobcardDetails['mechanic_Id'],
          "Issue_Date": transdate,
          "ItemId": partId ?? 0,
          "Hsn_Id": hsnId,
          "JobCard_No": 0,
          "Prefix_Name_Job": "online",
          "IgstAmount": int.parse(gstController.text.toString()),
          "CgstAmount": int.parse(gstController.text.toString()) / 2,
          "SgstAmount": int.parse(gstController.text.toString()) / 2,
        },
      ],
    });

    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "for run api in material issue screen");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  // Fatch Jobcard
  Future fetchJobcardDetails() async {
    var responseJobcard = await ApiService.fetchData(
      "Transactions/GetJobCardAW?prefix=online&refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    var responseMI = await ApiService.fetchData(
      "Transactions/GetMIAW?prefix=online&refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    if (responseMI['job_No'] != 0) {
      jobcardDetails = responseMI;
    } else if (responseJobcard['job_No'] != 0) {
      jobcardDetails = responseJobcard;
    } else {
      showCustomSnackbar(context, "Error on fatching data");
    }
  }
}
