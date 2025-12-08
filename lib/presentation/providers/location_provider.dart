import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../data/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final currentPositionProvider = StreamProvider<Position?>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.getPositionStream();
});

final currentLatLngProvider = Provider<LatLng?>((ref) {
  final positionAsync = ref.watch(currentPositionProvider);
  return positionAsync.whenOrNull(
    data: (position) {
      if (position == null) return null;
      return LatLng(position.latitude, position.longitude);
    },
  );
});

final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.requestPermission();
});
