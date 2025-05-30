// import 'package:autowheel_workshop/utils/components/library.dart';
// import 'package:intl/intl.dart';

// class CreditNote extends StatefulWidget {
//   const CreditNote({super.key});

//   @override
//   State<CreditNote> createState() => _CreditNoteState();
// }

// class _CreditNoteState extends State<CreditNote> {
//   // Date
//   TextEditingController fromDate = TextEditingController(
//       text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
//   TextEditingController toDate = TextEditingController(
//       text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
//   TextEditingController suplierInvDate = TextEditingController(
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

//   //Controller
//   TextEditingController prifixController = TextEditingController();
//   TextEditingController creditNoteController = TextEditingController();
//   TextEditingController creditamountController = TextEditingController();
//   TextEditingController suplierInvController = TextEditingController();
//   TextEditingController remarkController = TextEditingController();
//   TextEditingController debitamountController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back_ios)),
//           centerTitle: true,
//           title: const Text("Credit Note", overflow: TextOverflow.ellipsis),
//           backgroundColor: AppColor.colPrimary),
//       backgroundColor: AppColor.colWhite,
//       body: Container(
//         height: Sizes.height,
//         color: AppColor.colPrimary.withOpacity(.1),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//               horizontal: Sizes.width * 0.03, vertical: Sizes.height * 0.02),
//           child: Column(
//             children: [
//               addMasterOutside(children: [
//                 Column(
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "From Date",
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
//                       "To Date",
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
//                   children: [
//                     button("View Date Wise", AppColor.colPrimary),
//                   ],
//                 ),
//               ], context: context),
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
//               addMasterOutside(children: [
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Voucher Type",
//                       DropdownButton<int>(
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
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Voucher Mode",
//                       DropdownButton<int>(
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
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         flex: 3,
//                         child: textformfiles(prifixController,
//                             labelText: "Prifix")),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         flex: 5,
//                         child: textformfiles(creditNoteController,
//                             labelText: "Credit Note No.")),
//                   ],
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Branch Name",
//                       DropdownButton<int>(
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
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Party Details",
//                       DropdownButton<int>(
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
//                 ReuseContainer(title: "Balance", subtitle: "₹ 3257.00"),
//                 textformfiles(creditamountController,
//                     labelText: "Credit Amount"),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Good Details",
//                       DropdownButton<int>(
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
//                 Column(
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "Supplier Invoice Date",
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
//                               suplierInvDate.text =
//                                   DateFormat('yyyy/MM/dd').format(selectedDate);
//                             }
//                           });
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               suplierInvDate.text,
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
//                 textformfiles(suplierInvController,
//                     labelText: "Supplier Number"),
//                 textformfiles(remarkController, labelText: "Remark"),
//                 textformfiles(debitamountController, labelText: "Debit Amount"),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     dropdownTextfield(
//                       context,
//                       "HSN Code",
//                       DropdownButton<int>(
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
//                 ReuseContainer(title: "GST", subtitle: "18%"),
//                 ReuseContainer(title: "Taxable", subtitle: "29.37"),
//               ], context: context),
//               button("Save", AppColor.colPrimary),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
