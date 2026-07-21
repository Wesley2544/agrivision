import 'package:geolocator/geolocator.dart';

class GpsResult {
  final double? latitude;
  final double? longitude;
  final String label;

  const GpsResult({
    this.latitude,
    this.longitude,
    required this.label,
  });

  bool get hasCoordinates =>
      latitude != null && longitude != null;
}

class GisModule {
  GisModule._();
  static final GisModule instance = GisModule._();

  /// Gets current GPS position.
  /// Returns coordinates if available, or a label-only
  /// result if permission is denied or service is off.
  Future<GpsResult> getCurrentPosition() async {
    try {
      // Check if location services are on
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const GpsResult(
            label: 'Location service off');
      }

      // Check/request permission
      var permission =
          await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const GpsResult(
              label: 'Permission denied');
        }
      }
      if (permission ==
          LocationPermission.deniedForever) {
        return const GpsResult(
            label: 'Location blocked — open Settings');
      }

      // Get position with a 5 second timeout
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );

      // Format as human-readable label
      final label =
          '${pos.latitude.toStringAsFixed(4)}, '
          '${pos.longitude.toStringAsFixed(4)}';

      return GpsResult(
        latitude:  pos.latitude,
        longitude: pos.longitude,
        label:     label,
      );
    } catch (e) {
      return const GpsResult(label: 'Location unavailable');
    }
  }
}