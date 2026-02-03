import 'package:flutter/material.dart';
import '../../data/repositories/pricing_repository_impl.dart';
import '../../domain/entities/pricing_rule.dart';

class PricingController extends ChangeNotifier {
  final PricingRepositoryImpl _repository;

  PricingController({PricingRepositoryImpl? repository})
      : _repository = repository ?? PricingRepositoryImpl();

  PricingRule? _rule;
  String? _errorMessage;

  PricingRule? get rule => _rule;
  String? get errorMessage => _errorMessage;

  Stream<PricingRule?> watchPricingRule() {
    return _repository.watchPricingRule();
  }

  void setRule(PricingRule? rule) {
    _rule = rule;
    notifyListeners();
  }

  double calculatePrice({
    required String paperSize,
    required bool isColor,
    required int copies,
    required String binding,
    required int pages,
  }) {
    if (_rule == null) {
      _errorMessage = 'Pricing rule is not configured';
      return 0;
    }
    final base = _rule!.paperSizeBasePrice[paperSize] ?? 0;
    final colorKey = isColor ? 'color' : 'bw';
    final multiplier = _rule!.colorMultiplier[colorKey] ?? 1;
    final bindingCost = _rule!.bindingPrice[binding] ?? 0;
    final pageCost = base * pages * multiplier;
    return (pageCost * copies) + bindingCost;
  }
}
