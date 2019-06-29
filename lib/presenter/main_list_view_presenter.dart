import 'package:neuro_hack/model/recommendation_repository.dart';

import '../dependency_injection.dart';
import 'main_list_view_contract.dart';

class RecommendationListViewPresenter {
  RecommendationListViewContract _view;
  RecommendationRepository _repository;

  RecommendationListViewPresenter(this._view) {
    this._repository = new Injector().recommendationRepository;
  }

  void loadRecommendations(int index) {
    _repository
        .fetchRecommendations(index)
        .then((x) => _view.onRecommendationsFetchComplete(x))
        .catchError((onError) => _view.onRecommendationsFetchFailure());
  }
}
