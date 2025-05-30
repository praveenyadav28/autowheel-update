// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class AddLabourMI extends StatefulWidget {
  AddLabourMI({required this.jobcardNo, super.key});
  int? jobcardNo;

  @override
  State<AddLabourMI> createState() => _AddLabourMIState();
}

class _AddLabourMIState extends State<AddLabourMI> {
  TextEditingController mrpController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController labourNameController = TextEditingController();
  TextEditingController jobcodeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  double totalAmount = 0.0;
  String transdate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  Map<String, dynamic> jobcardDetails = {};
  String salePrice = '0';
  @override
  void dispose() {
    gstController.dispose();
    mrpController.dispose();
    jobcodeController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final double gst = double.tryParse(gstController.text) ?? 0;
    final double mrp = double.tryParse(mrpController.text) ?? 0;

    final double taxAmount = mrp * (gst / (100 + gst));
    final double withoutTaxes = mrp - taxAmount;
    setState(() {
      salePrice = withoutTaxes.toStringAsFixed(2);
      gstTotalAmount = taxAmount.toStringAsFixed(2);
    });
  }

  //labour
  List<Map<String, dynamic>> labourList = [];
  int? labourId;
  String labourName = '';
  Map<String, dynamic>? labourValue;

//Gst Amount
  String gstTotalAmount = "0";

  //Sac Code
  String sacCode = '';
  int sacCodeId = 0;

  @override
  void initState() {
    fatchJobcardDetails().then((value) => setState(() {}));
    fatchlabour().then((value) => setState(() {}));
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
          title: const Text("Add Labour", overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        height: Sizes.height,
        color: AppColor.colPrimary.withOpacity(.2),
        child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: Sizes.height * 0.02, horizontal: Sizes.width * 0.03),
            child: addMasterOutside(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: dropdownTextfield(
                        context,
                        "Choose Labour",
                        searchDropDown(
                            context,
                            "Search for a Labour...",
                            labourList
                                .map((item) => DropdownMenuItem(
                                      onTap: () {
                                        setState(() {
                                          labourId = item['job_Code_Id'];
                                          labourNameController.text =
                                              item['labour_Name'];
                                          sacCode = item['sac_Code'];
                                          sacCodeId = item['sac_Code_Id'];
                                          jobcodeController.text =
                                              item['job_Code'];
                                          mrpController.text =
                                              item['mrp'].toString();
                                          gstController.text =
                                              item['igst'].toString();

                                          _updateAmount();
                                        });
                                      },
                                      value: item,
                                      child: Row(
                                        children: [
                                          Text(
                                            item['labour_Name'].toString(),
                                            style: rubikTextStyle(
                                                16,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            labourValue,
                            (value) {
                              setState(() {
                                labourValue = value;
                              });
                            },
                            searchController,
                            (value) {
                              setState(() {
                                labourList
                                    .where((item) => item['labour_Name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                            'Search for a Labour...',
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
                      var result = await pushTo(const LabourMaster());
                      if (result != null) {
                        labourValue = null;
                        fatchlabour().then((value) => setState(() {}));
                      }
                    },
                  )
                ],
              ),
              textformfiles(labourNameController, labelText: "Labour Name"),
              textformfiles(jobcodeController, labelText: "Job Code"),
              ReuseContainer(title: "Sale Price", subtitle: "₹ $salePrice"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: textformfiles(mrpController,
                          labelText: "MRP", keyboardType: TextInputType.number,
                          onChanged: (value) {
                    _updateAmount();
                  })),
                  const SizedBox(width: 10),
                  Expanded(
                      child: textformfiles(gstController,
                          labelText: "GST %",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                    _updateAmount();
                  })),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button("Add", AppColor.colPrimary, onTap: () {
                    if (labourNameController.text.isEmpty ||
                        jobcodeController.text.isEmpty) {
                      showCustomSnackbar(
                          context, "Please enter Labour Name and Job Code");
                    } else if (mrpController.text.isEmpty ||
                        gstController.text.isEmpty) {
                      showCustomSnackbar(context, "Please enter MRP and GST");
                    } else {
                      postItem();
                    }
                  }),
                ],
              )
            ], context: context)),
      ),
    );
  }

  //Get labour List
  Future fatchlabour() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLabourMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    if (response is List) {
      // Map the response to a list of maps
      labourList =
          response.map((item) => item as Map<String, dynamic>).toList();
      // Update the state if necessary
      setState(() {});
    } else {
      print('Error: API response is not a list');
    }
  }

//Post Material Invoice
  Future postItem() async {
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
          "Item": labourNameController.text.toString(),
          "Item_Name": labourNameController.text.toString(),
          "Hsn_Code": sacCode,
          "Qty": "1",
          "Mrp": mrpController.text.toString(),
          "Sale_Price": salePrice,
          "Total_Price": mrpController.text.toString(),
          "Gst": gstController.text.toString(),
          "Gst_Amount": gstTotalAmount,
          "Cess": 0,
          "Cess_Amount": 0,
          "Taxable": "0",
          "Labour": mrpController.text.toString(),
          "Discount_Item": "0",
          "Type": "2",
          "TranDate": transdate,
          "Form_Type": "4",
          "Warranty_TypeId": 12,
          "Mechnic_Id": jobcardDetails['mechanic_Id'],
          "Issue_Date": transdate,
          "ItemId": labourId ?? 0,
          "Hsn_Id": sacCodeId,
          "JobCard_No": 0,
          "Prefix_Name_Job": "online",
          "IgstAmount": int.parse(gstController.text.toString()),
          "CgstAmount": int.parse(gstController.text.toString()) / 2,
          "SgstAmount": int.parse(gstController.text.toString()) / 2
        }
      ]
    });

    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "for run api in material issue screen");
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

// Fatch Jobcard
  Future fatchJobcardDetails() async {
    var responseJobcard = await ApiService.fetchData(
        "Transactions/GetJobCardAW?prefix=online&refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}");
    var responseMI = await ApiService.fetchData(
        "Transactions/GetMIAW?prefix=online&refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}");
    if (responseMI['job_No'] != 0) {
      jobcardDetails = responseMI;
    } else if (responseJobcard['job_No'] != 0) {
      jobcardDetails = responseJobcard;
    } else {
      showCustomSnackbar(context, "Error on fatching data");
    }
  }
}
