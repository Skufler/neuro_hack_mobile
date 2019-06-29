import 'contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> fetchContacts();
}
