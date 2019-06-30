import 'package:neuro_hack/model/contact_repository.dart';
import 'package:neuro_hack/model/eval_data.dart';

import '../dependency_injection.dart';
import 'contact_view_contract.dart';

class ContactViewPresenter {
  ContactViewContract _view;
  ContactRepository _repository;

  ContactViewPresenter(this._view) {
    this._repository = new Injector().contactRepository;
  }

  void loadContacts(int id) {
    _repository
        .fetchContacts(id)
        .then((x) => _view.onContactsFetchComplete(x))
        .catchError((onError) => _view.onContactsFetchFailure());
  }

  void sendEvalData(EvalData data) {
    _repository
        .sendEvalData(data)
        .then((x) => _view.onEvalDataFetchComplete(x))
        .catchError((onError) => _view.onEvalDataFetchFailure());
  }
}
