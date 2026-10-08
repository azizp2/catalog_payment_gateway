import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/utils/snackbar_helper.dart';

class SnapPaymentController extends GetxController {
  late final String snapUrl;
  late final String orderId;

  late final WebViewController webViewController;
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    snapUrl = args['snapUrl']?.toString() ?? '';
    orderId = args['orderId']?.toString() ?? '';
    _initWebView();
  }

  void _initWebView() {
    try {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              isLoading.value = true;
              errorMessage.value = null;
            },
            onPageFinished: (String url) {
              isLoading.value = false;
            },
            onWebResourceError: (WebResourceError error) {
              isLoading.value = false;
              errorMessage.value = error.description;
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );

      if (snapUrl.isNotEmpty) {
        webViewController.loadRequest(Uri.parse(snapUrl));
      } else {
        errorMessage.value = 'URL pembayaran tidak valid';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal menginisialisasi WebView: $e';
      isLoading.value = false;
    }
  }

  Future<void> openInExternalBrowser() async {
    if (snapUrl.isEmpty) return;
    final uri = Uri.parse(snapUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Tidak dapat membuka browser eksternal.',
      );
    }
  }

  void reload() {
    webViewController.reload();
  }
}
