import 'package:neuro_hack/model/contact.dart';

abstract class ContactListViewContract {
  void onContactsFetchComplete(List<Contact> items);
  void onContactsFetchFailure();
}
