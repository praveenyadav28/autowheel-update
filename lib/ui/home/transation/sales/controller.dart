import 'package:autowheel_workshop/utils/components/library.dart';

class InvoiceModel with ChangeNotifier {
  final List<Map<String, dynamic>> _labours = [];
  final List<Map<String, dynamic>> _parts = [];

  List<Map<String, dynamic>> get labours => _labours;
  List<Map<String, dynamic>> get parts => _parts;

  void addLabour(Map<String, dynamic> labour) {
    _labours.add(labour);
    notifyListeners();
  }

  void addPart(Map<String, dynamic> part) {
    _parts.add(part);
    notifyListeners();
  }

  void clearData() {
    _labours.clear();
    _parts.clear();
    // notifyListeners();
  }
}
