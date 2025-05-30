// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class SaleInvoice extends StatefulWidget {
  SaleInvoice({
    super.key,
    required this.saleIvoiceItems,
    required this.invoiceNumber,
    required this.jobcardNumber,
  });
  int invoiceNumber = 0;
  int jobcardNumber = 0;
  final List saleIvoiceItems;
  @override
  State<SaleInvoice> createState() => _SaleInvoiceState();
}

class _SaleInvoiceState extends State<SaleInvoice> {
  //Controller
  TextEditingController serailInvoiceController = TextEditingController();
  TextEditingController vechileController = TextEditingController();
  TextEditingController kmController = TextEditingController();
  TextEditingController partyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _otherChargesController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  double _finalPrice = 0.0;
  double totalDiscount = 0.0;

  // Date
  TextEditingController saleInvoiceDate = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  String saleInvoiceDateString = '';
  //Model Name
  List<Map<String, dynamic>> modelNameList = [];
  String modalName = '';
  Map<String, dynamic>? modelValue;
  int? modelNameId;

  //Sale Invoice Map
  Map<String, dynamic> saleInvoiceDetails = {};

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  String ledgerName = '';
  Map<String, dynamic>? ledgerDetails;
  int? ledgerId;

  //State
  List<Map<String, dynamic>> statesList = [
    {"id": 11, "name": "ANDAMAN AND NICOBAR ISLANDS"},
    {"id": 10, "name": "ANDHRA PRADESH(Old)"},
    {"id": 39, "name": "Andhra Pradesh (New)"},
    {"id": 12, "name": "ARUNACHAL PRADESH"},
    {"id": 7, "name": "ASSAM"},
    {"id": 13, "name": "BIHAR"},
    {"id": 14, "name": "CHANDIGARH"},
    {"id": 15, "name": "CHHATTISGARH"},
    {"id": 16, "name": "Dadra and Nagar Haveli and Daman and Diu"},
    {"id": 17, "name": "DAMAN AND DIU"},
    {"id": 18, "name": "DELHI"},
    {"id": 20, "name": "GUJARAT"},
    {"id": 3, "name": "HARYANA"},
    {"id": 21, "name": "HIMACHAL PRADESH"},
    {"id": 22, "name": "JAMMU AND KASHMIR"},
    {"id": 23, "name": "JHARKHAND"},
    {"id": 24, "name": "KARNATAKA"},
    {"id": 25, "name": "KERALA"},
    {"id": 26, "name": "LAKSHADWEEP"},
    {"id": 40, "name": "LADAKH (NEWLY ADDED)"},
    {"id": 27, "name": "MANIPUR"},
    {"id": 28, "name": "MEGHALAYA"},
    {"id": 29, "name": "MIZORAM"},
    {"id": 2, "name": "MADHYA PRADESH"},
    {"id": 9, "name": "MAHARASHTRA"},
    {"id": 30, "name": "NAGALAND"},
    {"id": 8, "name": "ODISHA"},
    {"id": 31, "name": "PUDUCHERRY"},
    {"id": 6, "name": "PUNJAB"},
    {"id": 1, "name": "RAJASTHAN"},
    {"id": 32, "name": "SIKKIM"},
    {"id": 33, "name": "TAMIL NADU"},
    {"id": 34, "name": "TELANGANA"},
    {"id": 35, "name": "TRIPURA"},
    {"id": 37, "name": "UTTARAKHAND"},
    {"id": 36, "name": "UTTAR PRADESH"},
    {"id": 38, "name": "WEST BENGAL"},
    {"id": 41, "name": "OTHER TERRITORY"},
    {"id": 42, "name": "CENTRE JURISDICTION"},
  ];
  int? stateId;
  String stateName = '';
  Map<String, dynamic>? stateValue;

  //staff
  List<Map<String, dynamic>> staffList = [];
  int? staffId;

  //Time
  late TimeOfDay saleInvoiceTime;
  Future<void> _saleInvoiceTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: saleInvoiceTime,
    );
    if (picked != null && picked != saleInvoiceTime) {
      setState(() {
        saleInvoiceTime = picked;
      });
    }
  }

  //Ledger Acount Type
  bool accountType = true;

  //Invoice model
  late InvoiceModel invoiceModel;
  @override
  void initState() {
    invoiceModel = Provider.of<InvoiceModel>(context, listen: false);
    saleInvoiceTime = TimeOfDay.now();
    invoiceModel.clearData();
    saleInvoiceDateString = saleInvoiceDate.text;
    _discountPriceController.addListener(_calculateFinalPrice);
    _discountPercentageController.addListener(_calculateFinalPrice);
    _otherChargesController.addListener(_calculateFinalPrice);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshFunction().then((value) {
        getInvoiceDetails().then(
          (value) => setState(() {
            _calculateFinalPrice();
            _populateInvoiceItems();
          }),
        );
      });
    });
    super.initState();
  }

  Future refreshFunction() async {
    await fatchInvoiceNumber();
    await getAccountDetails();
    await fatchledger();
    await fatchVehicle();
    await fatchJobcardDetails();
    await fatchstaff().then((value) {
      staffId = staffList.isNotEmpty ? staffList.first["id"] : null;
    });
  }

  void _populateInvoiceItems() {
    final invoiceModel = Provider.of<InvoiceModel>(context, listen: false);
    for (var item in widget.saleIvoiceItems) {
      if (item['type'] == "1") {
        invoiceModel.addPart({
          "location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": item['prefix_Name'],
          "Invoice_No": int.parse(serailInvoiceController.text),
          "item": item['item'],
          "item_Name": item['item_Name'],
          "hsn_Code": item['hsn_Code'],
          "qty": item['qty'],
          "mrp": item['mrp'],
          "sale_Price": item['sale_Price'],
          "total_Price": item['total_Price'],
          "gst": item['gst'],
          "gst_Amount": item['gst_Amount'],
          "cess": item['cess'],
          "cess_Amount": item['cess_Amount'],
          "taxable": item['taxable'],
          "labour": item['labour'],
          "discount_Item": item['discount_Item'],
          "type": item['type'],
          "tranDate": item['tranDate'],
          "form_Type": item['form_Type'],
          "warranty_TypeId": item['warranty_TypeId'],
          "mechnic_Id": item['mechnic_Id'],
          "issue_Date": item['issue_Date'],
          "itemId": item['itemId'],
          "hsn_Id": item['hsn_Id'],
          "jobCard_No": 0,
          "prefix_Name_Job": "online",
          "igstAmount": item['igstAmount'],
          "cgstAmount": item['cgstAmount'],
          "sgstAmount": item['sgstAmount'],
        });
      } else if (item['type'] == "2") {
        invoiceModel.addLabour({
          "location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "prefix_Name": item['prefix_Name'],
          "Invoice_No": int.parse(serailInvoiceController.text),
          "item": item['item'],
          "item_Name": item['item_Name'],
          "hsn_Code": item['hsn_Code'],
          "qty": item['qty'],
          "mrp": item['mrp'],
          "sale_Price": item['sale_Price'],
          "total_Price": item['total_Price'],
          "gst": item['gst'],
          "gst_Amount": item['gst_Amount'],
          "cess": item['cess'],
          "cess_Amount": item['cess_Amount'],
          "taxable": item['taxable'],
          "labour": item['labour'],
          "discount_Item": item['discount_Item'],
          "type": item['type'],
          "tranDate": item['tranDate'],
          "form_Type": item['form_Type'],
          "warranty_TypeId": item['warranty_TypeId'],
          "mechnic_Id": item['mechnic_Id'],
          "issue_Date": item['issue_Date'],
          "itemId": item['itemId'],
          "hsn_Id": item['hsn_Id'],
          "jobCard_No": 0,
          "prefix_Name_Job": "online",
          "igstAmount": item['igstAmount'],
          "cgstAmount": item['cgstAmount'],
          "sgstAmount": item['sgstAmount'],
        });
      }
    }
  }

  @override
  void dispose() {
    _discountPriceController.removeListener(_calculateFinalPrice);
    _discountPercentageController.removeListener(_calculateFinalPrice);
    _otherChargesController.removeListener(_calculateFinalPrice);

    _discountPriceController.dispose();
    _discountPercentageController.dispose();
    _otherChargesController.dispose();
    super.dispose();
  }

  void _calculateFinalPrice() {
    double price =
        (invoiceModel.labours.fold(
              0.0,
              (sum, map) => sum + double.parse(map['total_Price']),
            ) +
            invoiceModel.parts.fold(
              0.0,
              (sum, map) => sum + double.parse(map['total_Price']),
            ));
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
            invoiceModel.clearData();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text("Sale Invoice", overflow: TextOverflow.ellipsis),
        backgroundColor: AppColor.colPrimary,
      ),
      backgroundColor: AppColor.colWhite,
      body: Container(
        color: AppColor.colPrimary.withOpacity(.1),
        height: Sizes.height,
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
                  textformfiles(
                    serailInvoiceController,
                    labelText: 'Serial Invoice Number*',
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Sale Invoice Date",
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
                                  saleInvoiceDate.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                  saleInvoiceDateString = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  saleInvoiceDate.text,
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Sale Invoice Time",
                          InkWell(
                            onTap: () {
                              _saleInvoiceTime(context);
                            },
                            child: Center(
                              child: Text(
                                saleInvoiceTime.format(context),
                                style: rubikTextStyle(
                                  16,
                                  FontWeight.w500,
                                  AppColor.colBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  textformfiles(
                    textCapitalization: TextCapitalization.characters,
                    vechileController,
                    labelText: 'Vehicle Number',
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Model Name*",
                          searchDropDown(
                            context,
                            modalName.isEmpty
                                ? "Select Model Name*"
                                : modalName,
                            modelNameList
                                .map(
                                  (item) => DropdownMenuItem(
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
                                        AppColor.colBlack,
                                      ),
                                    ),
                                  ),
                                )
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
                                    .where(
                                      (item) => item['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()),
                                    )
                                    .toList();
                              });
                            },
                            'Search for a model...',
                            (isOpen) {
                              if (!isOpen) {
                                searchController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      addDefaultButton(context, () async {
                        var result = await pushTo(const VehicleMaster());
                        if (result != null) {
                          fatchVehicle().then((value) => setState(() {}));
                        }
                      }),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      dropdownTextfield(
                        context,
                        "Staff Name*",
                        DropdownButton<int>(
                          underline: Container(),
                          value: staffId,
                          items:
                              staffList.map((data) {
                                return DropdownMenuItem<int>(
                                  value: data['id'],
                                  child: Text(
                                    data['name'],
                                    style: rubikTextStyle(
                                      16,
                                      FontWeight.w500,
                                      AppColor.colBlack,
                                    ),
                                  ),
                                );
                              }).toList(),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          isExpanded: true,
                          onChanged: (selectedId) {
                            setState(() {
                              staffId = selectedId!;
                              // Call function to make API request
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      dropdownTextfield(
                        context,
                        "Place of supply*",
                        searchDropDown(
                          context,
                          stateName.isEmpty ? "Select State*" : stateName,
                          statesList
                              .map(
                                (item) => DropdownMenuItem(
                                  onTap: () {
                                    stateId = item['id'];
                                    stateName = item['name'];
                                  },
                                  value: item,
                                  child: Text(
                                    item['name'].toString(),
                                    style: rubikTextStyle(
                                      14,
                                      FontWeight.w500,
                                      AppColor.colBlack,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          stateValue,
                          (value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          searchController,
                          (value) {
                            setState(() {
                              statesList
                                  .where(
                                    (item) => item['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                                  )
                                  .toList();
                            });
                          },
                          'Search for a State...',
                          (isOpen) {
                            if (!isOpen) {
                              searchController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  textformfiles(partyNameController, labelText: 'Party Name'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          kmController,
                          labelText: 'K.M.',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(cityController, labelText: 'City'),
                      ),
                    ],
                  ),
                  textformfiles(addressController, labelText: 'Address'),
                ],
              ),
              SizedBox(height: Sizes.height * 0.03),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: Sizes.width * 0.02,
                runSpacing: Sizes.height * 0.02,
                children: [
                  SizedBox(
                    width:
                        Sizes.width <= 900
                            ? double.infinity
                            : Sizes.width * .46,
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.width * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.colWhite,
                        border: Border.all(color: AppColor.colBlack, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Credit"),
                          InkWell(
                            onTap: () {
                              setState(() {
                                accountType = !accountType;
                                fatchledger().then(
                                  (value) => setState(() {
                                    ledgerDetails = null;
                                  }),
                                );
                              });
                            },
                            child: Stack(
                              alignment:
                                  accountType
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              children: [
                                Container(
                                  width: 60,
                                  height: 23,
                                  decoration: BoxDecoration(
                                    color:
                                        accountType
                                            ? AppColor.colGrey
                                            : AppColor.colPriLite,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.colGrey,
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    color:
                                        accountType
                                            ? AppColor.colWhite
                                            : AppColor.colPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text("Cash"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width:
                        Sizes.width <= 900
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
                              ledgerName.isNotEmpty
                                  ? ledgerName
                                  : "Select Ledger Account*",
                              ledgerList
                                  .map(
                                    (item) => DropdownMenuItem(
                                      onTap: () {
                                        ledgerId = item['id'];
                                        ledgerName = item['name'];
                                        partyNameController.text = ledgerName;
                                      },
                                      value: item,
                                      child: Text(
                                        item['name'].toString(),
                                        style: rubikTextStyle(
                                          14,
                                          FontWeight.w500,
                                          AppColor.colBlack,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              ledgerDetails,
                              (value) {
                                setState(() {
                                  ledgerDetails = value;
                                });
                              },
                              searchController,
                              (value) {
                                setState(() {
                                  ledgerList
                                      .where(
                                        (item) => item['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()),
                                      )
                                      .toList();
                                });
                              },
                              'Search for a ledger...',
                              (isOpen) {
                                if (!isOpen) {
                                  searchController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        addDefaultButton(context, () async {
                          var result = await pushTo(LedgerMaster(groupId: 10));
                          if (result != null) {
                            fatchledger().then((value) => setState(() {}));
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Sizes.height * 0.03),
              Wrap(
                runSpacing: Sizes.height * 0.02,
                spacing: Sizes.width * 0.02,
                children: [
                  Container(
                    width:
                        Sizes.width <= 900
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final result = await pushTo(
                                AddPartInvoice(
                                  status: 1,
                                  invoiceNumber: int.parse(
                                    serailInvoiceController.text,
                                  ),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _calculateFinalPrice();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.colPrimary,
                            ),
                            child: const Text('Add +'),
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: 200,
                          child:
                              invoiceModel.parts.isEmpty
                                  ? const Center(
                                    child: Text("No Spare Parts Added"),
                                  )
                                  : SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(invoiceModel.parts.length, (
                                        index,
                                      ) {
                                        return ListTile(
                                          horizontalTitleGap: 0,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                          dense: true,
                                          title: Text(
                                            invoiceModel
                                                .parts[index]['item_Name'],
                                            style: rubikTextStyle(
                                              15,
                                              FontWeight.w500,
                                              AppColor.colBlack,
                                            ),
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "₹${invoiceModel.parts[index]['sale_Price']} * ${invoiceModel.parts[index]['qty']} ",
                                                style: rubikTextStyle(
                                                  14,
                                                  FontWeight.w400,
                                                  AppColor.colBlack,
                                                ),
                                              ),
                                              Text(
                                                " ( ${invoiceModel.parts[index]['gst']}% gst )",
                                                style: rubikTextStyle(
                                                  14,
                                                  FontWeight.w400,
                                                  AppColor.colGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                double.parse(
                                                  invoiceModel
                                                      .parts[index]['total_Price'],
                                                ).toStringAsFixed(2),
                                              ),
                                              PopupMenuButton(
                                                position:
                                                    PopupMenuPosition.under,
                                                itemBuilder:
                                                    (
                                                      BuildContext context,
                                                    ) => <PopupMenuEntry>[
                                                      PopupMenuItem(
                                                        value: 'Delete',
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (
                                                              BuildContext
                                                              context,
                                                            ) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                  'Delete part',
                                                                ),
                                                                content: const Text(
                                                                  'Are you sure you want to delete part ?',
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
                                                                      setState(() {
                                                                        invoiceModel
                                                                            .parts
                                                                            .removeAt(
                                                                              index,
                                                                            );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      'Delete',
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
                                                          'Delete',
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
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                              top: 7,
                                              bottom: 7,
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  AppColor.colPrimary,
                                              child: Text(
                                                "${index + 1}",
                                                style: rubikTextStyle(
                                                  14,
                                                  FontWeight.w500,
                                                  AppColor.colWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                        ),
                        Divider(thickness: 0, color: AppColor.colGrey),
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
                            "₹ ${invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
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
                            : Sizes.width * .46,
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
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final result = await pushTo(
                                AddLabourInvoice(
                                  invoiceNumber: int.parse(
                                    serailInvoiceController.text,
                                  ),
                                  status: 1,
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _calculateFinalPrice();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.colPrimary,
                            ),
                            child: const Text('Add +'),
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: 200,
                          child:
                              invoiceModel.labours.isEmpty
                                  ? const Center(child: Text("No Labour Added"))
                                  : SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(invoiceModel.labours.length, (
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
                                                invoiceModel
                                                    .labours[index]['item_Name'],
                                                style: rubikTextStyle(
                                                  15,
                                                  FontWeight.w500,
                                                  AppColor.colBlack,
                                                ),
                                              ),
                                              subtitle: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "₹${invoiceModel.labours[index]['sale_Price']} * ${invoiceModel.labours[index]['qty']} ",
                                                    style: rubikTextStyle(
                                                      14,
                                                      FontWeight.w400,
                                                      AppColor.colBlack,
                                                    ),
                                                  ),
                                                  Text(
                                                    " ( ${invoiceModel.labours[index]['gst']}% gst )",
                                                    style: rubikTextStyle(
                                                      14,
                                                      FontWeight.w400,
                                                      AppColor.colGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${invoiceModel.labours[index]['total_Price']}",
                                                  ),
                                                  PopupMenuButton(
                                                    position:
                                                        PopupMenuPosition.under,
                                                    itemBuilder:
                                                        (
                                                          BuildContext context,
                                                        ) => <PopupMenuEntry>[
                                                          PopupMenuItem(
                                                            value: 'Delete',
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
                                                                      'Delete part',
                                                                    ),
                                                                    content:
                                                                        const Text(
                                                                          'Are you sure you want to delete part ?',
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
                                                                          setState(() {
                                                                            invoiceModel.labours.removeAt(
                                                                              index,
                                                                            );
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                          'Delete',
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
                                                              'Delete',
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
                                                padding: const EdgeInsets.only(
                                                  right: 16,
                                                  top: 7,
                                                  bottom: 7,
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      AppColor.colPrimary,
                                                  child: Text(
                                                    "${index + 1}",
                                                    style: rubikTextStyle(
                                                      14,
                                                      FontWeight.w500,
                                                      AppColor.colWhite,
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
                        Divider(thickness: 0, color: AppColor.colGrey),
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
                            "₹ ${invoiceModel.labours.fold(0.0, (sum, map) => sum + double.parse(map['total_Price'])).toStringAsFixed(2)}",
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
              SizedBox(height: Sizes.height * 0.02),
              addMasterOutside(
                context: context,
                children: [
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
                        "₹ ${(invoiceModel.labours.fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount'])) + invoiceModel.parts.fold(0.0, (sum, map) => sum + double.parse(map['gst_Amount']))).toStringAsFixed(2)}",
                  ),
                  ReuseContainer(
                    title: "Cess",
                    subtitle:
                        "₹ ${(invoiceModel.labours.fold(0.0, (sum, map) => sum + map['cess_Amount']) + invoiceModel.parts.fold(0.0, (sum, map) => sum + map['cess_Amount'])).toStringAsFixed(2)}",
                  ),
                  ReuseContainer(
                    title: "Net Amount",
                    subtitle: "₹  ${_finalPrice.toStringAsFixed(2)}",
                  ),
                ],
              ),
              SizedBox(height: Sizes.height * 0.02),
              button(
                "Save",
                AppColor.colPrimary,
                onTap: () {
                  if (serailInvoiceController.text.isEmpty) {
                    showCustomSnackbar(context, "Please enter serial Inv.");
                  } else if (modelNameId == null || ledgerId == null) {
                    showCustomSnackbar(
                      context,
                      "Please select modal and ledger",
                    );
                  } else if (staffId == null || stateName.isEmpty) {
                    showCustomSnackbar(
                      context,
                      "Please select Staff and State",
                    );
                  } else if (invoiceModel.labours.isEmpty &&
                      invoiceModel.parts.isEmpty) {
                    showCustomSnackbar(
                      context,
                      "Please add atleast one part or labour",
                    );
                  } else if (ledgerId == null || ledgerId == 0) {
                    showCustomSnackbar(context, "Please select ledger account");
                  } else {
                    postSaleInvoice();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Get Invoice Number
  Future fatchInvoiceNumber() async {
    var response = await ApiService.fetchData(
      "Transactions/GetInvoiceNoAW?Tblname=Sale_Invoice&Fldname=Invoice_No&transdatefld=Invoice_Date&varprefixtblname=Prefix_Name&prefixfldnText=%27online%27&varlocationid=${Preference.getString(PrefKeys.locationId)}",
    );
    serailInvoiceController.text =
        widget.invoiceNumber != 0 ? "${widget.invoiceNumber}" : "$response";
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
      "MasterAW/GetLedgerByGroupId?LedgerGroupId=${accountType ? "10,23,24,25,29,9" : "7,8,11"}",
    );

    ledgerList = List<Map<String, dynamic>>.from(
      response.map(
        (item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
          'mob': item['mob'],
          'address': item['address'],
          'gst_No': item['gst_No'],
        },
      ),
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

  //Get staff List
  Future fatchstaff() async {
    List response = await ApiService.fetchData(
      "MasterAW/GetStaffDetailsLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}",
    );

    staffList = List<Map<String, dynamic>>.from(
      response.map((item) => {'id': item['id'], 'name': item['staff_Name']}),
    );
  }

  //Post sale Invoice
  Future postSaleInvoice() async {
    var grossAmount =
        invoiceModel.labours.fold(
          0.0,
          (sum, map) => sum + double.parse(map['sale_Price']),
        ) +
        invoiceModel.parts.fold(
          0.0,
          (sum, map) =>
              sum +
              (double.parse(map['sale_Price']) * double.parse(map['qty'])),
        );
    String gstAmount = (invoiceModel.labours.fold(
              0.0,
              (sum, map) => sum + double.parse(map['gst_Amount']),
            ) +
            invoiceModel.parts.fold(
              0.0,
              (sum, map) => sum + double.parse(map['gst_Amount']),
            ))
        .toStringAsFixed(2);
    String cessAmount = (invoiceModel.labours.fold(
              0.0,
              (sum, map) => sum + map['cess_Amount'],
            ) +
            invoiceModel.parts.fold(
              0.0,
              (sum, map) => sum + map['cess_Amount'],
            ))
        .toStringAsFixed(2);
    var response = await ApiService.postData(
      widget.invoiceNumber == 0
          ? 'Transactions/PostSaleInvoiceAW'
          : 'Transactions/UpdateSaleInvoiceAW?prefix=online&refno=${serailInvoiceController.text}&locationid=${Preference.getString(PrefKeys.locationId)}',
      {
        "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
        "prefix_Name": "online",
        "invoice_No": int.parse(serailInvoiceController.text),
        "invoice_Date": saleInvoiceDateString,
        "ledger_Id": ledgerId,
        "ledger_Name": ledgerName,
        "vehicle_No": vechileController.text.toString(),
        "model_Name": modalName,
        "party_Name": partyNameController.text.toString(),
        "address": addressController.text.toString(),
        "mob": ledgerDetails!['mob'] ?? "",
        "city_Name": cityController.text.toString(),
        "gross_Amount": grossAmount.toString(),
        "taxable_Amount": grossAmount.toString(),
        "gst": gstAmount,
        "discount": totalDiscount.toStringAsFixed(2),
        "net_Amount": _finalPrice.toStringAsFixed(2),
        "cash_Sale": accountType ? _finalPrice.toStringAsFixed(2) : "0",
        "credit_Sale": accountType ? "0" : _finalPrice.toStringAsFixed(2),
        "card_Sale": "0",
        "payment_Type": accountType ? "1" : "2",
        "other_Charge":
            _otherChargesController.text.isEmpty
                ? "0"
                : _otherChargesController.text.toString(),
        "sale_Type": "1",
        "jobCard_No": 0,
        "remarks": "Remarks",
        "a": "$staffId",
        "b": kmController.text.toString(),
        "c": "0",
        "d": "0",
        "e": "0",
        "f": "0",
        "Misc_Charge_Id": 1,
        "Misc_Charge": "0",
        "Misc_Per": 0,
        "igst_Text": double.parse(gstAmount),
        "cgst_Tax": double.parse(gstAmount) / 2,
        "sgst_Tax": double.parse(gstAmount) / 2,
        "cess_Tax": double.parse(cessAmount),
        "extra1": stateName,
        "extra2": "",
        "extra3": "",
        "extra4": "",
        "prefix_Name_Job": "online",
        "receiptNo": 0,
        "advanceAmt": 0,
        "mode_Id": 0,
        "balanceAmt": 0,
        "einvoiceStatus": "0",
        "sale_Invoice_Items": [...invoiceModel.labours, ...invoiceModel.parts],
      },
    );
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      postMaterialIssue(4);
      fatchGstDetails().then((value) => setState(() {}));
      invoiceModel.clearData();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  Map<String, dynamic> invoiceDetails = {};
  Map<String, dynamic> companyDetails = {};

  //Invoice Datails Get
  Future fatchGstDetails() async {
    invoiceDetails = await ApiService.fetchData(
      'Transactions/GetSaleInvoiceAW?prefix=online&refno=${serailInvoiceController.text}&locationid=${Preference.getString(PrefKeys.locationId)}',
    );
    generateInvoicePDF(0, invoiceDetails, companyDetails, ledgerDetails!);
  }

  //Fatch Company Details
  Future getAccountDetails() async {
    companyDetails = await ApiService.fetchData(
      "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}",
    );
  }

  //Get Invoice Details
  Future getInvoiceDetails() async {
    saleInvoiceDetails = await ApiService.fetchData(
      "Transactions/GetSaleInvoiceAW?prefix=online&refno=${widget.invoiceNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
    );
    cityController.text = saleInvoiceDetails['city_Name'] ?? "";
    vechileController.text = saleInvoiceDetails['vehicle_No'] ?? "";
    partyNameController.text = saleInvoiceDetails['party_Name'] ?? "";
    kmController.text = saleInvoiceDetails['b'] ?? "";
    addressController.text = saleInvoiceDetails['address'] ?? "";
    modalName = saleInvoiceDetails['model_Name'] ?? "";
    stateName = saleInvoiceDetails['extra1'] ?? "";
    ledgerId = saleInvoiceDetails['ledger_Id'];
    ledgerName =
        ledgerId == 0
            ? ''
            : ledgerList.firstWhere(
              (element) => element['id'] == ledgerId,
            )['name'];
    accountType = saleInvoiceDetails['payment_Type'] == "1" ? true : false;
    // staffId = int.parse(saleInvoiceDetails['a']);

    // Clear previous lists
    invoiceModel.labours.clear();
    invoiceModel.parts.clear();

    // Iterate through jobCard_Items and classify based on 'type'
    List items = (saleInvoiceDetails['sale_Invoice_Items'] as List);
    for (var item in items) {
      if (item['type'] == "1") {
        Provider.of<InvoiceModel>(context, listen: false).addPart(item);
      } else if (item['type'] == "2") {
        Provider.of<InvoiceModel>(context, listen: false).addLabour(item);
      }
    }
  }

  // Fatch Jobcard
  Future fatchJobcardDetails() async {
    if (widget.jobcardNumber != 0) {
      var responseJobcard = await ApiService.fetchData(
        "Transactions/GetJobCardAW?prefix=online&refno=${widget.jobcardNumber}&locationid=${Preference.getString(PrefKeys.locationId)}",
      );

      vechileController.text = responseJobcard['vehicle_No'];
      staffId = responseJobcard['mechanic_Id'];
      ledgerId = responseJobcard['ledger_Id'];
      ledgerName =
          ledgerList.isEmpty
              ? ""
              : ledgerList.firstWhere(
                (element) => element['id'] == ledgerId,
              )['name'];
      modelNameId = responseJobcard['model_Id'];
      modalName =
          modelNameList.isEmpty
              ? ""
              : modelNameList.firstWhere(
                (element) => element['id'] == modelNameId,
              )['name'];
      partyNameController.text = ledgerName;
      _calculateFinalPrice();
    } else {
      print(widget.jobcardNumber);
    }
  }

  //Post material Issue
  Future postMaterialIssue(int? id) async {
    var response = await ApiService.postData(
      "Transactions/PostJobCloseAW?refno=${widget.jobcardNumber}&locationid=${Preference.getString(PrefKeys.locationId)}&checklist=000000000000&jobclosestatus=$id",
      {},
    );

    if (response['sr_No'] == 0) {
      id == 4 ? null : Navigator.pop(context, "for run api in slider screen");
    }
  }
}
