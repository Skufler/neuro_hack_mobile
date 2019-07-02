import 'dart:convert';

import 'package:neuro_hack/model/eval_data.dart';

import '../constants.dart';
import '../exceptions.dart';
import 'eval_repository.dart';
import 'package:http/http.dart' as http;

class EvalRepositoryImpl implements EvalRepository {
  @override
  Future<String> sendEvalData(EvalData evalData) async {
    http.Response response = await http.post(
      Constants.serviceURL + "eval/send/",
      body: json.encode(evalData),
      headers: {"Content-Type": "application/json"},
    );

    var responseBody = json.decode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200 || responseBody == null)
      throw new FetchDataException(
          message: "An error ocurred {Status code $statusCode}");
    var result = responseBody['status'];
    return result;
  }
}
