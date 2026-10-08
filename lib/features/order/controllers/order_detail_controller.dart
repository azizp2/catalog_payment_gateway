import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../payment/repositories/payment_repository.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderDetailController extends GetxController {
  final OrderRepository orderRepository;
  final PaymentRepository paymentRepository;

  OrderDetailController({
    required this.orderRepository,
    required this.paymentRepository,
  });

  late final String orderId;

  final Rxn<OrderModel> order = Rxn<OrderModel>();
  final RxBool isLoading = true.obs;
  final RxBool isProcessing = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    orderId = Get.parameters['id'] ?? (Get.arguments?.toString() ?? '');
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    if (orderId.isEmpty) {
      errorMessage.value = 'ID pesanan tidak valid';
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await orderRepository.getOrderById(orderId);
      order.value = result;
    } catch (e) {
      errorMessage.value = 'Gagal memuat detail pesanan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payWithSnap({bool forceNew = false}) async {
    if (order.value == null) return;

    isProcessing.value = true;

    try {
      final payment = await paymentRepository.createSnapToken(
        order.value!.id,
        forceNew: forceNew,
      );

      isProcessing.value = false;

      if (payment.redirectUrl.isNotEmpty) {
        final result = await Get.toNamed(
          AppRoutes.snapPayment,
          arguments: {
            'snapUrl': payment.redirectUrl,
            'orderId': order.value!.id,
          },
        );

        // Auto refresh after coming back from WebView
        await fetchOrder();

        if (result == 'change_method') {
          // User requested to switch method from within WebView
          await payWithSnap(forceNew: true);
        } else if (result == true) {
          SnackbarHelper.showInfo(
            title: 'Pembayaran',
            message: 'Memeriksa status pembayaran terbaru...',
          );
        }
      } else {
        SnackbarHelper.showError(
          title: 'Gagal Membuka Pembayaran',
          message: 'Gagal mendapatkan tautan pembayaran dari Midtrans.',
        );
      }
    } catch (e) {
      isProcessing.value = false;
      SnackbarHelper.showError(
        title: 'Kesalahan Pembayaran',
        message: e.toString(),
      );
    }
  }

  void showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih / Ganti Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih metode untuk melanjutkan proses pembayaran:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary),
                ),
                title: const Text(
                  'Ganti Metode Pembayaran Baru',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text(
                  'Buka ulang semua pilihan (QRIS, GoPay, VA Bank BCA/BNI/Mandiri/BRI, Kartu Kredit)',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(ctx).pop();
                  payWithSnap(forceNew: true);
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.payment_rounded, color: AppColors.info),
                ),
                title: const Text(
                  'Lanjutkan Pembayaran Sebelumnya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text(
                  'Lanjutkan sesi pembayaran yang telah aktif',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(ctx).pop();
                  payWithSnap(forceNew: false);
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check_circle_outline, color: AppColors.success),
                ),
                title: const Text(
                  'Simulasi Bayar Langsung (Domain)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text(
                  'Simulasi pelunasan instan untuk pengujian',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(ctx).pop();
                  simulateDirectPay();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> simulateDirectPay() async {
    if (order.value == null) return;

    isProcessing.value = true;

    try {
      final success = await orderRepository.payOrder(order.value!.id);
      isProcessing.value = false;

      if (success) {
        SnackbarHelper.showSuccess(
          title: 'Pembayaran Berhasil',
          message: 'Status pesanan berhasil diperbarui menjadi LUNAS.',
        );
        await fetchOrder();
      } else {
        SnackbarHelper.showError(
          title: 'Gagal Memproses Pembayaran',
          message: 'Status pesanan tidak dapat diubah.',
        );
      }
    } catch (e) {
      isProcessing.value = false;
      SnackbarHelper.showError(
        title: 'Kesalahan Pembayaran',
        message: e.toString(),
      );
    }
  }

  Future<void> cancelOrder() async {
    if (order.value == null) return;

    isProcessing.value = true;

    try {
      final success = await orderRepository.cancelOrder(order.value!.id);
      isProcessing.value = false;

      if (success) {
        SnackbarHelper.showSuccess(
          title: 'Pesanan Dibatalkan',
          message: 'Pesanan #${order.value!.id} berhasil dibatalkan.',
        );
        await fetchOrder();
      } else {
        SnackbarHelper.showError(
          title: 'Gagal Membatalkan Pesanan',
          message: 'Pesanan tidak dapat dibatalkan.',
        );
      }
    } catch (e) {
      isProcessing.value = false;
      SnackbarHelper.showError(
        title: 'Kesalahan Pembatalan',
        message: e.toString(),
      );
    }
  }
}
