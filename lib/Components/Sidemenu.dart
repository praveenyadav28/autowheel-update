// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:autowheel_workshop/ui/home/drawer/reports.dart';
import 'package:autowheel_workshop/utils/components/library.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var profileResponse;
  @override
  void initState() {
    getAccountDetails().then((value) => setState(() {}));
    super.initState();
  }

  String getimagepath = '';
  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(getimagepath);
    return Consumer<Classvaluechange>(builder: (context, value, child) {
      return Drawer(
        backgroundColor: AppColor.colWhite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Sizes.height * 0.03),
              profileResponse == null
                  ? const CircleAvatar(
                      radius: 60, backgroundColor: Colors.transparent)
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColor.colBlack.withOpacity(.1),
                      backgroundImage: MemoryImage(bytes)),
              Text(
                profileResponse == null ? "" : profileResponse['location_Name'],
                style: rubikTextStyle(16, FontWeight.w500, AppColor.colBlack),
              ),
              Container(
                  margin: EdgeInsets.only(top: Sizes.height * 0.02),
                  color: AppColor.colGrey.withOpacity(.5),
                  width: double.infinity,
                  height: 2),
              // if (Preference.getString(PrefKeys.userType) != "staff")
              //   DrawerListtile(
              //     onTap: () {
              //       value.onChanged(const PricingTable(), context);
              //     },
              //     title: "💫 Try Premium",
              //   ),
              DrawerListtile(
                onTap: () {
                  value.onChanged(const HomePageScreen(), context);
                },
                title: "Dashboard",
              ),
              DrawerListtile(
                onTap: () {
                  value.onChanged(const Masters(), context);
                },
                title: "Master",
              ),
              DrawerListtile(
                onTap: () {
                  value.onChanged(const Transaction(), context);
                },
                title: "Transaction",
              ),
              DrawerListtile(
                onTap: () {
                  value.onChanged(const ViewScreen(), context);
                },
                title: "View",
              ),
              DrawerListtile(
                onTap: () {
                  value.onChanged(const ReportScreen(), context);
                },
                title: "Reports",
              ),
              DrawerListtile(
                onTap: () {
                  value.onChanged(const Setting(), context);
                },
                title: "Setting",
              ),
              // ExpansionTile(
              //     backgroundColor: AppColor.colBlack.withOpacity(.1),
              //     title: const Text("Masters"),
              //     childrenPadding: const EdgeInsets.only(left: 10),
              //     children: [
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(PartMaster(status: false), context);
              //         },
              //         title: "Part Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(LabourMaster(status: false), context);
              //         },
              //         title: "Labour Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(
              //               LedgerMaster(groupId: 10, status: false), context);
              //         },
              //         title: "Ledger Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(const StaffMaster(), context);
              //         },
              //         title: "Staff Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(CityMaster(status: false), context);
              //         },
              //         title: "City Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(DistrictMaster(status: false), context);
              //         },
              //         title: "District Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(VehicleMaster(status: false), context);
              //         },
              //         title: "Vehicle Master",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(HsnCode(status: false), context);
              //         },
              //         title: "HSN Master",
              //       ),
              //     ]),
              // ExpansionTile(
              //     backgroundColor: AppColor.colBlack.withOpacity(.1),
              //     title: const Text("Transaction"),
              //     childrenPadding: const EdgeInsets.only(left: 10),
              //     children: [
              //       ExpansionTile(
              //           title: const Text("Purchase"),
              //           childrenPadding: const EdgeInsets.only(left: 10),
              //           children: [
              //             // DrawerListtile(
              //             //   onTap: () {
              //             //     value.onChanged(const PurchaseOrder(), context);
              //             //   },
              //             //   title: "Purchase Order",
              //             // ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(
              //                     PurchaseInvoice(invoiceNumber: 0), context);
              //               },
              //               title: "Purchase Invoice",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(
              //                     PaymentScreen(paymentVoucherNo: 0), context);
              //               },
              //               title: "Payment",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(
              //                     PurchaseReturn(invoiceNumber: 0), context);
              //               },
              //               title: "Purchase Return",
              //             ),
              //           ]),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(
              //               Estimate(items: const [], docNumber: 0), context);
              //         },
              //         title: "Estimate",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(const OutstandingReminder(), context);
              //         },
              //         title: "Outstanding Reminder",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(const StockTransfer(), context);
              //         },
              //         title: "Stock Transfer",
              //       ),
              //       DrawerListtile(
              //         onTap: () {
              //           value.onChanged(SaleReturn(invoiceNumber: 0), context);
              //         },
              //         title: "Sale Return",
              //       ),
              //       ExpansionTile(
              //           childrenPadding: const EdgeInsets.only(left: 10),
              //           title: const Text("Voucher Entry"),
              //           children: [
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(
              //                     ReceiptScreen(reciptVoucherNo: 0), context);
              //               },
              //               title: "Receipt",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(
              //                     PaymentScreen(
              //                       paymentVoucherNo: 0,
              //                     ),
              //                     context);
              //               },
              //               title: "Payment",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(const ExpanceVoucher(), context);
              //               },
              //               title: "Expanses",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(const IncomeVoucher(), context);
              //               },
              //               title: "Income",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(const ContraVoucher(), context);
              //               },
              //               title: "Contra",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(const CreditNote(), context);
              //               },
              //               title: "Credit Note",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(const DebitNote(), context);
              //               },
              //               title: "Debit Note",
              //             ),
              //             DrawerListtile(
              //               onTap: () {
              //                 value.onChanged(const JournalScreen(), context);
              //               },
              //               title: "Journal",
              //             ),
              //           ]),
              //     ]),

              // DrawerListtile(
              //   onTap: () {
              //     // value.onChanged(const TermsConditions(), context);
              //   },
              //   title: "Terms & Conditions",
              // ),
              // DrawerListtile(
              //   onTap: () {
              //     // value.onChanged(const TermsConditions(), context);
              //   },
              //   title: "Privacy & Policy",
              // ),
              // DrawerListtile(
              //   onTap: () {
              //     // value.onChanged(const TermsConditions(), context);
              //   },
              //   title: "Contact Us",
              // ),
              // DrawerListtile(
              //   onTap: () {

              //     // Navigator.pushAndRemoveUntil(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //       builder: (context) => const Splash(),
              //     //     ),
              //     //     (route) => false);
              //   },
              //   title: "Logout",
              //   style: TextStyle(
              //       color: AppColor.colRideFare, fontWeight: FontWeight.w800),
              // ),
            ],
          ),
        ),
      );
    });
  }

  Future getAccountDetails() async {
    profileResponse = await ApiService.fetchData(
        "MasterAW/GetLocationByIdAW?LocationId=${Preference.getString(PrefKeys.locationId)}");
    if (profileResponse != null) {
      getimagepath = profileResponse['bLogoPath'];
    }
  }
}

class DrawerListtile extends StatelessWidget {
  const DrawerListtile({
    required this.title,
    required this.onTap,
    this.style,
    super.key,
  });
  final String title;
  final style;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: style,
      ),
    );
  }
}
