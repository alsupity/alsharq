import 'dart:io';
import 'package:alsharq/model/education_tool_model.dart';
import 'package:alsharq/util/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../util/launch_link.dart';
import '../util/widgets.dart';

class PdfReader extends StatefulWidget {
  final EducationToolModel educationToolModel;
  const PdfReader({super.key, required this.educationToolModel});

  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  PageNumberController pageNumberController = Get.put(PageNumberController());
  SearchInPdfController searchInPdfController =
      Get.put(SearchInPdfController());
  PdfViewerController pdfViewerController = PdfViewerController();
  PdfTextSearchResult searchResult = PdfTextSearchResult();
  TextEditingController _txtpagenumber = TextEditingController();
  TextEditingController txtSearchController = TextEditingController();
  bool isFirstPage = true;
  bool isLastPage = false;
  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 56,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 10,
          ),
          onPressed: () async {
            await Clipboard.setData(
                ClipboardData(text: details.selectedText ?? ""));
            pdfViewerController.clearSelection();
          },
          child: Text('Copy', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
    _overlayState!.insert(_overlayEntry!);
  }

  String fileUrl = "";

  @override
  void initState() {
    super.initState();
    fileUrl =
        "${AppConsts.baseUrl}${AppConsts.storageUrl}/${widget.educationToolModel.file}";
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<SearchInPdfController>(builder: (controller) {
          if (controller.isSearching == false) {
            return Text('PDF Reader');
          } else {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: txtSearchController,
                    onChanged: (value) {
                      controller.searchText = value;
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'بحث',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          searchResult = pdfViewerController
                              .searchText(txtSearchController.text);
                          searchResult.addListener(() {
                            if (searchResult.hasResult) {
                              print("searchResult.addListener");
                              controller.update();
                            }
                          });
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (searchResult.totalInstanceCount == 0)
                      ? null
                      : () {
                          searchResult.nextInstance();
                        },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Text(
                    "${searchResult.currentInstanceIndex}/${searchResult.totalInstanceCount}"),
                IconButton(
                  onPressed: (searchResult.totalInstanceCount == 0)
                      ? null
                      : () {
                          searchResult.previousInstance();
                        },
                  icon: Icon(Icons.arrow_forward_ios),
                ),
                IconButton(
                  onPressed: () {
                    txtSearchController.clear();
                    searchResult = pdfViewerController
                        .searchText(txtSearchController.text);
                    searchResult.clear();
                    controller.onChangeSearch(false);
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
            );
          }
        }),
        centerTitle: true,
        titleSpacing: 8,
        actions: [
          GetBuilder<SearchInPdfController>(builder: (controller) {
            if (controller.isSearching == false) {
              return Visibility(
                visible: false,
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    controller.onChangeSearch(true);
                  },
                ),
              );
            } else {
              return Text("");
            }
          }),
        ],
      ),
      body: FutureBuilder(
        future: DefaultCacheManager().getSingleFile(fileUrl),
        builder: (context, AsyncSnapshot<File?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Center(
                child: Text("لا توجد ملفات تم تنزيلها"),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SfPdfViewer.file(
                      snapshot.data!,
                      initialZoomLevel: 1.001,
                      controller: pdfViewerController,
                      pageSpacing: 8,
                      enableDocumentLinkAnnotation: false,
                      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                        print(
                            "details.document.pages.count: ${details.document.pages.count}");
                        _txtpagenumber.text =
                            "${pdfViewerController.pageNumber}";
                        pageNumberController.update();
                      },
                      onPageChanged: (PdfPageChangedDetails details) {
                        print(
                            "PdfPageChangedDetails: ${details.newPageNumber}");
                        _txtpagenumber.text =
                            "${pdfViewerController.pageNumber}";
                        isFirstPage = details.isFirstPage;
                        isLastPage = details.isLastPage;
                        pageNumberController.update();
                      },
                      onHyperlinkClicked: (PdfHyperlinkClickedDetails
                          pdfHyperlinkClickedDetails) {
                        print(pdfHyperlinkClickedDetails.uri);
                        launchLink(url: pdfHyperlinkClickedDetails.uri);
                      },
                      canShowHyperlinkDialog: false,
                      onTextSelectionChanged:
                          (PdfTextSelectionChangedDetails details) {
                        if (details.selectedText == null &&
                            _overlayEntry != null) {
                          _overlayEntry!.remove();
                          _overlayEntry = null;
                        } else if (details.selectedText != null &&
                            _overlayEntry == null) {
                          _showContextMenu(context, details);
                        }
                      },
                    ),
                  ),
                ),
                Material(
                  color: AppConsts.secondaryColor.withOpacity(0.7),
                  child: Container(
                    width: w,
                    height: 45,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, -1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GetBuilder<PageNumberController>(
                              builder: (controller) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isFirstPage == false)
                                  InkWell(
                                    onTap: () {
                                      pdfViewerController.jumpToPage(1);
                                    },
                                    child:
                                        Icon(Icons.keyboard_double_arrow_right),
                                  ),
                                if (isFirstPage == false)
                                  InkWell(
                                    onTap: () {
                                      pdfViewerController.previousPage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Icon(Icons.arrow_back_ios_rounded),
                                    ),
                                  ),
                                Container(
                                  width: 40,
                                  height: 25,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 14),
                                    controller: _txtpagenumber,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onFieldSubmitted: (String val) {
                                      print("val: $val");
                                      try {
                                        pdfViewerController
                                            .jumpToPage(int.parse(val));
                                      } catch (err) {
                                        print("err: ${err}");
                                      }
                                    },
                                  ),
                                ),
                                Text(
                                  " / ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text("${pdfViewerController.pageCount}"),
                                if (isLastPage == false)
                                  InkWell(
                                    onTap: () {
                                      pdfViewerController.nextPage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                    ),
                                  ),
                                if (isLastPage == false)
                                  InkWell(
                                    onTap: () {
                                      pdfViewerController.jumpToPage(
                                          pdfViewerController.pageCount);
                                    },
                                    child:
                                        Icon(Icons.keyboard_double_arrow_left),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: ErrorData());
          } else {
            return Center(child: LoadingData());
          }
        },
      ),
    );
  }
}

class PageNumberController extends GetxController {}

class SearchInPdfController extends GetxController {
  bool isSearching = false;
  String searchText = "";

  onChangeSearch(bool val) {
    isSearching = val;
    update();
  }
}
