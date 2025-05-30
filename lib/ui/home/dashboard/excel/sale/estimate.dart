import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:excel/excel.dart';

Future<void> createExcelEstimate(dataList) async {
  var excel = Excel.createExcel();
  var sheet = excel.sheets[excel.getDefaultSheet()];

  // Add headers
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
      TextCellValue('Doc No.');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
      TextCellValue('Doc Date');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
      TextCellValue('Customer Name');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
      TextCellValue('Party Name');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
      TextCellValue('Vehicle No.');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
      TextCellValue('Model Name');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value =
      TextCellValue('Phone No.');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value =
      TextCellValue('Taxable');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0)).value =
      TextCellValue('Other Charge');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0)).value =
      TextCellValue('GST');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0)).value =
      TextCellValue('Net Amount');

  // Add data rows
  int rowIndex = 1;
  for (var data in dataList) {
    sheet!
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .value = TextCellValue("${data['doc_No']}");
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .value = TextCellValue(data['doc_Date']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .value = TextCellValue(data['customer_Name']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
        .value = TextCellValue(data['party_Name']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
        .value = TextCellValue(data['vehicle_No']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
        .value = TextCellValue(data['model_Name']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
        .value = TextCellValue(data['mob']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
        .value = TextCellValue(data['taxable_Amount']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
        .value = TextCellValue(data['other_Charge']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
        .value = TextCellValue(data['gst']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
        .value = TextCellValue(data['net_Amount']);
    rowIndex++;
  }

  var bytes = excel.encode();
  if (kIsWeb) {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes!)}')
      ..setAttribute('download', 'Output.xlsx')
      ..click();
  } else if (Platform.isAndroid) {
    var i = DateTime.now();
    var directory = await getApplicationDocumentsDirectory();

    var file = File("${directory.path}/Output$i.xlsx");
    await file.writeAsBytes(bytes!);

    await OpenFile.open(file.path);
  } else {
    var directory = await getApplicationDocumentsDirectory();

    var file = File("${directory.path}/Output.xlsx");
    await file.writeAsBytes(bytes!);

    await OpenFile.open(file.path);
  }
}
