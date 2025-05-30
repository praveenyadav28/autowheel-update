import 'package:autowheel_workshop/utils/components/library.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List settingList = [
    {
      "text": "My Profile",
      "Image": Images.profile,
      // "path": const LabourMaster()
    },
    {
      "text": "Control Room",
      "Image": Images.controlRoom,
      // "path": const PartMaster()
    },
    {
      "text": "Change Password",
      "Image": Images.resetPassword,
      // "path": LedgerMaster(groupId: 9)
    },
    {
      "text": "FAQ",
      "Image": Images.faq,
      // "path": const StaffMaster()
    },
    {
      "text": "Help & Support",
      "Image": Images.helpDesk,
      // "path": const VehicleMaster()
    },
    {
      "text": "About Us",
      "Image": Images.aboutUs,
      // "path": const HsnCode(),
    },
    {
      "text": "Privacy Policy",
      "Image": Images.privacyPloicy,
      // "path": const DistrictMaster()
    },
    {
      "text": "Terms & Conditions",
      "Image": Images.termsCondition,
      // "path": const CityMaster(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<Classvaluechange>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.colPrimary,
          leading: (!Responsive.isDesktop(context))
              ? IconButton(
                  onPressed: context.read<MenuControlle>().controlMenu,
                  icon: const Icon(Icons.menu))
              : Container(),
          centerTitle: true,
          title: const Text("Setting", overflow: TextOverflow.ellipsis),
        ),
        backgroundColor: AppColor.colPrimary.withOpacity(.1),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                vertical: Sizes.height * 0.02, horizontal: Sizes.width * .05),
            child: Column(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (Responsive.isMobile(context)) ? 2 : 4,
                  ),
                  itemCount: settingList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pushTo(const MyAccount());
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
                                child:
                                    Image.asset(settingList[index]["Image"])),
                          ),
                        ),
                        SizedBox(height: Sizes.height * 0.02),
                        Text(settingList[index]["text"])
                      ],
                    );
                  },
                ),
                button("Logout", AppColor.colRideFare, onTap: () {
                  value.onLogout(context);
                  logoutPrefData();
                  pushNdRemove(const Splash());
                })
              ],
            )),
      );
    });
  }
}
