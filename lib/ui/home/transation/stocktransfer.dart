// import 'package:autowheel_workshop/utils/components/library.dart';
// import 'package:intl/intl.dart';

// class StockTransfer extends StatefulWidget {
//   const StockTransfer({super.key});

//   @override
//   State<StockTransfer> createState() => _StockTransferState();
// }

// class _StockTransferState extends State<StockTransfer> {
// //Controller
//   TextEditingController docNoController = TextEditingController();
//   TextEditingController prifixController = TextEditingController();
//   TextEditingController refNoController = TextEditingController();

// // Date
//   TextEditingController stockTransferDate = TextEditingController(
//       text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
//   TextEditingController refDate = TextEditingController(
//       text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             leading: (!Responsive.isDesktop(context))
//                 ? IconButton(
//                     onPressed: context.read<MenuControlle>().controlMenu,
//                     icon: const Icon(Icons.menu))
//                 : Container(),
//             centerTitle: true,
//             title:
//                 const Text("Stock Transfer", overflow: TextOverflow.ellipsis),
//             backgroundColor: AppColor.colPrimary),
//         backgroundColor: AppColor.colPrimary.withOpacity(.1),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: Sizes.height * 0.02, horizontal: Sizes.width * .03),
//             child: Column(
//               children: [
//                 addMasterOutside(context: context, children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                           flex: 1,
//                           child: textformfiles(prifixController,
//                               labelText: 'Prifix')),
//                       const SizedBox(width: 10),
//                       Expanded(
//                           flex: 2,
//                           child: textformfiles(docNoController,
//                               labelText: 'Document Number')),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       dropdownTextfield(
//                         context,
//                         "Document Date",
//                         InkWell(
//                           onTap: () async {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900),
//                               lastDate: DateTime(2500),
//                             ).then((selectedDate) {
//                               if (selectedDate != null) {
//                                 stockTransferDate.text =
//                                     DateFormat('yyyy/MM/dd')
//                                         .format(selectedDate);
//                               }
//                             });
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 stockTransferDate.text,
//                                 style: rubikTextStyle(
//                                     16, FontWeight.w500, AppColor.colBlack),
//                               ),
//                               Icon(Icons.edit_calendar,
//                                   color: AppColor.colBlack)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   textformfiles(refNoController, labelText: "Reference Number"),
//                   Column(
//                     children: [
//                       dropdownTextfield(
//                         context,
//                         "Reference Date",
//                         InkWell(
//                           onTap: () async {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(1900),
//                               lastDate: DateTime(2500),
//                             ).then((selectedDate) {
//                               if (selectedDate != null) {
//                                 refDate.text = DateFormat('yyyy/MM/dd')
//                                     .format(selectedDate);
//                               }
//                             });
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 refDate.text,
//                                 style: rubikTextStyle(
//                                     16, FontWeight.w500, AppColor.colBlack),
//                               ),
//                               Icon(Icons.edit_calendar,
//                                   color: AppColor.colBlack)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       dropdownTextfield(
//                         context,
//                         "Transfer From",
//                         DropdownButton<int>(
//                           underline: Container(),
//                           value: 1,
//                           items: [].map((data) {
//                             return DropdownMenuItem<int>(
//                               value: data['id'],
//                               child: Text(
//                                 data["name"],
//                                 style: rubikTextStyle(
//                                     16, FontWeight.w500, AppColor.colBlack),
//                               ),
//                             );
//                           }).toList(),
//                           icon: const Icon(Icons.keyboard_arrow_down_outlined),
//                           isExpanded: true,
//                           onChanged: (selectedId) {
//                             setState(() {
//                               // labourGroupId = selectedId!;
//                               // Call function to make API request
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       dropdownTextfield(
//                         context,
//                         "Transfer To",
//                         DropdownButton<int>(
//                           underline: Container(),
//                           value: 1,
//                           items: [].map((data) {
//                             return DropdownMenuItem<int>(
//                               value: data['id'],
//                               child: Text(
//                                 data["name"],
//                                 style: rubikTextStyle(
//                                     16, FontWeight.w500, AppColor.colBlack),
//                               ),
//                             );
//                           }).toList(),
//                           icon: const Icon(Icons.keyboard_arrow_down_outlined),
//                           isExpanded: true,
//                           onChanged: (selectedId) {
//                             setState(() {
//                               // labourGroupId = selectedId!;
//                               // Call function to make API request
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]),
//                 Container(
//                     width: double.infinity,
//                     decoration: decorationBox(),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           title: const Text(
//                             "‣ Add Spare Part",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           trailing: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColor.colPrimary),
//                               child: const Text('Add +')),
//                         ),
//                         const Divider(),
//                         SizedBox(
//                             height: 250,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                   children: List.generate(7, (index) {
//                                 return
//                                     // labourdetaList.length == 0
//                                     //     ? Container()
//                                     //     :
//                                     Column(
//                                   children: [
//                                     ListTile(
//                                         title: Text(
//                                           "Tyre Tube",
//                                           style: rubikTextStyle(
//                                               16,
//                                               FontWeight.w500,
//                                               AppColor.colBlack),
//                                         ),
//                                         subtitle: const Text(
//                                             "₹369, * 1 . 18% Tax incl. issued."),
//                                         trailing: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Text("327.05",
//                                                 style: rubikTextStyle(
//                                                     16,
//                                                     FontWeight.w500,
//                                                     AppColor.colBlack)),
//                                             PopupMenuButton(
//                                               position: PopupMenuPosition.under,
//                                               itemBuilder:
//                                                   (BuildContext context) =>
//                                                       <PopupMenuEntry>[
//                                                 PopupMenuItem(
//                                                   value: 'Edit',
//                                                   onTap: () {},
//                                                   child: const Text('Edit'),
//                                                 ),
//                                                 const PopupMenuItem(
//                                                     value: 'Delete',
//                                                     child: Text('Delete')),
//                                               ],
//                                               icon: const Icon(
//                                                 Icons.more_vert,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         leading: Checkbox(
//                                             value: false,
//                                             onChanged: (newValue) {
//                                               setState(() {
//                                                 newValue = true;
//                                               });
//                                             })),
//                                   ],
//                                 );
//                               })),
//                             )),
//                         Divider(
//                           thickness: 0,
//                           color: AppColor.colGrey,
//                         ),
//                         ListTile(
//                           dense: true,
//                           title: Text(
//                             "Subtotal",
//                             style: rubikTextStyle(
//                                 16, FontWeight.w500, AppColor.colBlack),
//                           ),
//                           trailing: Text(
//                             "₹2437.05",
//                             style: rubikTextStyle(
//                                 16, FontWeight.w500, AppColor.colBlack),
//                           ),
//                         )
//                       ],
//                     )),
//                 SizedBox(height: Sizes.height * 0.02),
//                 button("Save", AppColor.colPrimary),
//               ],
//             ),
//           ),
//         ));
//   }
// }
