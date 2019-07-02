import 'package:neuro_hack/model/eval_data.dart';

import 'eval_repository.dart';

class EvalRepositoryMock implements EvalRepository {
  @override
  Future<String> sendEvalData(EvalData evalData) {
    throw new UnimplementedError('sendEvalData [mock]');
  }
}
