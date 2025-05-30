  // Container(
  //                 decoration: BoxDecoration(border: Border.all()),
  //                 height: 300,
  //                 width: Sizes.width * 0.94,
  //                 child: SingleChildScrollView(
  //                   child: Wrap(
  //                     alignment: WrapAlignment.spaceBetween,
  //                     children: List.generate(6, (index) {
  //                       return Container(
  //                           width: Sizes.width <= 755
  //                               ? double.infinity
  //                               : Sizes.width <= 1300
  //                                   ? Sizes.width * 0.45
  //                                   : 380,
  //                           margin: EdgeInsets.symmetric(
  //                               vertical: Sizes.height * 0.01, horizontal: 10),
  //                           decoration: BoxDecoration(
  //                             color: AppColor.colWhite,
  //                             borderRadius: BorderRadius.circular(5),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                   blurRadius: 2, color: AppColor.colGrey)
  //                             ],
  //                           ),
  //                           child: ExpansionTile(
  //                             childrenPadding:
  //                                 const EdgeInsets.symmetric(horizontal: 10),
  //                             tilePadding: const EdgeInsets.only(right: 10),
  //                             title: ListTile(
  //                               minVerticalPadding: 0,
  //                               horizontalTitleGap: 0,
  //                               leading: Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     vertical: 2, horizontal: 7.5),
  //                                 decoration: BoxDecoration(
  //                                     color: AppColor.colPrimary,
  //                                     shape: BoxShape.circle),
  //                                 child: Text(
  //                                   '${index + 1}',
  //                                   style: rubikTextStyle(
  //                                       15, FontWeight.w500, AppColor.colWhite),
  //                                 ),
  //                               ),
  //                               title: const Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text("Apolo Private Ltd."),
  //                                   Text("51"),
  //                                 ],
  //                               ),
  //                             ),
  //                             subtitle: ListTile(
  //                               title: Row(
  //                                 children: [
  //                                   Icon(
  //                                     Icons.notifications_active_outlined,
  //                                     color: AppColor.colBlack,
  //                                   ),
  //                                   Text(
  //                                     '  22/03/2024',
  //                                     style: rubikTextStyle(
  //                                       16,
  //                                       FontWeight.w500,
  //                                       AppColor.colFbCircle.withOpacity(.5),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               trailing: const Text("AU Bank"),
  //                             ),
  //                             children: [
  //                               datastyle("Prifix", "Online", context),
  //                               datastyle("Total Amount", "₹ 192138", context),
  //                               datastyle("Paid Amount", "₹ 192000", context),
  //                               datastyle("Balance Amount", "₹ 138", context),
  //                               datastyle("Remark", "Advance P090", context),
  //                             ],
  //                           ));
  //                     }),
  //                   ),
  //                 ),
  //               ),
              