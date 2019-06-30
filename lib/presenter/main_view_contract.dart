import 'package:neuro_hack/model/recommendation.dart';

abstract class RecommendationListContract {
  void onRecommendationsFetchComplete(List<Recommendation> items);
  void onRecommendationsFetchFailure();
}
