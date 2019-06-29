import 'package:neuro_hack/model/contact_repository.dart';

import '../dependency_injection.dart';
import 'contact_list_view_contract.dart';

class ContactListViewPresenter {
  ContactListViewContract _view;
  ContactRepository _repository;

  ContactListViewPresenter(this._view) {
    this._repository = new Injector().contactRepository;
  }

  void loadContacts() {
    _repository
        .fetchContacts()
        .then((x) => _view.onContactsFetchComplete(x))
        .catchError((onError) => _view.onContactsFetchFailure());
  }
}
