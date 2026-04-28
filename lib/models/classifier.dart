// ─────────────────────────────────────────────────────────────
//  SugarScan — TFLite Classifier  (v5 — correct normalization)
//
//  Fix: The auto-calibration was choosing RAW (0-255) mode
//  because wrong preprocessing causes overconfident wrong
//  predictions (84% RedRot) vs correct preprocessing giving
//  lower but accurate confidence (50% Mosaic).
//
//  The model was trained with pixel_value / 255.0, so we
//  ALWAYS normalize to [0, 1]. No auto-detection needed.
// ─────────────────────────────────────────────────────────────

import "dart:io";
import "dart:math" as math;
import "dart:typed_data";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:tflite_flutter/tflite_flutter.dart";
import "package:image/image.dart" as img;

// ── Result DTO ──────────────────────────────────────────────
class ClassifierResult {
  final String label;
  final double confidence;
  final Map<String, double> allProbabilities;
  final String debugInfo;

  ClassifierResult({
    required this.label,
    required this.confidence,
    required this.allProbabilities,
    this.debugInfo = '',
  });
}

// ── Classifier ──────────────────────────────────────────────
class Classifier {
  static const int inputSize = 224;
  static const String _modelPath = "assets/model/final_model_1.tflite";
  static const String _labelPath = "assets/model/labels.txt";

  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;
  int _numClasses = 5;

  // Quantization params
  bool _isInputQuantized = false;
  bool _isOutputQuantized = false;
  double _outputScale = 1.0;
  int _outputZeroPoint = 0;

  // Debug log (reset per prediction)
  final StringBuffer _log = StringBuffer();

  bool get isLoaded => _isLoaded;

  // ═══════════════════════════════════════════════════════════
  //  Load model & labels
  // ═══════════════════════════════════════════════════════════
  Future<void> loadModel() async {
    if (_isLoaded) return;

    try {
      final options = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset(
        _modelPath,
        options: options,
      );

      // Load labels
      final labelsRaw = await rootBundle.loadString(_labelPath);
      _labels = labelsRaw
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _numClasses = _labels.length;

      // Inspect tensors
      final inT = _interpreter!.getInputTensor(0);
      final outT = _interpreter!.getOutputTensor(0);

      _isInputQuantized = (inT.type == TensorType.uint8 ||
          inT.type == TensorType.int8);
      _isOutputQuantized = (outT.type == TensorType.uint8 ||
          outT.type == TensorType.int8);

      if (_isOutputQuantized) {
        _outputScale = outT.params.scale;
        _outputZeroPoint = outT.params.zeroPoint;
      }

      _isLoaded = true;

      debugPrint("═══ SugarScan Model Loaded ═══");
      debugPrint("  Labels ($_numClasses): $_labels");
      debugPrint("  Input:  shape=${inT.shape}, type=${inT.type}");
      debugPrint("  Output: shape=${outT.shape}, type=${outT.type}");
      debugPrint("  Input quantized: $_isInputQuantized");
      debugPrint("  Output quantized: $_isOutputQuantized");
      debugPrint("  Preprocessing: ALWAYS normalize to [0, 1]");
      debugPrint("══════════════════════════════");
    } catch (e) {
      throw Exception("Failed to load model: $e");
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  Main prediction entry point
  // ═══════════════════════════════════════════════════════════
  Future<ClassifierResult> predict(File imageFile) async {
    _log.clear();
    if (!_isLoaded) await loadModel();

    // ── Load & resize image ──
    final bytes = await imageFile.readAsBytes();
    img.Image? rawImage = img.decodeImage(bytes);
    if (rawImage == null) throw Exception("Could not decode image");

    final resized = img.copyResize(
      rawImage,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );

    _log.writeln("Image: ${rawImage.width}x${rawImage.height} → "
        "${inputSize}x$inputSize");

    // ── Run inference with FIXED normalization (0-1) ──
    final probs = _runFloat32Inference(resized);

    // ── Find best class ──
    int bestIdx = 0;
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > probs[bestIdx]) bestIdx = i;
    }

    final probMap = <String, double>{};
    for (int i = 0; i < _labels.length && i < probs.length; i++) {
      probMap[_labels[i]] = probs[i];
    }

    _log.writeln("Preprocessing: pixel / 255.0 → [0, 1]");
    _log.writeln("Probs: ${probs.map((p) => p.toStringAsFixed(4)).toList()}");
    _log.writeln("Result: ${_labels[bestIdx]} "
        "@ ${(probs[bestIdx] * 100).toStringAsFixed(1)}%");

    debugPrint("═══ Prediction: ${_labels[bestIdx]} "
        "@ ${(probs[bestIdx] * 100).toStringAsFixed(1)}% ═══");

    return ClassifierResult(
      label: _labels[bestIdx],
      confidence: probs[bestIdx],
      allProbabilities: probMap,
      debugInfo: _log.toString(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  Float32 inference — ALWAYS normalizes to [0, 1]
  //
  //  Uses properly nested Dart lists (not Float32List.reshape)
  //  because tflite_flutter's JNI bridge on Android requires
  //  List<List<List<List<double>>>> for correct tensor mapping.
  // ═══════════════════════════════════════════════════════════
  List<double> _runFloat32Inference(img.Image image) {
    // BUILD PROPERLY NESTED 4D LIST: [1][224][224][3]
    final input = List.generate(1, (_) {
      return List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final pixel = image.getPixel(x, y);

          // ALWAYS normalize to [0, 1] — matches training pipeline
          final double r = pixel.r.toDouble() / 255.0;
          final double g = pixel.g.toDouble() / 255.0;
          final double b = pixel.b.toDouble() / 255.0;

          return [r, g, b];
        });
      });
    });

    // Log sample pixels for debugging
    final p0 = input[0][0][0];
    final p1 = input[0][0][1];
    final pmid = input[0][112][112];
    debugPrint("  Pixel[0,0]     = [${p0[0].toStringAsFixed(4)}, "
        "${p0[1].toStringAsFixed(4)}, ${p0[2].toStringAsFixed(4)}]");
    debugPrint("  Pixel[1,0]     = [${p1[0].toStringAsFixed(4)}, "
        "${p1[1].toStringAsFixed(4)}, ${p1[2].toStringAsFixed(4)}]");
    debugPrint("  Pixel[112,112] = [${pmid[0].toStringAsFixed(4)}, "
        "${pmid[1].toStringAsFixed(4)}, ${pmid[2].toStringAsFixed(4)}]");

    // OUTPUT: nested list [1][numClasses]
    final output = List.generate(1, (_) {
      return List.filled(_numClasses, 0.0);
    });

    // RUN INFERENCE
    _interpreter!.run(input, output);

    final rawOutput = output[0];

    debugPrint("  RAW model output: $rawOutput");
    debugPrint("  RAW sum: ${rawOutput.reduce((a, b) => a + b)}");

    // Apply softmax if output is raw logits
    return _ensureProbabilities(rawOutput);
  }

  // ═══════════════════════════════════════════════════════════
  //  Post-processing — softmax if needed
  // ═══════════════════════════════════════════════════════════
  List<double> _ensureProbabilities(List<double> rawOutput) {
    double sum = 0;
    for (final v in rawOutput) {
      sum += v;
    }

    // If sum is ~1.0 and all values non-negative → already probabilities
    if (sum >= 0.9 && sum <= 1.1) {
      bool allNonNeg = rawOutput.every((v) => v >= -0.01);
      if (allNonNeg) return rawOutput;
    }

    // Otherwise apply softmax (raw logits)
    debugPrint("  Applying softmax (sum=$sum)");
    return _softmax(rawOutput);
  }

  /// Numerically stable softmax
  List<double> _softmax(List<double> logits) {
    double maxLogit = logits[0];
    for (int i = 1; i < logits.length; i++) {
      if (logits[i] > maxLogit) maxLogit = logits[i];
    }

    final exps = List<double>.generate(logits.length, (i) {
      return math.exp(logits[i] - maxLogit);
    });

    final sumExp = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExp).toList();
  }

  // ═══════════════════════════════════════════════════════════
  //  Cleanup
  // ═══════════════════════════════════════════════════════════
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
