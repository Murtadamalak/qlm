import 'package:equatable/equatable.dart';

class PricingRule extends Equatable {
  final String id;
  final Map<String, double> paperSizeBasePrice;
  final Map<String, double> colorMultiplier;
  final Map<String, double> bindingPrice;

  const PricingRule({
    required this.id,
    required this.paperSizeBasePrice,
    required this.colorMultiplier,
    required this.bindingPrice,
  });

  @override
  List<Object?> get props => [id, paperSizeBasePrice, colorMultiplier, bindingPrice];
}
