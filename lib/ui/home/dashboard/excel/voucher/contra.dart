import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:excel/excel.dart';

Future<void> createExcelContra(dataList) async {
  var excel = Excel.createExcel();
  var sheet = excel.sheets[excel.getDefaultSheet()];

  // Add headers
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
      TextCellValue('CV Number');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
      TextCellValue('CV Date');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
      TextCellValue('From Ledger');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
      TextCellValue('To Ledger');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
      TextCellValue('Amount');
  sheet?.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
      TextCellValue('Remark');
  // Add data rows
  int rowIndex = 1;
  for (var data in dataList) {
    sheet!
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .value = TextCellValue("${data['voucher_No']}");
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .value = TextCellValue(data['tran_Date']);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .value = TextCellValue(data['voucher_Mode']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
        .value = TextCellValue(data['ledger_Name']);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
        .value = TextCellValue(data['debitAmount']);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
        .value = TextCellValue(data['remarks'] ?? '');
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
