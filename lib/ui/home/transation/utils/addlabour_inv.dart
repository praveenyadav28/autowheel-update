// ignore_for_file: must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class AddLabourInvoice extends StatefulWidget {
  AddLabourInvoice(
      {required this.invoiceNumber, required this.status, super.key});
  int? invoiceNumber;
  int? status;
  @override
  State<AddLabourInvoice> createState() => _AddLabourInvoiceState();
}

class _AddLabourInvoiceState extends State<AddLabourInvoice> {
  TextEditingController mrpController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController jobcodeController = TextEditingController();
  TextEditingController labourNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String transdate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  Map<String, dynamic> jobcardDetails = {};
  String salePrice = '0';
  @override
  void dispose() {
    gstController.dispose();
    mrpController.dispose();
    jobcodeController.dispose();
    searchController.dispose();
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
            child: Column(
              children: [
                addMasterOutside(children: [
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
                  textformfiles(labourNameController,
                      labelText: "Labour Name*"),
                  textformfiles(jobcodeController, labelText: "Job Code*"),
                  ReuseContainer(title: "Sale Price", subtitle: "₹ $salePrice"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: textformfiles(mrpController,
                              labelText: "MRP*",
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                        _updateAmount();
                      })),
                      const SizedBox(width: 10),
                      Expanded(
                          child: textformfiles(gstController,
                              labelText: "GST %*",
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                        _updateAmount();
                      })),
                    ],
                  ),
                ], context: context),
                button("Add", AppColor.colPrimary, onTap: () {
                  if (labourNameController.text.isEmpty ||
                      jobcodeController.text.isEmpty) {
                    showCustomSnackbar(
                        context, "Please enter Labour Name and Job Code");
                  } else if (mrpController.text.isEmpty ||
                      gstController.text.isEmpty) {
                    showCustomSnackbar(context, "Please enter MRP and GST");
                  } else {
                    widget.status == 2
                        ? Provider.of<InvoiceModel>(context, listen: false)
                            .addLabour({
                            "location_Id": int.parse(
                                Preference.getString(PrefKeys.locationId)),
                            "prefix_Name": "online",
                            "doc_No": widget.invoiceNumber,
                            "item": labourNameController.text.toString(),
                            "item_Name": labourNameController.text.toString(),
                            "hsn_Code": sacCode,
                            "qty": "1",
                            "mrp": mrpController.text.toString(),
                            "sale_Price": salePrice,
                            "total_Price": mrpController.text.toString(),
                            "gst": gstController.text.toString(),
                            "gst_Amount": gstTotalAmount,
                            "cess": "0",
                            "cess_Amount": "0",
                            "taxable": salePrice,
                            "labour": "0",
                            "type": "2",
                            "discount_Item": "0",
                            "tranDate": transdate,
                            "form_Type": "4",
                            "dPP": "0",
                            "itemId": labourId ?? 0,
                            "hsn_Id": sacCodeId,
                            "igstAmount":
                                int.parse(gstController.text.toString()),
                            "cgstAmount":
                                int.parse(gstController.text.toString()) / 2,
                            "sgstAmount":
                                int.parse(gstController.text.toString()) / 2,
                          })
                        : Provider.of<InvoiceModel>(context, listen: false)
                            .addLabour({
                            "Location_Id": int.parse(
                                Preference.getString(PrefKeys.locationId)),
                            "prefix_Name": "online",
                            "Invoice_No": widget.invoiceNumber,
                            "item": labourNameController.text.toString(),
                            "item_Name": labourNameController.text.toString(),
                            "hsn_Code": sacCode,
                            "qty": "1",
                            "mrp": mrpController.text.toString(),
                            "sale_Price": salePrice,
                            "total_Price": mrpController.text.toString(),
                            "gst": gstController.text.toString(),
                            "gst_Amount": gstTotalAmount,
                            "cess": 0,
                            "cess_Amount": 0,
                            "taxable": salePrice,
                            "tabour": mrpController.text.toString(),
                            "discount_Item": "0",
                            "type": "2",
                            "tranDate": transdate,
                            "form_Type": "4",
                            "warranty_TypeId": 12,
                            "mechnic_Id": 0,
                            "issue_Date": transdate,
                            "itemId": labourId ?? 0,
                            "hsn_Id": sacCodeId,
                            "jobCard_No": 0,
                            "prefix_Name_Job": "online",
                            "igstAmount":
                                double.parse(gstController.text.toString()),
                            "cgstAmount":
                                double.parse(gstController.text.toString()) / 2,
                            "sgstAmount":
                                double.parse(gstController.text.toString()) / 2
                          });
                    Navigator.pop(context, "to update Data in parent widget");
                  }
                })
              ],
            )),
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
    } else {}
  }
}
