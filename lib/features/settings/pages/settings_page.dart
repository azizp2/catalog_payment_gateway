import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_config.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Jaringan API'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Konfigurasi Backend Base URL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tentukan endpoint server ASP.NET Core API yang terhubung dengan database dan Event Bus.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      controller: controller.urlController,
                      label: 'Base URL Backend',
                      hint: 'http://10.0.2.2:5164',
                      prefixIcon: Icons.dns_outlined,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilihan Cepat:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.phone_android, size: 16),
                          label: const Text('Android Emulator (10.0.2.2:5164)', style: TextStyle(fontSize: 12)),
                          onPressed: () => controller.applyPreset(AppConfig.defaultAndroidEmulatorUrl),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.laptop, size: 16),
                          label: const Text('Localhost (127.0.0.1:5164)', style: TextStyle(fontSize: 12)),
                          onPressed: () => controller.applyPreset(AppConfig.defaultLocalhostUrl),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() => AppButton(
                          text: 'Uji Koneksi Backend',
                          icon: Icons.network_check,
                          isLoading: controller.isTesting.value,
                          onPressed: controller.testConnection,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Connection Result Card
            Obx(() {
              final result = controller.testResult.value;
              if (result == null) return const SizedBox.shrink();

              final isSuccess = controller.testSuccess.value;
              final color = isSuccess ? AppColors.success : AppColors.error;
              final bgColor = isSuccess ? AppColors.successLight : AppColors.errorLight;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.error,
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        result,
                        style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Architecture Info Card
            Card(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Catatan Arsitektur',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Aplikasi Flutter ini dirancang dengan prinsip DDD (Domain-Driven Design) Feature-First, menggunakan GetX State Management, Dio Network Layer, dan Freezed immutable data contracts yang berpasangan langsung dengan ASP.NET Core Domain & Application Layer.',
                      style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
