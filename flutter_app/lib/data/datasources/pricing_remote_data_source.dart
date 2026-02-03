import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/pricing_rule_model.dart';

class PricingRemoteDataSource {
  final FirebaseFirestore _firestore;

  PricingRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<PricingRuleModel?> watchPricingRule() {
    return _firestore
        .collection(FirestorePaths.pricingRules)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return PricingRuleModel.fromFirestore(snapshot.docs.first);
    });
  }

  Future<void> savePricingRule(PricingRuleModel rule) async {
    await _firestore
        .collection(FirestorePaths.pricingRules)
        .doc(rule.id)
        .set(rule.toFirestore());
  }
}
