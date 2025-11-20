import 'package:latlong2/latlong.dart';

class PolylineDecoder {
  static List<LatLng> decode(String encoded, {int precision = 5}) {
    print('🔍 Decoding polyline: ${encoded.substring(0, 20)}... (length: ${encoded.length})');
    print('🔍 Using precision: $precision');
    
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    int factor = (1 << precision).toInt();
    
    print('🔍 Factor: $factor');

    try {
      while (index < encoded.length) {
        // Decode latitude
        int b;
        int shift = 0;
        int result = 0;

        do {
          b = encoded.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);

        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;

        // Decode longitude
        shift = 0;
        result = 0;

        do {
          b = encoded.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);

        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;

        final latLng = LatLng(lat / factor.toDouble(), lng / factor.toDouble());
        points.add(latLng);
        
        if (points.length <= 3) {
          print('🔍 Point ${points.length}: ${latLng.latitude}, ${latLng.longitude}');
        }
      }
      
      print('🔍 Decoded ${points.length} points successfully');
      return points;
    } catch (e) {
      print('❌ Polyline decode error: $e');
      return [];
    }
  }
}
