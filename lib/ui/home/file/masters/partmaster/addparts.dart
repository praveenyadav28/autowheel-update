// ignore_for_file: use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:intl/intl.dart';

class AddParts extends StatefulWidget {
  const AddParts(
      {required this.switchToSecondTab,
      super.key,
      required this.isFirst,
      this.id});
  final bool isFirst;
  final int? id;
  final VoidCallback switchToSecondTab;

  @override
  State<AddParts> createState() => _AddPartsState();
}

class _AddPartsState extends State<AddParts> {
  //Controller
  TextEditingController partnumberController = TextEditingController();
  TextEditingController partnamecontroller = TextEditingController();
  TextEditingController bincontroller = TextEditingController();
  final TextEditingController _ndpController = TextEditingController();
  final TextEditingController _profitMarginController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  TextEditingController moqController = TextEditingController();
  TextEditingController rolController = TextEditingController();
  TextEditingController minstockController = TextEditingController();
  TextEditingController maxstockController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  //Opening Stock
  TextEditingController quentityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

//Key
  final _formaKey = GlobalKey<FormState>();

  //Date
  TextEditingController wefDatePicker = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  //groupList
  List<Map<String, dynamic>> groupList = [];
  int? selectedgroupListId;

  //Ledger
  List<Map<String, dynamic>> ledgerList = [];
  int? ledgerId;
  Map<String, dynamic>? ledgerValue;
  String ledgerName = '';

  //unit
  List<Map<String, dynamic>> unitList = [];
  int? unitId;

//HSN Type
  List<Map<String, dynamic>> hsnCodeList = [];
  int? hsnCodeId;
  Map<String, dynamic>? hsnCodeValue;
  String hsnCodeName = '';

//Gst
  String gstPersentage = '0';

//value
  String valueOpening = '0';

  @override
  void initState() {
    fatchledger().then((value) => setState(() {}));

    gstHsnData().then((value) => setState(() {
          fetchUnit().then((value) => setState(() {
                unitId = unitList.first['id'];
                widget.id == null
                    ? null
                    : getpartDetails().then((value) => setState(() {}));
              }));
        }));
    groupListData().then((value) => setState(() {}));
    super.initState();
  }

  bool _isMrpFieldChanged = false;
  bool _applyDiscountToNdp = true;

  double saleprice = 0;

  void _updateValues() {
    double ndp = double.tryParse(_ndpController.text) ?? 0.0;
    double profitMarginPercentage =
        double.tryParse(_profitMarginController.text) ?? 0.0;
    double discountPercentage =
        double.tryParse(_discountController.text) ?? 0.0;

    if (_isMrpFieldChanged) {
      double mrp = double.tryParse(_mrpController.text) ?? 0.0;

      // Calculate Discount Amount
      double discountAmount = _applyDiscountToNdp
          ? ndp * (discountPercentage / 100)
          : mrp * (discountPercentage / 100);

      // Adjust MRP for discount
      mrp += _applyDiscountToNdp ? discountAmount : 0;

      double priceNongst = mrp / (1 + int.parse(gstPersentage) / 100);
      // Calculate Profit Margin
      double profitMargin = priceNongst - ndp;

      // Calculate Profit Margin Percentage
      profitMarginPercentage = (profitMargin / ndp) * 100;

      // Update the Profit Margin field
      _profitMarginController.text = profitMarginPercentage.toStringAsFixed(2);
    } else {
      // Calculate Profit Margin
      double profitMargin = ndp * (profitMarginPercentage / 100);

      // Calculate initial MRP (before GST)
      double initialMrp = ndp + profitMargin;

      // Calculate Discount Amount
      double discountAmount = _applyDiscountToNdp
          ? ndp * (discountPercentage / 100)
          : initialMrp * (discountPercentage / 100);

      // Calculate final MRP after applying discount
      saleprice = _applyDiscountToNdp
          ? (initialMrp - discountAmount)
          : (initialMrp - (initialMrp * (discountPercentage / 100)));

      // Add GST to final MRP
      double mrpWithGst =
          saleprice + (saleprice * (int.parse(gstPersentage) / 100));

      // Update the MRP field
      _mrpController.text = mrpWithGst.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _ndpController.dispose();
    _profitMarginController.dispose();
    _discountController.dispose();
    _mrpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colPrimary.withOpacity(.1),
      body: Form(
        key: _formaKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
          child: Column(
            children: [
              addMasterOutside(
                context: context,
                children: [
                  textformfiles(partnamecontroller, labelText: "Part Name*"),
                  textformfiles(partnumberController,
                      labelText: "Part Number*",
                      textCapitalization: TextCapitalization.characters),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: dropdownTextfield(
                        context,
                        "Item Group*",
                        DropdownButton<int>(
                          underline: Container(),
                          value: selectedgroupListId,
                          items: groupList.map((data) {
                            return DropdownMenuItem<int>(
                              value: data['id'],
                              child: Text(
                                data['name'],
                                style: rubikTextStyle(
                                    16, FontWeight.w500, AppColor.colBlack),
                              ),
                            );
                          }).toList(),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          isExpanded: true,
                          onChanged: (selectedId) {
                            setState(() {
                              selectedgroupListId = selectedId!;
                            });
                          },
                        ),
                      )),
                      const SizedBox(width: 10),
                      addDefaultButton(
                        context,
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGroupScreen(
                                        sourecID: 101,
                                        name: 'Item Group',
                                      ))).then((value) =>
                              groupListData().then((value) => setState(() {})));
                        },
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "Manufacturer*",
                            searchDropDown(
                                context,
                                widget.id != null
                                    ? ledgerName
                                    : "Select Manufacturer*",
                                ledgerList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            ledgerId = item['id'];
                                            ledgerName = item['name'];
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
                                        .where((item) => item['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
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
                          var result = await pushTo(LedgerMaster(groupId: 10));
                          if (result != null) {
                            ledgerValue = null;
                            fatchledger().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: dropdownTextfield(
                            context,
                            "HSN Code*",
                            searchDropDown(
                                context,
                                widget.id != null
                                    ? hsnCodeName
                                    : "Select HSN Code*",
                                hsnCodeList
                                    .map((item) => DropdownMenuItem(
                                          onTap: () {
                                            setState(() {
                                              hsnCodeId = item['hsn_Id'];
                                              gstPersentage =
                                                  item['igst'].toString();
                                              hsnCodeName = item['hsn_Code'];
                                              _updateValues();
                                            });
                                          },
                                          value: item,
                                          child: Text(
                                            item['hsn_Code'].toString(),
                                            style: rubikTextStyle(
                                                16,
                                                FontWeight.w500,
                                                AppColor.colBlack),
                                          ),
                                        ))
                                    .toList(),
                                hsnCodeValue,
                                (value) {
                                  setState(() {
                                    hsnCodeValue = value;
                                  });
                                },
                                searchController,
                                (value) {
                                  setState(() {
                                    hsnCodeList
                                        .where((item) => item['hsn_Code']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                'Search for a Hsn Code...',
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
                          var result = await pushTo(const HsnCode());
                          if (result != null) {
                            hsnCodeValue = null;
                            gstHsnData().then((value) => setState(() {}));
                          }
                        },
                      )
                    ],
                  ),
                  ReuseContainer(title: "GST", subtitle: "$gstPersentage %"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(bincontroller,
                            labelText: "Bin Number"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdownTextfield(
                          context,
                          "Unit",
                          DropdownButton<int>(
                            underline: Container(),
                            value: unitId,
                            items: unitList.map((data) {
                              return DropdownMenuItem<int>(
                                value: data['id'],
                                child: Text(
                                  data['name'],
                                  style: rubikTextStyle(
                                      16, FontWeight.w500, AppColor.colBlack),
                                ),
                              );
                            }).toList(),
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            isExpanded: true,
                            onChanged: (selectedId) {
                              setState(() {
                                unitId = selectedId!;
                                // Call function to make API request
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          _ndpController,
                          labelText: "NDP",
                          onChanged: (value) {
                            _isMrpFieldChanged = false;
                            _updateValues();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          _discountController,
                          labelText: _applyDiscountToNdp
                              ? "Discount % on NDP"
                              : "Discount % on MRP",
                          onChanged: (value) {
                            _isMrpFieldChanged = false;
                            _updateValues();
                          },
                          suffixIcon: Switch(
                            value: _applyDiscountToNdp,
                            onChanged: (value) {
                              setState(() {
                                _applyDiscountToNdp = value;
                                _updateValues();
                              });
                            },
                            activeTrackColor: AppColor.colPriLite,
                            activeColor: AppColor.colPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          _profitMarginController,
                          labelText: "Profit Margin %",
                          onChanged: (value) {
                            _isMrpFieldChanged = false;
                            _updateValues();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          _mrpController,
                          labelText: "MRP",
                          onChanged: (value) {
                            _isMrpFieldChanged = true;
                            _updateValues();
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropdownTextfield(
                        context,
                        "Wef. Date",
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2400),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                wefDatePicker.text = DateFormat('yyyy/MM/dd')
                                    .format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                wefDatePicker.text,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          moqController,
                          labelText: "MOQ",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          rolController,
                          labelText: "ROL",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          minstockController,
                          labelText: "Min Stock",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textformfiles(
                          keyboardType: TextInputType.number,
                          maxstockController,
                          labelText: "Max Stock",
                        ),
                      ),
                    ],
                  ),
                  // textformfiles(
                  //   serialController,
                  //   labelText: 'Serial Number',
                  //   readOnly: !_applyDiscountToNdp,
                  //   prefixIcon: const Icon(Icons.gesture),
                  // ),
                ],
              ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(vertical: Sizes.height * 0.02),
              //     child: SizedBox(
              //       height: (Responsive.isMobile(context)) ? 45 : 40,
              //       width: 200,
              //       child: ElevatedButton(
              //           onPressed: () {},
              //           child: const Text(
              //             "Multi Store",
              //           )),
              //     ),
              //   ),
              // ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Opening Stock",
                  style: rubikTextStyle(18, FontWeight.w500, AppColor.colBlack),
                ),
              ),

              addMasterOutside(context: context, children: [
                textformfiles(quentityController,
                    labelText: "Quantity",
                    keyboardType: TextInputType.number, onChanged: (value) {
                  setState(() {
                    valueOpening =
                        "${double.parse(value) * double.parse(priceController.text.toString())}";
                  });
                }),
                textformfiles(priceController, labelText: "Price per item",
                    onChanged: (value) {
                  setState(() {
                    valueOpening =
                        "${double.parse(value) * double.parse(quentityController.text.toString())}";
                  });
                }),
                ReuseContainer(title: "Value", subtitle: "₹ $valueOpening")
              ]),
              // Padding(
              //   padding: EdgeInsets.only(bottom: Sizes.height * .02),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Closing Stock",
              //       style: rubikTextStyle(
              //           18, FontWeight.w500, AppColor.colBlack),
              //     ),
              //   ),
              // ),
              // addMasterOutside(context: context, children: [
              //   textformfiles(valueController,
              //       labelText: "Quantity", readOnly: true),
              // ]),

              SizedBox(height: Sizes.height * 0.02),
              Column(
                children: [
                  button(widget.id == null ? "Save" : "Update",
                      AppColor.colPrimary, onTap: () {
                    if (partnamecontroller.text.isEmpty ||
                        partnumberController.text.isEmpty) {
                      showCustomSnackbar(
                          context, "Please enter Part Name and Number");
                    } else if (hsnCodeId == null ||
                        ledgerId == null ||
                        selectedgroupListId == null) {
                      showCustomSnackbar(context,
                          "Please select HSN Code, Manufacturer and Item Group");
                    } else {
                      postItem();
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//Post Item
  Future postItem() async {
    var response = await ApiService.postData(
        widget.id != null
            ? "MasterAW/UpdateItemMaster?ItemId=${widget.id}"
            : 'MasterAW/PostItemMaster',
        {
          "Item_Name": partnamecontroller.text.toString(),
          "Item_Des": partnumberController.text.toString(),
          "Group_Id": selectedgroupListId,
          "CategoryId": 1,
          "Manufacturer_Id": ledgerId,
          "Supplier_Id": 1,
          "Unit_Id": unitId,
          "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
          "Mrp": double.parse(_mrpController.text.isEmpty
              ? "0"
              : _mrpController.text.toString()),
          "Ndp": double.parse(_ndpController.text.isEmpty
              ? "0"
              : _ndpController.text.toString()),
          "Discount": double.parse(_discountController.text.isEmpty
              ? "0"
              : _discountController.text.toString()),
          "Gst": double.parse(gstPersentage),
          "Order_Qty": 1,
          "Margin": double.parse(_profitMarginController.text.isEmpty
              ? "0"
              : _profitMarginController.text.toString()),
          "Opening_Stock": double.parse(quentityController.text.isEmpty
              ? "0"
              : quentityController.text.toString()),
          "Stock_Qty": double.parse(priceController.text.isEmpty
              ? "0"
              : priceController.text.toString()),
          "Bin_No": bincontroller.text.toString(),
          "Sale_Price": saleprice,
          "Hsn_Id": hsnCodeId,
          "Hsn_Code": "0",
          "Igst": gstPersentage,
          "Cgst": "${double.parse(gstPersentage) / 2}",
          "Sgst": "${double.parse(gstPersentage) / 2}",
          "Cess": "1",
          "AlternPartNo": "",
          "Min_Stock": double.parse(minstockController.text.isEmpty
              ? "0"
              : minstockController.text.toString()),
          "Max_Stock": double.parse(maxstockController.text.isEmpty
              ? "0"
              : maxstockController.text.toString()),
          "Moq": double.parse(
              moqController.text.isEmpty ? "0" : moqController.text.toString()),
          "Roi": double.parse(
              rolController.text.isEmpty ? "0" : rolController.text.toString()),
          "PartStatus": 1,
          "Status": 1,
          "Remarks": "remarks",
          "CreatedBy": 12,
          "CreatedDate": wefDatePicker.text.toString(),
          "UpdateBy": 2,
          "UpdatedDate": "09/12/2023"
        });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      widget.id != null ? Navigator.pop(context) : widget.switchToSecondTab();
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  //Get ledger List
  Future fatchledger() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLedgerByGroupId?LedgerGroupId=9");

    ledgerList = List<Map<String, dynamic>>.from(response.map((item) => {
          'id': item['ledger_Id'],
          'name': item['ledger_Name'],
        }));
    if (ledgerList.isNotEmpty) {
      ledgerId = ledgerList.first["id"];
    }
  }

//Unit
  Future<void> fetchUnit() async {
    await fetchDataByMiscTypeId(30, unitList);
  }

//Get Hsn List
  Future<void> gstHsnData() async {
    var response = await ApiService.fetchData("MasterAW/GetHSNMaster");
    if (response is List) {
      hsnCodeList =
          response.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Unexpected data format for districts');
    }
  }

//Part Group
  Future<void> groupListData() async {
    await fetchDataByMiscAdd(101, groupList);
    if (groupList.isNotEmpty) {
      selectedgroupListId = groupList.first["id"];
    }
  }

  //get part details
  Future getpartDetails() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetItemByItemId?ItemId=${widget.id}");
    priceController.text = response[0]["stock_Qty"].toString();
    quentityController.text = response[0]["opening_Stock"].toString();
    maxstockController.text = response[0]["max_Stock"].toString();
    minstockController.text = response[0]["min_Stock"].toString();
    rolController.text = response[0]["roi"].toString();
    moqController.text = response[0]["moq"].toString();
    _mrpController.text = response[0]["mrp"].toString();
    _discountController.text = response[0]["discount"].toString();
    _profitMarginController.text = response[0]["margin"].toString();
    _ndpController.text = response[0]["ndp"].toString();
    bincontroller.text = response[0]["bin_No"].toString();
    partnamecontroller.text = response[0]["item_Name"].toString();
    partnumberController.text = response[0]["item_Des"].toString();
    selectedgroupListId = response[0]['group_Id'];
    gstPersentage = response[0]['igst'];
    hsnCodeId = response[0]['hsn_Id'];
    hsnCodeName = hsnCodeList
        .firstWhere((element) => element['hsn_Id'] == hsnCodeId)['hsn_Code'];
    ledgerId = response[0]['manufacturer_Id'];
    ledgerName =
        ledgerList.firstWhere((element) => element['id'] == ledgerId)['name'];
    unitId = response[0]['unit_Id'];
  }
}
