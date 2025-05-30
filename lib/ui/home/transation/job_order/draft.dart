// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class Draft extends StatefulWidget {
  Draft({required this.status, required this.reportType, super.key});
  int status;
  bool reportType = false;
  @override
  State<Draft> createState() => _DraftState();
}

class _DraftState extends State<Draft> {
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController searchController = TextEditingController();

  List jobcardList = [];
  List modelNameList = [];
  List ledgerList = [];
  List filteredList = [];

  @override
  void initState() {
    datepickar1.text = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    datepickar2.text =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    widget.reportType
        ? null
        : fatchledger().then(
          (value) => setState(() {
            fatchJobcard(
              dateFrom: datepickar1.text,
              dateTo: datepickar2.text,
            ).then((value) => setState(() {}));
          }),
        );
    fatchVehicle().then((value) => setState(() {}));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList =
          jobcardList.where((value) {
            int ledgerId = value['ledger_Id'];
            String ledgerName =
                ledgerList.isEmpty
                    ? ""
                    : ledgerList.firstWhere(
                      (element) => element['ledger_Id'] == ledgerId,
                    )['ledger_Name'];
            return ledgerName.toLowerCase().contains(
                  searchText.toLowerCase(),
                ) ||
                value['vehicle_No'].toLowerCase().contains(
                  searchText.toLowerCase(),
                ) ||
                value['job_No'].toString().toLowerCase().contains(
                  searchText.toLowerCase(),
                );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.width * 0.03,
        vertical: Sizes.height * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.reportType
              ? addMasterOutside(
                children: [
                  Column(
                    children: [
                      dropdownTextfield(
                        context,
                        "From Date",
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2500),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                datepickar1.text = DateFormat(
                                  'yyyy/MM/dd',
                                ).format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                datepickar1.text,
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                              Icon(
                                Icons.edit_calendar,
                                color: AppColor.colBlack,
                              ),
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2500),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                datepickar2.text = DateFormat(
                                  'yyyy/MM/dd',
                                ).format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                datepickar2.text,
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                              Icon(
                                Icons.edit_calendar,
                                color: AppColor.colBlack,
                              ),
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
                          fatchJobcard(
                            dateFrom: datepickar1.text,
                            dateTo: datepickar2.text,
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ],
                  ),
                ],
                context: context,
              )
              : Container(),
          addMasterOutside(
            children: [
              textformfiles(
                searchController,
                onChanged: (value) => filterList(value),
                labelText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                  color: AppColor.colBlack,
                ),
              ),
            ],
            context: context,
          ),
          filteredList.isEmpty
              ? const Text("No Data found")
              : Responsive.isMobile(context)
              ? Column(
                children: List.generate(filteredList.length, (index) {
                  //Ledger
                  int ledgerId = filteredList[index]['ledger_Id'];
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

                  //Model
                  int modelId = filteredList[index]['model_Id'];
                  String modelName =
                      modelNameList.isEmpty
                          ? ""
                          : modelNameList.firstWhere(
                            (element) => element['id'] == modelId,
                          )['name'];

                  return GestureDetector(
                    onTap: () async {
                      final result = await pushTo(
                        MaterialIssue(
                          jobcardNo: filteredList[index]['job_No'],
                          materialIsuueNumber:
                              widget.status != 1 ? widget.status + 1 : 10,
                        ),
                      );
                      if (result != null) {
                        fatchJobcard(
                          dateFrom: datepickar1.text,
                          dateTo: datepickar2.text,
                        ).then((value) => setState(() {}));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Sizes.height * .02),
                      decoration: decorationBox(),
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
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w600,
                                  AppColor.colBlack,
                                ),
                              ),
                              trailing: Text(
                                "Job Card No : ${filteredList[index]['job_No']}",
                                style: rubikTextStyle(
                                  13,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            minVerticalPadding: Sizes.height * 0.02,
                            leading: CircleAvatar(
                              backgroundColor: AppColor.colPrimary,
                              child: Text(
                                ledgerName[0],
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colWhite,
                                ),
                              ),
                            ),
                            title: Text(
                              ledgerName,
                              style: rubikTextStyle(
                                17,
                                FontWeight.w500,
                                AppColor.colBlack,
                              ),
                            ),
                            subtitle: Text(
                              modelName,
                              style: rubikTextStyle(
                                14,
                                FontWeight.w400,
                                AppColor.colLabel,
                              ),
                            ),
                            trailing: PopupMenuButton(
                              onSelected: (value) async {
                                if (value == 'Generate') {
                                } else if (value == 'Edit') {
                                  pushTo(
                                    JobCardScreen(
                                      jobcardNumber:
                                          filteredList[index]['job_No'],
                                      srNo: filteredList[index]['sr_No'],
                                    ),
                                  );
                                } else if (value == 'Delete') {
                                  deleteJobCardApi(
                                    filteredList[index]['job_No'],
                                  ).then(
                                    (value) => fatchJobcard(
                                      dateFrom: datepickar1.text,
                                      dateTo: datepickar2.text,
                                    ).then((value) => setState(() {})),
                                  );
                                }
                              },
                              itemBuilder:
                                  (BuildContext context) => <PopupMenuEntry>[
                                    const PopupMenuItem(
                                      value: 'Edit',
                                      child: Text('Edit Job Card'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'Delete',
                                      child: Text('Delete Job Card'),
                                    ),
                                  ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      makeCall(context, ledgerNumber);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColor.colGreen,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: AppColor.colGreen,
                                            size: 16,
                                          ),
                                          Text(
                                            "Call",
                                            style: rubikTextStyle(
                                              16,
                                              FontWeight.w500,
                                              AppColor.colBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      sendMessage(
                                        context,
                                        ledgerNumber,
                                        ledgerName,
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColor.colFbCircle,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.chat,
                                            color: AppColor.colFbCircle,
                                            size: 16,
                                          ),
                                          Text(
                                            "SMS",
                                            style: rubikTextStyle(
                                              16,
                                              FontWeight.w500,
                                              AppColor.colBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    onTap: () {
                                      openWhatsApp(
                                        context,
                                        ledgerNumber,
                                        ledgerName,
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColor.colYellow,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            Images.whatsapp,
                                            height: 16,
                                          ),
                                          Text(
                                            " WhatsApp",
                                            style: rubikTextStyle(
                                              16,
                                              FontWeight.w500,
                                              AppColor.colBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Sizes.height * 0.02),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      "Odometer",
                                      style: rubikTextStyle(
                                        14,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                    Text(
                                      "${filteredList[index]['kms']} Km",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      "Fuel Indicator",
                                      style: rubikTextStyle(
                                        14,
                                        FontWeight.w500,
                                        AppColor.colBlack,
                                      ),
                                    ),
                                    Text(
                                      "${filteredList[index]['fuel']}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(flex: 1, child: Container()),
                            ],
                          ),
                          Divider(thickness: 1, color: AppColor.colBlack),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Customer remark : ${filteredList[index]['customer_Voice']}',
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Sizes.height * 0.01),
                        ],
                      ),
                    ),
                  );
                }),
              )
              : Table(
                border: TableBorder.all(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.colBlack,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: AppColor.colPrimary),
                    children: [
                      Text(
                        "Jobcard Number",
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Customer Name",
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Vehicle Model",
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Vehicle Number",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                      ),
                      Text(
                        "Mobile Number",
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Customer Remark",
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Action",
                        style: TextStyle(
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColor.colBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  ...List.generate(filteredList.length, (index) {
                    //Ledger
                    int ledgerId = filteredList[index]['ledger_Id'];
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

                    //Model
                    int modelId = filteredList[index]['model_Id'];
                    String modelName =
                        modelNameList.isEmpty
                            ? ""
                            : modelNameList.firstWhere(
                              (element) => element['id'] == modelId,
                            )['name'];

                    return TableRow(
                      decoration: BoxDecoration(color: AppColor.colWhite),
                      children: [
                        tableRow("${filteredList[index]["job_No"]}"),
                        tableRow(ledgerName),
                        tableRow(modelName),
                        tableRow(filteredList[index]['vehicle_No']),
                        tableRow(ledgerNumber),
                        tableRow(filteredList[index]['customer_Voice']),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final result = await pushTo(
                                  MaterialIssue(
                                    jobcardNo: filteredList[index]['job_No'],
                                    materialIsuueNumber:
                                        widget.status != 1
                                            ? widget.status + 1
                                            : 10,
                                  ),
                                );
                                if (result != null) {
                                  fatchJobcard(
                                    dateFrom: datepickar1.text,
                                    dateTo: datepickar2.text,
                                  ).then((value) => setState(() {}));
                                }
                              },
                              icon: Icon(
                                Icons.visibility,
                                color: AppColor.colGreen,
                              ),
                            ),
                            widget.status >= 3
                                ? Container()
                                : IconButton(
                                  onPressed: () {
                                    pushTo(
                                      JobCardScreen(
                                        jobcardNumber:
                                            filteredList[index]['job_No'],
                                        srNo: filteredList[index]['sr_No'],
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColor.colPrimary,
                                  ),
                                ),
                            IconButton(
                              onPressed: () {
                                deleteJobCardApi(
                                  filteredList[index]['job_No'],
                                ).then(
                                  (value) => fatchJobcard(
                                    dateFrom: datepickar1.text,
                                    dateTo: datepickar2.text,
                                  ).then((value) => setState(() {})),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: AppColor.colRideFare,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
        ],
      ),
    );
  }

  // Fatch Jobcard
  Future fatchJobcard({
    required String dateFrom,
    required String dateTo,
  }) async {
    final formattedDateFrom = DateFormat(
      'yyyy/MM/dd',
    ).format(DateFormat('yyyy/MM/dd').parse(dateFrom));
    final formattedDateTo = DateFormat(
      'yyyy/MM/dd',
    ).format(DateFormat('yyyy/MM/dd').parse(dateTo));
    var response = await ApiService.fetchData(
      "Transactions/GetJobCardALLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&jobclosestatus=${widget.status}&datefrom=$formattedDateFrom&dateto=$formattedDateTo",
    );

    jobcardList = response;
    filteredList = jobcardList;
  }

  //fatch Model Name list
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

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetLedgerByGroupId?LedgerGroupId=10",
    );

    ledgerList = response;
  }

  //Delete JobCard
  Future deleteJobCardApi(int? jobCardId) async {
    var response = await ApiService.postData(
      "Transactions/DeleteJobCardAW?prefix=online&refno=$jobCardId&locationid=${Preference.getString(PrefKeys.locationId)}",
      {},
    );

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }
}
