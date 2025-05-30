// ignore_for_file: avoid_print

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseurl = "http://lms.muepetro.com/api";

  static Future fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseurl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseurl/$endpoint'),
        headers: {
          'Content-Type': 'application/json', // Specify content-type
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}

//api mismaster
Future<void> fetchDataByMiscTypeId(
    int miscTypeId, List<Map<String, dynamic>> listToUpdate) async {
  try {
    final data = await ApiService.fetchData(
        "MasterAW/GetMiscMasterFixed?MiscTypeId=$miscTypeId");
    final List<Goruppartmodel> goruppartmodelList =
        grouppartmodelFromJson(jsonEncode(data));

    listToUpdate.clear();
    for (var item in goruppartmodelList) {
      listToUpdate.add({
        'id': item.id, // Provide a default value for null id
        'name': item.name, // Provide a default value for null name
      });
    }
  } catch (e) {
    // Handle error if needed
    print('Failed to load data: $e');
  }
}

Future<void> fetchDataByMiscAdd(
    int miscTypeId, List<Map<String, dynamic>> listToUpdate) async {
  try {
    final data = await ApiService.fetchData(
        "MasterAW/GetMiscMasterLocationWiseAW?LocationId=${Preference.getString(PrefKeys.locationId)}&MiscTypeId=$miscTypeId");
    final List<Goruppartmodel> goruppartmodelList =
        grouppartmodelFromJson(jsonEncode(data));

    listToUpdate.clear();
    for (var item in goruppartmodelList) {
      listToUpdate.add({
        'id': item.id, // Provide a default value for null id
        'name': item.name, // Provide a default value for null name
      });
    }
  } catch (e) {
    // Handle error if needed
    print('Failed to load data: $e');
  }
}
