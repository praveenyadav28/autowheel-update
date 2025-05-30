import 'package:autowheel_workshop/utils/components/library.dart';

class Masters extends StatefulWidget {
  const Masters({super.key});

  @override
  State<Masters> createState() => _MastersState();
}

class _MastersState extends State<Masters> {
  List mastersList = [
    {
      "text": "Part Master",
      "Image": Images.spareParts,
      "path": const PartMaster()
    },
    {
      "text": "Labour Master",
      "Image": Images.labour,
      "path": const LabourMaster()
    },
    {
      "text": "Ledger Master",
      "Image": Images.ledger,
      "path": LedgerMaster(groupId: 0)
    },
    {
      "text": "Staff Master",
      "Image": Images.staff,
      "path": const StaffMaster()
    },
    {
      "text": "Vehicle Master",
      "Image": Images.vehicle,
      "path": const VehicleMaster()
    },
    {"text": "HSN Master", "Image": Images.hsn, "path": const HsnCode()},
    {
      "text": "District Master",
      "Image": Images.district,
      "path": const DistrictMaster()
    },
    {
      "text": "City Master",
      "Image": Images.cityscape,
      "path": const CityMaster()
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colPrimary,
        leading: (!Responsive.isDesktop(context))
            ? IconButton(
                onPressed: context.read<MenuControlle>().controlMenu,
                icon: const Icon(Icons.menu))
            : Container(),
        centerTitle: true,
        title: const Text("Masters", overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColor.colPrimary.withOpacity(.1),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02, horizontal: Sizes.width * .05),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (Responsive.isMobile(context)) ? 2 : 4,
            ),
            itemCount: mastersList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      pushTo(mastersList[index]["path"]);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.colPrimary.withOpacity(.1),
                      ),
                      child: Center(
                          child: Image.asset(mastersList[index]["Image"])),
                    ),
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                  Text(mastersList[index]["text"])
                ],
              );
            },
          )),
    );
  }
}
