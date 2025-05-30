import 'package:autowheel_workshop/utils/components/library.dart';

class StaffList extends StatelessWidget {
  const StaffList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaffProvider(),
      child: Consumer<StaffProvider>(
        builder: (context, provider, child) {
          return Container(
            color: AppColor.colPrimary.withOpacity(.1),
            height: Sizes.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * .02),
              child: Responsive.isMobile(context)
                  ? Column(
                      children:
                          List.generate(provider.staffList.length, (index) {
                        // Priority
                        int deginationId =
                            provider.staffList[index]['staff_Degination_Id'];
                        String deginationName = provider.deginationList
                            .firstWhere(
                                (element) => element['id'] == deginationId,
                                orElse: () => {'name': 'Unknown'})['name'];

                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Sizes.height * 0.01, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(blurRadius: 2, color: Colors.grey)
                            ],
                          ),
                          child: ListTile(
                            minVerticalPadding: 0,
                            horizontalTitleGap: 0,
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 7.5),
                              decoration: BoxDecoration(
                                  color: AppColor.colPrimary,
                                  shape: BoxShape.circle),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(provider.staffList[index]['staff_Name']),
                                Text(deginationName),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(provider.staffList[index]['mob'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                Text(
                                    provider.staffList[index]['userType'] ==
                                            "staff"
                                        ? "Staff"
                                        : "Sub Admin",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
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
                                      builder: (context) => AddStaffWidget(
                                        isFirst: false,
                                        id: provider.staffList[index]['id'],
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
                                              title: const Text('Delete Staff'),
                                              content: const Text(
                                                  'Are you sure you want to delete staff ?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    provider
                                                        .deleteStaff(
                                                            provider.staffList[
                                                                index]['id'])
                                                        .then((_) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }).catchError((error) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Error'),
                                                              content: Text(error
                                                                  .toString()),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
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
                            decoration:
                                BoxDecoration(color: AppColor.colPrimary),
                            children: [
                              tableHeader("Staff Name"),
                              tableHeader("Mobile Number"),
                              tableHeader("City"),
                              tableHeader("Degination"),
                              tableHeader("Password"),
                              tableHeader("Access Type"),
                              tableHeader("Action"),
                            ]),
                        ...List.generate(provider.staffList.length, (index) {
                          // Priority
                          int deginationId =
                              provider.staffList[index]['staff_Degination_Id'];
                          String deginationName = provider.deginationList
                              .firstWhere(
                                  (element) => element['id'] == deginationId,
                                  orElse: () => {'name': 'Unknown'})['name'];

                          return TableRow(
                              decoration:
                                  BoxDecoration(color: AppColor.colWhite),
                              children: [
                                tableRow(
                                    provider.staffList[index]["staff_Name"]),
                                tableRow(provider.staffList[index]['mob']),
                                tableRow(
                                    "${provider.staffList[index]["city_Name"]}"),
                                tableRow(deginationName),
                                tableRow(provider.staffList[index]['password']),
                                tableRow(provider.staffList[index]
                                            ['userType'] ==
                                        "staff"
                                    ? "Staff"
                                    : "Sub Admin"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                AddStaffWidget(
                                              isFirst: false,
                                              id: provider.staffList[index]
                                                  ['id'],
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
                                                  title: const Text(
                                                      'Delete Staff'),
                                                  content: const Text(
                                                      'Are you sure you want to delete staff ?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        provider
                                                            .deleteStaff(provider
                                                                    .staffList[
                                                                index]['id'])
                                                            .then((_) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }).catchError((error) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Error'),
                                                                  content: Text(
                                                                      error
                                                                          .toString()),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
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
            ),
          );
        },
      ),
    );
  }
}
