// ignore_for_file: unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:autowheel_workshop/utils/components/library.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
    checkConnectivityAndNavigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UH-OH\nSomething went wrong.',
                style: rubikTextStyle(18, FontWeight.w500, AppColor.colBlack),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                checkConnectivityAndNavigate(context);
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  void checkConnectivityAndNavigate(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.toString() != [ConnectivityResult.none].toString()) {
      var status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        pushNdRemove(const Splash());
      }
    }
  }
}
