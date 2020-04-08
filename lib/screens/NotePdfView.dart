import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';

class NotePdfView extends StatefulWidget {
  var pdfPath;
  NotePdfView(this.pdfPath);
  @override
  State<StatefulWidget> createState() {
    return _NotePdfView();
  }
}

class _NotePdfView extends State<NotePdfView> {
  bool pdfReady = false;
  int totalPages = 0;
  int currentPage = 0;
  PDFViewController pdfViewController;
  @override
  Widget build(BuildContext context) {
    print('pdf path ${widget.pdfPath.toString()}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
        backgroundColor: Colors.black.withOpacity(0.95),
      ),
      floatingActionButton: Row(
        children: <Widget>[
          currentPage > 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    currentPage -= 1;
                    pdfViewController.setPage(currentPage);
                  },
                  label: Text('Next'))
              : Offstage(),
          currentPage < totalPages
              ? FloatingActionButton.extended(
                  onPressed: () {
                    currentPage += 1;
                    pdfViewController.setPage(currentPage);
                  },
                  label: Text('Previous'))
              : Offstage()
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.pdfPath,
            onRender: (_pages) {
              setState(() {
                totalPages = _pages;
                pdfReady = true;
                print('pdf ready');
              });
            },
            onViewCreated: (PDFViewController vc) {
              pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
          ),
          pdfReady ? Offstage() : CircularProgressIndicator()
        ],
      ),
    );
  }
}
