// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/ui/home/dashboard/excel/voucher/expanse.dart';
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class ExpanseView extends StatefulWidget {
  ExpanseView({required this.reportType, super.key});
  bool reportType = false;

  @override
  State<ExpanseView> createState() => _ExpanseViewState();
}

class _ExpanseViewState extends State<ExpanseView> {
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  TextEditingController searchController = TextEditingController();

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  List<Map<String, dynamic>> modeList = [];
  List<dynamic> expanseList = [];
  List filteredList = [];

  Map<String, dynamic> companyDetails = {};
  Map<String, dynamic> expanseDetails = {};
  @override
  void initState() {
    datepickar1.text = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    datepickar2.text =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    getAccountDetails().then((value) => setState(() {}));
    fatchledger().then((value) => setState(() {
          widget.reportType
              ? null
              : getExpanse(dateFrom: datepickar1.text, dateTo: datepickar2.text)
                  .then((value) => setState(() {
                        filteredList = expanseList;
                      }));
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = expanseList.where((value) {
        // Ledger
        int ledgerId = value['voucherType_Id'];
        String ledgerName = ledgerList.isEmpty
            ? ""
            : ledgerList
                .firstWhere((element) => element['id'] == ledgerId)['name'];
        return ledgerName.toLowerCase().contains(searchText.toLowerCase()) ||
            value['ev_No']
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
                  createExcelExpanse(filteredList,
                      ledgerList: ledgerList, modeList: modeList);
                },
                icon: const Icon(Icons.document_scanner))
          ],
          title: Text(widget.reportType ? "Expanse Report" : "Expanse View",
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
                              getExpanse(
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
                          int ledgerId = filteredList[index]['voucherType_Id'];
                          String ledgerName = ledgerList.isEmpty
                              ? ""
                              : ledgerList.firstWhere((element) =>
                                  element['id'] == ledgerId)['name'];
                          // mode
                          int modeId = filteredList[index]['voucher_Mode_Id'];
                          String modeName = modeList.isEmpty
                              ? ""
                              : modeList.firstWhere(
                                  (element) => element['id'] == modeId)['name'];
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
                                        "${filteredList[index]["eDate"]}"
                                            .substring(
                                                0,
                                                filteredList[index]["eDate"]
                                                        .length -
                                                    12),
                                        style: rubikTextStyle(16,
                                            FontWeight.w600, AppColor.colBlack),
                                      ),
                                      trailing: Text(
                                        "Reciept Voucher No : ${filteredList[index]['ev_No']}",
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
                                      filteredList[index]['mode'] ?? "",
                                      style: rubikTextStyle(14, FontWeight.w400,
                                          AppColor.colGrey),
                                    ),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 'Print') {
                                          fatchexpanseDetails(
                                                  filteredList[index]['ev_No'])
                                              .then((value) => setState(() {
                                                    generatePaymentPDF(
                                                        2, companyDetails, {
                                                      "ev_No": expanseDetails[
                                                          'ev_No'],
                                                      "eDate": expanseDetails[
                                                          'eDate'],
                                                      "ledger_Name": ledgerName,
                                                      "other1": expanseDetails[
                                                          'type'],
                                                      "mode": expanseDetails[
                                                          'particular'],
                                                      "cash_Amount":
                                                          expanseDetails[
                                                              'amount'],
                                                      "particular": modeName,
                                                      "remarks": expanseDetails[
                                                          'remarks']
                                                    });
                                                  }));
                                        } else if (value == 'Edit') {
                                          pushTo(ExpanceVoucher(
                                              expanseVoucherNo:
                                                  filteredList[index]
                                                      ['ev_No']));
                                        } else if (value == 'Delete') {
                                          deleteReciept(
                                                  filteredList[index]['ev_No'])
                                              .then((value) => getExpanse(
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
                                          child: Text('Print Reciept'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit Reciept'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete Reciept'),
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
                                        "₹ ${filteredList[index]['amount'] ?? "0"}",
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
                                  tableHeader("EV Number"),
                                  tableHeader("Voucher Type"),
                                  tableHeader("Date"),
                                  tableHeader("Mode"),
                                  tableHeader("Paid Amount"),
                                  tableHeader("Action"),
                                ]),
                            ...List.generate(filteredList.length, (index) {
                              // Ledger
                              int ledgerId =
                                  filteredList[index]['voucherType_Id'];
                              String ledgerName = ledgerList.isEmpty
                                  ? ""
                                  : ledgerList.firstWhere((element) =>
                                      element['id'] == ledgerId)['name'];
                              // mode
                              int modeId =
                                  filteredList[index]['voucher_Mode_Id'];
                              String modeName = modeList.isEmpty
                                  ? ""
                                  : modeList.firstWhere((element) =>
                                      element['id'] == modeId)['name'];
                              return TableRow(
                                  decoration:
                                      BoxDecoration(color: AppColor.colWhite),
                                  children: [
                                    tableRow("${filteredList[index]["ev_No"]}"),
                                    tableRow(ledgerName),
                                    tableRow("${filteredList[index]["eDate"]}"
                                        .substring(
                                            0,
                                            filteredList[index]["eDate"]
                                                    .length -
                                                12)),
                                    tableRow(modeName),
                                    tableRow(
                                        "₹ ${filteredList[index]['amount'] ?? "0"}"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              fatchexpanseDetails(
                                                      filteredList[index]
                                                          ['ev_No'])
                                                  .then((value) => setState(() {
                                                        generatePaymentPDF(
                                                            2, companyDetails, {
                                                          "ev_No":
                                                              expanseDetails[
                                                                  'ev_No'],
                                                          "eDate":
                                                              expanseDetails[
                                                                  'eDate'],
                                                          "ledger_Name":
                                                              ledgerName,
                                                          "other1":
                                                              expanseDetails[
                                                                  'type'],
                                                          "mode":
                                                              expanseDetails[
                                                                  'particular'],
                                                          "cash_Amount":
                                                              expanseDetails[
                                                                  'amount'],
                                                          "particular":
                                                              modeName,
                                                          "remarks":
                                                              expanseDetails[
                                                                  'remarks']
                                                        });
                                                      }));
                                            },
                                            icon: Icon(Icons.print,
                                                color: AppColor.colGreen)),
                                        IconButton(
                                            onPressed: () {
                                              pushTo(ExpanceVoucher(
                                                  expanseVoucherNo:
                                                      filteredList[index]
                                                          ['ev_No']));
                                            },
                                            icon: Icon(Icons.edit,
                                                color: AppColor.colPrimary)),
                                        IconButton(
                                            onPressed: () {
                                              deleteReciept(filteredList[index]
                                                      ['ev_No'])
                                                  .then((value) => getExpanse(
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

  //Reciept
  Future getExpanse({required String dateFrom, required String dateTo}) async {
    final formattedDateFrom = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateFrom),
    );
    final formattedDateTo = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateTo),
    );

    var response = await ApiService.fetchData(
        "Transactions/GetExpencesVoucherALLocationwiseAW?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=0");
    setState(() {
      expanseList = response;
      filteredList = expanseList;
    });
  }

  //Delete Reciept
  Future deleteReciept(int? voucherNo) async {
    var response = await ApiService.postData(
        "Transactions/DeleteExpencesVoucherAW?prefix=online&refno=$voucherNo&locationid=${Preference.getString(PrefKeys.locationId)}",
        {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

//Reciept Datails Get
  Future fatchexpanseDetails(int? rvNumber) async {
    expanseDetails = await ApiService.fetchData(
        'Transactions/GetExpencesVoucherAW?prefix=online&refno=$rvNumber&locationid=${Preference.getString(PrefKeys.locationId)}');
  }

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=14");
    var responsemode = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=7");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
    modeList = List<Map<String, dynamic>>.from(responsemode.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'group': item['ledger_Group_Id']
        }));
  }
}
