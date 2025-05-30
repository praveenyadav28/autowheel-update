// import 'package:autowheel_workshop/utils/components/library.dart';

// class BranchListClass extends StatefulWidget {
//   const BranchListClass({super.key});

//   @override
//   State<BranchListClass> createState() => _BranchListClassState();
// }

// class _BranchListClassState extends State<BranchListClass> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             vertical: Sizes.height * 0.02, horizontal: Sizes.width * .02),
//         child: Column(
//           children: [
//             Wrap(
//               children: List.generate(4, (index) {
//                 return Container(
//                   width: (Responsive.isMobile(context))
//                       ? double.infinity
//                       : (Responsive.isDesktop(context))
//                           ? Sizes.width * 0.23
//                           : Sizes.width <= 855
//                               ? Sizes.width * 0.42
//                               : Sizes.width * 0.28,
//                   margin: EdgeInsets.symmetric(
//                       vertical: Sizes.height * 0.01, horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: AppColor.colWhite,
//                     borderRadius: BorderRadius.circular(5),
//                     boxShadow: [
//                       BoxShadow(blurRadius: 2, color: AppColor.colGrey)
//                     ],
//                   ),
//                   child: ExpansionTile(
//                     title: ListTile(
//                       leading: Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 2, horizontal: 7.5),
//                         decoration: BoxDecoration(
//                             color: AppColor.colPrimary, shape: BoxShape.circle),
//                         child: Text(
//                           '${index + 1}',
//                           style: rubikTextStyle(
//                               16, FontWeight.w500, AppColor.colWhite),
//                         ),
//                       ),
//                       title: Text(
//                         'Shri Moters 5',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: AppColor.colBlack,
//                         ),
//                       ),
//                       subtitle: const Text(
//                         "GSTINLocation5",
//                       ),
//                     ),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Column(
//                           // crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             datastyle("Discription", 'Authrosied Of Show Room5',
//                                 context),
//                             datastyle("Email", 'prav@gmail.com', context),
//                             datastyle("Mobile No.:", '8479812434', context),
//                             datastyle("State", 'Rajasthan', context),
//                             datastyle("City:", 'Jaipur', context),
//                             datastyle("Address:",
//                                 'A-12 Barkat Nagar, Tonk phatak', context),
//                             datastyle("Pin Code:", '333515', context),
//                             datastyle("Dealer Code:", "2438732", context),
//                             datastyle("Jurdiction:", "nhi pta abhi", context),
//                             const Divider(),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {},
//                                     child: const Text(
//                                       "Edit",
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               title:
//                                                   const Text('Delete Branch'),
//                                               content: const Text(
//                                                   'Are you sure you want to delete branch ?'),
//                                               actions: <Widget>[
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     Navigator.of(context).pop();
//                                                   },
//                                                   child: const Text('Cancel'),
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () {},
//                                                   child: Text(
//                                                     'Delete',
//                                                     style: TextStyle(
//                                                         color: AppColor
//                                                             .colRideFare),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           });
//                                     },
//                                     child: Text(
//                                       "Delete",
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           color: AppColor.colRideFare),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
