import '../../domain/entities/pricing_rule.dart';
import '../../domain/repositories/pricing_repository.dart';
import '../datasources/pricing_remote_data_source.dart';
import '../models/pricing_rule_model.dart';

class PricingRepositoryImpl implements PricingRepository {
  final PricingRemoteDataSource _remoteDataSource;

  PricingRepositoryImpl({PricingRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? PricingRemoteDataSource();

  @override
  Stream<PricingRule?> watchPricingRule() =>
      _remoteDataSource.watchPricingRule();

  @override
  Future<void> savePricingRule(PricingRule rule) {
    final model = PricingRuleModel(
      id: rule.id,
      paperSizeBasePrice: rule.paperSizeBasePrice,
      colorMultiplier: rule.colorMultiplier,
      bindingPrice: rule.bindingPrice,
    );
    return _remoteDataSource.savePricingRule(model);
  }
}
