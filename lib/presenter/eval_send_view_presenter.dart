import 'package:neuro_hack/model/eval_data.dart';
import 'package:neuro_hack/model/eval_repository.dart';

import '../dependency_injection.dart';
import 'eval_send_view_contract.dart';

class EvalSendViewPresenter {
  EvalSendViewContract _view;
  EvalRepository _repository;

  EvalSendViewPresenter(this._view) {
    this._repository = new Injector().evalRepository;
  }

  void sendEvalData(EvalData data) {
    _repository
        .sendEvalData(data)
        .then((x) => _view.onEvalDataFetchComplete(x))
        .catchError((onError) => _view.onEvalDataFetchFailure());
  }
}
