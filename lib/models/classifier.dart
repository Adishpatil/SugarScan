import "dart:io";
import "dart:typed_data";
import "package:flutter/services.dart";
import "package:tflite_flutter/tflite_flutter.dart";
import "package:image/image.dart" as img;

class ClassifierResult {
  final String label;
  final double confidence;
  final Map<String, double> allProbabilities;
  ClassifierResult({required this.label, required this.confidence, required this.allProbabilities});
}

class Classifier {
  static const int inputSize = 224;
  static const int numClasses = 5;
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;

  Future<void> loadModel() async {
    try {
      final options = InterpreterOptions()..threads = 2;
      _interpreter = await Interpreter.fromAsset(
        "assets/model/best_model.tflite",
        options: options,
      );
      // Print tensor details for debugging
      print("Input tensor: ${_interpreter!.getInputTensor(0)}");
      print("Output tensor: ${_interpreter!.getOutputTensor(0)}");
      final labelsData = await rootBundle.loadString("assets/model/labels.txt");
      _labels = labelsData.split("\n").map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      _isLoaded = true;
    } catch (e) {
      throw Exception("Failed to load model: $e");
    }
  }

  bool get isLoaded => _isLoaded;

  Future<ClassifierResult> predict(File imageFile) async {
    if (!_isLoaded) await loadModel();
    final bytes = await imageFile.readAsBytes();
    img.Image? rawImage = img.decodeImage(bytes);
    if (rawImage == null) throw Exception("Could not decode image");
    final resized = img.copyResize(rawImage, width: inputSize, height: inputSize);

    final inputBuffer = Float32List(1 * inputSize * inputSize * 3);
    int idx = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        // Divide by 255 — normalize to 0-1
        inputBuffer[idx++] = pixel.r.toDouble() / 255.0;
        inputBuffer[idx++] = pixel.g.toDouble() / 255.0;
        inputBuffer[idx++] = pixel.b.toDouble() / 255.0;
      }
    }

    final input = inputBuffer.reshape([1, inputSize, inputSize, 3]);
    final outputBuffer = Float32List(numClasses);
    final output = outputBuffer.reshape([1, numClasses]);
    _interpreter!.run(input, output);

    print("Raw output: $outputBuffer");

    final probs = outputBuffer;
    int maxIdx = 0;
    for (int i = 1; i < numClasses; i++) {
      if (probs[i] > probs[maxIdx]) maxIdx = i;
    }

    final Map<String, double> probMap = {};
    for (int i = 0; i < _labels.length; i++) {
      probMap[_labels[i]] = probs[i];
    }

    return ClassifierResult(
      label: _labels[maxIdx],
      confidence: probs[maxIdx],
      allProbabilities: probMap,
    );
  }

  void dispose() => _interpreter?.close();
}
