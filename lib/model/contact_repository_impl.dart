import 'dart:convert';

import '../constants.dart';
import '../exceptions.dart';
import 'contact.dart';

import 'package:http/http.dart' as http;

import 'contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  @override
  Future<List<Contact>> fetchContacts(int id) async {
    http.Response response =
        await http.get(Constants.serviceURL + "eval/get/" + id.toString());
    var responseBody = json.decode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200 || responseBody == null)
      throw new FetchDataException(
          message: "An error ocurred {Status code $statusCode}");
    var list = List<Contact>.from(responseBody['message']['contacts']
        .map((recommendation) => new Contact.fromMap(recommendation))
        .toList());
    return list;
  }
}
