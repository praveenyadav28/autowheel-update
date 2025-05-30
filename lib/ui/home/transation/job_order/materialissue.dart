// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class MaterialIssue extends StatefulWidget {
  MaterialIssue({
    required this.jobcardNo,
    required this.materialIsuueNumber,
    super.key,
  });
  int? jobcardNo;
  int? materialIsuueNumber;
  @override
  State<MaterialIssue> createState() => _MaterialIssueState();
}

class _MaterialIssueState extends State<MaterialIssue> {
  Map<String, dynamic> jobcardDetails = {};

  //Model Name
  List<Map<String, dynamic>> modelNameList = [];
  String modelName = '';
  int? modelNameId;

  //Mechanic List
  List<Map<String, dynamic>> mechanicList = [];
  //manager List
  List<Map<String, dynamic>> managerList = [];
  //Ledger List
  List ledgerList = [];

  //Part List
  List sparePartList = [];

  //Labour List
  List labourList = [];

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

  bool isGstIncluded = false; // New state for GST inclusion/exclusion

  @override
  void initState() {
    fatchJobcardDetails().then((value) {
      fatchledger().then((value) => setState(() {}));
      getAccountDetails().then((value) => setState(() {}));
      fatchmanager().then((value) => setState(() {}));
      fatchmechanic().then((value) => setState(() {}));
      fatchVehicle().then((value) => setState(() {}));
      fetchPart().then(
        (value) => setState(() {
          quantityController.text = "1";
        }),
      );
    });

    super.initState();
  }

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

  String buttonName = "View Jobcard";
  @override
  Widget build(BuildContext context) {
    //Button Name
    if (widget.materialIsuueNumber == 1) {
      buttonName = "Start";
    } else if (widget.materialIsuueNumber == 2 ||
        widget.materialIsuueNumber == 3) {
      buttonName = "Ready";
    } else if (widget.materialIsuueNumber == 4) {
      buttonName = "Generate Invoice";
    } else if (widget.materialIsuueNumber == 5) {
      buttonName = "View Jobcard";
    }

    //Ledger
    int ledgerId = jobcardDetails['ledger_Id'] ?? -10;
    String ledgerName =
        ledgerList.isEmpty
            ? ""
            : ledgerList.firstWhere(
              (element) => element['ledger_Id'] == ledgerId,
            )['ledger_Name'];
    String ledgerNumber =
        ledgerList.isEmpty
            ? ""
            : ledgerList.firstWhere(
              (element) => element['ledger_Id'] == ledgerId,
            )['mob'];
    String ledgerAddress =
        ledgerList.isEmpty
            ? ""
            : ledgerList.firstWhere(
              (element) => element['ledger_Id'] == ledgerId,
            )['address'];
    String ledgerGST =
        ledgerList.isEmpty
            ? ""
            : ledgerList.firstWhere(
              (element) => element['ledger_Id'] == ledgerId,
            )['gst_No'];
    ledgerDetails = {
      'id': ledgerId,
      'name': ledgerName,
      'mob': ledgerNumber,
      'address': ledgerAddress,
      'gst_No': ledgerGST,
    };
    //mechanic
    int mechanicId = jobcardDetails['mechanic_Id'] ?? -10;
    String mechanicName =
        mechanicList.isEmpty
            ? ""
            : mechanicList.firstWhere(
              (element) => element['id'] == mechanicId,
            )['name'];

    //model
    int modelId = jobcardDetails['model_Id'] ?? -10;
    String modelName =
        modelNameList.isEmpty
            ? ""
            : modelNameList.firstWhere(
              (element) => element['id'] == modelId,
            )['name'];

    //manager
    int managerId = jobcardDetails['work_Mgr_Id'] ?? -10;
    String managerName =
        managerList.isEmpty
            ? ""
            : managerList.firstWhere(
              (element) => element['id'] == managerId,
            )['name'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text("Material Issue", overflow: TextOverflow.ellipsis),
        backgroundColor: AppColor.colPrimary,
      ),
      backgroundColor: AppColor.colWhite,
      body:
          jobcardDetails.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Container(
                height: Sizes.height,
                color: AppColor.colPrimary.withOpacity(.1),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.height * 0.02,
                    horizontal: Sizes.width * .03,
                  ),
                  child: Column(
                    children: [
                      addMasterOutside(
                        context: context,
                        children: [
                          ReuseContainer(
                            title: "Draft on",
                            subtitle: jobcardDetails['job_Date'].substring(
                              0,
                              jobcardDetails['job_Date'].length - 12,
                            ),
                          ),
                          ReuseContainer(
                            title: "Manager",
                            subtitle: managerName,
                          ),
                          ReuseContainer(
                            title: "Machenic",
                            subtitle: mechanicName,
                          ),
                          ReuseContainer(
                            title: "Vehicle Number",
                            subtitle: jobcardDetails["vehicle_No"],
                          ),
                          ReuseContainer(
                            title: "Customer Name",
                            subtitle: ledgerName,
                          ),
                          ReuseContainer(
                            title: "Mobile Number",
                            subtitle: ledgerNumber,
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: Sizes.width * 0.03),
                      //   child: jobcardContainer(context),
                      // ),
                      // SizedBox(height: Sizes.height * 0.02),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: Sizes.height * 0.02,
                          children: [
                            Container(
                              width:
                                  Sizes.width <= 900
                                      ? double.infinity
                                      : Sizes.width * .45,
                              decoration: decorationBox(),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text(
                                      "‣ Add Spare Part",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing:
                                        widget.materialIsuueNumber == 5 ||
                                                widget.materialIsuueNumber == 4
                                            ? null
                                            : ElevatedButton(
                                              onPressed: () async {
                                                final result = await pushTo(
                                                  AddPartMI(
                                                    jobcardNo: widget.jobcardNo,
                                                  ),
                                                );
                                                if (result != null) {
                                                  fatchJobcardDetails().then(
                                                    (value) => setState(() {}),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColor.colPrimary,
                                              ),
                                              child: const Text('Add +'),
                                            ),
                                  ),
                                  const Divider(),

                                  // addMasterOutside(
                                  //   children: [
                                  //     Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         Expanded(
                                  //           child: dropdownTextfield(
                                  //             context,
                                  //             "Choose Part",
                                  //             searchDropDown(
                                  //               context,
                                  //               "Search for a Part...",
                                  //               partList
                                  //                   .map(
                                  //                     (
                                  //                       item,
                                  //                     ) => DropdownMenuItem(
                                  //                       onTap: () {
                                  //                         setState(() {
                                  //                           partId =
                                  //                               item['item_Id'];
                                  //                           partNameController
                                  //                                   .text =
                                  //                               item['item_Name'];
                                  //                           hsnCode =
                                  //                               item['hsn_Code'];
                                  //                           hsnId =
                                  //                               item['hsn_Id'];
                                  //                           mrpController.text =
                                  //                               item['mrp']
                                  //                                   .toString();
                                  //                           totalAmount =
                                  //                               item['mrp'];
                                  //                           gstController.text =
                                  //                               item['igst']
                                  //                                   .toString();
                                  //                           salePriceController
                                  //                                   .text =
                                  //                               item['sale_Price']
                                  //                                   .toString();
                                  //                           partDiscController
                                  //                                   .text =
                                  //                               item['item_Des']
                                  //                                   .toString();
                                  //                           quantityController
                                  //                               .text = "1";
                                  //                           _updateAmount();
                                  //                           _updateMRP();
                                  //                         });
                                  //                       },
                                  //                       value: item,
                                  //                       child: Row(
                                  //                         children: [
                                  //                           Text(
                                  //                             item['item_Name']
                                  //                                 .toString(),
                                  //                             style:
                                  //                                 rubikTextStyle(
                                  //                                   16,
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                                   AppColor
                                  //                                       .colBlack,
                                  //                                 ),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   )
                                  //                   .toList(),
                                  //               partValue,
                                  //               (value) {
                                  //                 setState(() {
                                  //                   partValue = value;
                                  //                 });
                                  //               },
                                  //               searchController,
                                  //               (value) {
                                  //                 setState(() {
                                  //                   partList
                                  //                       .where(
                                  //                         (
                                  //                           item,
                                  //                         ) => item['item_Name']
                                  //                             .toString()
                                  //                             .toLowerCase()
                                  //                             .contains(
                                  //                               value
                                  //                                   .toLowerCase(),
                                  //                             ),
                                  //                       )
                                  //                       .toList();
                                  //                 });
                                  //               },
                                  //               'Search for a Part...',
                                  //               (isOpen) {
                                  //                 if (!isOpen) {
                                  //                   searchController.clear();
                                  //                 }
                                  //               },
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 10),
                                  //         addDefaultButton(context, () async {
                                  //           var result = await pushTo(
                                  //             const PartMaster(),
                                  //           );
                                  //           if (result != null) {
                                  //             partValue = null;
                                  //             fetchPart().then(
                                  //               (value) => setState(() {}),
                                  //             );
                                  //           }
                                  //         }),
                                  //       ],
                                  //     ),
                                  //     textformfiles(
                                  //       partNameController,
                                  //       labelText: "Part Name*",
                                  //     ),
                                  //     textformfiles(
                                  //       partDiscController,
                                  //       labelText: "Part Number*",
                                  //     ),
                                  //     Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         Expanded(
                                  //           child: textformfiles(
                                  //             quantityController,
                                  //             labelText: "Quantity",
                                  //             keyboardType:
                                  //                 TextInputType.number,
                                  //             onChanged: (value) {
                                  //               setState(_updateAmount);
                                  //             },
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 10),
                                  //         Expanded(
                                  //           child: textformfiles(
                                  //             salePriceController,
                                  //             labelText: "Sale Price",
                                  //             keyboardType:
                                  //                 TextInputType.number,
                                  //             onChanged: (value) {
                                  //               setState(_updateMRP);
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         Expanded(
                                  //           child: textformfiles(
                                  //             mrpController,
                                  //             labelText: "MRP*",
                                  //             keyboardType:
                                  //                 TextInputType.number,
                                  //             onChanged: (value) {
                                  //               setState(_updateAmount);
                                  //             },
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 10),
                                  //         Expanded(
                                  //           child: textformfiles(
                                  //             cessController,
                                  //             labelText: "Cess",
                                  //             keyboardType:
                                  //                 TextInputType.number,
                                  //             onChanged: (value) {
                                  //               setState(_updateAmount);
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         Expanded(
                                  //           child: textformfiles(
                                  //             discountController,
                                  //             labelText: "Discount % on MRP",
                                  //             keyboardType:
                                  //                 TextInputType.number,
                                  //             onChanged: (value) {
                                  //               setState(_updateMRP);
                                  //             },
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 10),
                                  //         Expanded(
                                  //           child: textformfiles(
                                  //             gstController,
                                  //             labelText: "GST %*",
                                  //             keyboardType:
                                  //                 TextInputType.number,
                                  //             onChanged: (value) {
                                  //               setState(_updateMRP);
                                  //             },
                                  //             // suffixIcon: Switch(
                                  //             //   activeTrackColor: AppColor.colPriLite,
                                  //             //   activeColor: AppColor.colPrimary,
                                  //             //   value: isGstIncluded,
                                  //             //   onChanged: (bool value) {
                                  //             //     setState(() {
                                  //             //       isGstIncluded = value;
                                  //             //       _updateMRP();
                                  //             //     });
                                  //             //   },
                                  //             // ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     ReuseContainer(
                                  //       title: "Total Amount",
                                  //       subtitle: totalAmount.toStringAsFixed(
                                  //         2,
                                  //       ),
                                  //     ),
                                  //     Column(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: [
                                  //         button(
                                  //           "Add",
                                  //           AppColor.colPrimary,
                                  //           onTap: () {
                                  //             if (partNameController
                                  //                     .text
                                  //                     .isEmpty ||
                                  //                 partDiscController
                                  //                     .text
                                  //                     .isEmpty) {
                                  //               showCustomSnackbar(
                                  //                 context,
                                  //                 "Please enter Part Name and Number",
                                  //               );
                                  //             } else if (mrpController
                                  //                     .text
                                  //                     .isEmpty ||
                                  //                 gstController.text.isEmpty) {
                                  //               showCustomSnackbar(
                                  //                 context,
                                  //                 "Please enter MRP and GST",
                                  //               );
                                  //             } else {
                                  //               postItem().then((value) {
                                  //                 fatchJobcardDetails().then(
                                  //                   (value) => setState(() {}),
                                  //                 );
                                  //               });
                                  //             }
                                  //           },
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  //   context: context,
                                  // ),
                                  SizedBox(
                                    height: 200,
                                    child:
                                        sparePartList.isEmpty
                                            ? const Center(
                                              child: Text(
                                                "No Spare Parts Added",
                                              ),
                                            )
                                            : SingleChildScrollView(
                                              child: Column(
                                                children: List.generate(sparePartList.length, (
                                                  index,
                                                ) {
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                            ),
                                                        dense: true,
                                                        title: Text(
                                                          sparePartList[index]['item_Name'],
                                                          style: rubikTextStyle(
                                                            15,
                                                            FontWeight.w500,
                                                            AppColor.colBlack,
                                                          ),
                                                        ),
                                                        subtitle: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "₹${sparePartList[index]['sale_Price']} * ${sparePartList[index]['qty']} ",
                                                              style:
                                                                  rubikTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w400,
                                                                    AppColor
                                                                        .colBlack,
                                                                  ),
                                                            ),
                                                            Text(
                                                              " ( ${sparePartList[index]['gst']}% gst )",
                                                              style:
                                                                  rubikTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w400,
                                                                    AppColor
                                                                        .colGrey,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "${sparePartList[index]['total_Price']}",
                                                            ),
                                                            PopupMenuButton(
                                                              position:
                                                                  PopupMenuPosition
                                                                      .under,
                                                              itemBuilder:
                                                                  (
                                                                    BuildContext
                                                                    context,
                                                                  ) => <
                                                                    PopupMenuEntry
                                                                  >[
                                                                    PopupMenuItem(
                                                                      value:
                                                                          'Remove',
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (
                                                                            BuildContext
                                                                            context,
                                                                          ) {
                                                                            return AlertDialog(
                                                                              title: const Text(
                                                                                'Remove part',
                                                                              ),
                                                                              content: const Text(
                                                                                'Are you sure you want to remove part ?',
                                                                              ),
                                                                              actions: <
                                                                                Widget
                                                                              >[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(
                                                                                      context,
                                                                                    ).pop();
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Cancel',
                                                                                  ),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    deletepartApi(
                                                                                      sparePartList[index]['id'],
                                                                                    ).then(
                                                                                      (
                                                                                        value,
                                                                                      ) {
                                                                                        fatchJobcardDetails().then(
                                                                                          (
                                                                                            value,
                                                                                          ) => setState(
                                                                                            () {
                                                                                              Navigator.of(
                                                                                                context,
                                                                                              ).pop();
                                                                                            },
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  child: Text(
                                                                                    'Remove',
                                                                                    style: TextStyle(
                                                                                      color:
                                                                                          AppColor.colRideFare,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        'Remove',
                                                                      ),
                                                                    ),
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
                                                                bottom: 7,
                                                              ),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                AppColor
                                                                    .colPrimary,
                                                            child: Text(
                                                              "${index + 1}",
                                                              style:
                                                                  rubikTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w500,
                                                                    AppColor
                                                                        .colWhite,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ),
                                            ),
                                  ),
                                  Divider(
                                    thickness: 0,
                                    color: AppColor.colGrey,
                                  ),
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      "Subtotal",
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                    trailing: Text(
                                      "₹ ${sparePartList.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  Sizes.width <= 900
                                      ? double.infinity
                                      : Sizes.width * .45,
                              decoration: decorationBox(),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text(
                                      "‣ Add Labour",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing:
                                        widget.materialIsuueNumber == 5 ||
                                                widget.materialIsuueNumber == 4
                                            ? null
                                            : ElevatedButton(
                                              onPressed: () async {
                                                final result = await pushTo(
                                                  AddLabourMI(
                                                    jobcardNo: widget.jobcardNo,
                                                  ),
                                                );
                                                if (result != null) {
                                                  fatchJobcardDetails().then(
                                                    (value) => setState(() {}),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColor.colPrimary,
                                              ),
                                              child: const Text('Add +'),
                                            ),
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    height: 200,
                                    child:
                                        labourList.isEmpty
                                            ? const Center(
                                              child: Text("No Labour Added"),
                                            )
                                            : SingleChildScrollView(
                                              child: Column(
                                                children: List.generate(labourList.length, (
                                                  index,
                                                ) {
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                            ),
                                                        dense: true,
                                                        title: Text(
                                                          labourList[index]['item_Name'],
                                                          style: rubikTextStyle(
                                                            15,
                                                            FontWeight.w500,
                                                            AppColor.colBlack,
                                                          ),
                                                        ),
                                                        subtitle: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "₹${labourList[index]['sale_Price']} * ${labourList[index]['qty']} ",
                                                              style:
                                                                  rubikTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w400,
                                                                    AppColor
                                                                        .colBlack,
                                                                  ),
                                                            ),
                                                            Text(
                                                              " ( ${labourList[index]['gst']}% gst )",
                                                              style:
                                                                  rubikTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w400,
                                                                    AppColor
                                                                        .colGrey,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "${labourList[index]['total_Price']}",
                                                            ),
                                                            PopupMenuButton(
                                                              position:
                                                                  PopupMenuPosition
                                                                      .under,
                                                              itemBuilder:
                                                                  (
                                                                    BuildContext
                                                                    context,
                                                                  ) => <
                                                                    PopupMenuEntry
                                                                  >[
                                                                    PopupMenuItem(
                                                                      value:
                                                                          'Remove',
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (
                                                                            BuildContext
                                                                            context,
                                                                          ) {
                                                                            return AlertDialog(
                                                                              title: const Text(
                                                                                'Remove labour',
                                                                              ),
                                                                              content: const Text(
                                                                                'Are you sure you want to remove labour ?',
                                                                              ),
                                                                              actions: <
                                                                                Widget
                                                                              >[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(
                                                                                      context,
                                                                                    ).pop();
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Cancel',
                                                                                  ),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    deletepartApi(
                                                                                      labourList[index]['id'],
                                                                                    ).then(
                                                                                      (
                                                                                        value,
                                                                                      ) {
                                                                                        fatchJobcardDetails().then(
                                                                                          (
                                                                                            value,
                                                                                          ) => setState(
                                                                                            () {
                                                                                              Navigator.of(
                                                                                                context,
                                                                                              ).pop();
                                                                                            },
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  child: Text(
                                                                                    'Remove',
                                                                                    style: TextStyle(
                                                                                      color:
                                                                                          AppColor.colRideFare,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        'Remove',
                                                                      ),
                                                                    ),
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
                                                                bottom: 7,
                                                              ),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                AppColor
                                                                    .colPrimary,
                                                            child: Text(
                                                              "${index + 1}",
                                                              style:
                                                                  rubikTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w500,
                                                                    AppColor
                                                                        .colWhite,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ),
                                            ),
                                  ),
                                  Divider(
                                    thickness: 0,
                                    color: AppColor.colGrey,
                                  ),
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      "Subtotal",
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                    trailing: Text(
                                      "₹ ${labourList.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
                                      style: rubikTextStyle(
                                        16,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Sizes.height * 0.02),
                      widget.materialIsuueNumber == 10
                          ? Row(
                            children: [
                              Expanded(
                                child: button(
                                  "On Hold",
                                  AppColor.colRideFare,
                                  onTap: () {
                                    if (sparePartList.length +
                                            labourList.length ==
                                        0) {
                                      showCustomSnackbar(
                                        context,
                                        "Please add Labour or Part",
                                      );
                                    } else {
                                      postMaterialIssue(2);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: button(
                                  "Ready",
                                  AppColor.colPrimary,
                                  onTap: () {
                                    if (sparePartList.length +
                                            labourList.length ==
                                        0) {
                                      showCustomSnackbar(
                                        context,
                                        "Please add Labour or Part",
                                      );
                                    } else {
                                      postMaterialIssue(3);
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                          : button(
                            buttonName,
                            AppColor.colPrimary,
                            onTap: () {
                              if (sparePartList.length + labourList.length ==
                                  0) {
                                showCustomSnackbar(
                                  context,
                                  "Please add Labour or Part",
                                );
                              } else {
                                widget.materialIsuueNumber == 4
                                    ? pushTo(
                                      SaleInvoice(
                                        invoiceNumber: 0,
                                        saleIvoiceItems:
                                            jobcardDetails['jobCard_Items'],
                                        jobcardNumber: widget.jobcardNo ?? 0,
                                      ),
                                    )
                                    : null;
                                widget.materialIsuueNumber == 5
                                    ? generateInvoicePDF(
                                      1,
                                      jobcardDetails,
                                      companyDetails,
                                      ledgerDetails,
                                      modalName: modelName,
                                    )
                                    : null;
                                widget.materialIsuueNumber == 5 ||
                                        widget.materialIsuueNumber == 4
                                    ? null
                                    : postMaterialIssue(
                                      widget.materialIsuueNumber == 10
                                          ? 3
                                          : widget.materialIsuueNumber,
                                    );
                              }
                            },
                          ),
                    ],
                  ),
                ),
              ),
    );
  }

  // Fatch Jobcard
  Future fatchJobcardDetails() async {
    var responseJobcard = await ApiService.fetchData(
      "Transactions/GetJobCardAW?prefix=online&refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    var responseMI = await ApiService.fetchData(
      "Transactions/GetMIAW?prefix=online&refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}",
    );

    // Check if either response contains valid job details
    if (responseMI['job_No'] != 0) {
      jobcardDetails = responseMI;
    } else if (responseJobcard['job_No'] != 0) {
      jobcardDetails = responseJobcard;
    } else {
      showCustomSnackbar(context, "Error fetching data");
      return;
    }

    // Clear previous lists
    sparePartList.clear();
    labourList.clear();

    // Iterate through jobCard_Items and classify based on 'type'
    List items = jobcardDetails['jobCard_Items'];
    for (var item in items) {
      if (item['type'] == "1") {
        sparePartList.add(item);
      } else if (item['type'] == "2") {
        labourList.add(item);
      }
    }
  }

  //Get manager List
  Future fatchmanager() async {
    List manager = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseDesinationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&Deginationid=1",
    );
    List supervisor = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseDesinationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&Deginationid=2",
    );

    List response = [...manager, ...supervisor];

    managerList = List<Map<String, dynamic>>.from(
      response.map((item) => {'id': item['id'], 'name': item['staff_Name']}),
    );
  }

  //Get mechanic List
  Future fatchmechanic() async {
    List response = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseDesinationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&Deginationid=3",
    );

    mechanicList = List<Map<String, dynamic>>.from(
      response.map((item) => {'id': item['id'], 'name': item['staff_Name']}),
    );
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetLedgerByGroupId?LedgerGroupId=10",
    );

    ledgerList = response;
  }

  //Delete part
  Future deletepartApi(int? partId) async {
    var response = await ApiService.postData(
      "Transactions/DeleteMiItemsAW?Id=$partId",
      {},
    );

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
      fatchJobcardDetails().then((value) => setState(() {}));
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

  //Post material Issue
  Future postMaterialIssue(int? id) async {
    var response = await ApiService.postData(
      "Transactions/PostJobCloseAW?refno=${widget.jobcardNo}&locationid=${Preference.getString(PrefKeys.locationId)}&checklist=000000000000&jobclosestatus=$id",
      {},
    );

    if (response['sr_No'] == 0) {
      id == 4 ? null : Navigator.pop(context, "for run api in slider screen");
    }
  }

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> ledgerDetails = {};

  //Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
      "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}",
    );
  }

  //Fatch Model Name list
  Future fatchVehicle() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetVehicleMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    modelNameList = List<Map<String, dynamic>>.from(
      response.map(
        (item) => {
          'id': item['model_Id'],
          'name': "${item['model_Name']} ${item['model_Code']}",
        },
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
      // showCustomSnackbarSuccess(context, '${response["message"]}');

      // setState(() {});
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }
}
