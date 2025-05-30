// ignore_for_file: file_names, deprecated_member_use

import 'package:autowheel_workshop/utils/components/library.dart';

class FullScreen extends StatefulWidget {
  const FullScreen({super.key});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return Consumer<Classvaluechange>(builder: (context, cangedclass, child) {
      return WillPopScope(
          onWillPop: () async {
            final DateTime now = DateTime.now();
            const Duration backButtonPressDelay = Duration(seconds: 2);

            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) > backButtonPressDelay) {
              currentBackPressTime = now;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 0,
                  content: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColor.colWhite,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Press again to exit',
                          style: TextStyle(color: AppColor.colBlack))),
                  duration: backButtonPressDelay,
                  backgroundColor: Colors.transparent,
                ),
              );
              return false;
            }
            return true;
          },
          child: Scaffold(
              key: context.read<MenuControlle>().scaffoldKey,
              drawer: const SideMenu(),
              body: SafeArea(
                child: Row(
                  children: [
                    if (Responsive.isDesktop(context))
                      const Expanded(child: SideMenu()),
                    Expanded(flex: 4, child: klass)
                  ],
                ),
              )));
    });
  }
}
