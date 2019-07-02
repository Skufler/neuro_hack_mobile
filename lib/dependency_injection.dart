import 'model/contact_repository.dart';
import 'model/contact_repository_impl.dart';
import 'model/contact_repository_mock.dart';
import 'model/eval_repository.dart';
import 'model/eval_repository_impl.dart';
import 'model/eval_repository_mock.dart';
import 'model/recommendation_repository.dart';
import 'model/recommendation_repository_impl.dart';
import 'model/recommendation_repository_mock.dart';

enum Flavor { mock, production }

class Injector {
  static final Injector _singleton = new Injector._internal();

  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  RecommendationRepository get recommendationRepository {
    switch (_flavor) {
      case Flavor.mock:
        return new RecommendationRepositoryMock();
      default:
        return new RecommendationRepositoryImpl();
    }
  }

  ContactRepository get contactRepository {
    switch (_flavor) {
      case Flavor.mock:
        return new ContactRepositoryMock();
      default:
        return new ContactRepositoryImpl();
    }
  }

  EvalRepository get evalRepository {
    switch (_flavor) {
      case Flavor.mock:
        return new EvalRepositoryMock();
      default:
        return new EvalRepositoryImpl();
    }
  }
}
