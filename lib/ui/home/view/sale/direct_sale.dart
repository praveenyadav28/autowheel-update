// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/ui/home/dashboard/excel/sale/sale_invoice.dart';
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class DirectSale extends StatefulWidget {
  DirectSale({required this.reportType, super.key});
  bool reportType = false;

  @override
  State<DirectSale> createState() => _DirectSaleState();
}

class _DirectSaleState extends State<DirectSale> {
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController searchController = TextEditingController();

  List<dynamic> saleInvoiceList = [];
  List filteredList = [];

  @override
  void initState() {
    datepickar1.text = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    datepickar2.text =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    getAccountDetails();
    widget.reportType
        ? null
        : getallSaleInvoice(
                dateFrom: datepickar1.text, dateTo: datepickar2.text)
            .then((value) => setState(() {
                  filteredList = saleInvoiceList;
                }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = saleInvoiceList.where((value) {
        return value['party_Name']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['vehicle_No']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['invoice_No']
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
                  createExcelSaleInvoice(filteredList);
                },
                icon: const Icon(Icons.document_scanner))
          ],
          title: Text(
              widget.reportType ? "Sale Invoice Report" : "Sale Invoice View",
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
                              getallSaleInvoice(
                                dateFrom: datepickar1.text,
                                dateTo: datepickar2.text,
                              ).then((value) => setState(() {}));
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
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Sizes.height * 0.01),
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
                                        filteredList[index]["vehicle_No"],
                                        style: rubikTextStyle(16,
                                            FontWeight.w600, AppColor.colBlack),
                                      ),
                                      trailing: Text(
                                        "Invoice No : ${filteredList[index]['invoice_No']}",
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
                                        "${filteredList[index]['party_Name']}"
                                                .isEmpty
                                            ? ""
                                            : filteredList[index]['party_Name']
                                                [0],
                                        style: rubikTextStyle(16,
                                            FontWeight.w500, AppColor.colWhite),
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          filteredList[index]['party_Name'],
                                          style: rubikTextStyle(
                                              17,
                                              FontWeight.w500,
                                              AppColor.colBlack),
                                        ),
                                        Text(
                                          "   (${filteredList[index]['invoice_Date'].substring(0, filteredList[index]['invoice_Date'].length - 12)})",
                                          style: rubikTextStyle(
                                              14,
                                              FontWeight.w400,
                                              AppColor.colGrey),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      filteredList[index]['model_Name'],
                                      style: rubikTextStyle(14, FontWeight.w400,
                                          AppColor.colLabel),
                                    ),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 'Generate') {
                                        } else if (value == 'Invoice') {
                                          getInvoiceDetails(filteredList[index]
                                                  ['invoice_No'])
                                              .then((value) =>
                                                  generateInvoicePDF(
                                                      2,
                                                      invoiceDetails,
                                                      companyDetails, {}));
                                        } else if (value == 'Edit') {
                                          pushTo(SaleInvoice(
                                              saleIvoiceItems: const [],
                                              invoiceNumber: filteredList[index]
                                                  ['invoice_No'],
                                              jobcardNumber: 0));
                                        } else if (value == 'Delete') {
                                          deleteInvoice(filteredList[index]
                                                  ['invoice_No'])
                                              .then((value) =>
                                                  getallSaleInvoice(
                                                    dateFrom: datepickar1.text,
                                                    dateTo: datepickar2.text,
                                                  ).then((value) =>
                                                      setState(() {})));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          value: 'Invoice',
                                          child: Text('Generate Sale Invoice'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit Sale Invoice'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete Sale Invoice'),
                                        )
                                      ],
                                    )),
                                const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text("Taxable",
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
                                  tableHeader("Invoice Number"),
                                  tableHeader("Customer Name"),
                                  tableHeader("Date"),
                                  tableHeader("Vehicle Model"),
                                  tableHeader("Vehicle Number"),
                                  tableHeader("Amount"),
                                  tableHeader("Action"),
                                ]),
                            ...List.generate(filteredList.length, (index) {
                              return TableRow(
                                  decoration:
                                      BoxDecoration(color: AppColor.colWhite),
                                  children: [
                                    tableRow(
                                        "${filteredList[index]["invoice_No"]}"),
                                    tableRow(filteredList[index]['party_Name']),
                                    tableRow(
                                        "${filteredList[index]["invoice_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]
                                                            ["invoice_Date"]
                                                        .length -
                                                    12)),
                                    tableRow(filteredList[index]['model_Name']),
                                    tableRow(filteredList[index]['vehicle_No']),
                                    tableRow(
                                        "₹ ${filteredList[index]['net_Amount'] ?? "0"}"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              getInvoiceDetails(
                                                      filteredList[index]
                                                          ['invoice_No'])
                                                  .then((value) =>
                                                      generateInvoicePDF(
                                                          2,
                                                          invoiceDetails,
                                                          companyDetails, {}));
                                            },
                                            icon: Icon(Icons.print,
                                                color: AppColor.colGreen)),
                                        IconButton(
                                            onPressed: () {
                                              pushTo(SaleInvoice(
                                                  saleIvoiceItems: const [],
                                                  invoiceNumber:
                                                      filteredList[index]
                                                          ['invoice_No'],
                                                  jobcardNumber: 0));
                                            },
                                            icon: Icon(Icons.edit,
                                                color: AppColor.colPrimary)),
                                        IconButton(
                                            onPressed: () {
                                              deleteInvoice(filteredList[index]
                                                      ['invoice_No'])
                                                  .then((value) =>
                                                      getallSaleInvoice(
                                                        dateFrom:
                                                            datepickar1.text,
                                                        dateTo:
                                                            datepickar2.text,
                                                      ).then((value) =>
                                                          setState(() {})));
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

  //Sale Invoice
  Future getallSaleInvoice(
      {required String dateFrom, required String dateTo}) async {
    final formattedDateFrom = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateFrom),
    );
    final formattedDateTo = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateTo),
    );

    var response = await ApiService.fetchData(
        "Transactions/GetSaleInvoiceALLocationwiseAW?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=0");
    saleInvoiceList = response;
    filteredList = saleInvoiceList;
  }

  //Delete Invoice
  Future deleteInvoice(int? invoiceNo) async {
    var response = await ApiService.postData(
        "Transactions/DeleteSaleInvoiceAW?prefix=online&refno=$invoiceNo&locationid=${Preference.getString(PrefKeys.locationId)}",
        {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

  Map<String, dynamic> invoiceDetails = {};
  Map<String, dynamic> companyDetails = {};

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }

//Fatch Invoice Details
  Future getInvoiceDetails(int? refNo) async {
    invoiceDetails = await ApiService.fetchData(
        "Transactions/GetSaleInvoiceAW?prefix=online&refno=$refNo&locationid=${Preference.getString(PrefKeys.locationId)}");
  }
}
