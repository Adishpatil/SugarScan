import 'package:flutter/material.dart';

class DiseaseInfo {
  final String name;
  final String emoji;
  final Color color;
  final String description;
  final String cause;
  final String treatment;
  final String severity;

  const DiseaseInfo({
    required this.name,
    required this.emoji,
    required this.color,
    required this.description,
    required this.cause,
    required this.treatment,
    required this.severity,
  });
}

const Map<String, DiseaseInfo> diseaseDatabase = {
  'Healthy': DiseaseInfo(
    name: 'Healthy', emoji: '✅', color: Color(0xFF2ECC71), severity: 'None',
    description: 'The sugarcane plant is perfectly healthy.',
    cause: 'N/A',
    treatment: 'No treatment required.',
  ),
  'Mosaic': DiseaseInfo(
    name: 'Mosaic', emoji: '🟡', color: Color(0xFFF1C40F), severity: 'Moderate',
    description: 'Caused by SCMV. Light and dark green patches on leaves.',
    cause: 'Spread by aphid insects and infected seed cane.',
    treatment: '1. Remove infected plants.\n2. Use virus-free seed cane.\n3. Control aphids.',
  ),
  'Rust': DiseaseInfo(
    name: 'Rust', emoji: '🟠', color: Color(0xFFE67E22), severity: 'Moderate',
    description: 'Caused by Puccinia melanocephala. Orange-brown pustules on leaves.',
    cause: 'Fungal spores spread through wind and rain.',
    treatment: '1. Apply Mancozeb fungicide.\n2. Remove infected leaves.\n3. Improve air circulation.',
  ),
  'RedRot': DiseaseInfo(
    name: 'Red Rot', emoji: '🔴', color: Color(0xFFE74C3C), severity: 'Severe',
    description: 'Caused by Colletotrichum falcatum. Red discoloration inside stalk.',
    cause: 'Fungal infection through wounds and waterlogging.',
    treatment: '1. Destroy infected plants.\n2. Treat seed with Carbendazim.\n3. Improve drainage.',
  ),
  'Yellow': DiseaseInfo(
    name: 'Yellow Leaf', emoji: '🟡', color: Color(0xFFF39C12), severity: 'Moderate',
    description: 'Caused by SCYLV. Midrib turns yellow on older leaves.',
    cause: 'Spread by aphid Melanaphis sacchari.',
    treatment: '1. Use disease-free planting material.\n2. Control aphids.\n3. Remove infected ratoons.',
  ),
};
