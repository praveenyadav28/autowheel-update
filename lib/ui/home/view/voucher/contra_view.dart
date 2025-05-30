// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:autowheel_workshop/ui/home/dashboard/excel/voucher/contra.dart';
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class ContraView extends StatefulWidget {
  ContraView({required this.reportType, super.key});
  bool reportType = false;

  @override
  State<ContraView> createState() => _ContraViewState();
}

class _ContraViewState extends State<ContraView> {
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  TextEditingController searchController = TextEditingController();

  //Ledger
  // List<Map<String, dynamic>> ledgerList = [];
  // List<Map<String, dynamic>> modeList = [];
  List<dynamic> contraList = [];
  List filteredList = [];

  Map<String, dynamic> contraDetails = {};
  @override
  void initState() {
    datepickar1.text = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    datepickar2.text =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    widget.reportType
        ? null
        : getContra(dateFrom: datepickar1.text, dateTo: datepickar2.text)
            .then((value) => setState(() {
                  filteredList = contraList;
                }));

    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = contraList.where((value) {
        return value['voucher_Mode']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
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
                  createExcelContra(filteredList);
                },
                icon: const Icon(Icons.document_scanner))
          ],
          title: Text(widget.reportType ? "Contra Report" : "Contra View",
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
                              getContra(
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
                                        "${filteredList[index]["tran_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]["tran_Date"]
                                                        .length -
                                                    12),
                                        style: rubikTextStyle(16,
                                            FontWeight.w600, AppColor.colBlack),
                                      ),
                                      trailing: Text(
                                        "Reciept Voucher No : ${filteredList[index]['voucher_No']}",
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
                                        "",
                                        style: rubikTextStyle(16,
                                            FontWeight.w500, AppColor.colWhite),
                                      ),
                                    ),
                                    title: Text(
                                      "From : ${filteredList[index]['voucher_Mode']}",
                                      style: rubikTextStyle(17, FontWeight.w500,
                                          AppColor.colBlack),
                                    ),
                                    subtitle: Text(
                                      "To : ${filteredList[index]['ledger_Name'] ?? ""}",
                                      style: rubikTextStyle(14, FontWeight.w400,
                                          AppColor.colGrey),
                                    ),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 'Edit') {
                                          pushTo(ContraVoucher(
                                              contraVoucherNo:
                                                  filteredList[index]
                                                      ['voucher_No']));
                                        } else if (value == 'Delete') {
                                          deleteContra(filteredList[index]
                                                  ['voucher_No'])
                                              .then((value) => getContra(
                                                    dateFrom: datepickar1.text,
                                                    dateTo: datepickar2.text,
                                                  ).then((value) =>
                                                      setState(() {})));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
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
                                        "₹ ${filteredList[index]['debitAmount'] ?? "0"}",
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
                                  tableHeader("CV Number"),
                                  tableHeader("Date"),
                                  tableHeader("From Ledger"),
                                  tableHeader("To Ledger"),
                                  tableHeader("Paid Amount"),
                                  tableHeader("Action"),
                                ]),
                            ...List.generate(filteredList.length, (index) {
                              return TableRow(
                                  decoration:
                                      BoxDecoration(color: AppColor.colWhite),
                                  children: [
                                    tableRow(
                                        "${filteredList[index]["voucher_No"]}"),
                                    tableRow(
                                        "${filteredList[index]["tran_Date"]}"
                                            .substring(
                                                0,
                                                filteredList[index]["tran_Date"]
                                                        .length -
                                                    12)),
                                    tableRow(
                                        filteredList[index]["voucher_Mode"]),
                                    tableRow(filteredList[index]
                                            ["ledger_Name"] ??
                                        ''),
                                    tableRow(
                                        "₹ ${filteredList[index]['debitAmount'] ?? "0"}"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              var result =
                                                  await pushTo(ContraVoucher(
                                                contraVoucherNo:
                                                    filteredList[index]
                                                        ['voucher_No'],
                                              ));
                                              if (result != null) {
                                                getContra(
                                                        dateFrom:
                                                            datepickar1.text,
                                                        dateTo:
                                                            datepickar2.text)
                                                    .then((value) =>
                                                        setState(() {}));
                                              }
                                            },
                                            icon: Icon(Icons.edit,
                                                color: AppColor.colPrimary)),
                                        IconButton(
                                            onPressed: () {
                                              deleteContra(filteredList[index]
                                                      ['voucher_No'])
                                                  .then((value) => getContra(
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
  Future getContra({required String dateFrom, required String dateTo}) async {
    final formattedDateFrom = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateFrom),
    );
    final formattedDateTo = DateFormat('yyyy/MM/dd').format(
      DateFormat('yyyy/MM/dd').parse(dateTo),
    );

    var response = await ApiService.fetchData(
        "Transactions/GetContraVoucherALLocationwiseAW?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=0");
    setState(() {
      contraList = response;
      filteredList = contraList;
    });
  }

  //Delete Contra
  Future deleteContra(int? voucherNo) async {
    var response = await ApiService.postData(
        "Transactions/DeleteContraVoucherAW?prefix=online&refno=$voucherNo&locationid=${Preference.getString(PrefKeys.locationId)}",
        {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }

//Reciept Datails Get
  Future fatchContraDetails(int? rvNumber) async {
    contraDetails = await ApiService.fetchData(
        'Transactions/GetContraVoucherAW?prefix=online&refno=$rvNumber&locationid=${Preference.getString(PrefKeys.locationId)}');
  }
}
