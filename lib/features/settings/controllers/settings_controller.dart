import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class SettingsController extends GetxController {
  final ApiClient apiClient;

  SettingsController({required this.apiClient});

  final urlController = TextEditingController();
  final RxBool isTesting = false.obs;
  final RxnString testResult = RxnString();
  final RxBool testSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    urlController.text = apiClient.baseUrl;
  }

  @override
  void onClose() {
    urlController.dispose();
    super.onClose();
  }

  void applyPreset(String url) {
    urlController.text = url;
    apiClient.setBaseUrl(url);
    testResult.value = null;
  }

  Future<void> testConnection() async {
    isTesting.value = true;
    testResult.value = null;

    final targetUrl = urlController.text.trim();
    apiClient.setBaseUrl(targetUrl);

    final stopwatch = Stopwatch()..start();
    try {
      final response = await apiClient.get<List<dynamic>>(ApiEndpoints.products);
      stopwatch.stop();

      final count = response.data?.length ?? 0;
      testSuccess.value = true;
      testResult.value =
          'Koneksi Berhasil! Terhubung ke API (${stopwatch.elapsedMilliseconds} ms).\nDitemukan $count produk di database.';
    } catch (e) {
      stopwatch.stop();
      testSuccess.value = false;
      testResult.value =
          'Gagal terhubung ke API:\n$e\n\nPastikan Backend API berjalan di host (e.g. dotnet run).';
    } finally {
      isTesting.value = false;
    }
  }
}
