import 'package:neuro_hack/model/recommendation_repository.dart';

import '../dependency_injection.dart';
import 'main_view_contract.dart';

class RecommendationListPresenter {
  RecommendationListContract _view;
  RecommendationRepository _repository;

  RecommendationListPresenter(this._view) {
    this._repository = new Injector().recommendationRepository;
  }

  void loadRecommendations(int index) {
    _repository
        .fetchRecommendations(index)
        .then((x) => _view.onRecommendationsFetchComplete(x))
        .catchError((onError) => _view.onRecommendationsFetchFailure());
  }
}
