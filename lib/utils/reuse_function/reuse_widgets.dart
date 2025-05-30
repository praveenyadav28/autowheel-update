// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:autowheel_workshop/utils/components/library.dart';

//TextRow
datastyle(String title, String subtitle, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: Sizes.height * .01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: rubikTextStyle(15, FontWeight.w500, AppColor.colBlack),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: (Responsive.isMobile(context))
              ? 200
              : (Responsive.isDesktop(context))
                  ? Sizes.width * 0.12
                  : Sizes.width <= 855
                      ? Sizes.width * 0.21
                      : Sizes.width * 0.13,
          child: Text(
            subtitle.trim(),
            style: rubikTextStyle(15, FontWeight.w500, AppColor.colGrey),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}

//Appbar
class AppbarClass extends StatelessWidget {
  AppbarClass({
    this.title,
    super.key,
  });
  String? title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // toolbarHeight: 60,
      elevation: 0,
      // leadingWidth: 24,

      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColor.colBlack,
          )),
      backgroundColor: Colors.transparent,
      // centerTitle: true,
      title: Text(
        title!,
        style: rubikTextStyle(18, FontWeight.w500, AppColor.colBlack),
      ),
    );
  }
}

//Expensiontile
class ExpansionTileWidget extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const ExpansionTileWidget({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  _ExpansionTileWidgetState createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: !_isExpanded
          ? BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: AppColor.colWhite,
              borderRadius: BorderRadius.circular(10))
          : const BoxDecoration(),
      child: ExpansionTile(
        dense: true,
        shape: Border.all(width: 0, color: Colors.transparent),
        tilePadding: EdgeInsets.zero,
        title: Text(
          "   ${widget.title}",
          style: rubikTextStyle(16, FontWeight.w600, AppColor.colBlack),
        ),
        backgroundColor: Colors.transparent,
        trailing: _isExpanded
            ? const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.expand_less),
              )
            : const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.expand_more),
              ),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: widget.children,
      ),
    );
  }
}

//Url Louncher
Future sendMessage(
    BuildContext context, String phoneNumber, String name) async {
  if (!await launchUrl(
    Uri.parse("sms:$phoneNumber?body=$name"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

Future makeCall(BuildContext context, String phoneNumber) async {
  if (!await launchUrl(
    Uri.parse("tel:$phoneNumber"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

Future openWhatsApp(
    BuildContext context, String phoneNumber, String name) async {
  if (!await launchUrl(
    Uri.parse("https://wa.me/+91$phoneNumber?text=$name"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}


//decoration
BoxDecoration decorationBox() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColor.colWhite,
      border: Border.all(
        color: AppColor.colGrey,
      ),
      boxShadow: [BoxShadow(blurRadius: 2, color: AppColor.colWhite)]);
}

//Reuse Conatiner
class ReuseContainer extends StatelessWidget {
  ReuseContainer({super.key, required this.title, required this.subtitle});
  String title;
  String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: decorationBox(),
          child: SizedBox(
              height: (Responsive.isMobile(context)) ? 45 : 40,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(title))),
                  Expanded(
                      child: Container(
                          height: (Responsive.isMobile(context)) ? 45 : 40,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 10),
                          color: AppColor.colBlack.withOpacity(.1),
                          child: Text(subtitle))),
                ],
              )),
        ),
      ],
    );
  }
}

// Utility function for creating table headers
Widget tableHeader(String text) {
  return Text(text,
      style: TextStyle(
        height: 1.6,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColor.colBlack,
      ),
      textAlign: TextAlign.center);
}

// Utility function for creating table headers
Widget tableRow(String text) {
  return Text(text,
      style: rubikTextStyle(15, FontWeight.w500, AppColor.colBlack)
          .copyWith(height: 2),
      textAlign: TextAlign.center);
}
