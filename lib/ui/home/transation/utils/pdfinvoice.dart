// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateInvoicePDF(int status, Map<String, dynamic> invoiceDetails,
    Map<String, dynamic> companyDetails, Map<String, dynamic> ledgerDetails,
    {String modalName = ''}) async {
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  Uint8List imageBytes = decodeBase64Image(companyDetails['bLogoPath']);

  final pdf = pw.Document();
  // Define page size and orientation
  const pageFormat = PdfPageFormat.a4;

  // Create a table for item descriptions
  final List<String> headers = [
    'S.N.',
    'ITEM DESCRIPTIONS',
    'HSN',
    'Qty',
    'Price',
    'Dis.%',
    'Discount',
    'GST Rate',
    'GST Amount',
    'Taxable'
  ];

  final List<dynamic> jsonData = status == 6
      ? invoiceDetails['saleReturn_Items']
      : status == 5
          ? invoiceDetails['purchaseReturn_Items']
          : status == 4
              ? invoiceDetails['estimate_Items']
              : status == 3
                  ? invoiceDetails['purchase_Invoice_Items']
                  : status == 1
                      ? invoiceDetails['jobCard_Items']
                      : invoiceDetails['sale_Invoice_Items'];

  final List<List> tableRows = jsonData.map((item) {
    return [
      (jsonData.indexOf(item) + 1).toString(), // S.N.
      item['item_Name'] ?? '', // ITEM DESCRIPTIONS
      item['hsn_Code'] ?? '', // HSN
      status == 3 || status == 5 ? item['quantity'] : item['qty'] ?? '', // Qty
      status == 3 || status == 5
          ? item['ndpPrice']
          : item['sale_Price'] ?? '', // Price
      item['discount_Item'] ?? '0.00', // Dis.%
      '0.00', // Discount
      item['gst'] ?? '', // GST Rate
      double.parse(status == 3 || status == 5
              ? item['gstAmount'] ?? "0"
              : item['gst_Amount'] ?? "0")
          .toStringAsFixed(2), // GST Amount
      item['taxable'] ?? '', // Taxable
    ];
  }).toList();

  final List<List> gstRows = jsonData.map((item) {
    return [
      "${item['gst']} %", // GST
      item['taxable'] ?? '', // Taxable
      double.parse(status == 3 || status == 5
              ? item['gstAmount'] ?? "0"
              : item['gst_Amount'] ?? "0")
          .toStringAsFixed(2), // Qty
      "${item['igstAmount']}", // iGST
      "${item['cgstAmount']}", // cGST
      "${item['sgstAmount']}", // sGSt                                                                                                                                                                                                                                                                            GST
    ];
  }).toList();

  // Define totals and summary
  String otherAmount = status == 3 || status == 5
      ? invoiceDetails['other_Charge']
      : status == 2
          ? invoiceDetails['other_Charge']
          : "0";
  String totalsonData = status == 3 || status == 5
      ? "0"
      : status == 1
          ? invoiceDetails['jobCard_Items']
              .fold(0.0, (sum, map) => sum + double.parse(map['labour']))
              .toStringAsFixed(2)
          : status == 4
              ? invoiceDetails['estimate_Items']
                  .fold(0.0, (sum, map) => sum + double.parse(map['labour']))
                  .toStringAsFixed(2)
              : status == 6
                  ? invoiceDetails["saleReturn_Items"]
                      .fold(
                          0.0, (sum, map) => sum + double.parse(map['labour']))
                      .toStringAsFixed(2)
                  : invoiceDetails["sale_Invoice_Items"]
                      .fold(
                          0.0, (sum, map) => sum + double.parse(map['labour']))
                      .toStringAsFixed(2);
  String igst = status == 5
      ? invoiceDetails['purchaseReturn_Items']
          .fold(
              0.0,
              (sum, map) =>
                  sum + (map['igstAmount'] * double.parse(map['quantity'])))
          .toStringAsFixed(2)
      : status == 3
          ? invoiceDetails['purchase_Invoice_Items']
              .fold(
                  0.0,
                  (sum, map) =>
                      sum + (map['igstAmount'] * double.parse(map['quantity'])))
              .toStringAsFixed(2)
          : status == 1
              ? invoiceDetails['jobCard_Items']
                  .fold(
                      0.0,
                      (sum, map) =>
                          sum + (map['igstAmount'] * double.parse(map['qty'])))
                  .toStringAsFixed(2)
              : status == 4
                  ? invoiceDetails['estimate_Items']
                      .fold(
                          0.0,
                          (sum, map) =>
                              sum +
                              (map['igstAmount'] * double.parse(map['qty'])))
                      .toStringAsFixed(2)
                  : status == 6
                      ? invoiceDetails["saleReturn_Items"]
                          .fold(
                              0.0,
                              (sum, map) =>
                                  sum +
                                  (map['igstAmount'] *
                                      double.parse(map['qty'])))
                          .toStringAsFixed(2)
                      : invoiceDetails["sale_Invoice_Items"]
                          .fold(
                              0.0, (sum, map) => sum + (map['igstAmount'] * double.parse(map['qty'])))
                          .toStringAsFixed(2);
  String sgst = status == 5
      ? invoiceDetails['purchaseReturn_Items']
          .fold(
              0.0,
              (sum, map) =>
                  sum + (map['sgstAmount'] * double.parse(map['quantity'])))
          .toStringAsFixed(2)
      : status == 3
          ? invoiceDetails['purchase_Invoice_Items']
              .fold(
                  0.0,
                  (sum, map) =>
                      sum + (map['sgstAmount'] * double.parse(map['quantity'])))
              .toStringAsFixed(2)
          : status == 1
              ? invoiceDetails['jobCard_Items']
                  .fold(
                      0.0,
                      (sum, map) =>
                          sum + (map['sgstAmount'] * double.parse(map['qty'])))
                  .toStringAsFixed(2)
              : status == 4
                  ? invoiceDetails['estimate_Items']
                      .fold(
                          0.0,
                          (sum, map) =>
                              sum +
                              (map['sgstAmount'] * double.parse(map['qty'])))
                      .toStringAsFixed(2)
                  : status == 6
                      ? invoiceDetails["saleReturn_Items"]
                          .fold(
                              0.0,
                              (sum, map) =>
                                  sum +
                                  (map['sgstAmount'] *
                                      double.parse(map['qty'])))
                          .toStringAsFixed(2)
                      : invoiceDetails["sale_Invoice_Items"]
                          .fold(
                              0.0, (sum, map) => sum + (map['sgstAmount'] * double.parse(map['qty'])))
                          .toStringAsFixed(2);
  String cgst = status == 5
      ? invoiceDetails['purchaseReturn_Items']
          .fold(
              0.0,
              (sum, map) =>
                  sum + (map['cgstAmount'] * double.parse(map['quantity'])))
          .toStringAsFixed(2)
      : status == 3
          ? invoiceDetails['purchase_Invoice_Items']
              .fold(
                  0.0,
                  (sum, map) =>
                      sum + (map['cgstAmount'] * double.parse(map['quantity'])))
              .toStringAsFixed(2)
          : status == 1
              ? invoiceDetails['jobCard_Items']
                  .fold(
                      0.0,
                      (sum, map) =>
                          sum + (map['cgstAmount'] * double.parse(map['qty'])))
                  .toStringAsFixed(2)
              : status == 4
                  ? invoiceDetails['estimate_Items']
                      .fold(
                          0.0,
                          (sum, map) =>
                              sum +
                              (map['cgstAmount'] * double.parse(map['qty'])))
                      .toStringAsFixed(2)
                  : status == 6
                      ? invoiceDetails['saleReturn_Items']
                          .fold(
                              0.0,
                              (sum, map) =>
                                  sum +
                                  (map['cgstAmount'] *
                                      double.parse(map['qty'])))
                          .toStringAsFixed(2)
                      : invoiceDetails['sale_Invoice_Items']
                          .fold(
                              0.0, (sum, map) => sum + (map['cgstAmount'] * double.parse(map['qty'])))
                          .toStringAsFixed(2);
  String totalQty = ((status == 5
          ? invoiceDetails['purchaseReturn_Items']
          : status == 3
              ? invoiceDetails['purchase_Invoice_Items']
              : status == 1
                  ? invoiceDetails['jobCard_Items']
                  : status == 4
                      ? invoiceDetails['estimate_Items']
                      : status == 6
                          ? invoiceDetails['saleReturn_Items']
                          : invoiceDetails['sale_Invoice_Items']) as List)
      .length
      .toString();
  String taxableAmount = status == 1
      ? invoiceDetails['jobCard_Items']
          .fold(
              0.0,
              (sum, map) =>
                  sum +
                  (double.parse(map['sale_Price']) * double.parse(map['qty'])))
          .toString()
      : status == 3 || status == 5
          ? invoiceDetails['gross_Amount'] ?? "0"
          : status == 4
              ? invoiceDetails['gross_Amount'] ?? "0"
              : invoiceDetails['taxable_Amount'] ?? "0";
  double netAmount = status == 1
      ? invoiceDetails['jobCard_Items']
          .fold(0.0, (sum, map) => sum + double.parse(map['total_Price']))
      : double.parse(invoiceDetails['net_Amount'].toString());
  int netAmountInt = netAmount.toInt();
  String amountInWords = NumberToWords.convert(netAmountInt);
  // Add the invoice to the PDF document
  pdf.addPage(pw.Page(
    pageFormat: pageFormat,
    margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    build: (context) => pw.Container(
      decoration:
          pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                                'GSTIN : ${companyDetails['bgstinno']}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.start)),
                        pw.Expanded(
                            flex: 5,
                            child: pw.Text(
                                'SUBJECT TO ${companyDetails['bJuridiction']} JURISDICTION',
                                textAlign: pw.TextAlign.center)),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Text('Original Copy',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.end)),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(pw.MemoryImage(imageBytes),
                            width: 100, height: 60),
                        pw.Column(
                          children: [
                            pw.Text(companyDetails['location_Name'],
                                style: pw.TextStyle(
                                    fontSize: 24,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text(companyDetails['description']),
                            pw.Text(companyDetails['address1']),
                            pw.Text(
                                'Phone: ${companyDetails['contact_No']}, Email: ${companyDetails['bEmailId']}'),
                          ],
                        ),
                        pw.Image(pw.MemoryImage(imageBytes),
                            width: 100, height: 60),
                      ],
                    ),
                  ])),
          pw.Container(
              height: 1,
              width: double.infinity,
              color: PdfColors.black,
              margin: const pw.EdgeInsets.only(bottom: 2)),
          pw.Text(
              status == 6
                  ? "Sale Return"
                  : status == 5
                      ? "Purchase Return"
                      : status == 3
                          ? "Purchase Invoice"
                          : status == 1
                              ? 'Jobcard'
                              : status == 4
                                  ? 'Estimate'
                                  : 'TAX INVOICE',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center),
          pw.Container(
              height: 1,
              width: double.infinity,
              color: PdfColors.black,
              margin: const pw.EdgeInsets.only(top: 2)),
          // Party Details and Invoice Information
          pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                      child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Party Details:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('NAME'),
                            pw.Text('ADDRESS'),
                            pw.Text('PHONE'),
                            pw.Text('GSTIN No.'),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Details',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white)),
                            pw.Text(
                                ':  ${status == 2 || status == 4 ? invoiceDetails['party_Name'] : ledgerDetails['name']}'),
                            pw.Text(
                                ':  ${status == 2 || status == 4 ? invoiceDetails['address'] : ledgerDetails['address']}'),
                            pw.Text(
                                ':  ${status == 2 || status == 4 ? invoiceDetails['mob'] : ledgerDetails['mob']}'),
                            pw.Text(
                                ':  ${status == 2 || status == 4 ? "" : ledgerDetails['gst_No']}'),
                          ],
                        ),
                      ])),
                  pw.Container(
                      width: 1,
                      height: 100,
                      color: PdfColors.black,
                      margin: const pw.EdgeInsets.symmetric(horizontal: 10)),
                  pw.Expanded(
                      child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            status == 1
                                ? pw.Container()
                                : status == 5
                                    ? pw.Text("Purchase Return No.")
                                    : status == 4
                                        ? pw.Text("Doc No.")
                                        : status == 6
                                            ? pw.Text('Sale Rtn No.')
                                            : pw.Text('Invoice No.'),
                            pw.Text('Sale Rtn Date'),
                            status == 3 || status == 5
                                ? pw.Container()
                                : status == 6
                                    ? pw.Text('Sale Inv No.')
                                    : pw.Text('Model'),
                            status == 3 || status == 5
                                ? pw.Container()
                                : status == 6
                                    ? pw.Text('Sale Inv Date')
                                    : pw.Text('Vehicle No.'),
                            status == 3 ||
                                    status == 4 ||
                                    status == 5 ||
                                    status == 6
                                ? pw.Container()
                                : pw.Text('K.M.'),
                            status == 1 ? pw.Text('Job No.') : pw.Container(),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            status == 1
                                ? pw.Container()
                                : pw.Text(
                                    ':  ${status == 5 || status == 6 ? invoiceDetails['pRtn'] : status == 3 ? invoiceDetails['pInvo'] : status == 4 ? invoiceDetails['doc_No'] : invoiceDetails['invoice_No']}'),
                            pw.Text(
                                ':  ${status == 5 || status == 6 ? invoiceDetails['pRtn_Date'] : status == 3 ? invoiceDetails['pInvo_Date'] : status == 1 ? invoiceDetails['job_Date'] : status == 4 ? invoiceDetails['doc_Date'] : invoiceDetails['invoice_Date']}'),
                            status == 3 || status == 5
                                ? pw.Container()
                                : status == 6
                                    ? pw.Text(':  ${invoiceDetails['pInvo']}')
                                    : pw.Text(
                                        ':  ${status == 1 ? modalName : invoiceDetails['model_Name']}'),
                            status == 3 || status == 5
                                ? pw.Container()
                                : status == 6
                                    ? pw.Text(
                                        ':  ${invoiceDetails['pInvo_Date']}')
                                    : pw.Text(
                                        ':  ${status == 1 ? invoiceDetails['vehicle_No'] : invoiceDetails['vehicle_No']}'),
                            status == 3 ||
                                    status == 4 ||
                                    status == 5 ||
                                    status == 6
                                ? pw.Container()
                                : pw.Text(
                                    ':  ${status == 1 ? invoiceDetails['kms'] : invoiceDetails['a']}'),
                            status == 1
                                ? pw.Text(':  ${invoiceDetails['job_No']}')
                                : pw.Container(),
                          ],
                        ),
                      ])),
                ],
              )),
          // Item Description Table
          pw.Table.fromTextArray(
            headers: headers,
            data: tableRows,
            cellAlignment: pw.Alignment.center,
            border: const pw.TableBorder(
              top: pw.BorderSide(color: PdfColors.black),
              left: pw.BorderSide(color: PdfColors.black),
              right: pw.BorderSide(color: PdfColors.black),
              bottom: pw.BorderSide(color: PdfColors.black),
              verticalInside: pw.BorderSide(color: PdfColors.black),
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: const pw.TextStyle(fontSize: 7),
            cellPadding: const pw.EdgeInsets.all(5),
          ),
          pw.SizedBox(height: 5),
          pw.Row(children: [
            status == 1
                ? pw.SizedBox(width: 0, height: 0)
                : pw.Expanded(
                    child: pw.Text("Total Labour   : ",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 7))),
            pw.Expanded(
                child: pw.Text("Other Amount   : $otherAmount",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 7))),
            pw.Expanded(
                child: pw.Text("Total Quantity : $totalQty",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 7))),
            pw.Expanded(
                child: pw.Text("Taxble Amount  : $taxableAmount",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 7))),
          ]),
          pw.Container(
              height: 1,
              width: double.infinity,
              color: PdfColors.black,
              margin: const pw.EdgeInsets.only(top: 5)),
          // Totals Section
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Text("Amount in Words: $amountInWords",
                      textAlign: pw.TextAlign.center),
                  flex: 3),
              pw.Container(
                  width: 1,
                  height: 80,
                  color: PdfColors.black,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 10)),
              pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('IGST Amount'),
                      pw.Text('CGST Amount'),
                      pw.Text('SGST Amount'),
                      pw.Text('Discount'),
                    ],
                  )),
              pw.Container(
                  width: 1,
                  height: 80,
                  color: PdfColors.black,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 10)),
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(igst),
                    pw.Text(cgst),
                    pw.Text(sgst),
                    pw.Text('0.00'),
                  ],
                ),
              )
            ],
          ),
          pw.Container(
              height: 1, width: double.infinity, color: PdfColors.black),
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Text(
                    "  Remark : ",
                  ),
                  flex: 3),
              pw.Container(
                  width: 1,
                  height: 15,
                  color: PdfColors.black,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 10)),
              pw.Expanded(
                  flex: 1,
                  child: pw.Text('Total Amount',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Container(
                  width: 1,
                  height: 15,
                  color: PdfColors.black,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 10)),
              pw.Expanded(
                flex: 1,
                child: pw.Text('  $netAmount',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              )
            ],
          ),

          pw.Container(
              height: 1,
              width: double.infinity,
              color: PdfColors.black,
              margin: const pw.EdgeInsets.only(bottom: 5)),
          pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('  GST SUMMARY:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 10),
          // GST Summary Table
          pw.Table.fromTextArray(
            headers: [
              'GST Rate',
              'Taxable Value',
              'GST Amount',
              'IGST Amount',
              'CGST Amount',
              'SGST Amount'
            ],
            data: gstRows,
            cellAlignment: pw.Alignment.center,
            border: const pw.TableBorder(
              top: pw.BorderSide(color: PdfColors.black),
              left: pw.BorderSide(color: PdfColors.black),
              right: pw.BorderSide(color: PdfColors.black),
              bottom: pw.BorderSide(color: PdfColors.black),
              verticalInside: pw.BorderSide(color: PdfColors.black),
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: const pw.TextStyle(fontSize: 7),
            cellPadding: const pw.EdgeInsets.all(5),
          ),
          pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Terms and Conditions:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        '1. Payment by Cheque/DD/Pay Order in favour of our Company.'),
                    pw.Text(
                        '2. Delivery is subject to availability of Stock/Colour and Normal production schedule.'),
                    pw.Text(
                        '3. Prices are subject to change without prior information.'),
                    pw.Text(
                        '4. We declare that this invoice shows the actual price of the goods described and that all particulars are true and correct.'),
                    pw.SizedBox(height: 30),
                    // Signatures
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Customer Signature'),
                        pw.Text('Authorised Signature',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ])),
        ],
      ),
    ),
  ));

  // Save the PDF to the device
  final output = await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );

  final file = File('invoice.pdf');
  await file.writeAsBytes(await pdf.save());
}
