import 'package:autowheel_workshop/utils/components/library.dart';

//Default button
Widget  button(String txt, Color? color,
    {void Function()? onTap, double width = double.infinity}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 40,
      width: width,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      child: Center(
          child: Text(txt,
              style: rubikTextStyle(15, FontWeight.w500, AppColor.colWhite))),
    ),
  );
}

//Add masters
InkWell addDefaultButton(BuildContext context, Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: (Responsive.isMobile(context)) ? 45 : 40,
        width: (Responsive.isMobile(context)) ? 45 : 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColor.colWhite,
          border: Border.all(
            width: 1,
            color: AppColor.colBlack,
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColor.colBlack,
        )),
  );
}
