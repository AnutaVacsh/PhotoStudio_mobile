// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class AddressPage extends StatelessWidget {
//   const AddressPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final address = 'г. Саратов, проспект Строителей д.1к3А, ТЦ Атрио, центральный вход, 3-й этаж';

//     // Замените эти координаты на фактические координаты вашего адреса
//     final latitude = 51.5469;
//     final longitude = 46.0164;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Наш адрес'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               address,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: FlutterMap(
//                 options: MapOptions(
//                   center: LatLng(latitude, longitude),
//                   zoom: 15,
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     subdomains: ['a', 'b', 'c'],
//                   ),
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         width: 80.0,
//                         height: 80.0,
//                         point: LatLng(latitude, longitude),
//                         builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ],  
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
/*
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final String address = 'г. Саратов, проспект Строителей д.1к3А, ТЦ Атрио, центральный вход, 3-й этаж';
  late YandexMapController mapController;
  late Point _point;

  @override
  void initState() {
    super.initState();
    _getPointFromAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Наш адрес'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: YandexMap(
                onMapCreated: (controller) => mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: _point,
                  zoom: 15,
                ),
                onMapTap: (point) {
                  // ...
                },
                markers: [
                  Marker(
                    point: _point,
                    onTap: () {
                      // ...
                    },
                    icon: PlacemarkIcon(
                      iconName: 'placemark',
                      iconColor: Colors.red,
                      iconScale: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getPointFromAddress(String address) async {
    try {
      // Используйте API Яндекс.Карт для получения координат
      // (Замените `API_KEY` на ваш реальный API-ключ)
      final response = await YandexMapkit.geocode(
        address: address,
        apiKey: 'API_KEY',
      );
      // Получите координаты из ответа API
      _point = Point(
        latitude: response.geoObjects.first.geometry.first.coordinates.first,
        longitude: response.geoObjects.first.geometry.first.coordinates.last,
      );
      setState(() {});
    } catch (e) {
      print('Error getting coordinates: $e');
    }
  }
}
*/