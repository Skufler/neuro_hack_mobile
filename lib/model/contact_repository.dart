import 'contact.dart';
import 'eval_data.dart';

abstract class ContactRepository {
  Future<List<Contact>> fetchContacts(int id);

  Future<String> sendEvalData(EvalData evalData);
}
