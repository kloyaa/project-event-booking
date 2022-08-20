import 'package:map_launcher/map_launcher.dart';

Future findInMap(Coords coord, {required title, required description}) async {
  await MapLauncher.showMarker(
    mapType: MapType.google,
    coords: coord,
    title: title,
    description: description,
  );
}
