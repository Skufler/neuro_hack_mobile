import 'dart:async';

import 'package:neuro_hack/model/recommendation.dart';

abstract class RecommendationRepository {
  Future<List<Recommendation>> fetchRecommendations(int index);
}
