import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePage extends StatelessWidget {
  final String customerName;
  final String customerMobile;
  final String account;
  final String dollar;
  final double rate;
  final double amount;
  final String paymentMethod;
  final DateTime transactionDate;
  final File? paymentScreenshot;

  final GlobalKey _invoiceKey = GlobalKey();

  InvoicePage({
    super.key,
    required this.customerName,
    required this.customerMobile,
    required this.account,
    required this.dollar,
    required this.rate,
    required this.amount,
    required this.paymentMethod,
    required this.transactionDate,
    this.paymentScreenshot,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(transactionDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _printInvoice(context),
          )
        ],
      ),
      body: RepaintBoundary(
        key: _invoiceKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    const Text("MOHASAGOR IT Solutions",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("House-08 (5th floor), Mirpur-10, Dhaka"),
                    const Text("Mobile: +8801814801801"),
                    const Text("boost.mohasagorit.solutions"),
                    const SizedBox(height: 16),
                    Text("Invoice",
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Customer Info
              Text("Customer: $customerName"),
              Text("Mobile: $customerMobile"),
              const Text("Status: Completed"),
              Text("Date: $formattedDate"),

              const Divider(height: 32),

              // Account info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Account"),
                  Text("Quantity"),
                  Text("Unit Price"),
                  Text("Subtotal"),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(account),
                  Text("$dollar \$"),
                  Text("$rate ৳"),
                  Text("$amount ৳"),
                ],
              ),

              const Divider(height: 32),

              // Transaction details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Transaction Details:"),
                      Text("Payment Method: $paymentMethod"),
                      Text("Date: $formattedDate"),
                      Text("Amount: $amount ৳"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Total: $amount ৳",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),

              const Divider(height: 32),

              // Payment Screenshot
              if (paymentScreenshot != null) ...[
                const Text("Payment Screenshot:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    paymentScreenshot!,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const Divider(height: 32),
              ],

              // Total

            ],
          ),
        ),
      ),
    );
  }

  /// Capture Invoice Widget and generate PDF
  Future<void> _printInvoice(BuildContext context) async {
    try {
      // capture widget as image
      RenderRepaintBoundary boundary =
      _invoiceKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // create PDF with captured image
      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
          ),
        ),
      );

      // show print / save dialog
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } catch (e) {
      debugPrint("Error printing invoice: $e");
    }
  }
}
