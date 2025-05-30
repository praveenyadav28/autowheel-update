// Staff Provider Class
import 'package:autowheel_workshop/utils/components/library.dart';

class StaffProvider extends ChangeNotifier {
  List<Map<String, dynamic>> deginationList = [];
  List staffList = [];

  StaffProvider() {
    fetchDeginationData();
    fetchStaff();
  }

  Future<void> fetchDeginationData() async {
    await fetchDataByMiscTypeId(
      28,
      deginationList,
    );
    notifyListeners();
  }

  Future<void> fetchStaff() async {
    var response = await ApiService.fetchData(
        "MasterAW/GetStaffDetailsLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}");
    staffList = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  Future<void> deleteStaff(int staffId) async {
    var response =
        await ApiService.postData("MasterAW/DeleteStaffByIdAW?Id=$staffId", {});
    if (response['status'] == false) {
      throw Exception(response['message']);
    } else {
      fetchStaff();
    }
  }
}
