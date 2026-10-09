import 'package:flutter/material.dart';

import '../modelos/ciudad.modelo.dart';
import '../servicios/open_meteo.servicio.dart';

class CalidadAireVista extends StatefulWidget {
  const CalidadAireVista({super.key});

  @override
  State<CalidadAireVista> createState() => _CalidadAireState();
}

class _CalidadAireState extends State<CalidadAireVista> {
  final _estadoFormulario = GlobalKey<FormState>();
  final _txtHoras = TextEditingController();

  Ciudad _ciudadSeleccionada = ciudadesColombia.first;
  DateTime _fechaSeleccionada = DateTime.now();

  bool _cargando = false;
  String? _mensajeError;
  double? _indiceExposicion;
  double? _promedioPm25;
  String? _nivelRiesgo;

  @override
  void dispose() {
    _txtHoras.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final anio = fecha.year.toString().padLeft(4, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final dia = fecha.day.toString().padLeft(2, '0');
    return '$anio-$mes-$dia';
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() => _fechaSeleccionada = fecha);
    }
  }

  // Clasifica el índice de exposición según la tabla del enunciado.
  String _clasificarRiesgo(double indice) {
    if (indice < 100) return 'Bajo';
    if (indice <= 200) return 'Moderado';
    return 'Alto';
  }

  Color _colorPorRiesgo(String nivel) {
    switch (nivel) {
      case 'Bajo':
        return Colors.green.shade700;
      case 'Moderado':
        return Colors.orange.shade800;
      default:
        return Colors.red.shade700;
    }
  }

  IconData _iconoPorRiesgo(String nivel) {
    switch (nivel) {
      case 'Bajo':
        return Icons.sentiment_satisfied_alt;
      case 'Moderado':
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  Future<void> _calcularIndice() async {
    if (!_estadoFormulario.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
      _indiceExposicion = null;
      _promedioPm25 = null;
      _nivelRiesgo = null;
    });

    try {
      final horas = double.parse(_txtHoras.text.replaceAll(',', '.'));
      final promedioPm25 = await OpenMeteoServicio.obtenerPromedioPm25(
        latitud: _ciudadSeleccionada.latitud,
        longitud: _ciudadSeleccionada.longitud,
        fecha: _fechaSeleccionada,
      );
      final indice = promedioPm25 * horas;

      setState(() {
        _promedioPm25 = promedioPm25;
        _indiceExposicion = indice;
        _nivelRiesgo = _clasificarRiesgo(indice);
      });
    } catch (error) {
      setState(() {
        _mensajeError = 'Ocurrió un error al consultar la API: ${error.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Calidad del Aire'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _estadoFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  color: colores.primaryContainer.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.air, color: colores.primary, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Estima tu índice de exposición diaria a PM2.5 según la ciudad, '
                            'el día y tus horas al aire libre.',
                            style: TextStyle(
                              color: colores.onPrimaryContainer,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Selección de ciudad
                DropdownButtonFormField<Ciudad>(
                  initialValue: _ciudadSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  items: ciudadesColombia
                      .map((ciudad) => DropdownMenuItem(
                            value: ciudad,
                            child: Text(ciudad.nombre),
                          ))
                      .toList(),
                  onChanged: (ciudad) {
                    if (ciudad != null) {
                      setState(() => _ciudadSeleccionada = ciudad);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Selección de fecha
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _formatearFecha(_fechaSeleccionada),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Fecha de consulta',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _seleccionarFecha,
                ),
                const SizedBox(height: 16),

                // Horas de exposición
                TextFormField(
                  controller: _txtHoras,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Horas de exposición diaria',
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Ingresa tus horas de exposición';
                    }
                    final numero = double.tryParse(valor.replaceAll(',', '.'));
                    if (numero == null || numero <= 0) {
                      return 'Ingresa un número válido mayor a 0';
                    }
                    if (numero > 24) {
                      return 'Las horas no pueden superar 24';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _cargando ? null : _calcularIndice,
                  icon: _cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.calculate_outlined),
                  label: Text(_cargando ? 'Consultando...' : 'Calcular Índice de Exposición'),
                ),
                const SizedBox(height: 24),

                if (_mensajeError != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _mensajeError!,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_indiceExposicion != null && _nivelRiesgo != null)
                  _TarjetaResultado(
                    promedioPm25: _promedioPm25!,
                    indice: _indiceExposicion!,
                    nivelRiesgo: _nivelRiesgo!,
                    color: _colorPorRiesgo(_nivelRiesgo!),
                    icono: _iconoPorRiesgo(_nivelRiesgo!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta que muestra el resultado del cálculo con un diseño que resalta
/// el nivel de riesgo mediante color e ícono.
class _TarjetaResultado extends StatelessWidget {
  final double promedioPm25;
  final double indice;
  final String nivelRiesgo;
  final Color color;
  final IconData icono;

  const _TarjetaResultado({
    required this.promedioPm25,
    required this.indice,
    required this.nivelRiesgo,
    required this.color,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 40),
          const SizedBox(height: 8),
          Text(
            'Índice de exposición: ${indice.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Nivel de riesgo: $nivelRiesgo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Promedio PM2.5 del día: ${promedioPm25.toStringAsFixed(1)} µg/m³',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
