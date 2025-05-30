// ignore_for_file: non_constant_identifier_names, file_names, use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable
import 'package:autowheel_workshop/utils/components/library.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({required this.child, super.key});
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.colWhite,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: !Responsive.isMobile(context)
                    ? Sizes.width * 0.4
                    : Sizes.width * .5,
                height: Sizes.height,
                color: AppColor.colPrimary,
              ),
            ),
            Container(
              width: Sizes.width * 0.8,
              height: Sizes.height * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.colWhite,
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.colBlack.withOpacity(.4),
                        spreadRadius: .1,
                        blurRadius: 30)
                  ]),
              child: !Responsive.isMobile(context)
                  ? Row(children: [
                      Container(
                        width: Sizes.width * .3,
                        height: Sizes.height * 0.8,
                        decoration: BoxDecoration(
                            color: AppColor.colPrimary,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Image.asset(Images.logopng),
                      ),
                      Container(
                          width: Sizes.width * .5,
                          padding: EdgeInsets.symmetric(
                              horizontal: !Responsive.isTablet(context)
                                  ? Sizes.width * 0.15
                                  : Sizes.width * 0.11),
                          alignment: Alignment.center,
                          child: child),
                    ])
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Sizes.width * 0.04),
                      child: child,
                    ),
            )
          ],
        ));
  }
}
