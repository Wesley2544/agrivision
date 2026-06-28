import 'package:drift/drift.dart';
import 'local_database.dart';

part 'treatment_dao.g.dart';

@DriftAccessor(tables: [Treatments])
class TreatmentDao extends DatabaseAccessor<LocalDatabase>
    with _$TreatmentDaoMixin {
  TreatmentDao(LocalDatabase db) : super(db);

  /// Returns all treatment options for a given disease.
  Future<List<Treatment>> getTreatmentsForDisease(String diseaseName) {
    return (select(treatments)
          ..where((t) => t.diseaseName.equals(diseaseName)))
        .get();
  }

  /// Adds treatment data to the database.
  Future<int> insertTreatment({
    required String diseaseName,
    required String type,
    required String description,
  }) {
    return into(treatments).insert(
      TreatmentsCompanion.insert(
        diseaseName: diseaseName,
        type: type,
        description: description,
      ),
    );
  }

  /// Seeds the database with sample treatment data — run once on first launch.
  Future<void> seedSampleData() async {
    final existing = await select(treatments).get();
    if (existing.isNotEmpty) return; // already seeded

    await batch((b) {
      b.insertAll(treatments, [
        TreatmentsCompanion.insert(
          diseaseName: 'Northern Leaf Blight',
          type: 'chemical',
          description: 'Apply mancozeb fungicide at 2kg/ha.',
        ),
        TreatmentsCompanion.insert(
          diseaseName: 'Northern Leaf Blight',
          type: 'cultural',
          description: 'Rotate with non-host crops next season.',
        ),
        TreatmentsCompanion.insert(
          diseaseName: 'Early Blight',
          type: 'organic',
          description: 'Apply neem oil spray every 7 days.',
        ),
      ]);
    });
  }
}