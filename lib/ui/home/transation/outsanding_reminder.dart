// import 'package:autowheel_workshop/utils/components/library.dart';
// import 'package:intl/intl.dart';

// class OutstandingReminder extends StatefulWidget {
//   const OutstandingReminder({super.key});

//   @override
//   State<OutstandingReminder> createState() => _OutstandingReminderState();
// }

// class _OutstandingReminderState extends State<OutstandingReminder> {
// // Date
//   TextEditingController fromDate = TextEditingController(
//       text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
//   TextEditingController toDate = TextEditingController(
//       text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

//   final List<Map<String, dynamic>> data = [
//     {
//       'PartyName': 'TVS MOTORS',
//       'Address': 'RAJKOT',
//       'CityName': 'RAJKOT',
//       'DistrictName': 'RAJKOT',
//       'StateName': 'GUJARAT',
//       'Mob': '',
//       'DueDate': '11-04-2024',
//       'ClosingBal': '20000',
//       'BalType': 'Cr',
//       'Remarks': '',
//       'StaffName': 'KAPIL'
//     },
//     {
//       'PartyName': 'SURENDER',
//       'Address': 'RAJKOT',
//       'CityName': 'RAJKOT',
//       'DistrictName': 'RAJKOT',
//       'StateName': 'GUJARAT',
//       'Mob': '',
//       'DueDate': '01-03-2024',
//       'ClosingBal': '34000',
//       'BalType': 'Dr',
//       'Remarks': '',
//       'StaffName': 'KAPIL'
//     },
//     {
//       'PartyName': 'Anil Sharma',
//       'Address': 'RAJKOT',
//       'CityName': 'RAJKOT',
//       'DistrictName': 'RAJKOT',
//       'StateName': 'GUJARAT',
//       'Mob': '',
//       'DueDate': '11-04-2024',
//       'ClosingBal': '57402',
//       'BalType': 'Dr',
//       'Remarks': 'INSTALLMENT',
//       'StaffName': 'KAPIL'
//     },
//     {
//       'PartyName': 'SURESH JI SH...',
//       'Address': 'RAJKOT',
//       'CityName': 'RAJKOT',
//       'DistrictName': 'RAJKOT',
//       'StateName': 'GUJARAT',
//       'Mob': '',
//       'DueDate': '12-04-2024',
//       'ClosingBal': '243000',
//       'BalType': 'Dr',
//       'Remarks': '',
//       'StaffName': 'KAPIL'
//     },
//     {
//       'PartyName': 'BAJAJ',
//       'Address': 'SODALA',
//       'CityName': 'Jaipur',
//       'DistrictName': 'Jaipur',
//       'StateName': 'RAJASTHAN',
//       'Mob': '556435973',
//       'DueDate': '25-01-2024',
//       'ClosingBal': '5366',
//       'BalType': 'Cr',
//       'Remarks': '26 JAN.MEETI...',
//       'StaffName': 'KAPIL'
//     },
//     {
//       'PartyName': 'RAHUL SHAR...',
//       'Address': 'SHAYAM NA...',
//       'CityName': 'Jaipur',
//       'DistrictName': 'Jaipur',
//       'StateName': 'RAJASTHAN',
//       'Mob': '',
//       'DueDate': '24-01-2024',
//       'ClosingBal': '5371955',
//       'BalType': 'Cr',
//       'Remarks': '',
//       'StaffName': 'KAPIL'
//     },
//     {
//       'PartyName': 'KRISHNA SH...',
//       'Address': 'SHAYAM NA...',
//       'CityName': 'Jaipur',
//       'DistrictName': 'Jaipur',
//       'StateName': 'RAJASTHAN',
//       'Mob': '',
//       'DueDate': '24-01-2024',
//       'ClosingBal': '708',
//       'BalType': 'Cr',
//       'Remarks': '',
//       'StaffName': 'KAPIL'
//     },
//   ];

//   final ScrollController _horizontalScrollController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: (!Responsive.isDesktop(context))
//               ? IconButton(
//                   onPressed: context.read<MenuControlle>().controlMenu,
//                   icon: const Icon(Icons.menu))
//               : Container(),
//           centerTitle: true,
//           title: const Text("Outstanding Reminder",
//               overflow: TextOverflow.ellipsis),
//           backgroundColor: AppColor.colPrimary),
//       backgroundColor: AppColor.colPrimary.withOpacity(.1),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: Sizes.width * 0.03, vertical: Sizes.height * 0.02),
//           child: Column(
//             children: [
//               addMasterOutside(children: [
//                 Column(
//                   children: [button("Staff Entry Wise", AppColor.colPrimary)],
//                 ),
//                 Column(
//                   children: [
//                     button("Categary Wise", AppColor.colGrey.withOpacity(.5))
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     button("City Wise", AppColor.colGrey.withOpacity(.5))
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     button("District Wise", AppColor.colGrey.withOpacity(.5))
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     button("State Wise", AppColor.colGrey.withOpacity(.5))
//                   ],
//                 ),
//               ], context: context),
//               addMasterOutside(children: [
//                 Column(
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Due From",
//                       InkWell(
//                         onTap: () async {
//                           FocusScope.of(context).requestFocus(FocusNode());
//                           await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(2500),
//                           ).then((selectedDate) {
//                             if (selectedDate != null) {
//                               fromDate.text =
//                                   DateFormat('yyyy/MM/dd').format(selectedDate);
//                             }
//                           });
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               fromDate.text,
//                               style: rubikTextStyle(
//                                   16, FontWeight.w500, AppColor.colBlack),
//                             ),
//                             Icon(Icons.edit_calendar, color: AppColor.colBlack)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Due To",
//                       InkWell(
//                         onTap: () async {
//                           FocusScope.of(context).requestFocus(FocusNode());
//                           await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(2500),
//                           ).then((selectedDate) {
//                             if (selectedDate != null) {
//                               toDate.text =
//                                   DateFormat('yyyy/MM/dd').format(selectedDate);
//                             }
//                           });
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               toDate.text,
//                               style: rubikTextStyle(
//                                   16, FontWeight.w500, AppColor.colBlack),
//                             ),
//                             Icon(Icons.edit_calendar, color: AppColor.colBlack)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Staff Name",
//                      
//                         underline: Container(),
//                         value: 1,
//                         items: [].map((data) {
//                           return DropdownMenuItem<int>(
//                             value: data['id'],
//                             child: Text(
//                               data["name"],
//                               style: rubikTextStyle(
//                                   16, FontWeight.w500, AppColor.colBlack),
//                             ),
//                           );
//                         }).toList(),
//                         icon: const Icon(Icons.keyboard_arrow_down_outlined),
//                         isExpanded: true,
//                         onChanged: (selectedId) {
//                           setState(() {
//                             // labourGroupId = selectedId!;
//                             // Call function to make API request
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ], context: context),
//               button("Refresh", AppColor.colPrimary),
//               SizedBox(height: Sizes.height * 0.02),
//               Container(
//                   width: double.infinity,
//                   height: 300,
//                   decoration: BoxDecoration(
//                       border: Border.all(), color: AppColor.colWhite),
//                   child: Scrollbar(
//                     controller: _horizontalScrollController,
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       controller: _horizontalScrollController,
//                       scrollDirection: Axis.horizontal,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: DataTable(
//                           columns: const [
//                             DataColumn(label: Text('PartyName')),
//                             DataColumn(label: Text('Address')),
//                             DataColumn(label: Text('CityName')),
//                             DataColumn(label: Text('DistrictName')),
//                             DataColumn(label: Text('StateName')),
//                             DataColumn(label: Text('Mob')),
//                             DataColumn(label: Text('DueDate')),
//                             DataColumn(label: Text('ClosingBal')),
//                             DataColumn(label: Text('BalType')),
//                             DataColumn(label: Text('Remarks')),
//                             DataColumn(label: Text('StaffName')),
//                           ],
//                           rows: data
//                               .map(
//                                 (item) => DataRow(
//                                   cells: [
//                                     DataCell(Text(item['PartyName'])),
//                                     DataCell(Text(item['Address'])),
//                                     DataCell(Text(item['CityName'])),
//                                     DataCell(Text(item['DistrictName'])),
//                                     DataCell(Text(item['StateName'])),
//                                     DataCell(Text(item['Mob'])),
//                                     DataCell(Text(item['DueDate'])),
//                                     DataCell(Text(item['ClosingBal'])),
//                                     DataCell(Text(item['BalType'])),
//                                     DataCell(Text(item['Remarks'])),
//                                     DataCell(Text(item['StaffName'])),
//                                   ],
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                   )),
//               SizedBox(height: Sizes.height * 0.02),
//               Row(
//                 children: [
//                   Expanded(child: button("Send SMS", AppColor.colPrimary)),
//                   const SizedBox(width: 10),
//                   Expanded(
//                       child:
//                           button("Send Whatsapp Message", AppColor.colPrimary)),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
