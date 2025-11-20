import 'package:latlong2/latlong.dart';
import 'package:widgets_app/utils/app_logger.dart';

class PolylineDecoder {
  static List<LatLng> decode(String encoded, {int precision = 5}) {
    AppLogger.debug('🔍 Decoding polyline: ${encoded.substring(0, encoded.length > 20 ? 20 : encoded.length)}... (length: ${encoded.length})');
    AppLogger.debug('🔍 Using precision: $precision');
    
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    double factor = 1e5; // Standard precision 5 factor
    
    if (precision == 6) {
      factor = 1e6;
    }
    
    AppLogger.debug('🔍 Factor: $factor');

    try {
      while (index < encoded.length) {
        // Decode latitude
        int b;
        int shift = 0;
        int result = 0;

        do {
          if (index >= encoded.length) {
            AppLogger.warning('Unexpected end of encoded string while decoding latitude');
            break;
          }
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
          if (index >= encoded.length) {
            AppLogger.warning('Unexpected end of encoded string while decoding longitude');
            break;
          }
          b = encoded.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);

        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;

        final latLng = LatLng(lat / factor, lng / factor);
        points.add(latLng);
        
        if (points.length <= 3 || points.length == points.length) {
          AppLogger.debug('🔍 Point ${points.length}: lat=${latLng.latitude}, lng=${latLng.longitude}');
        }
      }
      
      AppLogger.info('✅ Decoded ${points.length} points successfully');
      if (points.isNotEmpty) {
        AppLogger.debug('First point: ${points.first.latitude}, ${points.first.longitude}');
        AppLogger.debug('Last point: ${points.last.latitude}, ${points.last.longitude}');
      }
      return points;
    } catch (e, stackTrace) {
      AppLogger.error('❌ Polyline decode error: $e', e, stackTrace);
      return [];
    }
  }
}
