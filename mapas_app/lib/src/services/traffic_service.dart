import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/src/models/traffic_response.dart';

class TrafficService {
  // Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  final baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apiKey = 'pk.eyJ1IjoiZ3JlZW5pZWd0eiIsImEiOiJja2g1MWRtMDMwOG5oMnJxdnZsaWExeWQwIn0.IKoctry14qKIb_jwDI89kA';

  Future<DrivingResponse> getCoordsInicioYFin(LatLng inicio, LatLng destino) async {
    print('inicio: $inicio');
    print('destino: $destino');

    final coordString = '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this.baseUrl}/mapbox/driving/$coordString';
    
    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es'
    });

    final data = DrivingResponse.fromJson(resp.data);

    return data;
  }
}