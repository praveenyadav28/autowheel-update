// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePaymentPDF(
  int status,
  Map<String, dynamic> companyDetails,
  Map<String, dynamic> paymentDetails,
) async {
  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }

  Uint8List imageBytes = decodeBase64Image(companyDetails['bLogoPath']);

  final pdf = pw.Document();
  // Define page size and orientation
  const pageFormat = PdfPageFormat.a4;

  String amountInWords =
      NumberToWords.convert(int.parse(paymentDetails['cash_Amount'] ?? "0"));
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
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
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
                    status == 3
                        ? "INCOME VOUCHER"
                        : status == 2
                            ? "EXPANSES VOUCHER"
                            : status == 0
                                ? 'PAYMENT VOUCHER'
                                : "RECIEPT",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center),
                pw.Container(
                    height: 1,
                    width: double.infinity,
                    color: PdfColors.black,
                    margin: const pw.EdgeInsets.only(top: 2)),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          flex: 7,
                          child: pw.Column(children: [
                            pw.Row(children: [
                              pw.Expanded(
                                  flex: 3,
                                  child: pw.Column(children: [
                                    pw.Container(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      width: double.infinity,
                                      height: 25,
                                      child: pw.Text(
                                        status == 3 || status == 2
                                            ? "Expences With Thanks From"
                                            : status == 0
                                                ? 'Payment With Thanks From'
                                                : "Received With Thanks From",
                                      ),
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                              bottom: pw.BorderSide(
                                                  color: PdfColors.black))),
                                    ),
                                    pw.Container(
                                      width: double.infinity,
                                      height: 35,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        "   ${paymentDetails['ledger_Name']}",
                                        style: pw.TextStyle(
                                            fontSize: 17,
                                            fontWeight: pw.FontWeight.bold),
                                      ),
                                    )
                                  ])),
                              pw.Container(
                                  width: 1, height: 62, color: PdfColors.black),
                              pw.Expanded(
                                  child: pw.Text(
                                      "Cheque Payment is Subject To Realisatin",
                                      textAlign: pw.TextAlign.center))
                            ]),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              alignment: pw.Alignment.centerLeft,
                              width: double.infinity,
                              height: 40,
                              child: pw.Text("Amount in Words: $amountInWords"),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top:
                                          pw.BorderSide(color: PdfColors.black),
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black))),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              alignment: pw.Alignment.centerLeft,
                              width: double.infinity,
                              height: 40,
                              child: pw.Text(
                                  "Description : ${paymentDetails['other1']}"),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black))),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              width: double.infinity,
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              height: 40,
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                        "Payment By: ${paymentDetails['mode']}"),
                                    status == 2 || status == 3
                                        ? pw.Text(
                                            "Payment Mode: ${paymentDetails['particular']}")
                                        : pw.Row(
                                            children: [
                                              pw.Expanded(
                                                  child: pw.Text(
                                                      "Cheque/Draft No: ${paymentDetails['cheque_No']}",
                                                      textAlign:
                                                          pw.TextAlign.start)),
                                              status == 0
                                                  ? pw.SizedBox(width: 0)
                                                  : pw.Expanded(
                                                      child: pw.Text(
                                                          "Date: ${paymentDetails['cheque_Date']}",
                                                          textAlign: pw
                                                              .TextAlign
                                                              .start)),
                                            ],
                                          ),
                                  ]),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black))),
                            ),
                          ])),
                      pw.Container(
                          width: 1, height: 181, color: PdfColors.black),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Column(children: [
                            pw.Column(children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                width: double.infinity,
                                height: 26,
                                child: pw.Text(
                                    "REF. NO./  ${status == 3 ? paymentDetails['iv_no'] : status == 2 ? paymentDetails['ev_No'] : status == 0 ? paymentDetails['pv_No'] : paymentDetails['rv_No']}"),
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(
                                            color: PdfColors.black))),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                width: double.infinity,
                                alignment: pw.Alignment.centerLeft,
                                height: 36,
                                child: pw.Text(status == 3
                                    ? "DATE : ${paymentDetails['iDate']}"
                                        .substring(0,
                                            paymentDetails['iDate'].length - 4)
                                    : status == 2
                                        ? "DATE : ${paymentDetails['eDate']}"
                                            .substring(
                                                0,
                                                paymentDetails['eDate'].length -
                                                    4)
                                        : status == 0
                                            ? "DATE : ${paymentDetails['payment_Date']}"
                                                .substring(
                                                    0,
                                                    paymentDetails[
                                                                'payment_Date']
                                                            .length -
                                                        4)
                                            : "DATE : ${paymentDetails['receipt_Date']}"
                                                .substring(
                                                    0,
                                                    paymentDetails[
                                                                'receipt_Date']
                                                            .length -
                                                        4)),
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(
                                            color: PdfColors.black))),
                              ),
                            ]),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              width: double.infinity,
                              alignment: pw.Alignment.centerLeft,
                              height: 45,
                              child: pw.Text(
                                  "Rs: ${paymentDetails['cash_Amount'] ?? '0.00'}"),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black))),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              width: double.infinity,
                              height: 75,
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                      "For ${companyDetails['location_Name']}",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      "Authorised Signatory",
                                      style: const pw.TextStyle(fontSize: 12),
                                    ),
                                  ]),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black))),
                            ),
                          ])),
                    ])
              ]))));

  // Save the PDF to the device
  final output = await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );

  final file = File('invoice.pdf');
  await file.writeAsBytes(await pdf.save());
}
