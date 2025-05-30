// ignore_for_file: use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class HsnCode extends StatefulWidget {
  const HsnCode({super.key});

  @override
  State<HsnCode> createState() => _HsnCodeState();
}

class _HsnCodeState extends State<HsnCode> {
  TextEditingController hsnCodeController = TextEditingController();
  TextEditingController igstController = TextEditingController();
  TextEditingController sgstcontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  //HSN List
  List hsnList = [];

  List filteredList = [];

  @override
  void initState() {
    fatchHSN().then((value) => setState(() {
          filteredList = hsnList;
        }));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = hsnList.where((value) {
        return value['hsn_Code']
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
                Navigator.pop(context, "Update Data");
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("HSN Code", overflow: TextOverflow.ellipsis),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        height: Sizes.height,
        color: AppColor.colPrimary.withOpacity(.1),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
          child: Column(
            children: [
              textformfiles(hsnCodeController,
                  labelText: "HSN Code*",
                  prefixIcon: Icon(Icons.code, color: AppColor.colGrey)),
              SizedBox(height: Sizes.height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: textformfiles(igstController, onChanged: (value) {
                      if (igstController.text.isNotEmpty) {
                        String poolPrice = (int.parse(igstController.text) / 2)
                            .toStringAsFixed(2);
                        sgstcontroller.text = poolPrice;
                        setState(() {});
                      } else {
                        sgstcontroller.clear();
                        setState(() {});
                      }
                      setState(() {});
                    },
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        labelText: "IGST*"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: textformfiles(readOnly: true, sgstcontroller,
                        validator: (p0) {
                      return null;
                    }, labelText: "CGST"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: textformfiles(readOnly: true, sgstcontroller,
                        validator: (p0) {
                      return null;
                    }, labelText: "SGST"),
                  ),
                ],
              ),
              SizedBox(height: Sizes.height * 0.02),
              button("Save", AppColor.colPrimary, onTap: () {
                if (hsnCodeController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter HSN Code");
                } else if (igstController.text.isEmpty) {
                  showCustomSnackbar(context, "Please enter IGST");
                } else {
                  postHSn().then((value) => setState(() {}));
                }
              }),
              SizedBox(height: Sizes.height * 0.02),
              addMasterOutside(children: [
                Container(),
                Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textformfiles(searchController,
                        onChanged: (value) => filterList(value),
                        labelText: 'Search',
                        suffixIcon: Icon(
                          Icons.search,
                          size: 30,
                          color: AppColor.colBlack,
                        )),
                  ],
                ),
              ], context: context),
              Responsive.isMobile(context)
                  ? Column(
                      children: List.generate(filteredList.length, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: Sizes.height * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.colWhite,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(blurRadius: 2, color: AppColor.colGrey)
                            ],
                          ),
                          child: ListTile(
                            minVerticalPadding: 0,
                            horizontalTitleGap: 0,
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 12),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: AppColor.colPrimary,
                                  shape: BoxShape.circle),
                              child: Text(
                                '${index + 1}',
                                style: rubikTextStyle(
                                    15, FontWeight.w500, AppColor.colWhite),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(filteredList[index]['hsn_Code']),
                                Text("${filteredList[index]['igst']}%"),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("cGST-${filteredList[index]['cgst']}%",
                                    style: const TextStyle(fontSize: 13)),
                                Text("sGST-${filteredList[index]['cgst']}%",
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              position: PopupMenuPosition.under,
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 'Edit',
                                  onTap: () {
                                    hsnCodeController.text =
                                        filteredList[index]['hsn_Code'];
                                    igstController.text =
                                        filteredList[index]['igst'].toString();
                                    sgstcontroller.text =
                                        filteredList[index]['cgst'].toString();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        Sizes.width * .02,
                                                    vertical:
                                                        Sizes.height * 0.02),
                                            title: const Text('Edit HSN'),
                                            content: SizedBox(
                                                width: Sizes.width,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    textformfiles(
                                                        hsnCodeController,
                                                        labelText: "HSN Code",
                                                        prefixIcon: Icon(
                                                            Icons.code,
                                                            color: AppColor
                                                                .colGrey)),
                                                    SizedBox(
                                                        height: Sizes.height *
                                                            0.02),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: textformfiles(
                                                              igstController,
                                                              onChanged:
                                                                  (value) {
                                                            if (igstController
                                                                .text
                                                                .isNotEmpty) {
                                                              String poolPrice =
                                                                  (int.parse(igstController
                                                                              .text) /
                                                                          2)
                                                                      .toStringAsFixed(
                                                                          2);
                                                              sgstcontroller
                                                                      .text =
                                                                  poolPrice;
                                                              setState(() {});
                                                            } else {
                                                              sgstcontroller
                                                                  .clear();
                                                              setState(() {});
                                                            }
                                                            setState(() {});
                                                          },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              maxLength: 2,
                                                              labelText:
                                                                  "IGST"),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: textformfiles(
                                                              readOnly: true,
                                                              sgstcontroller,
                                                              validator: (p0) {
                                                            return null;
                                                          }, labelText: "CGST"),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: textformfiles(
                                                              readOnly: true,
                                                              sgstcontroller,
                                                              validator: (p0) {
                                                            return null;
                                                          }, labelText: "SGST"),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: Sizes.height *
                                                            0.02),
                                                    button("Update",
                                                        AppColor.colPrimary,
                                                        onTap: () {
                                                      if (hsnCodeController
                                                          .text.isEmpty) {
                                                        showCustomSnackbar(
                                                            context,
                                                            "Please enter HSN Code");
                                                      } else if (igstController
                                                          .text.isEmpty) {
                                                        showCustomSnackbar(
                                                            context,
                                                            "Please enter IGST");
                                                      } else {
                                                        updateHSn(filteredList[
                                                                    index]
                                                                ["hsn_Id"])
                                                            .then((value) =>
                                                                setState(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                  fatchHSN().then(
                                                                      (value) =>
                                                                          setState(
                                                                              () {
                                                                            filteredList =
                                                                                filteredList;
                                                                            hsnCodeController.clear();
                                                                            sgstcontroller.clear();
                                                                            igstController.clear();
                                                                          }));
                                                                }));
                                                      }
                                                    })
                                                  ],
                                                )),
                                          );
                                        });
                                  },
                                  child: const Text('Edit'),
                                ),
                                PopupMenuItem(
                                    onTap: () {
                                      deletehsnApi(
                                              filteredList[index]['hsn_Id'])
                                          .then((value) => fatchHSN()
                                              .then((value) => setState(() {
                                                    filteredList = filteredList;
                                                  })));
                                    },
                                    value: 'Delete',
                                    child: const Text('Delete')),
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ),
                        );
                      }),
                    )
                  : Table(
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.colBlack),
                      children: [
                        TableRow(
                            decoration:
                                BoxDecoration(color: AppColor.colPrimary),
                            children: [
                              Text("HSN Code",
                                  style: TextStyle(
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColor.colBlack,
                                  ),
                                  textAlign: TextAlign.center),
                              Text("IGST",
                                  style: TextStyle(
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColor.colBlack,
                                  ),
                                  textAlign: TextAlign.center),
                              Text(
                                "CGST",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColor.colBlack,
                                ),
                              ),
                              Text("SGST",
                                  style: TextStyle(
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColor.colBlack,
                                  ),
                                  textAlign: TextAlign.center),
                              Text("Action",
                                  style: TextStyle(
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColor.colBlack,
                                  ),
                                  textAlign: TextAlign.center),
                            ]),
                        ...List.generate(filteredList.length, (index) {
                          return TableRow(
                              decoration:
                                  BoxDecoration(color: AppColor.colWhite),
                              children: [
                                tableRow(filteredList[index]["hsn_Code"]),
                                tableRow("${filteredList[index]['igst']}%"),
                                tableRow("${filteredList[index]['cgst']}%"),
                                tableRow("${filteredList[index]['sgst']}%"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          hsnCodeController.text =
                                              filteredList[index]['hsn_Code'];
                                          igstController.text =
                                              filteredList[index]['igst']
                                                  .toString();
                                          sgstcontroller.text =
                                              filteredList[index]['cgst']
                                                  .toString();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  insetPadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              Sizes.width * .02,
                                                          vertical:
                                                              Sizes.height *
                                                                  0.02),
                                                  title: const Text('Edit HSN'),
                                                  content: SizedBox(
                                                      width: Sizes.width,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          textformfiles(
                                                              hsnCodeController,
                                                              labelText:
                                                                  "HSN Code",
                                                              prefixIcon: Icon(
                                                                  Icons.code,
                                                                  color: AppColor
                                                                      .colGrey)),
                                                          SizedBox(
                                                              height:
                                                                  Sizes.height *
                                                                      0.02),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: textformfiles(
                                                                    igstController,
                                                                    onChanged:
                                                                        (value) {
                                                                  if (igstController
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    String
                                                                        poolPrice =
                                                                        (int.parse(igstController.text) /
                                                                                2)
                                                                            .toStringAsFixed(2);
                                                                    sgstcontroller
                                                                            .text =
                                                                        poolPrice;
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    sgstcontroller
                                                                        .clear();
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    maxLength:
                                                                        2,
                                                                    labelText:
                                                                        "IGST"),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child: textformfiles(
                                                                    readOnly:
                                                                        true,
                                                                    sgstcontroller,
                                                                    validator:
                                                                        (p0) {
                                                                  return null;
                                                                },
                                                                    labelText:
                                                                        "CGST"),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child: textformfiles(
                                                                    readOnly:
                                                                        true,
                                                                    sgstcontroller,
                                                                    validator:
                                                                        (p0) {
                                                                  return null;
                                                                },
                                                                    labelText:
                                                                        "SGST"),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  Sizes.height *
                                                                      0.02),
                                                          button(
                                                              "Update",
                                                              AppColor
                                                                  .colPrimary,
                                                              onTap: () {
                                                            if (hsnCodeController
                                                                .text.isEmpty) {
                                                              showCustomSnackbar(
                                                                  context,
                                                                  "Please enter HSN Code");
                                                            } else if (igstController
                                                                .text.isEmpty) {
                                                              showCustomSnackbar(
                                                                  context,
                                                                  "Please enter IGST");
                                                            } else {
                                                              updateHSn(filteredList[
                                                                          index]
                                                                      [
                                                                      "hsn_Id"])
                                                                  .then((value) =>
                                                                      setState(
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        fatchHSN().then((value) =>
                                                                            setState(() {
                                                                              filteredList = filteredList;
                                                                              hsnCodeController.clear();
                                                                              sgstcontroller.clear();
                                                                              igstController.clear();
                                                                            }));
                                                                      }));
                                                            }
                                                          })
                                                        ],
                                                      )),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit,
                                            color: AppColor.colPrimary)),
                                    IconButton(
                                        onPressed: () {
                                          deletehsnApi(
                                                  filteredList[index]['hsn_Id'])
                                              .then((value) => fatchHSN()
                                                  .then((value) => setState(() {
                                                        filteredList =
                                                            filteredList;
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

//Post HSN
  Future postHSn() async {
    var response = await ApiService.postData('MasterAW/PostHSNMaster', {
      "Hsn_Code": hsnCodeController.text.toString(),
      "Igst": int.parse(igstController.text),
      "Cgst": int.parse(igstController.text) / 2,
      "Sgst": int.parse(igstController.text) / 2,
      "Status": 1,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
      Navigator.pop(context, "Refresh Data");
      fatchHSN().then((value) => setState(() {
            filteredList = hsnList;
          }));
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

//Update HSN
  Future updateHSn(int id) async {
    var response =
        await ApiService.postData('MasterAW/UpdateHSNMasterByIdAW?Id=$id', {
      "Hsn_Code": hsnCodeController.text.toString(),
      "Igst": int.parse(igstController.text),
      "Cgst": int.parse(igstController.text) / 2,
      "Sgst": int.parse(igstController.text) / 2,
      "Status": 1,
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId))
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, '${response["message"]}');
    } else {
      showCustomSnackbar(context, '${response["message"]}');
    }
  }

  //Get hsn List
  Future fatchHSN() async {
    var response = await ApiService.fetchData("MasterAW/GetHSNMaster");
    hsnList = response;
  }

  //Delete hsn
  Future deletehsnApi(int? hsnId) async {
    var response = await ApiService.postData(
        "MasterAW/DeleteHSNMasterByIdAW?Id=$hsnId", {});

    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }
}
