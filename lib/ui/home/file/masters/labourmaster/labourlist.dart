// ignore_for_file: use_build_context_synchronously

import 'package:autowheel_workshop/utils/components/library.dart';

class LabourListClass extends StatefulWidget {
  const LabourListClass({super.key});

  @override
  State<LabourListClass> createState() => _LabourListClassState();
}

class _LabourListClassState extends State<LabourListClass> {
  //Labour List
  List labourList = [];

  List filteredList = [];

  TextEditingController searchController = TextEditingController();

//Category
  List<Map<String, dynamic>> labourGroupList = [];
  int? labourGroupId;

  @override
  void initState() {
    fatchlabour().then((value) => setState(() {}));
    categoryData().then((value) => setState(() {}));
    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList = labourList.where((value) {
        return value['labour_Name']
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            value['job_Code'].toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.height,
      color: AppColor.colPrimary.withOpacity(.1),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02, horizontal: Sizes.width * .02),
        child: Column(
          children: [
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
            (Responsive.isMobile(context))
                ? Column(
                    children: List.generate(filteredList.length, (index) {
                      // Group
                      int groupId = filteredList[index]['labour_Group_Id'];
                      String groupName = labourGroupList.isEmpty
                          ? ""
                          : labourGroupList.firstWhere(
                              (element) => element['id'] == groupId)['name'];
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            vertical: Sizes.height * 0.01, horizontal: 10),
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
                                vertical: 2, horizontal: 7.5),
                            // margin: const EdgeInsets.only(right: 10),
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
                              Text(filteredList[index]["labour_Name"]),
                              Text("₹ ${filteredList[index]["mrp"]}"),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "$groupName - ${filteredList[index]["igst"]}%",
                                  style: const TextStyle(fontSize: 13)),
                              Text(filteredList[index]["job_Code"],
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
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AddLabour(
                                      isFirst: false,
                                      id: filteredList[index]['job_Code_Id'],
                                      switchToSecondTab: () {},
                                    ),
                                  );
                                },
                                child: const Text('Edit'),
                              ),
                              PopupMenuItem(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete labour'),
                                            content: const Text(
                                                'Are you sure you want to delete labour ?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deletelabourApi(
                                                          filteredList[index]
                                                              ['job_Code_Id'])
                                                      .then((value) {
                                                    fatchlabour().then(
                                                        (value) => setState(() {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }));
                                                  });
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.colRideFare),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  value: 'Delete',
                                  child: const Text('Delete')),
                            ],
                            icon: const Icon(
                              Icons.more_vert,
                            ),
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
                          decoration: BoxDecoration(color: AppColor.colPrimary),
                          children: [
                            tableHeader("Job Code"),
                            tableHeader("Name"),
                            tableHeader("MRP"),
                            tableHeader("Group"),
                            tableHeader("Sac Code"),
                            tableHeader("GST"),
                            tableHeader("Action"),
                          ]),
                      ...List.generate(filteredList.length, (index) {
                        // Group
                        int groupId = filteredList[index]['labour_Group_Id'];
                        String groupName = labourGroupList.isEmpty
                            ? ""
                            : labourGroupList.firstWhere(
                                (element) => element['id'] == groupId)['name'];
                        return TableRow(
                            decoration: BoxDecoration(color: AppColor.colWhite),
                            children: [
                              tableRow(filteredList[index]["job_Code"]),
                              tableRow(filteredList[index]["labour_Name"]),
                              tableRow("₹ ${filteredList[index]["mrp"]}"),
                              tableRow(groupName),
                              tableRow(filteredList[index]['sac_Code']),
                              tableRow("${filteredList[index]['igst']} %"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => AddLabour(
                                            isFirst: false,
                                            id: filteredList[index]
                                                ['job_Code_Id'],
                                            switchToSecondTab: () {},
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit,
                                          color: AppColor.colPrimary)),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Delete labour'),
                                                content: const Text(
                                                    'Are you sure you want to delete labour ?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deletelabourApi(
                                                              filteredList[
                                                                      index][
                                                                  'job_Code_Id'])
                                                          .then((value) {
                                                        fatchlabour().then(
                                                            (value) =>
                                                                setState(() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }));
                                                      });
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .colRideFare),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
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
    );
  }

  //Get labour List
  Future fatchlabour() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetLabourMasterLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    labourList = response;
    filteredList = labourList;
  }

//Get category
  Future<void> categoryData() async {
    await fetchDataByMiscAdd(105, labourGroupList);
  }

  //Delete labour
  Future deletelabourApi(int? labourId) async {
    var response = await ApiService.postData(
        "MasterAW/DeleteLabourByIdAW?Id=$labourId", {});
    if (response['status'] == false) {
      showCustomSnackbar(context, response['message']);
    } else {
      showCustomSnackbarSuccess(context, response['message']);
    }
  }
}
