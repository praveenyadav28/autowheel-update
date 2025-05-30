// ignore_for_file: unrelated_type_equality_checks
import 'package:autowheel_workshop/utils/components/library.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColor.colPrimary),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Preference.preferences = await SharedPreferences.getInstance();
  Preference.getBool(PrefKeys.userstatus);
  runApp(
    ChangeNotifierProvider(
      create: (context) => InvoiceModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Sizes.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      title: 'AutoWheel Workshop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.colBlack),
        useMaterial3: false,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<Classvaluechange>(
            create: (_) => Classvaluechange(),
          ),
          ChangeNotifierProvider(create: (context) => MenuControlle()),
          ChangeNotifierProvider(create: (context) => StaffProvider()),
        ],
        child: const Splash(),
      ),
    );
  }

  Future<List<ConnectivityResult>> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult;
  }
}
