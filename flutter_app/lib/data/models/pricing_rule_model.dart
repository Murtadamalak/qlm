import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/pricing_rule.dart';

class PricingRuleModel extends PricingRule {
  const PricingRuleModel({
    required super.id,
    required super.paperSizeBasePrice,
    required super.colorMultiplier,
    required super.bindingPrice,
  });

  factory PricingRuleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PricingRuleModel(
      id: doc.id,
      paperSizeBasePrice: Map<String, double>.from(
        (data['paper_size_base_price'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(key, (value as num).toDouble())),
      ),
      colorMultiplier: Map<String, double>.from(
        (data['color_multiplier'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(key, (value as num).toDouble())),
      ),
      bindingPrice: Map<String, double>.from(
        (data['binding_price'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(key, (value as num).toDouble())),
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'paper_size_base_price': paperSizeBasePrice,
      'color_multiplier': colorMultiplier,
      'binding_price': bindingPrice,
    };
  }
}
