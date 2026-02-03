import '../entities/pricing_rule.dart';

abstract class PricingRepository {
  Stream<PricingRule?> watchPricingRule();
  Future<void> savePricingRule(PricingRule rule);
}
