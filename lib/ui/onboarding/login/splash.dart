import 'package:autowheel_workshop/utils/components/library.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Preference.getBool(PrefKeys.userstatus) == false
          ? pushNdRemove(const WalkThrough())
          : pushNdRemove(MultiProvider(
              providers: [
                ChangeNotifierProvider<Classvaluechange>(
                    create: (_) => Classvaluechange()),
                ChangeNotifierProvider(create: (context) => MenuControlle())
              ],
              child: const FullScreen(),
            ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colWhite,
      body: Center(
        child: Image.asset(
          Images.logomain,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
