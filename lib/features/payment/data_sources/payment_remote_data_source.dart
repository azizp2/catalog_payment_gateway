import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/payment_token_response.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentTokenResponse> createSnapToken(String orderId, {bool forceNew = false});
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaymentTokenResponse> createSnapToken(String orderId, {bool forceNew = false}) async {
    final path = ApiEndpoints.snapToken(orderId);
    final response = await apiClient.post<Map<String, dynamic>>(
      path,
      queryParameters: forceNew ? {'forceNew': 'true'} : null,
    );
    return PaymentTokenResponse.fromJson(response.data!);
  }
}
