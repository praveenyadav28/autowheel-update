// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable, non_constant_identifier_names, use_build_context_synchronously, avoid_print, empty_catches
import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:http/http.dart' as http;

class AddGroupScreen extends StatefulWidget {
  int? sourecID;
  String? name;
  AddGroupScreen({super.key, this.sourecID, required this.name});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  TextEditingController groupcontroller = TextEditingController();
  bool isSearchMode = false;

  List<Map<String, dynamic>> listToUpdate = [];

  final TextEditingController _editController = TextEditingController();
  @override
  void initState() {
    fetchDataByMiscType().then((value) => setState(() {}));
    super.initState();
    // postData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add ${widget.name}"),
        iconTheme: IconThemeData(color: AppColor.colWhite),
        elevation: 2,
        backgroundColor: AppColor.colPrimary,
        leading: IconButton(
            onPressed: () {
              fetchDataByMiscType().then((value) => setState(() {}));
              Navigator.pop(context, "refresh");
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: AppColor.colWhite,
      body: Container(
        height: double.infinity,
        color: AppColor.colPrimary.withOpacity(.1),
        padding: EdgeInsets.symmetric(
            vertical: Sizes.height * 0.02, horizontal: Sizes.width * .04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              addMasterOutside(children: [
                textformfiles(groupcontroller,
                    validator: (p0) {},
                    label: const Text("Group"),
                    prefixIcon: Icon(Icons.code, color: AppColor.colGrey)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    button(
                      "Save",
                      AppColor.colPrimary,
                      onTap: () {
                        postData();
                      },
                    ),
                  ],
                )
              ], context: context),
              const Divider(),
              SizedBox(height: Sizes.height * 0.02),
              SizedBox(
                  width: double.infinity,
                  child: Wrap(
                      spacing: Sizes.width * 0.02,
                      runSpacing: Sizes.height * 0.02,
                      children: List.generate(listToUpdate.length, (index) {
                        return SizedBox(
                          width: (Responsive.isMobile(context))
                              ? double.infinity
                              : Sizes.width <= 855
                                  ? Sizes.width * 0.42
                                  : Sizes.width * 0.293,
                          child: Card(
                            child: ListTile(
                              leading: Text("${index + 1}",
                                  style: rubikTextStyle(
                                      16, FontWeight.w400, AppColor.colBlack)),
                              horizontalTitleGap: 0,
                              title: Text(
                                listToUpdate[index]['name'],
                                style: rubikTextStyle(
                                    16, FontWeight.w500, AppColor.colBlack),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AlertDialog(
                                                    title: Text(
                                                        'Edit ${widget.name}'),
                                                    content: textformfiles(
                                                        _editController,
                                                        labelText: "Edit"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          editMismaster(
                                                                  listToUpdate[
                                                                          index]
                                                                      ['id'],
                                                                  _editController
                                                                      .text
                                                                      .toString())
                                                              .then((value) =>
                                                                  setState(() {
                                                                    fetchDataByMiscType().then(
                                                                        (value) =>
                                                                            setState(() {}));
                                                                    Navigator.pop(
                                                                        context);
                                                                    _editController
                                                                        .clear();
                                                                  }));
                                                        },
                                                        child: Text(
                                                          'Save',
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .colRideFare),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: AppColor.colPrimary,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Delete ${widget.name}'),
                                                content: Text(
                                                    'Are you sure you want to delete ${listToUpdate[index]['name']} ?'),
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
                                                      deleteMismaster(
                                                              listToUpdate[
                                                                  index]['id'])
                                                          .then(
                                                              (value) =>
                                                                  setState(() {
                                                                    fetchDataByMiscType().then(
                                                                        (value) =>
                                                                            setState(() {}));
                                                                    Navigator.pop(
                                                                        context);
                                                                  }));
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
                                      icon: Icon(
                                        Icons.delete,
                                        color: AppColor.colRideFare,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      })))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchDataByMiscType() async {
    final url = Uri.parse(
        'http://lms.muepetro.com/api/MasterAW/GetMiscMasterLocationWiseAW?LocationId=${Preference.getString(PrefKeys.locationId)}&MiscTypeId=${widget.sourecID}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Goruppartmodel> goruppartmodelList =
            grouppartmodelFromJson(response.body);
        listToUpdate.clear();
        for (var item in goruppartmodelList) {
          listToUpdate.add({'id': item.id, 'name': item.name});
        }
        setState(() {});
      } else {
        // Handle error if needed
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> postData() async {
    var response = await ApiService.postData("MasterAW/PostMiscMasterAW", {
      "Name": groupcontroller.text.toString(),
      "LocationId": int.parse(Preference.getString(PrefKeys.locationId)),
      "MiscMasterId": widget.sourecID
    });
    if (response['result'] == true) {
      showCustomSnackbarSuccess(context, "Details saved successfully");
      Navigator.pop(context);
    } else if (response['message'] == "Name already exists") {
      showCustomSnackbar(
          context, "Name already exists. Please use a different name.");
    } else {
      showCustomSnackbar(context, "An error occurred while saving the details");
    }
  }

  Future deleteMismaster(int? id) async {
    var response =
        await ApiService.postData("MasterAW/DeleteMiscMasterByIdAW?Id=$id", {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response['message']),
      backgroundColor: AppColor.colPrimary,
    ));
  }

  Future editMismaster(int? id, controller) async {
    var response =
        await ApiService.postData("MasterAW/UpdateMiscMasterByIdAW?Id=$id", {
      "Name": controller,
      "LocationId": int.parse(Preference.getString(PrefKeys.locationId)),
      "MiscMasterId": widget.sourecID,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response['message']),
      backgroundColor: AppColor.colPrimary,
    ));
  }
}
