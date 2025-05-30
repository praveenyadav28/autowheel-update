// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/ui/home/dashboard/excel/purchase/payment.dart';
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class PaymentView extends StatefulWidget {
  PaymentView({required this.reportType, super.key});
  bool reportType = false;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController searchController = TextEditingController();

  List<dynamic> paymentList = [];
  List<Map<String, dynamic>> voucherList = [];
  List filteredList = [];

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> paymentDetails = {};
  @override
  void initState() {
    datepickar1.text = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    datepickar2.text =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    getAccountDetails().then((value) => setState(() {}));
    fatchVoucher().then((value) => setState(() {
          widget.reportType
              ? null
              : getPayment(dateFrom: datepickar1.text, dateTo: datepickar2.text)
                  .then((value) => setState(() {
                        filteredList = paymentList;
                      }));
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = paymentList.where((value) {
        return value['ledger_Name']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['pv_No']
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
                  createExcelPayment(filteredList, modeList: voucherList);
                },
                icon: const Icon(Icons.document_scanner))
          ],
          title: Text(widget.reportType ? "Payment Report" : "Payment View",
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
                              getPayment(
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
                          // Ledger
                          int voucherId =
                              filteredList[index]['voucher_Mode_Id'];
                          String voucherName = voucherList.isEmpty
                              ? ""
                              : voucherList.firstWhere((element) =>
                                  element['id'] == voucherId)['name'];
                          return Container(
                            decoration: decorationBox(),
                            margin: EdgeInsets.symmetric(
                                vertical: Sizes.height * 0.01),
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
                                        "${filteredList[index]["payment_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]
                                                            ["payment_Date"]
                                                        .length -
                                                    12),
                                        style: rubikTextStyle(16,
                                            FontWeight.w600, AppColor.colBlack),
                                      ),
                                      trailing: Text(
                                        "Payment Voucher No : ${filteredList[index]['pv_No']}",
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
                                        "${filteredList[index]['ledger_Name']}"
                                                .isEmpty
                                            ? ""
                                            : filteredList[index]['ledger_Name']
                                                [0],
                                        style: rubikTextStyle(16,
                                            FontWeight.w500, AppColor.colWhite),
                                      ),
                                    ),
                                    title: Text(
                                      filteredList[index]['ledger_Name'],
                                      style: rubikTextStyle(17, FontWeight.w500,
                                          AppColor.colBlack),
                                    ),
                                    subtitle: Text(
                                      voucherName,
                                      style: rubikTextStyle(14, FontWeight.w400,
                                          AppColor.colGrey),
                                    ),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 'Print') {
                                          fatchPaymentDetails(
                                                  filteredList[index]['pv_No'])
                                              .then((value) => setState(() {
                                                    generatePaymentPDF(
                                                        0,
                                                        companyDetails,
                                                        paymentDetails);
                                                  }));
                                        } else if (value == 'Edit') {
                                          pushTo(PaymentScreen(
                                              paymentVoucherNo:
                                                  filteredList[index]
                                                      ['pv_No']));
                                        } else if (value == 'Delete') {
                                          deleteInvoice(
                                                  filteredList[index]['pv_No'])
                                              .then((value) => getPayment(
                                                    dateFrom: datepickar1.text,
                                                    dateTo: datepickar2.text,
                                                  ).then((value) =>
                                                      setState(() {})));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          value: 'Print',
                                          child: Text('Print Payment'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit Payment'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete Payment'),
                                        )
                                      ],
                                    )),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Paid Amount :",
                                        style: rubikTextStyle(15,
                                            FontWeight.w500, AppColor.colBlack),
                                        textAlign: TextAlign.center),
                                    Text(
                                        "₹ ${filteredList[index]['cash_Amount'] ?? "0"}",
                                        style: rubikTextStyle(15,
                                            FontWeight.w500, AppColor.colBlack),
                                        textAlign: TextAlign.center),
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
                                  tableHeader("PV Number"),
                                  tableHeader("Ledger Name"),
                                  tableHeader("Date"),
                                  tableHeader("Mode"),
                                  tableHeader("Paid Amount"),
                                  tableHeader("Action"),
                                ]),
                            ...List.generate(filteredList.length, (index) {
                              // Ledger
                              int voucherId =
                                  filteredList[index]['voucher_Mode_Id'];
                              String voucherName = voucherList.isEmpty
                                  ? ""
                                  : voucherList.firstWhere((element) =>
                                      element['id'] == voucherId)['name'];
                              return TableRow(
                                  decoration:
                                      BoxDecoration(color: AppColor.colWhite),
                                  children: [
                                    tableRow("${filteredList[index]["pv_No"]}"),
                                    tableRow(
                                        filteredList[index]['ledger_Name']),
                                    tableRow(
                                        "${filteredList[index]["payment_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]
                                                            ["payment_Date"]
                                                        .length -
                                                    12)),
                                    tableRow(voucherName),
                                    tableRow(
                                        "₹ ${filteredList[index]['cash_Amount'] ?? "0"}"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              fatchPaymentDetails(
                                                      filteredList[index]
                                                          ['pv_No'])
                                                  .then((value) => setState(() {
                                                        generatePaymentPDF(
                                                            0,
                                                            companyDetails,
                                                            paymentDetails);
                                                      }));
                                            },
                                            icon: Icon(Icons.print,
                                                color: AppColor.colGreen)),
                                        IconButton(
                                            onPressed: () {
                                              pushTo(PaymentScreen(
                                                  paymentVoucherNo:
                                                      filteredList[index]
                                                          ['pv_No']));
                                            },
                                            icon: Icon(Icons.edit,
                                                color: AppColor.colPrimary)),
                                        IconButton(
                                            onPressed: () {
                                              deleteInvoice(filteredList[index]
                                                      ['pv_No'])
                                                  .then((value) => getPayment(
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

  //Payment
  Future getPayment({required String dateFrom, required String dateTo}) async {
    final formattedDateFrom = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateFrom),
    );
    final formattedDateTo = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateTo),
    );

    var response = await ApiService.fetchData(
        "Transactions/GetPaymentVoucherALLocationwiseAW?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=0");
    setState(() {
      paymentList = response;
      filteredList = paymentList;
    });
  }

  //Delete Invoice
  Future deleteInvoice(int? voucherNo) async {
    var response = await ApiService.postData(
        "Transactions/DeletePaymentVoucherAW?prefix=online&refno=$voucherNo&locationid=${Preference.getString(PrefKeys.locationId)}",
        {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

//Payment Datails Get
  Future fatchPaymentDetails(int? pvNumber) async {
    paymentDetails = await ApiService.fetchData(
        'Transactions/GetPaymentVoucherAW?prefix=online&refno=$pvNumber&locationid=${Preference.getString(PrefKeys.locationId)}');
  }

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }

//Get ledger List
  Future fatchVoucher() async {
    var responseVoucher = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=7,8,11");

    voucherList =
        List<Map<String, dynamic>>.from(responseVoucher.map((item) => {
              'id': item['ledger_Id'],
              'name': item['ledger_Name'],
            }));
  }
}
