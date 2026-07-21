import 'package:drift/drift.dart';
import 'local_database.dart';

part 'treatment_dao.g.dart';

@DriftAccessor(tables: [Treatments])
class TreatmentDao extends DatabaseAccessor<LocalDatabase>
    with _$TreatmentDaoMixin {
  TreatmentDao(LocalDatabase db) : super(db);

  // ── Read ──────────────────────────────────────────────

  /// Exact disease name match — first try this
  Future<List<Treatment>> getTreatmentsForDisease(
      String diseaseName) {
    return (select(treatments)
          ..where(
              (t) => t.diseaseName.equals(diseaseName)))
        .get();
  }

  /// Keyword match fallback — if exact name not found
  Future<List<Treatment>> getTreatmentsByKeyword(
      String keyword) {
    return (select(treatments)
          ..where(
              (t) => t.diseaseName.like('%$keyword%')))
        .get();
  }

  /// Smart lookup: tries exact first, then keyword fallback
  Future<List<Treatment>> getSmartTreatments(
      String diseaseName) async {
    var results = await getTreatmentsForDisease(diseaseName);
    if (results.isNotEmpty) return results;

    // Try each word in the disease name as a keyword
    final words = diseaseName.split(' ')
      ..removeWhere((w) => w.length < 4);

    for (final word in words) {
      results = await getTreatmentsByKeyword(word);
      if (results.isNotEmpty) return results;
    }

    return [];
  }

  // ── Seed ──────────────────────────────────────────────

  /// Seeds the database with treatment data on first launch.
  /// Safe to call multiple times — checks before inserting.
  Future<void> seedIfEmpty() async {
    final existing = await select(treatments).get();
    if (existing.isNotEmpty) return;

    await batch((b) {
      b.insertAll(treatments, _seedData.map((e) =>
          TreatmentsCompanion.insert(
            diseaseName: e['disease']!,
            type:        e['type']!,
            description: e['description']!,
          )));
    });

    print('✅ Treatment database seeded with '
        '${_seedData.length} entries');
  }

  // ── Seed data ─────────────────────────────────────────
  static const List<Map<String, String>> _seedData = [
    // ── Early Blight ────────────────────────────────────
    {
      'disease': 'Early Blight',
      'type': 'organic',
      'description':
          'Apply neem oil spray every 7 days. Remove and '
          'destroy affected leaves immediately to stop spread.',
    },
    {
      'disease': 'Early Blight',
      'type': 'chemical',
      'description':
          'Apply chlorothalonil or mancozeb fungicide at '
          'first sign. Repeat every 7–10 days during wet '
          'weather.',
    },
    {
      'disease': 'Early Blight',
      'type': 'cultural',
      'description':
          'Avoid overhead irrigation. Ensure good air '
          'circulation between plants. Mulch soil to reduce '
          'splash spread.',
    },

    // ── Late Blight ─────────────────────────────────────
    {
      'disease': 'Late Blight',
      'type': 'organic',
      'description':
          'Apply copper-based fungicide spray immediately. '
          'Remove and destroy all infected tissue — do not '
          'compost.',
    },
    {
      'disease': 'Late Blight',
      'type': 'chemical',
      'description':
          'Apply metalaxyl or cymoxanil fungicide. Repeat '
          'every 5–7 days. Act fast — disease spreads '
          'rapidly in cool wet conditions.',
    },
    {
      'disease': 'Late Blight',
      'type': 'cultural',
      'description':
          'Avoid planting in poorly drained areas. Rotate '
          'crops every 2–3 seasons. Use certified '
          'disease-free seed potatoes or transplants.',
    },

    // ── Northern Leaf Blight ─────────────────────────────
    {
      'disease': 'Northern Leaf Blight',
      'type': 'organic',
      'description':
          'Remove infected leaves early. Apply compost tea '
          'spray weekly to boost plant immune response.',
    },
    {
      'disease': 'Northern Leaf Blight',
      'type': 'chemical',
      'description':
          'Apply mancozeb fungicide at 2kg/ha at first sign '
          'of grey-green lesions. Repeat every 10–14 days.',
    },
    {
      'disease': 'Northern Leaf Blight',
      'type': 'cultural',
      'description':
          'Plant resistant maize varieties. Rotate with '
          'non-host crops (legumes, vegetables) next season. '
          'Plow crop residue after harvest.',
    },

    // ── Mosaic Virus ─────────────────────────────────────
    {
      'disease': 'Mosaic Virus',
      'type': 'organic',
      'description':
          'Remove and destroy infected plants immediately. '
          'Apply insecticidal soap to control aphid vectors '
          'that spread the virus.',
    },
    {
      'disease': 'Mosaic Virus',
      'type': 'chemical',
      'description':
          'Apply imidacloprid or thiamethoxam to control '
          'aphid vectors. No direct chemical cure exists for '
          'the virus — prevention is key.',
    },
    {
      'disease': 'Mosaic Virus',
      'type': 'cultural',
      'description':
          'Use virus-resistant certified varieties. '
          'Disinfect tools between plants with bleach '
          'solution. Remove weed hosts around the field.',
    },

    // ── Leaf Rust ───────────────────────────────────────
    {
      'disease': 'Leaf Rust',
      'type': 'organic',
      'description':
          'Apply neem oil or sulfur-based fungicide at first '
          'sign of orange pustules. Remove heavily infected '
          'leaves.',
    },
    {
      'disease': 'Leaf Rust',
      'type': 'chemical',
      'description':
          'Apply triazole fungicide (propiconazole or '
          'tebuconazole) at first sign. Repeat every 14 days '
          'in high-risk periods.',
    },
    {
      'disease': 'Leaf Rust',
      'type': 'cultural',
      'description':
          'Improve air circulation by proper plant spacing. '
          'Avoid wetting foliage during irrigation. Plant '
          'rust-resistant varieties.',
    },

    // ── Septoria Leaf Spot ───────────────────────────────
    {
      'disease': 'Septoria Leaf Spot',
      'type': 'organic',
      'description':
          'Remove infected lower leaves immediately. Apply '
          'copper fungicide spray every 7–10 days.',
    },
    {
      'disease': 'Septoria Leaf Spot',
      'type': 'chemical',
      'description':
          'Apply chlorothalonil or mancozeb. Begin before '
          'symptoms appear in wet seasons. Spray lower canopy '
          'thoroughly.',
    },
    {
      'disease': 'Septoria Leaf Spot',
      'type': 'cultural',
      'description':
          'Avoid working in field when plants are wet. '
          'Remove all plant debris after harvest. Use a '
          '2-year crop rotation.',
    },

    // ── Brown Spot ──────────────────────────────────────
    {
      'disease': 'Brown Spot',
      'type': 'organic',
      'description':
          'Apply neem oil spray. Ensure proper field '
          'drainage to reduce leaf wetness and humidity.',
    },
    {
      'disease': 'Brown Spot',
      'type': 'chemical',
      'description':
          'Apply iprodione, propiconazole, or azoxystrobin '
          'fungicide. Repeat every 14 days.',
    },
    {
      'disease': 'Brown Spot',
      'type': 'cultural',
      'description':
          'Avoid excessive nitrogen fertilization. Ensure '
          'proper plant spacing for good air circulation.',
    },

    // ── Bacterial Spot ───────────────────────────────────
    {
      'disease': 'Bacterial Spot',
      'type': 'organic',
      'description':
          'Apply copper-based bactericide at first sign. '
          'Avoid overhead irrigation — bacteria spread in '
          'water.',
    },
    {
      'disease': 'Bacterial Spot',
      'type': 'chemical',
      'description':
          'Apply copper hydroxide spray. Do not apply in '
          'hot weather above 35°C — risk of phytotoxicity.',
    },
    {
      'disease': 'Bacterial Spot',
      'type': 'cultural',
      'description':
          'Use certified disease-free seed or transplants. '
          'Rotate crops every 2 years. Destroy all infected '
          'plant debris after harvest.',
    },

    // ── Spider Mites ────────────────────────────────────
    {
      'disease': 'Spider Mites Two Spotted Spider Mite',
      'type': 'organic',
      'description':
          'Apply insecticidal soap or neem oil to both sides '
          'of leaves. Release predatory mites if available '
          'locally.',
    },
    {
      'disease': 'Spider Mites Two Spotted Spider Mite',
      'type': 'chemical',
      'description':
          'Apply abamectin or bifenazate miticide. Rotate '
          'active ingredients to prevent resistance. Spray '
          'leaf undersides.',
    },
    {
      'disease': 'Spider Mites Two Spotted Spider Mite',
      'type': 'cultural',
      'description':
          'Keep plants well-watered — mites thrive under '
          'drought stress. Avoid dusty field conditions. '
          'Increase relative humidity around plants.',
    },

    // ── Leaf Mold ───────────────────────────────────────
    {
      'disease': 'Leaf Mold',
      'type': 'organic',
      'description':
          'Improve ventilation immediately. Apply potassium '
          'bicarbonate spray to affected areas. '
          'Remove infected leaves.',
    },
    {
      'disease': 'Leaf Mold',
      'type': 'chemical',
      'description':
          'Apply difenoconazole or chlorothalonil fungicide '
          'every 7 days until controlled.',
    },
    {
      'disease': 'Leaf Mold',
      'type': 'cultural',
      'description':
          'Reduce humidity below 85% in greenhouse. Prune '
          'lower leaves to improve airflow. '
          'Avoid wetting foliage.',
    },

    // ── Powdery Mildew ───────────────────────────────────
    {
      'disease': 'Powdery Mildew',
      'type': 'organic',
      'description':
          'Apply diluted milk spray (1:9 milk:water) or '
          'potassium bicarbonate weekly. Neem oil also '
          'effective at early stages.',
    },
    {
      'disease': 'Powdery Mildew',
      'type': 'chemical',
      'description':
          'Apply trifloxystrobin or tebuconazole fungicide '
          'at first white powdery patches. Repeat every '
          '10–14 days.',
    },
    {
      'disease': 'Powdery Mildew',
      'type': 'cultural',
      'description':
          'Plant in full sunlight. Avoid excess nitrogen '
          'fertilizer. Use powdery mildew-resistant varieties '
          'where available.',
    },

    // ── Healthy ──────────────────────────────────────────
    {
      'disease': 'Healthy',
      'type': 'cultural',
      'description':
          'Your crop appears healthy. Continue regular '
          'monitoring, maintain good soil health, and '
          'practice crop rotation to prevent future disease.',
    },
  ];
}