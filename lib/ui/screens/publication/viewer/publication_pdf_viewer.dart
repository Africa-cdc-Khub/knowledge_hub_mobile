import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
// import 'package:pdfx/pdfx.dart';

class PublicationPdfViewer extends StatefulWidget {
  final String pdfUrl;

  const PublicationPdfViewer({super.key, required this.pdfUrl});

  @override
  State<PublicationPdfViewer> createState() => _PublicationPdfViewerState();
}

class _PublicationPdfViewerState extends State<PublicationPdfViewer> {
  String? localFilePath;
  // late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    // _pdfController = PdfControllerPinch(
    //   document: PdfDocument.openFile(widget.pdfUrl),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: appBarText(context, 'View Publication'),
      ),
      body: Container() // SfPdfViewer.network(widget.pdfUrl),
    );
  }
}
