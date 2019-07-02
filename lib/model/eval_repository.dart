import 'eval_data.dart';

abstract class EvalRepository {
  Future<String> sendEvalData(EvalData evalData);
}
