// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/ui/home/dashboard/excel/purchase/purchanse_invoice.dart';
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class PurchaseInvoiceView extends StatefulWidget {
  PurchaseInvoiceView({required this.reportType, super.key});
  bool reportType = false;
  @override
  State<PurchaseInvoiceView> createState() => _PurchaseInvoiceViewState();
}

class _PurchaseInvoiceViewState extends State<PurchaseInvoiceView> {
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController searchController = TextEditingController();

  List<dynamic> purchaseInvoiceList = [];
  List<Map<String, dynamic>> ledgerList = [];
  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> pInvoiceDetails = {};

//All Prospect Data List
  List filteredList = [];
  String ledgerName = '';

  @override
  void initState() {
    datepickar1.text = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    datepickar2.text =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    getAccountDetails().then((value) => setState(() {}));
    fatchledger().then((value) => setState(() {
          widget.reportType
              ? null
              : getpurchaseInvoice(
                      dateFrom: datepickar1.text, dateTo: datepickar2.text)
                  .then((value) => setState(() {
                        filteredList = purchaseInvoiceList;
                      }));
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = purchaseInvoiceList.where((value) {
        // Ledger
        int ledgerId = value['ledger_Id'];
        String ledgerName = ledgerList.isEmpty
            ? ""
            : ledgerList
                .firstWhere((element) => element['id'] == ledgerId)['name'];
        return ledgerName.toLowerCase().contains(searchText.toLowerCase()) ||
            value['pInvo']
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase());
      }).toList();
    });
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
            IconButton(
                onPressed: () async {
                  createExcelPurchaseInvoice(filteredList,
                      ledgerList: ledgerList);
                },
                icon: const Icon(Icons.document_scanner))
          ],
          title: Text(
              widget.reportType
                  ? "Purchase Invoice Report"
                  : "Purchase Invoice View",
              overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        color: AppColor.colPrimary.withOpacity(.1),
        height: Sizes.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.03, horizontal: Sizes.width * .03),
          child: Column(
            children: [
              widget.reportType
                  ? addMasterOutside(children: [
                      Column(
                        children: [
                          dropdownTextfield(
                            context,
                            "From Date",
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2500),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    datepickar1.text = DateFormat('yyyy/MM/dd')
                                        .format(selectedDate);
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    datepickar1.text,
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
                      Column(
                        children: [
                          dropdownTextfield(
                            context,
                            "To Date",
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2500),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    datepickar2.text = DateFormat('yyyy/MM/dd')
                                        .format(selectedDate);
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    datepickar2.text,
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
                      Column(
                        children: [
                          button(
                            "Get Data",
                            AppColor.colPrimary,
                            onTap: () {
                              getpurchaseInvoice(
                                dateFrom: datepickar1.text,
                                dateTo: datepickar2.text,
                              ).then((value) => setState(() {
                                    filteredList = purchaseInvoiceList;
                                  }));
                            },
                          ),
                        ],
                      ),
                    ], context: context)
                  : Container(),
              addMasterOutside(children: [
                textformfiles(searchController,
                    onChanged: (value) => filterList(value),
                    labelText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: AppColor.colBlack,
                    )),
              ], context: context),
              filteredList.isEmpty
                  ? const Text("No Data found")
                  : Responsive.isMobile(context)
                      ? Column(
                          children: List.generate(filteredList.length, (index) {
                          // Ledger
                          int ledgerId = filteredList[index]['ledger_Id'];
                          String ledgerName = ledgerList.isEmpty
                              ? ""
                              : ledgerList.firstWhere((element) =>
                                  element['id'] == ledgerId)['name'];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Sizes.height * .01),
                            decoration: decorationBox(),
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.colPrimary,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        "${filteredList[index]["pInvo_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]
                                                            ["pInvo_Date"]
                                                        .length -
                                                    12),
                                        style: rubikTextStyle(16,
                                            FontWeight.w600, AppColor.colBlack),
                                      ),
                                      trailing: Text(
                                        "Purchase Invoice No : ${filteredList[index]['pInvo']}",
                                        style: rubikTextStyle(13,
                                            FontWeight.w500, AppColor.colBlack),
                                      ),
                                    )),
                                ListTile(
                                    dense: true,
                                    minVerticalPadding: Sizes.height * 0.02,
                                    leading: CircleAvatar(
                                      backgroundColor: AppColor.colPrimary,
                                      child: Text(
                                        ledgerName.isEmpty ? "" : ledgerName[0],
                                        style: rubikTextStyle(16,
                                            FontWeight.w500, AppColor.colWhite),
                                      ),
                                    ),
                                    title: Text(
                                      ledgerName,
                                      style: rubikTextStyle(17, FontWeight.w500,
                                          AppColor.colBlack),
                                    ),
                                    subtitle: Text(
                                      "${filteredList[index]['pInvo_Date'].substring(0, filteredList[index]['pInvo_Date'].length - 12)}",
                                      style: rubikTextStyle(14, FontWeight.w400,
                                          AppColor.colGrey),
                                    ),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 'Generate') {
                                          // Ledger
                                          int ledgerId =
                                              filteredList[index]['ledger_Id'];
                                          String ledgerName = ledgerList.isEmpty
                                              ? ""
                                              : ledgerList.firstWhere(
                                                  (element) =>
                                                      element['id'] ==
                                                      ledgerId)['name'];
                                          String ledgerMob = ledgerList.isEmpty
                                              ? ""
                                              : ledgerList.firstWhere(
                                                  (element) =>
                                                      element['id'] ==
                                                      ledgerId)['mob'];
                                          String ledgerAddress =
                                              ledgerList.isEmpty
                                                  ? ""
                                                  : ledgerList.firstWhere(
                                                      (element) =>
                                                          element['id'] ==
                                                          ledgerId)['address'];
                                          String ledgerGst = ledgerList.isEmpty
                                              ? ""
                                              : ledgerList.firstWhere(
                                                  (element) =>
                                                      element['id'] ==
                                                      ledgerId)['gst_No'];
                                          getPurchaseInvoiceData(
                                                  filteredList[index]['pInvo'])
                                              .then((value) => setState(() {
                                                    generateInvoicePDF(
                                                        3,
                                                        pInvoiceDetails,
                                                        companyDetails, {
                                                      'id': ledgerId,
                                                      'name': ledgerName,
                                                      'mob': ledgerMob,
                                                      'address': ledgerAddress,
                                                      'gst_No': ledgerGst,
                                                    });
                                                  }));
                                        } else if (value == 'Edit') {
                                          pushTo(PurchaseInvoice(
                                              invoiceNumber: filteredList[index]
                                                  ['pInvo']));
                                        } else if (value == 'Delete') {
                                          deleteInvoice(
                                                  filteredList[index]['pInvo'])
                                              .then((value) =>
                                                  getpurchaseInvoice(
                                                    dateFrom: datepickar1.text,
                                                    dateTo: datepickar2.text,
                                                  ).then(
                                                      (value) => setState(() {
                                                            filteredList =
                                                                purchaseInvoiceList;
                                                          })));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          value: 'Generate',
                                          child: Text('Print'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete'),
                                        )
                                      ],
                                    )),
                                const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Gross Amount",
                                            style: rubikTextStyle(
                                                15,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                            textAlign: TextAlign.center)),
                                    Expanded(
                                        child: Text("GST Amount",
                                            style: rubikTextStyle(
                                                15,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                            textAlign: TextAlign.center)),
                                    Expanded(
                                        child: Text("Net Amount",
                                            style: rubikTextStyle(
                                                15,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                            textAlign: TextAlign.center)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                            filteredList[index]['gross_Amount'],
                                            style: rubikTextStyle(
                                                14,
                                                FontWeight.w500,
                                                AppColor.colGrey),
                                            textAlign: TextAlign.center)),
                                    Expanded(
                                        child: Text(filteredList[index]['gst'],
                                            style: rubikTextStyle(
                                                14,
                                                FontWeight.w500,
                                                AppColor.colGrey),
                                            textAlign: TextAlign.center)),
                                    Expanded(
                                        child: Text(
                                            filteredList[index]['net_Amount'],
                                            style: rubikTextStyle(
                                                14,
                                                FontWeight.w500,
                                                AppColor.colGrey),
                                            textAlign: TextAlign.center)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }))
                      : Table(
                          border: TableBorder.all(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColor.colBlack),
                          children: [
                            TableRow(
                                decoration:
                                    BoxDecoration(color: AppColor.colPrimary),
                                children: [
                                  tableHeader("Purchase Invoice No."),
                                  tableHeader("Customer Name"),
                                  tableHeader("Date"),
                                  tableHeader("Gross Amount"),
                                  tableHeader("GST Amount"),
                                  tableHeader("Net Amount"),
                                  tableHeader("Action"),
                                ]),
                            ...List.generate(filteredList.length, (index) {
                              // Ledger
                              int ledgerId = filteredList[index]['ledger_Id'];
                              ledgerName = ledgerList.isEmpty
                                  ? ""
                                  : ledgerList.firstWhere((element) =>
                                      element['id'] == ledgerId)['name'];
                              return TableRow(
                                  decoration:
                                      BoxDecoration(color: AppColor.colWhite),
                                  children: [
                                    tableRow("${filteredList[index]["pInvo"]}"),
                                    tableRow(ledgerName),
                                    tableRow(
                                        "${filteredList[index]["pInvo_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]
                                                            ["pInvo_Date"]
                                                        .length -
                                                    12)),
                                    tableRow(
                                        filteredList[index]['gross_Amount']),
                                    tableRow(filteredList[index]['gst']),
                                    tableRow(
                                        "₹ ${filteredList[index]['net_Amount'] ?? "0"}"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              // Ledger
                                              int ledgerId = filteredList[index]
                                                  ['ledger_Id'];
                                              String ledgerName = ledgerList
                                                      .isEmpty
                                                  ? ""
                                                  : ledgerList.firstWhere(
                                                      (element) =>
                                                          element['id'] ==
                                                          ledgerId)['name'];
                                              String ledgerMob =
                                                  ledgerList.isEmpty
                                                      ? ""
                                                      : ledgerList.firstWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              ledgerId)['mob'];
                                              String ledgerAddress = ledgerList
                                                      .isEmpty
                                                  ? ""
                                                  : ledgerList.firstWhere(
                                                      (element) =>
                                                          element['id'] ==
                                                          ledgerId)['address'];
                                              String ledgerGst = ledgerList
                                                      .isEmpty
                                                  ? ""
                                                  : ledgerList.firstWhere(
                                                      (element) =>
                                                          element['id'] ==
                                                          ledgerId)['gst_No'];
                                              getPurchaseInvoiceData(
                                                      filteredList[index]
                                                          ['pInvo'])
                                                  .then((value) => setState(() {
                                                        generateInvoicePDF(
                                                            3,
                                                            pInvoiceDetails,
                                                            companyDetails, {
                                                          'id': ledgerId,
                                                          'name': ledgerName,
                                                          'mob': ledgerMob,
                                                          'address':
                                                              ledgerAddress,
                                                          'gst_No': ledgerGst,
                                                        });
                                                      }));
                                            },
                                            icon: Icon(Icons.print,
                                                color: AppColor.colGreen)),
                                        IconButton(
                                            onPressed: () {
                                              pushTo(PurchaseInvoice(
                                                  invoiceNumber:
                                                      filteredList[index]
                                                          ['pInvo']));
                                            },
                                            icon: Icon(Icons.edit,
                                                color: AppColor.colPrimary)),
                                        IconButton(
                                            onPressed: () {
                                              deleteInvoice(filteredList[index]
                                                      ['pInvo'])
                                                  .then((value) =>
                                                      getpurchaseInvoice(
                                                        dateFrom:
                                                            datepickar1.text,
                                                        dateTo:
                                                            datepickar2.text,
                                                      ).then((value) =>
                                                          setState(() {
                                                            filteredList =
                                                                purchaseInvoiceList;
                                                          })));
                                            },
                                            icon: Icon(Icons.delete,
                                                color: AppColor.colRideFare)),
                                      ],
                                    )
                                  ]);
                            })
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }

  //Purchase Invoice
  Future getpurchaseInvoice(
      {required String dateFrom, required String dateTo}) async {
    final formattedDateFrom = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateFrom),
    );
    final formattedDateTo = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateTo),
    );

    var response = await ApiService.fetchData(
        "Transactions/GetPurchaseInvoiceALLocationwiseAW?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=0");
    purchaseInvoiceList = response;
  }

  //Delete Invoice
  Future deleteInvoice(int? invoiceNo) async {
    var response = await ApiService.postData(
        "Transactions/DeletePurchaseInvoiceAW?prefix=online&refno=$invoiceNo&locationid=${Preference.getString(PrefKeys.locationId)}",
        {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

//fatch Purchase Invoice Data
  Future getPurchaseInvoiceData(pInvNo) async {
    pInvoiceDetails = await ApiService.fetchData(
        "Transactions/GetPurchaseInvoiceAW?prefix=online&refno=$pInvNo&locationid=${Preference.getString(PrefKeys.locationId)}");
  }

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
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
}
