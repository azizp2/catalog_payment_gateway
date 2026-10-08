import '../data_sources/payment_remote_data_source.dart';
import '../models/payment_token_response.dart';

abstract class PaymentRepository {
  Future<PaymentTokenResponse> createSnapToken(String orderId, {bool forceNew = false});
}

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaymentTokenResponse> createSnapToken(String orderId, {bool forceNew = false}) =>
      remoteDataSource.createSnapToken(orderId, forceNew: forceNew);
}
