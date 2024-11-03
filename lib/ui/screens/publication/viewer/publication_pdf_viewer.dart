import 'package:flutter/material.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PublicationPdfViewer extends StatefulWidget {
  final String pdfUrl;

  const PublicationPdfViewer({super.key, required this.pdfUrl});

  @override
  State<PublicationPdfViewer> createState() => _PublicationPdfViewerState();
}

class _PublicationPdfViewerState extends State<PublicationPdfViewer> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
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
      body: SfPdfViewer.network(widget.pdfUrl),
    );
  }
}
