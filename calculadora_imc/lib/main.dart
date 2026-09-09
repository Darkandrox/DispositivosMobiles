import 'package:flutter/material.dart';

void main() {
  runApp(const AplicacionImc());
}

class AplicacionImc extends StatelessWidget {
  const AplicacionImc({super.key});

  @override
  Widget build(BuildContext context) {
    final esquemaColores = ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.light,
    ).copyWith(
      primary: Colors.red.shade700,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade700,
      onSecondary: Colors.white,
      surface: Colors.grey.shade100,
      onSurface: Colors.grey.shade900,
      primaryContainer: Colors.grey.shade200,
      onPrimaryContainer: Colors.red.shade900,
      error: Colors.red.shade900,
    );

    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        colorScheme: esquemaColores,
        scaffoldBackgroundColor: Colors.grey.shade100,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade800),
          prefixIconColor: Colors.red.shade700,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: const PantallaCalculadora(),
    );
  }
}

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _PantallaCalculadoraState();
}

class _PantallaCalculadoraState extends State<PantallaCalculadora> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorPeso = TextEditingController();
  final _controladorAltura = TextEditingController();

  double? _resultadoImc;
  String? _resultadoCategoria;

  @override
  void dispose() {
    _controladorPeso.dispose();
    _controladorAltura.dispose();
    super.dispose();
  }

  String? _validarCampoNumerico(String? entrada, String nombreCampo) {
    if (entrada == null || entrada.trim().isEmpty) {
      return 'El campo $nombreCampo no puede estar vacío';
    }
    final valorNumerico = double.tryParse(entrada.replaceAll(',', '.'));
    if (valorNumerico == null) {
      return 'Ingresa un número válido';
    }
    if (valorNumerico <= 0) {
      return '$nombreCampo debe ser un valor positivo';
    }
    return null;
  }

  String _obtenerCategoria(double indiceMasaCorporal) {
    if (indiceMasaCorporal < 18.5) {
      return 'Bajo peso';
    } else if (indiceMasaCorporal < 25.0) {
      return 'Peso normal';
    } else if (indiceMasaCorporal < 30.0) {
      return 'Sobrepeso';
    } else {
      return 'Obesidad';
    }
  }

  void _procesarCalculo() {
    if (_claveFormulario.currentState!.validate()) {
      final pesoKg =
          double.parse(_controladorPeso.text.replaceAll(',', '.'));
      final alturaMetros =
          double.parse(_controladorAltura.text.replaceAll(',', '.'));
      final indiceCalculado = pesoKg / (alturaMetros * alturaMetros);

      setState(() {
        _resultadoImc = indiceCalculado;
        _resultadoCategoria = _obtenerCategoria(indiceCalculado);
      });
    } else {
      setState(() {
        _resultadoImc = null;
        _resultadoCategoria = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _claveFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ingresa tu peso y altura para calcular tu IMC.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _controladorPeso,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                  validator: (entrada) =>
                      _validarCampoNumerico(entrada, 'peso'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controladorAltura,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Altura (m)',
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (entrada) =>
                      _validarCampoNumerico(entrada, 'altura'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _procesarCalculo,
                  child: const Text('Calcular IMC'),
                ),
                const SizedBox(height: 24),
                if (_resultadoImc != null && _resultadoCategoria != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade700, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Tu IMC es: ${_resultadoImc!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Categoría: $_resultadoCategoria',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
