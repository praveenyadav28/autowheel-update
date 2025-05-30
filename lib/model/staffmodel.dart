import 'package:autowheel_workshop/utils/components/library.dart';

List<Staffmodel> staffmodelFromJson(String str) =>
    List<Staffmodel>.from(json.decode(str).map((x) => Staffmodel.fromJson(x)));

String staffmodelToJson(List<Staffmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Staffmodel {
  final int id;
  final String staffName;

  Staffmodel({
    required this.id,
    required this.staffName,
  });

  factory Staffmodel.fromJson(Map<String, dynamic> json) => Staffmodel(
        id: json["id"],
        staffName: json["staff_Name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "staff_Name": staffName,
      };
}
