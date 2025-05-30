// ignore_for_file: file_names

import 'package:autowheel_workshop/utils/components/library.dart';

class MenuControlle extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }
}

dynamic klass = const HomePageScreen();

class Classvaluechange extends ChangeNotifier {
  onChanged(Object? cangedclass, BuildContext context) {
    klass = cangedclass;
    notifyListeners();
    !Responsive.isDesktop(context) ? Navigator.pop(context) : null;
  }

  onLogout(context) {
    onChanged(const HomePageScreen(), context);
  }
}
