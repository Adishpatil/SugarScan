import 'package:flutter_test/flutter_test.dart';
import 'package:sugarscan1/models/classifier.dart';

void main() {
  ClassifierResult resultWithConfidence(double confidence) {
    return ClassifierResult(
      label: 'Healthy',
      confidence: confidence,
      allProbabilities: {'Healthy': confidence},
    );
  }

  test('confidence thresholds classify boundary values correctly', () {
    expect(
      resultWithConfidence(0.49).confidenceLevel,
      ConfidenceLevel.rejected,
    );
    expect(
      resultWithConfidence(0.50).confidenceLevel,
      ConfidenceLevel.low,
    );
    expect(
      resultWithConfidence(0.69).confidenceLevel,
      ConfidenceLevel.low,
    );
    expect(
      resultWithConfidence(0.70).confidenceLevel,
      ConfidenceLevel.high,
    );
    expect(
      resultWithConfidence(1.0).confidenceLevel,
      ConfidenceLevel.high,
    );
  });
}
