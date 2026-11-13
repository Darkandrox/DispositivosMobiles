import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../config/config.dart';
import '../controladores/animacion_mapa.controlador.dart';
import '../controladores/marcadores.controlador.dart';
import '../modelos/evento.modelo.dart';
import '../modelos/filtro.modelo.dart';
import '../servicios/ticketmaster.servicio.dart';
import '../servicios/ubicacion.servicio.dart';
import 'detalle_evento.vista.dart';
import 'filtros.vista.dart';

class EventosCercanosVista extends StatefulWidget {
  const EventosCercanosVista({super.key});

  @override
  State<EventosCercanosVista> createState() => _EventosCercanosState();
}

class _EventosCercanosState extends State<EventosCercanosVista>
    with TickerProviderStateMixin {
  final _mapController = MapController();
  late final AnimacionMapaControlador _animacion;

  LatLng _ubicacionUsuario = Config.ubicacionPorDefecto;
  bool _ubicacionObtenida = false;
  List<Evento> _eventos = [];
  Filtro _filtro = const Filtro();
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _animacion = AnimacionMapaControlador(
      mapController: _mapController,
      vsync: this,
    );
    // Se espera al primer frame para que el mapa ya exista al animarlo.
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarTodo());
  }

  @override
  void dispose() {
    _animacion.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _cargarTodo() async {
    await _obtenerUbicacion();
    await _buscarEventos();
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _cargando = true);
    try {
      final ubicacion = await UbicacionServicio.obtenerUbicacionActual();
      setState(() {
        _ubicacionUsuario = ubicacion;
        _ubicacionObtenida = true;
      });
    } catch (error) {
      _mostrarMensaje(
        '${_limpiarError(error)}. Se usará una ubicación por defecto.',
        accion: SnackBarAction(
          label: 'AJUSTES',
          onPressed: UbicacionServicio.abrirAjustes,
        ),
      );
    }
    _animacion.moverA(_ubicacionUsuario, _zoomParaRadio(_filtro.radioKm));
  }

  Future<void> _buscarEventos() async {
    setState(() => _cargando = true);
    try {
      final eventos = await TicketmasterServicio.buscarEventos(
        ubicacion: _ubicacionUsuario,
        filtro: _filtro,
      );
      setState(() => _eventos = eventos);
      if (eventos.isEmpty) _mostrarMensaje(Config.textoSinEventos);
    } catch (error) {
      setState(() => _eventos = []);
      _mostrarMensaje('Error al consultar eventos: ${_limpiarError(error)}');
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _abrirFiltros() async {
    final nuevoFiltro = await showModalBottomSheet<Filtro>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FiltrosVista(filtroActual: _filtro),
    );
    if (nuevoFiltro == null) return;

    setState(() => _filtro = nuevoFiltro);
    _animacion.moverA(_ubicacionUsuario, _zoomParaRadio(nuevoFiltro.radioKm));
    await _buscarEventos();
  }

  void _mostrarDetalle(Evento evento) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (contextoPanel) => DetalleEventoVista(
        evento: evento,
        alIrAhora: () {
          Navigator.pop(contextoPanel);
          _animacion.moverA(evento.coordenadas, Config.zoomEvento);
        },
      ),
    );
  }

  /// Zoom aproximado para que el radio de búsqueda quepa en pantalla.
  double _zoomParaRadio(int radioKm) =>
      Config.zoomInicial - log(radioKm / Config.radioPorDefecto) / ln2;

  String _limpiarError(Object error) =>
      error.toString().replaceAll('Exception: ', '');

  void _mostrarMensaje(String mensaje, {SnackBarAction? accion}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje), action: accion));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Config.tituloApp),
        actions: [
          IconButton(
            tooltip: Config.textoFiltros,
            onPressed: _cargando ? null : _abrirFiltros,
            icon: Badge(
              isLabelVisible: _filtro.filtrosActivos > 0,
              label: Text('${_filtro.filtrosActivos}'),
              child: const Icon(Config.iconoFiltros),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _ubicacionUsuario,
              initialZoom: Config.zoomInicial,
            ),
            children: [
              TileLayer(
                urlTemplate: Config.urlTiles,
                userAgentPackageName: Config.paqueteUserAgent,
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _ubicacionUsuario,
                    radius: _filtro.radioKm * 1000,
                    useRadiusInMeter: true,
                    color: Config.colorUsuario.withValues(alpha: 0.08),
                    borderColor: Config.colorUsuario.withValues(alpha: 0.5),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  ...MarcadoresControlador.marcadoresEventos(_eventos, _mostrarDetalle),
                  MarcadoresControlador.marcadorUsuario(_ubicacionUsuario),
                ],
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            child: _ResumenBusqueda(
              cantidad: _eventos.length,
              radioKm: _filtro.radioKm,
              ubicacionReal: _ubicacionObtenida,
            ),
          ),
          if (_cargando)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Mi ubicación',
        onPressed: _cargando ? null : _cargarTodo,
        child: const Icon(Config.iconoRecentrar),
      ),
    );
  }
}

/// Etiqueta flotante con la cantidad de eventos y el radio usado.
class _ResumenBusqueda extends StatelessWidget {
  final int cantidad;
  final int radioKm;
  final bool ubicacionReal;

  const _ResumenBusqueda({
    required this.cantidad,
    required this.radioKm,
    required this.ubicacionReal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event, size: 18, color: Config.colorEvento),
            const SizedBox(width: 6),
            Text('$cantidad eventos · $radioKm km'),
            if (!ubicacionReal) ...[
              const SizedBox(width: 6),
              const Tooltip(
                message: 'Usando ubicación por defecto',
                child: Icon(Icons.location_off, size: 18, color: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
