// ignore_for_file: must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

Widget addMasterOutside({
  required List<Widget> children,
  required BuildContext context,
}) {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio:
        (Responsive.isMobile(context))
            ? Sizes.width >= 450
                ? 8
                : Sizes.width <= 450
                ? 6
                : 7
            : (Responsive.isTablet(context))
            ? Sizes.width >= 800
                ? 5
                : Sizes.width <= 700
                ? 5
                : 6
            : 5,
    shrinkWrap: true,
    crossAxisSpacing: Sizes.width * 0.02,
    crossAxisCount:
        (Responsive.isMobile(context))
            ? 1
            : (Responsive.isTablet(context))
            ? Sizes.width >= 800
                ? 3
                : 2
            : 3,
    children: children,
  );
}

Widget addMasterOutside4({
  required List<Widget> children,
  required BuildContext context,
}) {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio:
        Sizes.width < 600
            ? Sizes.width >= 450
                ? 6
                : Sizes.width <= 450
                ? 4
                : 6
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3.2
                : 4
            : 4,
    shrinkWrap: true,
    crossAxisSpacing: Sizes.width * 0.03,
    mainAxisSpacing: Sizes.height * .02,
    crossAxisCount:
        Sizes.width < 600
            ? 1
            : Sizes.width < 1100 && Sizes.width >= 600
            ? Sizes.width >= 800
                ? 3
                : 2
            : 4,
    children: children,
  );
}
