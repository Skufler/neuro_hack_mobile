import 'dart:convert';

import 'package:neuro_hack/model/recommendation.dart';
import 'package:neuro_hack/model/recommendation_repository.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../exceptions.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  @override
  Future<List<Recommendation>> fetchRecommendations(int index) async {
    http.Response response = await http
        .get(Constants.serviceURL + "recommendation/new/" + index.toString());
    var responseBody = json.decode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200 || responseBody == null)
      throw new FetchDataException(
          message: "An error ocurred {Status code $statusCode}");
    var list = List<Recommendation>.from(responseBody['message']
            ['recommendations']
        .map((recommendation) => new Recommendation.fromMap(recommendation))
        .toList());
    return list;
  }
}
