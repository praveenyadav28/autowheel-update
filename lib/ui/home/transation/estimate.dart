// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class Estimate extends StatefulWidget {
  Estimate({super.key, required this.items, required this.docNumber});

  int docNumber = 0;
  final List items;
  @override
  State<Estimate> createState() => _EstimateState();
}

class _EstimateState extends State<Estimate> {
//Controller
  TextEditingController docNoController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController engineNoController = TextEditingController();
  TextEditingController chassisController = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _pinCodecontroller = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _otherChargesController = TextEditingController();
  TextEditingController searchController = TextEditingController();

// Date
  TextEditingController estimateDate = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

  double _finalPrice = 0.0;
  double totalDiscount = 0.0;

  //City
  List<Map<String, dynamic>> cityList = [];
  List<Map<String, dynamic>> districtList = [];
  int? cityId;
  Map<String, dynamic>? cityValue;
  String cityName = '';
  String stateName = 'Unknown';
  String districtName = 'Unknown';

//Title
  List<Map<String, dynamic>> titleList = [
    {'id': 101, 'name': 'Mr.'},
    {'id': 102, 'name': 'Mrs.'},
    {'id': 103, 'name': 'Dr.'},
    {'id': 104, 'name': 'M/s'}
  ];
  int selectedtitleId = 101;

//Invoice model
  late InvoiceModel invoiceModel;

//Model Name
  List<Map<String, dynamic>> modelNameList = [];
  int? modelNameId;
  String modalName = '';
  Map<String, dynamic>? modelValue;

//Ledger
  List<Map<String, dynamic>> ledgerList = [];
  String ledgerName = '';
  Map<String, dynamic>? ledgerValue;
  int? ledgerId;

//Ledger Acount Type
  bool accountType = true;

  @override
  void initState() {
    invoiceModel = Provider.of<InvoiceModel>(context, listen: false);
    fatchdocNumber().then((value) => setState(() {}));
    getAccountDetails().then((value) => setState(() {}));
    fatchledger().then((value) => setState(() {}));

    fetchDistrict().then((value) => setState(() {}));
    fetchCity().then((value) => setState(() {
          widget.docNumber == 0
              ? null
              : getEstimateDetails().then((value) => setState(() {}));
        }));

    fatchVehicle().then((value) => setState(() {
          modelNameId = modelNameList.first['id'];
        }));
    super.initState();
  }

  void _calculateFinalPrice() {
    double price = (invoiceModel.labours
            .fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])) +
        invoiceModel.parts
            .fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])));
    double discountPrice =
        double.tryParse(_discountPriceController.text) ?? 0.0;
    double discountPercentage =
        double.tryParse(_discountPercentageController.text) ?? 0.0;
    double otherCharges = double.tryParse(_otherChargesController.text) ?? 0.0;

    double discountFromPercentage = (price * discountPercentage) / 100;
    totalDiscount = discountPrice + discountFromPercentage;
    _finalPrice = price - totalDiscount + otherCharges;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var invoiceModel = Provider.of<InvoiceModel>(context);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            centerTitle: true,
            title: const Text("Estimate", overflow: TextOverflow.ellipsis),
            backgroundColor: AppColor.colPrimary),
        backgroundColor: AppColor.colWhite,
        body: Container(
          height: Sizes.height,
          color: AppColor.colPrimary.withOpacity(.1),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
              child: Column(
                children: [
                  addMasterOutside(context: context, children: [
                    textformfiles(docNoController,
                        labelText: 'Document Number*'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dropdownTextfield(
                          context,
                          "Document Date",
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
                                  estimateDate.text = DateFormat('yyyy/MM/dd')
                                      .format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  estimateDate.text,
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
                    textformfiles(
                        textCapitalization: TextCapitalization.characters,
                        vehicleController,
                        labelText: 'Vehicle Number*'),
                    textformfiles(
                        textCapitalization: TextCapitalization.characters,
                        chassisController,
                        labelText: 'Chassis Number*'),
                    textformfiles(
                        textCapitalization: TextCapitalization.characters,
                        engineNoController,
                        labelText: 'Engine Number'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: dropdownTextfield(
                              context,
                              "Model Name*",
                              searchDropDown(
                                  context,
                                  modalName.isNotEmpty
                                      ? modalName
                                      : "Select Model Name*",
                                  modelNameList
                                      .map((item) => DropdownMenuItem(
                                            onTap: () {
                                              modelNameId = item['id'];
                                              modalName = item['name'];
                                            },
                                            value: item,
                                            child: Text(
                                              item['name'].toString(),
                                              style: rubikTextStyle(
                                                  14,
                                                  FontWeight.w500,
                                                  AppColor.colBlack),
                                            ),
                                          ))
                                      .toList(),
                                  modelValue,
                                  (value) {
                                    setState(() {
                                      modelValue = value;
                                    });
                                  },
                                  searchController,
                                  (value) {
                                    setState(() {
                                      modelNameList
                                          .where((item) => item['name']
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                  'Search for a model...',
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
                            var result = await pushTo(const VehicleMaster());
                            if (result != null) {
                              fatchVehicle().then((value) => setState(() {}));
                            }
                          },
                        )
                      ],
                    ),
                  ]),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: accountType ? 0 : Sizes.width * 0.02,
                    runSpacing: accountType ? 0 : Sizes.height * 0.02,
                    children: [
                      SizedBox(
                          width: accountType
                              ? double.infinity
                              : Sizes.width <= 900
                                  ? double.infinity
                                  : Sizes.width * .46,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizes.width * 0.02),
                            decoration: BoxDecoration(
                                color: AppColor.colWhite,
                                border: Border.all(
                                    color: AppColor.colBlack, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Entry"),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      accountType = !accountType;
                                      // fatchledger().then((value) => setState(() {
                                      //       ledgerId = ledgerList.first["id"];
                                      //       ledgerName = ledgerList.first["name"];

                                      //       ledgerValue! = {
                                      //         'id': ledgerId,
                                      //         'name': ledgerName,
                                      //         'mob': ledgerList.first['mob'],
                                      //         'address':
                                      //             ledgerList.first['address'],
                                      //         'gst_No':
                                      //             ledgerList.first['gst_No'],
                                      //       };
                                      //     }));
                                    });
                                  },
                                  child: Stack(
                                    alignment: accountType
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 23,
                                        decoration: BoxDecoration(
                                            color: accountType
                                                ? AppColor.colGrey
                                                : AppColor.colPriLite,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                      Container(
                                        width: 28,
                                        height: 28,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColor.colGrey,
                                                  blurRadius: 2,
                                                  spreadRadius: 1)
                                            ],
                                            shape: BoxShape.circle,
                                            color: accountType
                                                ? AppColor.colWhite
                                                : AppColor.colPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text("Ledger"),
                              ],
                            ),
                          )),
                      accountType
                          ? Container()
                          : SizedBox(
                              width: Sizes.width <= 900
                                  ? double.infinity
                                  : Sizes.width * .46,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: dropdownTextfield(
                                        context,
                                        "Ledger Account*",
                                        searchDropDown(
                                            context,
                                            "Select Ledger Account*",
                                            ledgerList
                                                .map((item) => DropdownMenuItem(
                                                      onTap: () {
                                                        ledgerId = item['id'];
                                                        ledgerName =
                                                            item['name'];
                                                      },
                                                      value: item,
                                                      child: Text(
                                                        item['name'].toString(),
                                                        style: rubikTextStyle(
                                                            14,
                                                            FontWeight.w500,
                                                            AppColor.colBlack),
                                                      ),
                                                    ))
                                                .toList(),
                                            ledgerValue,
                                            (value) {
                                              setState(() {
                                                ledgerValue = value;
                                              });
                                            },
                                            searchController,
                                            (value) {
                                              setState(() {
                                                ledgerList
                                                    .where((item) =>
                                                        item['name']
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                    .toList();
                                              });
                                            },
                                            'Search for a ledger...',
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
                                      var result = await pushTo(
                                          LedgerMaster(groupId: 10));
                                      if (result != null) {
                                        fatchledger()
                                            .then((value) => setState(() {}));
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: Sizes.height * 0.03),
                  !accountType
                      ? Container()
                      : addMasterOutside(context: context, children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: dropdownTextfield(
                                  context,
                                  "",
                                  defaultDropDown(
                                      value: titleList.firstWhere((item) =>
                                          item['id'] == selectedtitleId),
                                      items: titleList.map((data) {
                                        return DropdownMenuItem<
                                            Map<String, dynamic>>(
                                          value: data,
                                          child: Text(
                                            data['name'],
                                            style: rubikTextStyle(
                                                16,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (selectedId) {
                                        setState(() {
                                          selectedtitleId = selectedId!['id'];
                                          // Call function to make API request
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 5,
                                child: textformfiles(namecontroller,
                                    labelText: "Customer Name*",
                                    validator: (value) {
                                  if (value!.isEmpty &&
                                      namecontroller.text.trim().isEmpty) {
                                    return "Please enter name";
                                  }
                                  return null;
                                }),
                              ),
                            ],
                          ),
                          textformfiles(_addresscontroller,
                              labelText: "Address"),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: dropdownTextfield(
                                    context,
                                    "City",
                                    searchDropDown(
                                        context,
                                        cityName.isNotEmpty
                                            ? cityName
                                            : "Select City",
                                        cityList
                                            .map((item) => DropdownMenuItem(
                                                  onTap: () {
                                                    setState(() {
                                                      cityId = item['city_Id'];
                                                      cityName =
                                                          item['city_Name'];

                                                      int districtId =
                                                          item['district_Id'];
                                                      districtName = districtList
                                                              .isEmpty
                                                          ? ""
                                                          : districtList.firstWhere(
                                                                  (element) =>
                                                                      element[
                                                                          'district_Id'] ==
                                                                      districtId)[
                                                              'district_Name'];
                                                      stateName = districtList
                                                              .isEmpty
                                                          ? ""
                                                          : districtList.firstWhere(
                                                                  (element) =>
                                                                      element[
                                                                          'district_Id'] ==
                                                                      districtId)[
                                                              'state_Name'];
                                                    });
                                                  },
                                                  value: item,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        item['city_Name']
                                                            .toString(),
                                                        style: rubikTextStyle(
                                                            16,
                                                            FontWeight.w500,
                                                            AppColor.colBlack),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                        cityValue,
                                        (value) {
                                          setState(() {
                                            cityValue = value;
                                          });
                                        },
                                        searchController,
                                        (value) {
                                          setState(() {
                                            cityList
                                                .where((item) =>
                                                    item['city_Name']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(value
                                                            .toLowerCase()))
                                                .toList();
                                          });
                                        },
                                        'Search for a City...',
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
                                  var result = await pushTo(const CityMaster());
                                  if (result != null) {
                                    cityValue = null;
                                    fetchDistrict()
                                        .then((value) => setState(() {}));
                                    fetchCity()
                                        .then((value) => setState(() {}));
                                  }
                                },
                              )
                            ],
                          ),
                          ReuseContainer(
                              title: "District", subtitle: districtName),
                          ReuseContainer(title: "State", subtitle: stateName),
                          textformfiles(_pinCodecontroller,
                              labelText: "Pin Code",
                              keyboardType: TextInputType.number),
                          textformfiles(_mobileController,
                              labelText: "Mobile Number",
                              keyboardType: TextInputType.phone)
                        ]),
                  Wrap(
                    runSpacing: Sizes.height * 0.02,
                    spacing: Sizes.width * 0.02,
                    children: [
                      Container(
                          width: Sizes.width <= 900
                              ? double.infinity
                              : Sizes.width * .46,
                          decoration: decorationBox(),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  "‣ Add Spare Part",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: ElevatedButton(
                                    onPressed: () async {
                                      final result =
                                          await pushTo(AddPartInvoice(
                                        status: 3,
                                        invoiceNumber:
                                            int.parse(docNoController.text),
                                      ));
                                      if (result != null) {
                                        setState(() {
                                          _calculateFinalPrice();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.colPrimary),
                                    child: const Text('Add +')),
                              ),
                              const Divider(),
                              SizedBox(
                                  height: 200,
                                  child: invoiceModel.parts.isEmpty
                                      ? const Center(
                                          child: Text("No Spare Parts Added"))
                                      : SingleChildScrollView(
                                          child: Column(
                                              children: List.generate(
                                                  invoiceModel.parts.length,
                                                  (index) {
                                            return ListTile(
                                                horizontalTitleGap: 0,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                dense: true,
                                                title: Text(
                                                  invoiceModel.parts[index]
                                                      ['item_Name'],
                                                  style: rubikTextStyle(
                                                      15,
                                                      FontWeight.w500,
                                                      AppColor.colBlack),
                                                ),
                                                subtitle: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "₹${invoiceModel.parts[index]['sale_Price']} * ${invoiceModel.parts[index]['qty']} ",
                                                      style: rubikTextStyle(
                                                          14,
                                                          FontWeight.w400,
                                                          AppColor.colBlack),
                                                    ),
                                                    Text(
                                                      " ( ${invoiceModel.parts[index]['gst']}% gst )",
                                                      style: rubikTextStyle(
                                                          14,
                                                          FontWeight.w400,
                                                          AppColor.colGrey),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(double.parse(invoiceModel
                                                                        .parts[
                                                                    index][
                                                                'total_Price'] ??
                                                            "0")
                                                        .toStringAsFixed(2)),
                                                    PopupMenuButton(
                                                      position:
                                                          PopupMenuPosition
                                                              .under,
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry>[
                                                        PopupMenuItem(
                                                            value: 'Delete',
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          'Delete part'),
                                                                      content:
                                                                          const Text(
                                                                              'Are you sure you want to delete part ?'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('Cancel'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              invoiceModel.parts.removeAt(index);
                                                                              Navigator.pop(context);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Delete',
                                                                            style:
                                                                                TextStyle(color: AppColor.colRideFare),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: const Text(
                                                                'Delete')),
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
                                                          bottom: 7),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        AppColor.colPrimary,
                                                    child: Text("${index + 1}",
                                                        style: rubikTextStyle(
                                                            14,
                                                            FontWeight.w500,
                                                            AppColor.colWhite)),
                                                  ),
                                                ));
                                          })),
                                        )),
                              Divider(thickness: 0, color: AppColor.colGrey),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "Subtotal",
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                                trailing: Text(
                                  "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'] ?? "0")).toStringAsFixed(2)}",
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              )
                            ],
                          )),
                      Container(
                          width: Sizes.width <= 900
                              ? double.infinity
                              : Sizes.width * .46,
                          decoration: decorationBox(),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  "‣ Add Labour",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: ElevatedButton(
                                    onPressed: () async {
                                      final result =
                                          await pushTo(AddLabourInvoice(
                                        invoiceNumber:
                                            int.parse(docNoController.text),
                                        status: 2,
                                      ));
                                      if (result != null) {
                                        setState(() {
                                          _calculateFinalPrice();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.colPrimary),
                                    child: const Text('Add +')),
                              ),
                              const Divider(),
                              SizedBox(
                                  height: 200,
                                  child: invoiceModel.labours.isEmpty
                                      ? const Center(
                                          child: Text("No Labour Added"))
                                      : SingleChildScrollView(
                                          child: Column(
                                              children: List.generate(
                                                  invoiceModel.labours.length,
                                                  (index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                    horizontalTitleGap: 0,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 16),
                                                    dense: true,
                                                    title: Text(
                                                      invoiceModel
                                                              .labours[index]
                                                          ['item_Name'],
                                                      style: rubikTextStyle(
                                                          15,
                                                          FontWeight.w500,
                                                          AppColor.colBlack),
                                                    ),
                                                    subtitle: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "₹${invoiceModel.labours[index]['sale_Price']} * ${invoiceModel.labours[index]['qty']} ",
                                                          style: rubikTextStyle(
                                                              14,
                                                              FontWeight.w400,
                                                              AppColor
                                                                  .colBlack),
                                                        ),
                                                        Text(
                                                          " ( ${invoiceModel.labours[index]['gst']}% gst )",
                                                          style: rubikTextStyle(
                                                              14,
                                                              FontWeight.w400,
                                                              AppColor.colGrey),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "${invoiceModel.labours[index]['total_Price']}"),
                                                        PopupMenuButton(
                                                          position:
                                                              PopupMenuPosition
                                                                  .under,
                                                          itemBuilder: (BuildContext
                                                                  context) =>
                                                              <PopupMenuEntry>[
                                                            PopupMenuItem(
                                                                value: 'Delete',
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Delete part'),
                                                                          content:
                                                                              const Text('Are you sure you want to delete part ?'),
                                                                          actions: <Widget>[
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text('Cancel'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  invoiceModel.labours.removeAt(index);
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: Text(
                                                                                'Delete',
                                                                                style: TextStyle(color: AppColor.colRideFare),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                child: const Text(
                                                                    'Delete')),
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
                                                              bottom: 7),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            AppColor.colPrimary,
                                                        child: Text(
                                                            "${index + 1}",
                                                            style: rubikTextStyle(
                                                                14,
                                                                FontWeight.w500,
                                                                AppColor
                                                                    .colWhite)),
                                                      ),
                                                    )),
                                              ],
                                            );
                                          })),
                                        )),
                              Divider(thickness: 0, color: AppColor.colGrey),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "Subtotal",
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                                trailing: Text(
                                  "₹ ${invoiceModel.labours.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                  addMasterOutside(context: context, children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: textformfiles(
                            _discountPriceController,
                            labelText: "Discount in ₹",
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _calculateFinalPrice(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: textformfiles(
                            _discountPercentageController,
                            labelText: "Discount in %",
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _calculateFinalPrice(),
                          ),
                        ),
                      ],
                    ),
                    textformfiles(
                      _otherChargesController,
                      labelText: "Other",
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _calculateFinalPrice(),
                    ),
                    ReuseContainer(
                        title: "Gst",
                        subtitle:
                            "₹ ${(invoiceModel.labours.fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount'])) + invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount'] ?? "0"))).toStringAsFixed(2)}"),
                    ReuseContainer(
                        title: "Net Amount",
                        subtitle: "₹  ${_finalPrice.toStringAsFixed(2)}"),
                  ]),
                  SizedBox(height: Sizes.height * 0.02),
                  button("Save", AppColor.colPrimary, onTap: () {
                    if (docNoController.text.isEmpty) {
                      showCustomSnackbar(
                          context, "Please enter Document Number");
                    } else if (chassisController.text.isEmpty &&
                        vehicleController.text.isEmpty) {
                      showCustomSnackbar(
                          context, "Please enter Chassis or Vehicle Number");
                    } else if (modelNameId == null || ledgerId == null) {
                      showCustomSnackbar(
                          context, "Please select modal and ledger");
                    } else if (invoiceModel.labours.isEmpty &&
                        invoiceModel.parts.isEmpty) {
                      showCustomSnackbar(
                          context, "Please add atleast one part or labour");
                    } else {
                      postEstimateInvoice();
                    }
                  }),
                ],
              ),
            ),
          ),
        ));
  }

//Get doc Number
  Future fatchdocNumber() async {
    var response = await ApiService.fetchData(
        "Transactions/GetInvoiceNoAW?Tblname=Estimate&Fldname=Doc_No&transdatefld=Doc_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}");
    docNoController.text =
        widget.docNumber != 0 ? "${widget.docNumber}" : "$response";
  }

  //Post Estimate Invoice
  Future postEstimateInvoice() async {
    var grossAmount = invoiceModel.labours
            .fold(0.0, (sum, map) => sum + double.parse(map['sale_Price'])) +
        invoiceModel.parts.fold(
            0.0,
            (sum, map) =>
                sum +
                (double.parse(map['sale_Price']) * double.parse(map['qty'])));
    String gstAmount = (invoiceModel.labours.fold(
                0.0, (sum, map) => sum + double.parse(map['gst_Amount'])) +
            invoiceModel.parts
                .fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount'])))
        .toStringAsFixed(2);
    var response = await ApiService.postData(
        widget.docNumber == 0
            ? 'Transactions/PostEstimateAW'
            : "Transactions/UpdateEstimateAW?prefix=online&refno=${widget.docNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
        {
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": "online",
          "doc_No": int.parse(docNoController.text),
          "doc_Date": estimateDate.text.toString(),
          "jobPrefix_Name": "online",
          "job_No": 0,
          "vehicle_No": vehicleController.text.toString(),
          "chassis_No": chassisController.text.toString(),
          "engine_No": engineNoController.text.toString(),
          "model_Id": modelNameId,
          "model_Name": modalName,
          "ledger_Id": accountType ? 0 : ledgerId,
          "customer_Name":
              accountType ? namecontroller.text.toString() : ledgerName,
          "title": "Title",
          "party_Name":
              accountType ? namecontroller.text.toString() : ledgerName,
          "address": accountType
              ? _addresscontroller.text.toString()
              : ledgerValue!['address'] ?? "",
          "dist": districtName,
          "mob": accountType
              ? _mobileController.text.toString()
              : ledgerValue!['mob'] ?? "",
          "pin": accountType
              ? _pinCodecontroller.text.toString()
              : ledgerValue!['pin_Code'] ?? "",
          "city_Id": accountType ? cityId ?? 0 : ledgerValue?['city_Id'] ?? 0,
          "city": cityName,
          "gross_Amount": grossAmount.toString(),
          "discount": totalDiscount.toStringAsFixed(2),
          "taxable_Amount": grossAmount.toString(),
          "gst": gstAmount,
          "net_Amount": _finalPrice.toStringAsFixed(2),
          "other_Charge": _otherChargesController.text.isEmpty
              ? "0"
              : _otherChargesController.text.toString(),
          "status": "0",
          "prefix_Name_Receipt": "online",
          "receiptNo": 0,
          "advanceAmt": "0",
          "mode_Id": accountType ? 1 : 2,
          "balanceAmt": "0",
          "estimate_Items": [...invoiceModel.labours, ...invoiceModel.parts]
        });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      fatchEstimateDetails().then((value) => setState(() {}));
      invoiceModel.clearData();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//estimate Datails Get
  Future fatchEstimateDetails() async {
    estimateDetails = await ApiService.fetchData(
        'Transactions/GetEstimateAW?prefix=online&refno=${docNoController.text}&locationid=${Preference.getString(PrefKeys.locationId)}');
    generateInvoicePDF(4, estimateDetails, companyDetails, ledgerValue!);
  }

  // Get City List
  Future fetchCity() async {
    final response = await ApiService.fetchData("MasterAW/GetCityAW");

    if (response is List) {
      // Assuming it's a list, convert each item to a Map
      cityList = response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for cities');
    }
  }

  // Get District List
  Future fetchDistrict() async {
    final response = await ApiService.fetchData("MasterAW/GetDistrictAW");

    if (response is List) {
      // Assuming it's a list, convert each item to a Map
      districtList =
          response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for cities');
    }
  }

//Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=10");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'mob': item['mob'],
          'address': item['address'],
          'city_Id': item['city_Id'],
          'gst_No': item['gst_No'],
          'pin_Code': item['pin_Code'],
        }));
  }

  Map<String, dynamic> estimateDetails = {};
  Map<String, dynamic> companyDetails = {};

//Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
  }

//Fatch Model Name list
  Future fatchVehicle() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetVehicleMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    modelNameList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['model_Id'],
          'name': "${item['model_Name']} ${item['model_Code']}",
        }));
  }

  //Get Estimate Details
  Future getEstimateDetails() async {
    estimateDetails = await ApiService.fetchData(
        "Transactions/GetEstimateAW?prefix=online&refno=${widget.docNumber}&locationid=${Preference.getString(PrefKeys.locationId)}");
    _otherChargesController.text = estimateDetails['other_Charge'] ?? "";
    _mobileController.text = estimateDetails['mob'] ?? "";
    _pinCodecontroller.text = estimateDetails['pin'] ?? "";
    _addresscontroller.text = estimateDetails['address'] ?? "";
    chassisController.text = estimateDetails['chassis_No'] ?? "";
    namecontroller.text = estimateDetails['party_Name'] ?? "";
    engineNoController.text = estimateDetails['engin_no'] ?? "";
    vehicleController.text = estimateDetails['vehicle_No'] ?? "";
    modelNameId = estimateDetails['model_Id'];
    modalName = modelNameList
        .firstWhere((element) => element['id'] == modelNameId)['name'];
    ledgerId = estimateDetails['ledger_Id'];
    cityId = estimateDetails['city_Id'];
    cityName = estimateDetails['city'];
    districtName = cityList
        .firstWhere((element) => element['city_Id'] == cityId)['district_Name'];
    stateName = cityList
        .firstWhere((element) => element['city_Id'] == cityId)['state_Name'];

    // Clear previous lists
    invoiceModel.labours.clear();
    invoiceModel.parts.clear();

    // Iterate through Estimate Items and classify based on 'type'
    List items = (estimateDetails['estimate_Items'] as List);
    for (var item in items) {
      if (item['type'] == "1") {
        Provider.of<InvoiceModel>(context, listen: false).addPart(item);
      } else if (item['type'] == "2") {
        Provider.of<InvoiceModel>(context, listen: false).addLabour(item);
      }
    }
  }
}
