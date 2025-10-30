import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' hide PermissionStatus;

Future<Map<String, double>?> getCurrentLocation() async {
  final location = Location();

  // Step 1: Check if location service is enabled
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print('❌ Location services are disabled.');
      return null;
    }
  }

  // Step 2: Check & request permission
  PermissionStatus permissionStatus = await Permission.location.status;
  if (permissionStatus.isDenied) {
    permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      print('❌ Location permission denied.');
      return null;
    }
  }

  if (permissionStatus.isPermanentlyDenied) {
    print(
      '⚠️ Location permission permanently denied. Please enable in settings.',
    );
    await openAppSettings();
    return null;
  }

  // Step 3: Get current location
  LocationData locationData = await location.getLocation();

  if (locationData.latitude == null || locationData.longitude == null) {
    print('⚠️ Failed to fetch location.');
    return null;
  }

  print(
    '✅ Current Location: ${locationData.latitude}, ${locationData.longitude}',
  );
  return {"lat": locationData.latitude!, "lng": locationData.longitude!};
}
