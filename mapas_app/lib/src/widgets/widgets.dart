import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polyline/polyline.dart' as Poly;
import 'package:mapas_app/src/helpers/helpers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapas_app/src/bloc/mapa/mapa_bloc.dart';
import 'package:mapas_app/src/bloc/busqueda/busqueda_bloc.dart';
import 'package:mapas_app/src/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

import 'package:mapas_app/src/models/search_result.dart';
import 'package:mapas_app/src/services/traffic_service.dart';
import 'package:mapas_app/src/search/search_destination.dart';

part 'searchbar.dart';
part 'btn_mi_ruta.dart';
part 'btn_ubicacion.dart';
part 'marcador_manual.dart';
part 'btn_seguir_ubicacion.dart';