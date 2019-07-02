import 'package:neuro_hack/model/contact.dart';

abstract class ContactViewContract {
  void onContactsFetchComplete(List<Contact> items);
  void onContactsFetchFailure();
}
