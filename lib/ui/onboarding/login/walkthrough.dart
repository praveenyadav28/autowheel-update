import 'package:autowheel_workshop/utils/components/library.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({super.key});

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<String> imagePaths = [
    Images.walkthrough1,
    Images.walkthrough2,
    Images.walkthrough3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingScreen(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: Sizes.height - 90 - Sizes.height * .26,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    children: List.generate(
                      imagePaths.length,
                      (index) => buildPage(index),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imagePaths.length,
                (index) => buildIndicator(index),
              ),
            ),
            SizedBox(height: Sizes.height * 0.02),
            button('Use Trail Version', AppColor.colPrimary, onTap: () {
              pushTo(const SignUp());
            }),
            SizedBox(height: Sizes.height * 0.02),
            button('Already had a License', AppColor.colPrimary, onTap: () {
              pushTo(const Login());
            }),
            SizedBox(height: Sizes.height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget buildPage(int index) {
    return Image.asset(imagePaths[index]);
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentPage == index ? AppColor.colPrimary : AppColor.colGrey,
      ),
    );
  }
}
