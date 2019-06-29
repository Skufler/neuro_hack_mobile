import 'package:neuro_hack/model/recommendation.dart';

abstract class RecommendationListViewContract {
  void onRecommendationsFetchComplete(List<Recommendation> items);
  void onRecommendationsFetchFailure();
}
